import 'package:flutter/material.dart';
import 'package:moneyjar/models/category.dart';
import 'package:moneyjar/screens/categories/category_header.dart';
import 'package:moneyjar/screens/transactions/transaction_table.dart';

import '../../constants.dart';

class CategoryView extends StatefulWidget {
  const CategoryView({
    Key? key,
    required this.category,
  }) : super(key: key);
  final Category category;
  @override
  State<CategoryView> createState() => _CategoryState();
}

class _CategoryState extends State<CategoryView> {
  late Category category;

  @override
  void initState() {
    super.initState();
    category = widget.category;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CategoryInfo(category: category),
        const SizedBox(height: defaultPadding),
        Expanded(
            child: TransactionTable(
                params: QueryParams(categoryId: <int>[category.id!]))),
      ],
    );
  }
}
