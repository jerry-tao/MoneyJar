import 'package:flutter/material.dart';
import 'package:graphic/graphic.dart';

class PieCard2 extends StatelessWidget {
  const PieCard2({
    Key? key,
    required this.kvs,
  }) : super(key: key);
  final List<Map<String, dynamic>> kvs;

  @override
  Widget build(BuildContext context) {
    final top10 = kvs.sublist(0, kvs.length > 9 ? 9 : kvs.length);
    if (kvs.length > 9) {
      final rest = kvs.sublist(9);
      top10.add({
        'name': 'Other',
        'value': double.parse(rest.fold(0, (previousValue, element) {
          return (previousValue as num) + element['value'];
        }).toStringAsFixed(2))
      });
      top10.sort((a, b) => (a['value'] as double).compareTo(b['value']));
    }

    return Container(
      margin: const EdgeInsets.only(top: 10),
      child: Chart(
        data: top10,
        variables: {
          'Category': Variable(
            accessor: (Map map) {
              return map['name'] as String;
            },
          ),
          'Amount': Variable(
            accessor: (Map map) => (map['value'] as num).abs(),
          ),
        },
        transforms: [
          Proportion(
            variable: 'Amount',
            as: 'percent',
          )
        ],
        marks: [
          IntervalMark(
              label: LabelEncode(
                  encoder: (tuple) => Label(
                        tuple['Amount'].toString(),
                        LabelStyle(textStyle: Defaults.runeStyle),
                      )),
              position: Varset('percent') / Varset('Category'),
              color:
                  ColorEncode(variable: 'Category', values: Defaults.colors10),
              modifiers: [StackModifier()],
              // TODO hover rebuild.
              // transition: Transition(duration: const Duration(seconds: 2)),
              entrance: {MarkEntrance.y})
        ],
        coord: PolarCoord(
          transposed: true,
          dimCount: 1,
          startRadius: 0.4,
        ),
        selections: {
          // TODO inner circle selection wrong.
          'hover': PointSelection(
            on: {GestureType.hover, GestureType.longPressMoveUpdate},
          )
        },
        tooltip: TooltipGuide(renderer: centralPieLabel),
      ),
    );
  }

  List<MarkElement> centralPieLabel(
    Size size,
    Offset anchor,
    Map<int, Tuple> selectedTuples,
  ) {
    final tuple = selectedTuples.values.last;
    final titleElement = LabelElement(
        text: '${tuple['Category']}\n',
        anchor: Offset(size.width / 2, size.height / 2),
        style: LabelStyle(
            textStyle: const TextStyle(
              fontSize: 14,
            ),
            align: Alignment.topCenter));

    final valueElement = LabelElement(
        text: '${((tuple['percent'] as double) * 100).toStringAsFixed(2)}%',
        anchor: Offset(size.width / 2, size.height / 2),
        style: LabelStyle(
            textStyle: const TextStyle(
              fontSize: 24,
            ),
            align: Alignment.bottomCenter));

    return [titleElement, valueElement];
  }
}

class BarCard2 extends StatelessWidget {
  const BarCard2({
    Key? key,
    required this.kvs,
  }) : super(key: key);
  final List<Map<String, dynamic>> kvs;

  @override
  Widget build(BuildContext context) {
    final top10 = kvs.sublist(0, kvs.length > 9 ? 9 : kvs.length);
    if (kvs.length > 9) {
      final rest = kvs.sublist(9);
      top10.add({
        'name': 'Other',
        'value': double.parse(rest.fold(0, (previousValue, element) {
          return (previousValue as num) + element['value'];
        }).toStringAsFixed(2))
      });
      top10.sort((a, b) => (b['value'] as double).compareTo(a['value']));
    }
    return Container(
      margin: const EdgeInsets.only(top: 10),
      child: Chart(
        data: top10,
        variables: {
          'Category': Variable(
            accessor: (Map map) {
              return map['name'] as String;
            },
          ),
          'Amount': Variable(
            accessor: (Map map) => (map['value'] as double).abs() as num,
          ),
        },
        marks: [
          IntervalMark(
            label: LabelEncode(
                encoder: (tuple) => Label(tuple['Amount'].toString())),
            gradient: GradientEncode(
                value: const LinearGradient(colors: [
                  Color(0x8883bff6),
                  Color(0x88188df0),
                  Color(0xcc188df0),
                ], stops: [
                  0,
                  0.5,
                  1
                ]),
                updaters: {
                  'tap': {
                    true: (_) => const LinearGradient(colors: [
                          Color(0xee83bff6),
                          Color(0xee3f78f7),
                          Color(0xff3f78f7),
                        ], stops: [
                          0,
                          0.7,
                          1
                        ])
                  }
                }),
          )
        ],
        coord: RectCoord(transposed: true),
        axes: [
          Defaults.verticalAxis..grid = null,
          Defaults.horizontalAxis
            ..line = null
            ..grid = Defaults.strokeStyle,
        ],
        selections: {'tap': PointSelection(dim: Dim.x)},
      ),
    );
  }
}
