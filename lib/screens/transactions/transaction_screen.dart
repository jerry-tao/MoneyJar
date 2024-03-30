import 'package:moneyjar/models/transaction.dart';
import 'package:flutter/material.dart';

import '../../constants.dart';

class TransactionScreen extends StatelessWidget {
  final Transaction transaction;

  TransactionScreen({required this.transaction});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
        content: Stack(clipBehavior: Clip.none, children: <Widget>[
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
          width: 500,
          padding: EdgeInsets.all(defaultPadding),
          decoration: BoxDecoration(
            color: secondaryColor,
            borderRadius: const BorderRadius.all(Radius.circular(10)),
          ),
          child: Column(
            children: [
              ListTile(
                leading: CircleAvatar(child: Icon(Icons.translate)),
                title: Text("${transaction.description}"),
                subtitle: Text('Description'),
              ),
              Divider(height: 0),
              ListTile(
                leading: CircleAvatar(child: Icon(Icons.translate)),
                title: Text("${transaction.date.toString().substring(0, 19)}"),
                subtitle: Text('Date'),
              ),
              Divider(height: 0),
              ListTile(
                leading: CircleAvatar(child: Icon(Icons.translate)),
                title: Text("${transaction.amount}"),
                subtitle:
                    Text("Amount ${Transaction.typeString(transaction.type!)}"),
              ),
              Divider(height: 0),
              ListTile(
                leading: CircleAvatar(child: Icon(Icons.translate)),
                title: Text("${transaction.category}"),
                subtitle: Text("Category"),
              ),
              Divider(height: 0),
              ListTile(
                leading: CircleAvatar(child: Icon(Icons.translate)),
                title: Text("${transaction.account}"),
                subtitle: Text("Account"),
              ),
              Divider(height: 0),
              ListTile(
                leading: CircleAvatar(child: Icon(Icons.translate)),
                title: Text("${transaction.remark}"),
                subtitle: Text("Remark"),
              ),
              Divider(height: 0),
              ListTile(
                leading: CircleAvatar(child: Icon(Icons.translate)),
                title: Text("${transaction.target}"),
                subtitle: Text("Target"),
              ),
              Divider(height: 0),
              ListTile(
                leading: CircleAvatar(child: Icon(Icons.translate)),
                title: Text("${transaction.tag}"),
                subtitle: Text("Tag"),
              ),
              Divider(height: 0),
            ],
          ),
        ),
      ),
    ]));
  }
}
