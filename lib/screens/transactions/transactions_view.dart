import 'package:flutter/material.dart';
import 'package:moneyjar/constants.dart';
import 'package:moneyjar/data/database.dart';
import 'package:moneyjar/models/account.dart';
import 'package:moneyjar/models/category.dart';
import 'transaction_table.dart';

class TransactionsView extends StatefulWidget {
  const TransactionsView({super.key, this.params});
  final QueryParams? params;
  @override
  State<TransactionsView> createState() => _TransactionsState();
}

class _TransactionsState extends State<TransactionsView> {
  late QueryParams params;
  late Widget table;
  DateTime? _start, _end;
  var dateText = 'Start Date - End Date';
  int categorySelect = 0;
  int accountSelect = 0;
  int typeSelect = 0;
  List<DropdownMenuItem<Category>>? _categories;
  List<DropdownMenuItem<Account>>? _accounts;
  final List<DropdownMenuItem<int>> _types = [
    const DropdownMenuItem(value: 0, child: Text('交易类型')),
    const DropdownMenuItem(value: 1, child: Text('支出')),
    const DropdownMenuItem(value: 2, child: Text('收入')),
    const DropdownMenuItem(value: 3, child: Text('转移'))
  ];
  Future<void>? future;

  @override
  void initState() {
    future = loadData();
    super.initState();
    params = widget.params ?? QueryParams();
    table = TransactionTable(params: params);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: future,
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const CircularProgressIndicator();
          }

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                margin: const EdgeInsets.only(top: defaultPadding),
                padding: const EdgeInsets.all(defaultPadding),
                decoration: BoxDecoration(
                  border: Border.all(
                      width: 2, color: primaryColor.withOpacity(0.15)),
                  borderRadius: const BorderRadius.all(
                    Radius.circular(defaultPadding),
                  ),
                ),
                child: Row(
                  children: [
                    const SizedBox(
                      height: 20,
                      width: 20,
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: defaultPadding),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            MaterialButton(
                              child: Text(dateText),
                              onPressed: () {
                                // 调用函数打开
                                showDateRangePicker(
                                  // 选择日期范围
                                  context: context,
                                  firstDate: DateTime.now().subtract(
                                      const Duration(days: 365 * 10)), // 减 30 天
                                  lastDate: DateTime.now()
                                      .add(const Duration(days: 30)), // 加 30 天
                                ).then((value) {
                                  if (value == null) {
                                    return;
                                  }
                                  _start = value.start;
                                  _end = value.end;
                                  setState(() {
                                    dateText =
                                        '${_start?.toString().substring(0, 10)} - ${_end?.toString().substring(0, 10)}';
                                  });
                                  return null;
                                });
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: defaultPadding),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            DropdownButtonFormField<Account>(
                              value: _accounts!
                                  .firstWhere((element) =>
                                      element.value!.id == accountSelect)
                                  .value,
                              onChanged: (account) {
                                accountSelect = account!.id!;
                              },
                              items: _accounts,
                            ),
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: defaultPadding),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            DropdownButtonFormField<Category>(
                              value: _categories!
                                  .firstWhere((element) =>
                                      element.value!.id == categorySelect)
                                  .value,
                              onChanged: (category) {
                                categorySelect = category!.id!;
                              },
                              items: _categories,
                            ),
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: defaultPadding),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            DropdownButtonFormField<int>(
                              value: _types
                                  .firstWhere(
                                      (element) => element.value == typeSelect)
                                  .value,
                              onChanged: (type) {
                                typeSelect = type!;
                              },
                              items: _types,
                            ),
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: defaultPadding),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            MaterialButton(
                              child: const Text('Query'),
                              onPressed: () {
                                query();
                              },
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
              Expanded(
                child: table,
              ),
            ],
          );
        });
  }

  Future<void> loadData() async {
    final clist = await DBProvider.db.getCategories();
    _categories = clist.map<DropdownMenuItem<Category>>((category) {
      return DropdownMenuItem<Category>(
        key: ValueKey<int>(category.id!),
        value: category,
        child: Text('${category.name}'),
      );
    }).toList();
    _categories!.insert(
        0,
        DropdownMenuItem<Category>(
          key: const ValueKey<int>(0),
          value: Category(id: 0, name: 'All'),
          child: const Text('交易分类'),
        ));
    _accounts = (await DBProvider.db.getAccounts())
        .map<DropdownMenuItem<Account>>((account) {
      return DropdownMenuItem<Account>(
        key: ValueKey<int>(account.id!),
        value: account,
        child: Text(account.name),
      );
    }).toList();
    _accounts!.insert(
        0,
        DropdownMenuItem<Account>(
          key: const ValueKey<int>(0),
          value: Account(id: 0, name: 'All'),
          child: const Text('交易账户'),
        ));
  }

  void query() async {
    // selected categories support
    if (categorySelect != 0) {
      params.categoryId = [categorySelect];
    }
    if (_start != null) {
      params.start = _start!.millisecondsSinceEpoch;
    }
    if (_end != null) {
      params.end = _end!.millisecondsSinceEpoch;
    }
    if (typeSelect != 0) {
      params.type = typeSelect;
    }
    if (accountSelect != 0) {
      params.accountId = [accountSelect];
    }
    setState(() {
      table = TransactionTable(params: params);
    });
  }
}
