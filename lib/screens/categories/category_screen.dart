import 'package:moneyjar/models/category.dart';
import 'package:moneyjar/screens/categories/category_info.dart';

import 'package:moneyjar/screens/transactions/transaction_table.dart';
import 'package:flutter/material.dart';

import '../../constants.dart';

class CategoryScreen extends StatefulWidget {
  final Category category;
  CategoryScreen({
    Key? key,
    required this.category,
  }) : super(key: key);
  @override
  _CategoryState createState() => _CategoryState(category: this.category);
}

class _CategoryState extends State<CategoryScreen> {
  _CategoryState({
    required this.category, // 接收一个text参数
  });
  Category category;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CategoryInfo(category: this.category),
        SizedBox(height: defaultPadding),
        Expanded(child:
        TransactionTable(
            params: QueryParams(categoryId: <int>[this.category.id!]))),
      ],
    );
  }
}
