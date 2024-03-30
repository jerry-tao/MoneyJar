import 'package:flutter/material.dart';
import 'package:graphic/graphic.dart';
import 'dart:async';

class BarChart extends StatelessWidget {
  final Map<String, List<Map>> kvs;
  final priceVolumeStream = StreamController<GestureEvent>.broadcast();

  BarChart({required this.kvs});
  @override
  Widget build(BuildContext context) {
    List<Map> kvsList = [];
    kvs.entries.forEach((entry) {
      entry.value.forEach((value) {
        kvsList.add({
          "name": value['name'], // date
          "type": entry.key, // income/outcom
          "value": value['value'].abs() // amount
        });
      });
    });
    return Container(
      color: Colors.white,
      margin: const EdgeInsets.only(top: 10),
      child: Chart(
        padding: (_) => const EdgeInsets.fromLTRB(40, 5, 10, 40),
        data: kvsList,
        variables: {
          'index': Variable(
            accessor: (Map map) => map['name'] as String,
          ),
          'type': Variable(
            accessor: (Map map) => map['type'] as String,
          ),
          'value': Variable(
            accessor: (Map map) => map['value'] as num,
          ),
        },
        marks: [
          IntervalMark(
            position: Varset('index') * Varset('value') / Varset('type'),
            color: ColorEncode(variable: 'type', values: Defaults.colors10),
            size: SizeEncode(value: 2),
            modifiers: [DodgeModifier(ratio: 0.1)],
          )
        ],
        coord: RectCoord(
          horizontalRangeUpdater: Defaults.horizontalRangeEvent,
        ),
        axes: [
          Defaults.horizontalAxis..tickLine = TickLine(),
          Defaults.verticalAxis,
        ],
        selections: {
          'tap': PointSelection(
            variable: 'index',
          )
        },
        tooltip: TooltipGuide(multiTuples: true),
        crosshair: CrosshairGuide(),
      ),
    );
  }
}
