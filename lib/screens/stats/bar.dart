import 'package:moneyjar/data/database.dart';
import 'package:flutter/material.dart';
import 'package:moneyjar/screens/stats/bar_chart.dart';
import '../../constants.dart';

class Bar extends StatefulWidget {
  Bar({
    Key? key,
  }) : super(key: key);

  @override
  _BarState createState() => _BarState();
}

class KindItem {
  String name, value;

  KindItem({required this.name, required this.value});
}

class _BarState extends State<Bar> {
  // String? kind;
  DateTime? _start, _end;
  int touchedIndex = -1;
  Widget? chart;
  var dateText = "Start Date - End Date";

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          margin: EdgeInsets.only(top: defaultPadding),
          padding: EdgeInsets.all(defaultPadding),
          decoration: BoxDecoration(
            border: Border.all(width: 2, color: primaryColor.withOpacity(0.15)),
            borderRadius: const BorderRadius.all(
              Radius.circular(defaultPadding),
            ),
          ),
          child: Row(
            children: [
              SizedBox(
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
                        child: new Text(dateText),
                        onPressed: () {
                          // 调用函数打开
                          showDateRangePicker(
                            // 选择日期范围
                            context: context,
                            firstDate: new DateTime.now().subtract(
                                new Duration(days: 365 * 10)), // 减 30 天
                            lastDate: new DateTime.now()
                                .add(new Duration(days: 30)), // 加 30 天
                          ).then((value) {
                            if (value == null) {
                              return;
                            }
                            _start = value.start;
                            _end = value.end;
                            setState(() {
                              dateText =
                              "${_start?.toString().substring(0, 10)} - ${_end?.toString().substring(0, 10)}";
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
                        child: new Text('Query'),
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
          child: Container(child: chart ?? Text("") ,
            margin: EdgeInsets.only(top: defaultPadding),
            padding: EdgeInsets.all(defaultPadding),
            ),flex: 10,)
        ,
      ],
    );
  }

  getBarData() async {
    var result = await DBProvider.db.getBarData(
        _start!.millisecondsSinceEpoch, _end!.millisecondsSinceEpoch);
    setState(() {
      chart = BarChart(kvs: result);
    });
  }
}
