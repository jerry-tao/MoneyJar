import 'package:flutter/material.dart';
import 'package:flutter_iconpicker/Models/configuration.dart';
import 'package:flutter_iconpicker/flutter_iconpicker.dart';
import 'package:moneyjar/models/category.dart';
import '../../constants.dart';

class CategoryForm extends StatefulWidget {
  const CategoryForm({
    super.key,
    required this.category,
    required this.callback,
  });
  final Category category;
  final Function(Category) callback;

  @override
  State<CategoryForm> createState() => _CategoryFormState();
}

class _CategoryFormState extends State<CategoryForm> {
  var nameController = TextEditingController();
  var descriptionController = TextEditingController();

  late Category category;
  late Function(Category) callback;
  late IconPickerIcon _icon;
  late String _iconKey;
  late String _iconPack;

  Future<void> _pickIcon() async {
    final icon = await showIconPicker(
      context,
      configuration: const SinglePickerConfiguration(
        iconPackModes: [IconPack.material],
      ),
    );
    if (icon == null) {
      return;
    }
    _icon = icon;
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    category = widget.category;
    callback = widget.callback;
    nameController.text = category.name ?? '';
    descriptionController.text = category.description ?? '';
    _iconKey = category.icon ?? 'add';
    _iconPack = category.iconPack ?? 'material';
    final icon = deserializeIcon({'key': _iconKey, 'pack': _iconPack});
    if (icon != null) {
      _icon = icon;
    } else {
      _icon = const IconPickerIcon(
          name: 'add', data: Icons.add, pack: IconPack.material);
    }
  }

  @override
  Widget build(BuildContext context) {
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
                const SizedBox(height: defaultPadding),
                Container(
                  margin: const EdgeInsets.only(top: defaultPadding),
                  padding: const EdgeInsets.all(defaultPadding),
                  decoration: BoxDecoration(
                    border: Border.all(
                        width: 2, color: primaryColor.withOpacity(0.15)),
                    borderRadius: const BorderRadius.all(
                      Radius.circular(defaultPadding),
                    ),
                  ),
                  child: Row(
                    children: [
                      const SizedBox(
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
                                  prefixIcon: InkWell(
                                    onTap: _pickIcon,
                                    child: Icon(_icon.data),
                                  ),
                                  labelText: 'Name',
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
                  margin: const EdgeInsets.only(top: defaultPadding),
                  padding: const EdgeInsets.all(defaultPadding),
                  decoration: BoxDecoration(
                    border: Border.all(
                        width: 2, color: primaryColor.withOpacity(0.15)),
                    borderRadius: const BorderRadius.all(
                      Radius.circular(defaultPadding),
                    ),
                  ),
                  child: Row(
                    children: [
                      const SizedBox(
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
                                decoration: const InputDecoration(
                                  labelText: 'Description',
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
                            child: const Padding(
                              padding: EdgeInsets.all(16.0),
                              child: Text('Save'),
                            ),
                            onPressed: () {
                              final iconMap = serializeIcon(_icon);
                              if (iconMap != null) {
                                _iconKey = iconMap['key'];
                                _iconPack = iconMap['pack'];
                              }
                              final c = Category(
                                id: category.id,
                                name: nameController.text,
                                description: descriptionController.text,
                                icon: _iconKey,
                                iconPack: _iconPack,
                              );
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
