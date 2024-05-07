import 'dart:async';

import 'package:flutter/material.dart';
import 'package:graphic/graphic.dart';

class BarChart extends StatelessWidget {
  BarChart({Key? key, required this.kvs}) : super(key: key);
  final Map<String, List<Map>> kvs;
  final priceVolumeStream = StreamController<GestureEvent>.broadcast();
  @override
  Widget build(BuildContext context) {
    final kvsList = <Map>[];
    for (var entry in kvs.entries) {
      for (var value in entry.value) {
        kvsList.add({
          'name': value['name'], // date
          'type': entry.key, // income/outcom
          'value': (value['value'] as int).abs() / 100.0 // amount
        });
      }
    }
    if (kvsList.isEmpty) {
      return const SizedBox();
    }
    return Container(
      // color: Colors.white,
      margin: const EdgeInsets.only(top: 20, left: 10, right: 10, bottom: 20),
      child: Chart(
        padding: (_) => const EdgeInsets.fromLTRB(0, 0, 0, 0),
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
            size: SizeEncode(value: 20),
            modifiers: [DodgeModifier(ratio: 0.06)],
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
