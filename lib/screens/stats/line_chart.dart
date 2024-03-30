import 'package:flutter/material.dart';
import 'package:graphic/graphic.dart';
import 'dart:async';

class LineChart extends StatelessWidget {
  final List<Map> kvs;
  final priceVolumeStream = StreamController<GestureEvent>.broadcast();

  LineChart({required this.kvs});
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      margin: const EdgeInsets.only(top: 10),
      // width: 650,
      // height: 450,
      child: Chart(
        data: kvs,
        variables: {
          'Date': Variable(
            accessor: (Map map) => map['name'] as String,
            scale: OrdinalScale(tickCount: 5),
          ),
          'Blanace': Variable(
            accessor: (Map map) => map['value'] as num,
          ),
        },
        marks: [
          AreaMark(
            shape: ShapeEncode(value: BasicAreaShape(smooth: true)),
            color: ColorEncode(value: Defaults.colors10.first.withAlpha(80)),
          ),
          LineMark(
            shape: ShapeEncode(value: BasicLineShape(smooth: true)),
            size: SizeEncode(value: 0.5),
          ),
        ],
        axes: [
          Defaults.horizontalAxis,
          Defaults.verticalAxis,
        ],
        selections: {
          'touchMove': PointSelection(
            on: {
              GestureType.scaleUpdate,
              GestureType.tapDown,
              GestureType.longPressMoveUpdate
            },
            dim: Dim.x,
          )
        },
        tooltip: TooltipGuide(
          followPointer: [false, true],
          align: Alignment.topLeft,
          offset: const Offset(-20, -20),
        ),
        crosshair: CrosshairGuide(followPointer: [false, true]),
      ),
    );
  }
}
