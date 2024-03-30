import 'package:moneyjar/models/category.dart';
import 'package:flutter/material.dart';
import 'package:moneyjar/data/database.dart';
import 'package:moneyjar/screens/categories/category_form.dart';
import 'package:moneyjar/screens/categories/category_screen.dart';
import 'package:moneyjar/screens/components/refresh.dart';
import '../../constants.dart';

class CategoryGridView extends StatefulWidget {
  final List<Category> categories;
  final int crossAxisCount;
  final double childAspectRatio;
  CategoryGridView(
      {required this.categories,
      this.crossAxisCount = 4,
      this.childAspectRatio = 1});
  @override
  _CategoryGridViewState createState() => _CategoryGridViewState(
      categories: categories,
      crossAxisCount: crossAxisCount,
      childAspectRatio: childAspectRatio);
}

class _CategoryGridViewState extends State<CategoryGridView> {
  _CategoryGridViewState({
    required this.categories,
    this.crossAxisCount = 4,
    this.childAspectRatio = 1,
  });
  List<Category> categories;
  final int crossAxisCount;
  final double childAspectRatio;

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
        padding: EdgeInsets.all(defaultPadding),
        decoration: BoxDecoration(
          color: secondaryColor,
          borderRadius: const BorderRadius.all(Radius.circular(10)),
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
                  "${categories[index].transactionCount} Transactions",
                  style: Theme.of(context)
                      .textTheme
                      .bodySmall!
                      .copyWith(color: Colors.white70),
                ),
                Text(
                  categories[index].amount?.toString() ?? '0.0',
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
                  icon: Icon(Icons.remove_red_eye),
                  onPressed: () {
                    RefreshContext.of(context)!.refresh(
                        CategoryScreen(category: categories[index]),
                        categories[index].name!);
                  },
                ),
                IconButton(
                  icon: Icon(Icons.edit),
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
                  icon: Icon(Icons.delete),
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
