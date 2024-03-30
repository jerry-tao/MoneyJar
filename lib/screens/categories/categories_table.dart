import 'package:moneyjar/models/category.dart';
import 'package:flutter/material.dart';

import '../../../constants.dart';
import '../../responsive.dart';
import 'category_grid_view.dart';

class CategoryTable extends StatefulWidget {
  final List<Category> categories;
  const CategoryTable({
    required this.categories,
    Key? key,
  }) : super(key: key);

  @override
  _CategoryTableState createState() =>
      _CategoryTableState(categories: categories);
}

class _CategoryTableState extends State<CategoryTable> {
  List<Category> categories;
  _CategoryTableState({required this.categories});
  @override
  Widget build(BuildContext context) {
    final Size _size = MediaQuery.of(context).size;
    return SingleChildScrollView(
      padding: EdgeInsets.all(defaultPadding),
      // decoration: BoxDecoration(
      // color: secondaryColor,
      // borderRadius: const BorderRadius.all(Radius.circular(10)),
      // ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: [
              SizedBox(height: defaultPadding),
              Responsive(
                mobile: CategoryGridView(
                  categories: categories,
                  crossAxisCount: _size.width < 650 ? 2 : 4,
                  childAspectRatio:
                      _size.width < 650 && _size.width > 350 ? 1.3 : 1,
                ),
                tablet: CategoryGridView(
                  categories: categories,
                ),
                desktop: CategoryGridView(
                  categories: categories,
                  childAspectRatio: _size.width < 1400 ? 1.1 : 1.4,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
