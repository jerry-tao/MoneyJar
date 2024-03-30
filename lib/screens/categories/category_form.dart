import 'package:flutter/material.dart';
import 'package:moneyjar/models/category.dart';
import '../../constants.dart';

class CategoryForm extends StatefulWidget {
  CategoryForm({
    Key? key,
    required this.category,
    required this.callback,
  }) : super(key: key);
  final Category category;
  final callback;

  @override
  _CategoryFormState createState() =>
      _CategoryFormState(category: this.category, callback: this.callback);
}

class _CategoryFormState extends State<CategoryForm> {
  _CategoryFormState({
    required this.category,
    required this.callback,
  });

  var nameController = TextEditingController();
  var descriptionController = TextEditingController();
  var colorController = TextEditingController();
  var iconController = TextEditingController();

  Category category;
  final callback;
  @override
  Widget build(BuildContext context) {
    nameController.text = category.name ?? '';
    descriptionController.text = category.description ?? '';
    if (category.color != null) {
      colorController.text = category.color.toString();
    }
    iconController.text = category.icon ?? '';

    return AlertDialog(
      content: Stack(
        clipBehavior: Clip.none,
        children: <Widget>[
          Positioned(
            right: -40,
            top: -40,
            child: InkResponse(
              onTap: () {
                Navigator.of(context).pop();
              },
              child: const CircleAvatar(
                backgroundColor: Colors.red,
                child: Icon(Icons.close),
              ),
            ),
          ),
          Form(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                SizedBox(height: defaultPadding),
                Container(
                  margin: EdgeInsets.only(top: defaultPadding),
                  padding: EdgeInsets.all(defaultPadding),
                  decoration: BoxDecoration(
                    border: Border.all(
                        width: 2, color: primaryColor.withOpacity(0.15)),
                    borderRadius: const BorderRadius.all(
                      Radius.circular(defaultPadding),
                    ),
                  ),
                  child: Row(
                    children: [
                      SizedBox(
                        height: 20,
                        width: 20,
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: defaultPadding),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              TextFormField(
                                controller: nameController,
                                decoration: InputDecoration(
                                  labelText: "Name",
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: defaultPadding),
                  padding: EdgeInsets.all(defaultPadding),
                  decoration: BoxDecoration(
                    border: Border.all(
                        width: 2, color: primaryColor.withOpacity(0.15)),
                    borderRadius: const BorderRadius.all(
                      Radius.circular(defaultPadding),
                    ),
                  ),
                  child: Row(
                    children: [
                      SizedBox(
                        height: 20,
                        width: 20,
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: defaultPadding),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              TextFormField(
                                controller: descriptionController,
                                decoration: InputDecoration(
                                  labelText: "Description",
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: defaultPadding),
                  padding: EdgeInsets.all(defaultPadding),
                  decoration: BoxDecoration(
                    border: Border.all(
                        width: 2, color: primaryColor.withOpacity(0.15)),
                    borderRadius: const BorderRadius.all(
                      Radius.circular(defaultPadding),
                    ),
                  ),
                  child: Row(
                    children: [
                      SizedBox(
                        height: 20,
                        width: 20,
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: defaultPadding),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              TextFormField(
                                controller: colorController,
                                decoration: InputDecoration(
                                  labelText: "Color",
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: defaultPadding),
                  padding: EdgeInsets.all(defaultPadding),
                  decoration: BoxDecoration(
                    border: Border.all(
                        width: 2, color: primaryColor.withOpacity(0.15)),
                    borderRadius: const BorderRadius.all(
                      Radius.circular(defaultPadding),
                    ),
                  ),
                  child: Row(
                    children: [
                      SizedBox(
                        height: 20,
                        width: 20,
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: defaultPadding),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              TextFormField(
                                controller: iconController,
                                decoration: InputDecoration(
                                  labelText: "Icon",
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                    padding: const EdgeInsets.only(top: 28.0),
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: ElevatedButton(
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Text("Save"),
                            ),
                            onPressed: () {
                              var c = Category(
                                  id: category.id,
                                  name: nameController.text,
                                  description: descriptionController.text,
                                  color: int.parse(colorController.text),
                                  icon: iconController.text);
                              c.transactionCount = category.transactionCount;
                              c.amount = category.amount;
                              callback(c);
                              Navigator.of(context).pop();
                            },
                          ),
                        ),
                      ],
                    ))
              ],
            ),
          ),
        ],
      ),
    );
  }
}
