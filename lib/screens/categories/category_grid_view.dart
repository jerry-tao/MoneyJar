import 'package:flutter/material.dart';
import 'package:moneyjar/controllers/refresh.dart';
import 'package:moneyjar/data/database.dart';
import 'package:moneyjar/models/category.dart';
import 'package:moneyjar/screens/categories/category_form.dart';
import 'package:moneyjar/screens/categories/category_view.dart';

import '../../constants.dart';

class CategoryGridView extends StatefulWidget {
  const CategoryGridView(
      {Key? key,
      required this.categories,
      this.crossAxisCount = 4,
      this.childAspectRatio = 1})
      : super(key: key);
  final List<Category> categories;
  final int crossAxisCount;
  final double childAspectRatio;
  @override
  State<CategoryGridView> createState() => _CategoryGridViewState();
}

class _CategoryGridViewState extends State<CategoryGridView> {
  late List<Category> categories;
  late int crossAxisCount = 4;
  late double childAspectRatio = 1;
  @override
  void initState() {
    super.initState();
    categories = widget.categories;
    crossAxisCount = widget.crossAxisCount;
    childAspectRatio = widget.childAspectRatio;
  }

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      controller: ScrollController(),
      shrinkWrap: true,
      itemCount: categories.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        crossAxisSpacing: defaultPadding,
        mainAxisSpacing: defaultPadding,
        childAspectRatio: childAspectRatio,
      ),
      itemBuilder: (context, index) => Container(
        padding: const EdgeInsets.all(defaultPadding),
        decoration: const BoxDecoration(
          color: secondaryColor,
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              categories[index].name!,
              maxLines: 1,
              style: Theme.of(context)
                  .textTheme
                  .bodyLarge!
                  .copyWith(color: Colors.white),
              overflow: TextOverflow.ellipsis,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${categories[index].transactionCount} Transactions',
                  style: Theme.of(context)
                      .textTheme
                      .bodySmall!
                      .copyWith(color: Colors.white70),
                ),
                Text(
                  (categories[index].amount! / 100.0).toString(),
                  style: Theme.of(context)
                      .textTheme
                      .bodySmall!
                      .copyWith(color: Colors.white),
                ),
              ],
            ),
            Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.remove_red_eye),
                  onPressed: () {
                    RefreshContext.of(context)!.refreshWidget(
                        CategoryView(category: categories[index]),
                        categories[index].name!);
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () {
                    showDialog<void>(
                        context: context,
                        builder: (context) => CategoryForm(
                            category: categories[index],
                            callback: (c) {
                              DBProvider.db.saveCategory(c);
                              setState(() {
                                categories[categories.indexWhere(
                                    (element) => element.id == c.id)] = c;
                              });
                            }));
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () {
                    DBProvider.db.deleteCategory(categories[index].id!);
                    setState(() {
                      categories.removeAt(index);
                    });
                  },
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
