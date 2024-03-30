import 'package:moneyjar/data/database.dart';
import 'package:moneyjar/models/account.dart';
import 'package:moneyjar/models/category.dart';
import 'package:moneyjar/models/transaction.dart';
import 'package:flutter/material.dart';

import '../../constants.dart';

class TransactionForm extends StatefulWidget {
  final Transaction transaction;
  final callback;
  TransactionForm({required this.transaction, required this.callback});
  @override
  TransactionFormState createState() =>
      TransactionFormState(transaction: transaction, callback: callback);
}

class TransactionFormState extends State<TransactionForm> {
  Transaction transaction;
  final callback;
  TransactionFormState({required this.transaction, required this.callback});
  List<DropdownMenuItem<Category>>? _categories;
  List<DropdownMenuItem<Account>>? _accounts;
  final List<DropdownMenuItem<int>> types = [
    DropdownMenuItem(child: Text("Expense"), value: 1),
    DropdownMenuItem(child: Text("Income"), value: 2),
    DropdownMenuItem(child: Text("Transfer"), value: 3)
  ];
  Future<void>? future;
  @override
  initState() {
    future = loadData();
    super.initState();
    dateSelect = DateTime.now();
    dateShow = dateSelect.toString().substring(0, 19);
  }

  var descriptionController = TextEditingController();
  var amountController = TextEditingController();
  var dateSelect;
  var dateShow;
  var typeSelect = 1;
  var targetController = TextEditingController();
  var categorySelect;
  var accountSelect;
  var tagController = TextEditingController();
  var remarkController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: future,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            categorySelect = _categories![0].value!.id!;
            accountSelect = _accounts![0].value!.id!;
            dateSelect = DateTime.now();
            if (transaction.id != null) {
              descriptionController.text = transaction.description.toString();
              amountController.text = transaction.amount.toString();
              dateSelect = transaction.date;
              dateShow = dateSelect.toString().substring(0, 19);
              typeSelect = transaction.type!;
              targetController.text = transaction.target.toString();
              categorySelect = transaction.category_id;
              accountSelect = transaction.account_id;
              tagController.text = transaction.tag.toString();
              remarkController.text = transaction.remark.toString();
            }
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
                SingleChildScrollView(
                  child: Container(
                    width: 600,
                    padding: EdgeInsets.all(defaultPadding),
                    decoration: BoxDecoration(
                      color: secondaryColor,
                      borderRadius: const BorderRadius.all(Radius.circular(10)),
                    ),
                    child: Form(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: defaultPadding),
                          Container(
                            margin: EdgeInsets.only(top: defaultPadding),
                            padding: EdgeInsets.all(defaultPadding),
                            decoration: BoxDecoration(
                              border: Border.all(
                                  width: 2,
                                  color: primaryColor.withOpacity(0.15)),
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
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
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
                                  width: 2,
                                  color: primaryColor.withOpacity(0.15)),
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
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        TextFormField(
                                          controller: amountController,
                                          decoration: InputDecoration(
                                            labelText: "Amount",
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
                                  width: 2,
                                  color: primaryColor.withOpacity(0.15)),
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
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        TextFormField(
                                          controller: targetController,
                                          decoration: InputDecoration(
                                            labelText: "Target",
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
                                  width: 2,
                                  color: primaryColor.withOpacity(0.15)),
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
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
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
                                  width: 2,
                                  color: primaryColor.withOpacity(0.15)),
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
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        MaterialButton(
                                          child: Text(dateShow),
                                          onPressed: () {
                                            // 调用函数打开
                                            showDatePicker(
                                              context: context,
                                              initialDate: new DateTime.now(),
                                              firstDate: new DateTime.now()
                                                  .subtract(new Duration(
                                                      days: 30)), // 减 30 天
                                              lastDate: new DateTime.now().add(
                                                  new Duration(
                                                      days: 30)), // 加 30 天
                                            ).then((DateTime? val) {
                                              if (val == null) return;
                                              showTimePicker(
                                                      context: context,
                                                      initialTime: TimeOfDay
                                                          .fromDateTime(
                                                              dateSelect))
                                                  .then((value) {
                                                val = new DateTime(
                                                    val!.year,
                                                    val!.month,
                                                    val!.day,
                                                    value!.hour,
                                                    value.minute,
                                                    0,
                                                    0,
                                                    0);
                                                update(val);
                                              });
                                              return null;
                                            });
                                          },
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
                                  width: 2,
                                  color: primaryColor.withOpacity(0.15)),
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
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        DropdownButtonFormField<Category>(
                                          value: _categories![0].value,
                                          onChanged: (category) {
                                            categorySelect = category!.id!;
                                          },
                                          items: _categories,
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
                                  width: 2,
                                  color: primaryColor.withOpacity(0.15)),
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
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        DropdownButtonFormField<Account>(
                                          value: _accounts![0].value!,
                                          onChanged: (account) {
                                            accountSelect = account!.id!;
                                          },
                                          items: _accounts,
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
                                  width: 2,
                                  color: primaryColor.withOpacity(0.15)),
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
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        TextFormField(
                                          controller: tagController,
                                          decoration: InputDecoration(
                                            labelText: "Tag",
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
                                  width: 2,
                                  color: primaryColor.withOpacity(0.15)),
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
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        TextFormField(
                                          controller: remarkController,
                                          decoration: InputDecoration(
                                            labelText: "Remark",
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
                                        // Save
                                        var t = Transaction(
                                            id: transaction.id,
                                            description:
                                                descriptionController.text,
                                            amount: double.parse(
                                                amountController.text),
                                            date: dateSelect,
                                            type: typeSelect,
                                            category_id: categorySelect,
                                            account_id: accountSelect,
                                            tag: tagController.text,
                                            target: targetController.text,
                                            remark: remarkController.text);
                                        DBProvider.db.saveTransaction(t);
                                        // var controller = context
                                        //     .read<TransactionTableController>();
                                        // controller.update();
                                        callback();
                                        Navigator.pop(context);
                                      },
                                    ),
                                  ),
                                ],
                              )),
                        ],
                      ),
                    ),
                  ),
                )
              ],
            ));
          }
          return Scaffold(
            appBar: AppBar(
                elevation: 0, centerTitle: true, title: Text("Transaction")),
            body: SafeArea(
              child: Container(
                padding: EdgeInsets.all(defaultPadding),
                decoration: BoxDecoration(
                  color: secondaryColor,
                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                ),
              ),
            ),
          );
        });
  }

  update(val) {
    setState(() {
      dateSelect = val;
      dateShow = dateSelect.toString().substring(0, 19);
    });
  }

  Future<void> loadData() async {
    var clist = await DBProvider.db.getCategories();
    var alist = await DBProvider.db.getAccounts();
    _categories = clist.map<DropdownMenuItem<Category>>((category) {
      return DropdownMenuItem<Category>(
        key: ValueKey<int>(category.id!),
        child: Text("${category.name}"),
        value: category,
      );
    }).toList();
    _accounts = alist.map<DropdownMenuItem<Account>>((account) {
      return DropdownMenuItem<Account>(
        key: ValueKey<int>(account.id!),
        child: Text("${account.name}"),
        value: account,
      );
    }).toList();
  }
}
