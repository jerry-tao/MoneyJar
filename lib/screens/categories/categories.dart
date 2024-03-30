import 'package:moneyjar/responsive.dart';
import 'package:moneyjar/screens/categories/categories_table.dart';
import 'package:moneyjar/screens/categories/category_form.dart';
import 'package:flutter/material.dart';
import 'package:moneyjar/data/database.dart';
import 'package:moneyjar/models/category.dart';

import '../../constants.dart';

class Categories extends StatefulWidget {
  Categories();
  @override
  _CategoriesState createState() => _CategoriesState(); // change
}

class _CategoriesState extends State<Categories> {
  late Future<List<Category>> _categories;
  _CategoriesState();

  Future<List<Category>> getRows() async {
    var categories = await DBProvider.db.getCategories();
    return categories;
  }

  @override
  void initState() {
    super.initState();
    _categories = getRows();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _categories,
        builder: (context, snap) {
          if (snap.connectionState == ConnectionState.done) {
            if (snap.hasError) {
              return Text("Error: ${snap.error}");
            }
            return Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ElevatedButton.icon(
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.symmetric(
                          horizontal: defaultPadding * 1.5,
                          vertical: defaultPadding /
                              (Responsive.isMobile(context) ? 2 : 1),
                        ),
                      ),
                      onPressed: () {
                        showDialog<void>(
                            context: context,
                            builder: (context) => CategoryForm(
                                category: Category(),
                                callback: (c) {
                                  DBProvider.db.saveCategory(c);
                                  setState(() {
                                    _categories = getRows();
                                  });
                                }));
                      },
                      icon: Icon(Icons.add),
                      label: Text("Add New"),
                    ),
                  ],
                ),
                SizedBox(height: defaultPadding, width: double.infinity),
                Expanded(child: CategoryTable(categories: snap.data! as List<Category>),flex: 10,)
                ,
              ],
            );
          }
          return CircularProgressIndicator();
        });
  }
}
