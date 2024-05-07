import 'package:flutter/material.dart';
import 'package:moneyjar/models/category.dart';
import 'package:moneyjar/responsive.dart';
import 'package:moneyjar/screens/components/card_grid.dart';

import '../../../constants.dart';

class CategoryInfo extends StatelessWidget {
  const CategoryInfo({Key? key, required this.category}) : super(key: key);

  final Category category;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final data = <MapEntry>[
      MapEntry('Amount', category.amount! / 100.0),
      MapEntry('Month', category.currentMonthlyAmount! / 100.0),
      MapEntry('Last Month', category.lastMonthlyAmount! / 100.0),
      MapEntry('Transaction Count', category.transactionCount),
    ];
    return Column(
      children: [
        const SizedBox(height: defaultPadding),
        Responsive(
          mobile: InfoCardGridView(
            data: data,
            crossAxisCount: size.width < 650 ? 2 : 4,
            childAspectRatio: size.width < 650 && size.width > 350 ? 1.3 : 1,
          ),
          tablet: InfoCardGridView(
            data: data,
            // account: account,
          ),
          desktop: InfoCardGridView(
            data: data,
            // account: account,
            childAspectRatio: size.width < 1400 ? 1.1 : 1.4,
          ),
        ),
      ],
    );
  }
}
