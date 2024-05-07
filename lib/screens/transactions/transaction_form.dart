import 'package:flutter/material.dart';
import 'package:moneyjar/data/database.dart';
import 'package:moneyjar/models/account.dart';
import 'package:moneyjar/models/category.dart';
import 'package:moneyjar/models/transaction.dart';

import '../../constants.dart';

class TransactionForm extends StatefulWidget {
  const TransactionForm(
      {Key? key, required this.transaction, required this.callback})
      : super(key: key);
  final Transaction transaction;
  final Function() callback;
  @override
  TransactionFormState createState() => TransactionFormState();
}

class TransactionFormState extends State<TransactionForm> {
  late Transaction transaction;
  late Function() callback;
  List<DropdownMenuItem<Category>>? _categories;
  List<DropdownMenuItem<Account>>? _accounts;
  final List<DropdownMenuItem<int>> types = [
    const DropdownMenuItem(value: 1, child: Text('支出')),
    const DropdownMenuItem(value: 2, child: Text('收入')),
    const DropdownMenuItem(value: 3, child: Text('转移'))
  ];
  Future<void>? future;
  @override
  void initState() {
    super.initState();
    future = loadData();
    transaction = widget.transaction;
    callback = widget.callback;
    dateSelect = DateTime.now();
    dateShow = dateSelect.toString().substring(0, 19);

    dateSelect = DateTime.now();
    if (transaction.id != null) {
      descriptionController.text = transaction.description.toString();
      amountController.text = (transaction.amount! / 100.0).toString();
      dateSelect = transaction.date?.toLocal() ?? DateTime.now();
      dateShow = dateSelect.toString().substring(0, 19);
      targetController.text = transaction.target.toString();
      typeSelect = transaction.type!;
      categorySelect = transaction.categoryID!;
      accountSelect = transaction.accountID!;
      tagController.text = transaction.tag.toString();
      remarkController.text = transaction.remark.toString();
    }
  }

