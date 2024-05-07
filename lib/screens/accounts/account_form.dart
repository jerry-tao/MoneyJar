import 'package:flutter/material.dart';
import 'package:moneyjar/data/database.dart';
import 'package:moneyjar/models/account.dart';
import 'package:moneyjar/models/currency.dart';
import '../../constants.dart';

class AccountForm extends StatefulWidget {
  const AccountForm({
    Key? key,
    this.account,
    required this.callback,
  }) : super(key: key);
  final Account? account;
  final Function(Account) callback;

  @override
  State<AccountForm> createState() => _AccountFormState();
}

class _AccountFormState extends State<AccountForm> {
  final List<DropdownMenuItem<int>> types = [
    const DropdownMenuItem(value: 1, child: Text('信用账户')),
    const DropdownMenuItem(value: 2, child: Text('现金账户')),
    const DropdownMenuItem(value: 3, child: Text('投资账户'))
  ];

  final List<DropdownMenuItem<String>> currencies = DBProvider
      .currencies.entries
      .map((MapEntry<String, Currency> e) =>
          DropdownMenuItem(value: e.key, child: Text(e.key)))
      .toList();
  var nameController = TextEditingController();
  var initialController = TextEditingController();
  var typeSelect = 1;
  var limitController = TextEditingController();

  late Account? account;
  late Function(Account) callback;
  @override
  void initState() {
    super.initState();
    account = widget.account;
    callback = widget.callback;
    if (account != null && account!.type != 0) {
      typeSelect = account!.type;
    }
  }

  @override
  Widget build(BuildContext context) {
    account ??= Account();
    nameController.text = account!.name;
    initialController.text = (account!.initialAmount / 100.0).toString();
    typeSelect = account!.type;
    var currencySelect = account!.currency;
    limitController.text = (account!.limitation / 100).toString();
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
                                decoration: const InputDecoration(
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
                                controller: initialController,
                                decoration: const InputDecoration(
                                  labelText: 'Initial',
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
                              DropdownButtonFormField<String>(
                                value: currencySelect,
                                onChanged: (currency) {
                                  currencySelect = currency!;
                                },
                                items: currencies,
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
                                controller: limitController,
                                decoration: const InputDecoration(
                                  labelText: 'Limit',
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
                              final a = Account(
                                  id: account?.id,
                                  name: nameController.text,
                                  initialAmount:
                                      (double.parse(initialController.text) *
                                              100)
                                          .round(),
                                  type: typeSelect,
                                  currency: currencySelect,
                                  limitation:
                                      (double.parse(limitController.text) * 100)
                                          .round());
                              if (account != null) {
                                a.transactionCount = account!.transactionCount;
                                a.transactionAmount =
                                    account!.transactionAmount;
                              }
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
