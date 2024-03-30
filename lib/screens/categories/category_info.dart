import 'package:moneyjar/models/category.dart';
import 'package:moneyjar/responsive.dart';
import 'package:flutter/material.dart';
import 'package:moneyjar/screens/components/card_grid.dart';

import '../../../constants.dart';

class CategoryInfo extends StatelessWidget {
  const CategoryInfo({Key? key, required this.category}) : super(key: key);

  final Category category;

  @override
  Widget build(BuildContext context) {
    final Size _size = MediaQuery.of(context).size;
    final List<MapEntry> data = [
      MapEntry("Amount", category.amount),
      MapEntry("Month", category.currentMonthlyAmount),
      MapEntry("Last Month", category.lastMonthlyAmount),
      MapEntry("Transaction Count", category.transactionCount),
    ];
    return Column(
      children: [
        SizedBox(height: defaultPadding),
        Responsive(
          mobile: InfoCardGridView(
            data: data,
            crossAxisCount: _size.width < 650 ? 2 : 4,
            childAspectRatio: _size.width < 650 && _size.width > 350 ? 1.3 : 1,
          ),
          tablet: InfoCardGridView(
            data: data,
            // account: account,
          ),
          desktop: InfoCardGridView(
            data: data,
            // account: account,
            childAspectRatio: _size.width < 1400 ? 1.1 : 1.4,
          ),
        ),
      ],
    );
  }
}