  var descriptionController = TextEditingController();
  var amountController = TextEditingController();
  late DateTime dateSelect;
  late String dateShow;
  late int typeSelect;
  var targetController = TextEditingController();
  late int categorySelect;
  late int accountSelect;
  var tagController = TextEditingController();
  var remarkController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: future,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return AlertDialog(
                content: Stack(
              clipBehavior: Clip.none,
              children: <Widget>[
                Positioned(
                  right: -40,
                  top: -40,
                  child: InkResponse(
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    child: const CircleAvatar(
                      backgroundColor: Colors.red,
                      child: Icon(Icons.close),
                    ),
                  ),
                ),
                SingleChildScrollView(
                  child: Container(
                    width: 600,
                    padding: const EdgeInsets.all(defaultPadding),
                    decoration: const BoxDecoration(
                      color: secondaryColor,
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                    child: Form(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: defaultPadding),
                          Container(
                            margin: const EdgeInsets.only(top: defaultPadding),
                            padding: const EdgeInsets.all(defaultPadding),
                            decoration: BoxDecoration(
                              border: Border.all(
                                  width: 2,
                                  color: primaryColor.withOpacity(0.15)),
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
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        TextFormField(
                                          controller: descriptionController,
                                          decoration: const InputDecoration(
                                            labelText: 'Description',
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.only(top: defaultPadding),
                            padding: const EdgeInsets.all(defaultPadding),
                            decoration: BoxDecoration(
                              border: Border.all(
                                  width: 2,
                                  color: primaryColor.withOpacity(0.15)),
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
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        TextFormField(
                                          controller: amountController,
                                          decoration: const InputDecoration(
                                            labelText: 'Amount',
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.only(top: defaultPadding),
                            padding: const EdgeInsets.all(defaultPadding),
                            decoration: BoxDecoration(
                              border: Border.all(
                                  width: 2,
                                  color: primaryColor.withOpacity(0.15)),
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
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        TextFormField(
                                          controller: targetController,
                                          decoration: const InputDecoration(
                                            labelText: 'Target',
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.only(top: defaultPadding),
                            padding: const EdgeInsets.all(defaultPadding),
                            decoration: BoxDecoration(
                              border: Border.all(
                                  width: 2,
                                  color: primaryColor.withOpacity(0.15)),
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
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        DropdownButtonFormField<int>(
                                          value: typeSelect,
                                          onChanged: (type) {
                                            typeSelect = type!;
                                          },
                                          items: types,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.only(top: defaultPadding),
                            padding: const EdgeInsets.all(defaultPadding),
                            decoration: BoxDecoration(
                              border: Border.all(
                                  width: 2,
                                  color: primaryColor.withOpacity(0.15)),
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
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        MaterialButton(
                                          child: Text(dateShow),
                                          onPressed: () {
                                            // 调用函数打开
                                            showDatePicker(
                                              context: context,
                                              initialDate: DateTime.now(),
                                              firstDate: DateTime.now()
                                                  .subtract(const Duration(
                                                      days:
                                                          365 * 10)), // 减 30 天
                                              lastDate: DateTime.now().add(
                                                  const Duration(
                                                      days: 30)), // 加 30 天
                                            ).then((DateTime? val) {
                                              if (val == null) return;
                                              showTimePicker(
                                                      context: context,
                                                      initialTime: TimeOfDay
                                                          .fromDateTime(
                                                              dateSelect))
                                                  .then((value) {
                                                val = DateTime(
                                                    val!.year,
                                                    val!.month,
                                                    val!.day,
                                                    value!.hour,
                                                    value.minute,
                                                    0,
                                                    0,
                                                    0);
                                                update(val);
                                              });
                                              return null;
                                            });
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.only(top: defaultPadding),
                            padding: const EdgeInsets.all(defaultPadding),
                            decoration: BoxDecoration(
                              border: Border.all(
                                  width: 2,
                                  color: primaryColor.withOpacity(0.15)),
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
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        DropdownButtonFormField<Category>(
                                          value: _categories!
                                              .firstWhere((element) =>
                                                  element.value!.id ==
                                                  categorySelect)
                                              .value!,
                                          onChanged: (category) {
                                            categorySelect = category!.id!;
                                          },
                                          items: _categories,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.only(top: defaultPadding),
                            padding: const EdgeInsets.all(defaultPadding),
                            decoration: BoxDecoration(
                              border: Border.all(
                                  width: 2,
                                  color: primaryColor.withOpacity(0.15)),
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
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        DropdownButtonFormField<Account>(
                                          value: _accounts!
                                              .firstWhere((element) =>
                                                  element.value!.id ==
                                                  accountSelect)
                                              .value!,
                                          onChanged: (account) {
                                            accountSelect = account!.id!;
                                          },
                                          items: _accounts,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.only(top: defaultPadding),
                            padding: const EdgeInsets.all(defaultPadding),
                            decoration: BoxDecoration(
                              border: Border.all(
                                  width: 2,
                                  color: primaryColor.withOpacity(0.15)),
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
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        TextFormField(
                                          controller: tagController,
                                          decoration: const InputDecoration(
                                            labelText: 'Tag',
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.only(top: defaultPadding),
                            padding: const EdgeInsets.all(defaultPadding),
                            decoration: BoxDecoration(
                              border: Border.all(
                                  width: 2,
                                  color: primaryColor.withOpacity(0.15)),
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
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        TextFormField(
                                          controller: remarkController,
                                          decoration: const InputDecoration(
                                            labelText: 'Remark',
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                              padding: const EdgeInsets.only(top: 28.0),
                              child: Row(
                                children: <Widget>[
                                  Expanded(
                                    child: ElevatedButton(
                                      child: const Padding(
                                        padding: EdgeInsets.all(16.0),
                                        child: Text('Save'),
                                      ),
                                      onPressed: () {
                                        // Save
                                        final t = Transaction(
                                            id: transaction.id,
                                            description:
                                                descriptionController.text,
                                            amount: (double.parse(
                                                        amountController.text) *
                                                    100)
                                                .round(),
                                            date: dateSelect,
                                            type: typeSelect,
                                            categoryID: categorySelect,
                                            accountID: accountSelect,
                                            tag: tagController.text,
                                            target: targetController.text,
                                            remark: remarkController.text);
                                        DBProvider.db.saveTransaction(t);
                                        // var controller = context
                                        //     .read<TransactionTableController>();
                                        // controller.update();
                                        callback();
                                        Navigator.pop(context);
                                      },
                                    ),
                                  ),
                                ],
                              )),
                        ],
                      ),
                    ),
                  ),
                )
              ],
            ));
          }
          return Scaffold(
            appBar: AppBar(
                elevation: 0,
                centerTitle: true,
                title: const Text('Transaction')),
            body: SafeArea(
              child: Container(
                padding: const EdgeInsets.all(defaultPadding),
                decoration: const BoxDecoration(
                  color: secondaryColor,
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                ),
              ),
            ),
          );
        });
  }

  void update(val) {
    setState(() {
      dateSelect = val;
      dateShow = dateSelect.toString().substring(0, 19);
    });
  }

  Future<void> loadData() async {
    final clist = await DBProvider.db.getCategories();
    final alist = await DBProvider.db.getAccounts();
    _categories = clist.map<DropdownMenuItem<Category>>((category) {
      return DropdownMenuItem<Category>(
        key: ValueKey<int>(category.id!),
        value: category,
        child: Text('${category.name}'),
      );
    }).toList();
    _accounts = alist.map<DropdownMenuItem<Account>>((account) {
      return DropdownMenuItem<Account>(
        key: ValueKey<int>(account.id!),
        value: account,
        child: Text(account.name),
      );
    }).toList();
    if (categorySelect == 0) {
      categorySelect = _categories![0].value!.id!;
    }
    if (accountSelect == 0) {
      accountSelect = _accounts![0].value!.id!;
    }
  }
}
