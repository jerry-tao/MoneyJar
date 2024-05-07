import 'package:flutter/material.dart';
import 'package:moneyjar/data/database.dart';
import 'package:moneyjar/screens/stats/line_chart.dart';

import '../../constants.dart';

class Line extends StatefulWidget {
  const Line({
    Key? key,
  }) : super(key: key);

  @override
  State<Line> createState() => _LineState();
}

class KindItem {

  KindItem({required this.name, required this.value});
  String name, value;
}

class _LineState extends State<Line> {
  // String? kind;
  DateTime? _start, _end;
  Widget? chart;
  var dateText = 'Start Date - End Date';
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          margin: const EdgeInsets.only(top: defaultPadding),
          padding: const EdgeInsets.all(defaultPadding),
          decoration: BoxDecoration(
            border: Border.all(width: 2, color: primaryColor.withOpacity(0.15)),
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
                  padding:
                      const EdgeInsets.symmetric(horizontal: defaultPadding),
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
                  padding:
                      const EdgeInsets.symmetric(horizontal: defaultPadding),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      MaterialButton(
                        child: const Text('Query'),
                        onPressed: () {
                          getLineData();
                        },
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),

        // Container(
        //   margin: EdgeInsets.only(top: defaultPadding),
        //   padding: EdgeInsets.all(defaultPadding),
        //   decoration: BoxDecoration(
        //     border: Border.all(width: 2, color: primaryColor.withOpacity(0.15)),
        //     borderRadius: const BorderRadius.all(
        //       Radius.circular(defaultPadding),
        //     ),
        //   ),
        //   child: Row(
        //     children: [
        //       SizedBox(
        //         height: 20,
        //         width: 20,
        //       ),
        //       Expanded(
        //         child: Padding(
        //           padding:
        //               const EdgeInsets.symmetric(horizontal: defaultPadding),
        //           child: Column(
        //             crossAxisAlignment: CrossAxisAlignment.start,
        //             children: [
        //               DropdownButtonFormField<KindItem>(
        //                 onChanged: (kind) {
        //                   setState(() {
        //                     _kind = kind?.value;
        //                   });
        //                 },
        //                 items: _kinds,
        //               )
        //             ],
        //           ),
        //         ),
        //       ),
        //     ],
        //   ),
        // ),
        // Expanded(child: chart ?? Text(""))
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
  }

  Future<void> getLineData() async {
    final result = await DBProvider.db.getLineData(
        _start!.millisecondsSinceEpoch, _end!.millisecondsSinceEpoch);
    if (result.asMap().entries.isEmpty) {
      return;
    }
    setState(() {
      chart = LineChart(kvs: result);
    });
  }
}
