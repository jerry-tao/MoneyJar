import 'package:moneyjar/data/database.dart';
import 'package:flutter/material.dart';
import 'package:moneyjar/screens/stats/pie_chart.dart';
import '../../constants.dart';

class Pie extends StatefulWidget {
  Pie({
    Key? key,
  }) : super(key: key);

  @override
  PieState createState() => PieState();
}

class KindItem {
  String name, value;

  KindItem({required this.name, required this.value});
}

class PieState extends State<Pie> {
  // String? kind;
  DateTime? _start, _end;
  int touchedIndex = -1;
  Widget? chart;
  Widget? chart2;
  // List<DropdownMenuItem<KindItem>> _kinds = [
  //   KindItem(name: "Category", value: "category"),
  //   KindItem(name: "Tag", value: "tag")
  // ].map<DropdownMenuItem<KindItem>>((item) {
  //   return DropdownMenuItem<KindItem>(
  //     key: ValueKey<String>(item.value),
  //     child: Text("${item.name}"),
  //     value: item,
  //   );
  // }).toList();
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
                          getPieData();
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
          child: Container(child:Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Expanded(child: chart2 ?? Text(""),flex: 1,),
              Expanded(child: chart ?? Text(""),flex: 1,)
            ],
          ) ,
            margin: EdgeInsets.only(top: defaultPadding),
            padding: EdgeInsets.all(defaultPadding),
            decoration: BoxDecoration(
              border: Border.all(width: 2, color: primaryColor.withOpacity(0.15)),
              borderRadius: const BorderRadius.all(
                Radius.circular(defaultPadding),
              ),
            ),),flex: 10,)
        ,
      ],
    );
  }

  getPieData() async {
    var result = await DBProvider.db.getPieData(
        _start!.millisecondsSinceEpoch, _end!.millisecondsSinceEpoch);
    if (result.asMap().entries.length == 0) {
      return;
    }
    setState(() {
      chart = PieCard2(kvs: result);
      chart2 = BarCard2(kvs: result);
    });
  }
}
