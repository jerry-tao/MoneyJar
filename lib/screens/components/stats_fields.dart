import 'package:flutter/material.dart';
import 'package:moneyjar/controllers/refresh.dart';
import 'package:moneyjar/responsive.dart';
import 'package:moneyjar/screens/stats/bar_view.dart';
import 'package:moneyjar/screens/stats/line_view.dart';
import 'package:moneyjar/screens/stats/pie_view.dart';

import '../../../constants.dart';

class StatsField extends StatelessWidget {
  const StatsField({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Stats Graph',
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ],
        ),
        const SizedBox(height: defaultPadding),
        Responsive(
          mobile: StatsCardGridView(
            crossAxisCount: size.width < 650 ? 2 : 4,
            childAspectRatio: size.width < 650 && size.width > 350 ? 1.3 : 1,
          ),
          tablet: const StatsCardGridView(),
          desktop: StatsCardGridView(
            childAspectRatio: size.width < 1400 ? 1.1 : 1.4,
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
      physics: const NeverScrollableScrollPhysics(),
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
      padding: const EdgeInsets.all(defaultPadding),
      decoration: const BoxDecoration(
        color: secondaryColor,
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                  padding: const EdgeInsets.all(defaultPadding * 0.75),
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

  StatGraph({this.svgSrc, this.title, this.color, required this.child});
  final String? svgSrc, title;
  final Color? color;
  final Widget child;
}

List stats = [
  StatGraph(
    title: 'Pie',
    svgSrc: 'assets/icons/Documents.svg',
    color: primaryColor,
    child: const Pie(),
  ),
  StatGraph(
    title: 'Line',
    svgSrc: 'assets/icons/google_drive.svg',
    color: const Color(0xFFFFA113),
    child: const Line(),
  ),
  StatGraph(
    title: 'Bar',
    svgSrc: 'assets/icons/one_drive.svg',
    color: const Color(0xFFA4CDFF),
    child: const Bar(),
  ),
];
