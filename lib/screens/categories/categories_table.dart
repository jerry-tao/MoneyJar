import 'package:flutter/material.dart';
import 'package:moneyjar/models/category.dart';

import '../../../constants.dart';
import '../../responsive.dart';
import 'category_grid_view.dart';

class CategoryTable extends StatefulWidget {
  const CategoryTable({
    required this.categories,
    Key? key,
  }) : super(key: key);
  final List<Category> categories;

  @override
  State<CategoryTable> createState() => _CategoryTableState();
}

class _CategoryTableState extends State<CategoryTable> {
  late List<Category> categories;
  @override
  void initState() {
    super.initState();
    categories = widget.categories;
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return SingleChildScrollView(
      padding: const EdgeInsets.all(defaultPadding),
      // decoration: BoxDecoration(
      // color: secondaryColor,
      // borderRadius: const BorderRadius.all(Radius.circular(10)),
      // ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: [
              const SizedBox(height: defaultPadding),
              Responsive(
                mobile: CategoryGridView(
                  categories: categories,
                  crossAxisCount: size.width < 650 ? 2 : 4,
                  childAspectRatio:
                      size.width < 650 && size.width > 350 ? 1.3 : 1,
                ),
                tablet: CategoryGridView(
                  categories: categories,
                ),
                desktop: CategoryGridView(
                  categories: categories,
                  childAspectRatio: size.width < 1400 ? 1.1 : 1.4,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
