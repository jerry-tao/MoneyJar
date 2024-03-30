import 'package:moneyjar/responsive.dart';
import 'package:moneyjar/screens/components/refresh.dart';
import 'package:moneyjar/screens/stats/pie.dart';
import 'package:moneyjar/screens/stats/line.dart';
import 'package:moneyjar/screens/stats/bar.dart';
import 'package:flutter/material.dart';

import '../../../constants.dart';

class StatsField extends StatelessWidget {
  const StatsField({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Size _size = MediaQuery.of(context).size;
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Stats Graph",
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ],
        ),
        SizedBox(height: defaultPadding),
        Responsive(
          mobile: StatsCardGridView(
            crossAxisCount: _size.width < 650 ? 2 : 4,
            childAspectRatio: _size.width < 650 && _size.width > 350 ? 1.3 : 1,
          ),
          tablet: StatsCardGridView(),
          desktop: StatsCardGridView(
            childAspectRatio: _size.width < 1400 ? 1.1 : 1.4,
          ),
        ),
      ],
    );
  }
}

class StatsCardGridView extends StatelessWidget {
  const StatsCardGridView({
    Key? key,
    this.crossAxisCount = 4,
    this.childAspectRatio = 1,
  }) : super(key: key);

  final int crossAxisCount;
  final double childAspectRatio;
  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: stats.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        crossAxisSpacing: defaultPadding,
        mainAxisSpacing: defaultPadding,
        childAspectRatio: childAspectRatio,
      ),
      itemBuilder: (context, index) => StatsInfoCard(info: stats[index]),
    );
  }
}

class StatsInfoCard extends StatelessWidget {
  const StatsInfoCard({
    Key? key,
    required this.info,
  }) : super(key: key);

  final StatGraph info;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(defaultPadding),
      decoration: BoxDecoration(
        color: secondaryColor,
        borderRadius: const BorderRadius.all(Radius.circular(10)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                  padding: EdgeInsets.all(defaultPadding * 0.75),
                  height: 100,
                  width: 100,
                  decoration: BoxDecoration(
                    color: info.color!.withOpacity(0.1),
                    borderRadius: const BorderRadius.all(Radius.circular(10)),
                  ),
                  child: Icon(Icons.insert_chart_outlined, color: info.color)),
            ],
          ),
          MaterialButton(
              onPressed: () {
                RefreshContext.of(context)!.refresh(info.child, info.title!);
              },
              child: Text(
                info.title!,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ))
        ],
      ),
    );
  }
}

class StatGraph {
  final String? svgSrc, title;
  final Color? color;
  final Widget child;

  StatGraph({this.svgSrc, this.title, this.color, required this.child});
}

List stats = [
  StatGraph(
    title: "Pie",
    svgSrc: "assets/icons/Documents.svg",
    color: primaryColor,
    child: Pie(),
  ),
  StatGraph(
    title: "Line",
    svgSrc: "assets/icons/google_drive.svg",
    color: Color(0xFFFFA113),
    child: Line(),
  ),
  StatGraph(
    title: "Bar",
    svgSrc: "assets/icons/one_drive.svg",
    color: Color(0xFFA4CDFF),
    child: Bar(),
  ),
];
