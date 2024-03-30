import 'package:flutter/material.dart';
import 'package:moneyjar/models/account.dart';
import '../../constants.dart';

class AccountForm extends StatefulWidget {
  AccountForm({
    Key? key,
    required this.account,
    required this.callback,
  }) : super(key: key);
  final Account account;
  final callback;

  @override
  _AccountFormState createState() =>
      _AccountFormState(account: this.account, callback: this.callback);
}

class _AccountFormState extends State<AccountForm> {
  _AccountFormState({
    required this.account,
    required this.callback,
  });
  final List<DropdownMenuItem<int>> types = [
    DropdownMenuItem(child: Text("Cash"), value: 1),
    DropdownMenuItem(child: Text("Credit"), value: 2)
  ];
  var nameController = TextEditingController();
  var initialController = TextEditingController();
  var typeSelect;
  var limitController = TextEditingController();

  Account account;
  final callback;
  @override
  Widget build(BuildContext context) {
    nameController.text = account.name ?? '';
    initialController.text = account.initialAmount.toString();
    typeSelect = account.type ?? 1;
    limitController.text = account.limitation.toString();
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
                                controller: initialController,
                                decoration: InputDecoration(
                                  labelText: "Initial",
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
                              DropdownButtonFormField<int>(
                                value: typeSelect,
                                onChanged: (type) {
                                  typeSelect = type!;
                                },
                                items: types,
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
                                controller: limitController,
                                decoration: InputDecoration(
                                  labelText: "Limit",
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
                              var a = Account(
                                  id: account.id,
                                  name: nameController.text,
                                  initialAmount:
                                      double.parse(initialController.text),
                                  type: typeSelect,
                                  limitation:
                                      double.parse(limitController.text));
                              a.transactionCount = account.transactionCount;
                              a.transactionAmount = account.transactionAmount;
                              callback(a);
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
