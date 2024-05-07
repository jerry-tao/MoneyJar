import 'package:flutter/material.dart';
import 'package:moneyjar/data/database.dart';
import 'package:moneyjar/models/category.dart';
import 'package:moneyjar/screens/stats/bar_chart.dart';

import '../../constants.dart';

class Bar extends StatefulWidget {
  const Bar({
    Key? key,
  }) : super(key: key);

  @override
  State<Bar> createState() => _BarState();
}

class KindItem {
  KindItem({required this.name, required this.value});
  String name, value;
}

class _BarState extends State<Bar> {
  // String? kind;
  DateTime? _start, _end;
  int touchedIndex = -1;
  Widget? chart;
  var dateText = 'Start Date - End Date';
  List<DropdownMenuItem<Category>>? _categories;
  Future<void>? future;
  var categorySelect = 0;
  @override
  void initState() {
    future = loadData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: future,
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const CircularProgressIndicator();
          }
          _categories!.insert(
              0,
              DropdownMenuItem<Category>(
                key: const ValueKey<int>(0),
                value: Category(id: 0, name: 'All'),
                child: const Text('All'),
              ));
          return Column(
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
                            MaterialButton(
                              child: const Text('Query'),
                              onPressed: () {
                                getBarData();
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
                flex: 10,
                child: Container(
                  margin: const EdgeInsets.only(top: defaultPadding),
                  padding: const EdgeInsets.all(defaultPadding),
                  child: chart ?? const Text(''),
                ),
              ),
            ],
          );
        });
  }

  void getBarData() async {
    final result = await DBProvider.db.getBarData(
        _start!.millisecondsSinceEpoch,
        _end!.millisecondsSinceEpoch,
        categorySelect);

    setState(() {
      chart = BarChart(kvs: result);
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
  }
}
