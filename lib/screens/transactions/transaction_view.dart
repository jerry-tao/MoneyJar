import 'package:flutter/material.dart';
import 'package:moneyjar/models/transaction.dart';

import '../../constants.dart';

class TransactionView extends StatelessWidget {
  const TransactionView({super.key, required this.transaction});
  final Transaction transaction;

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
          padding: const EdgeInsets.all(defaultPadding),
          decoration: const BoxDecoration(
            color: secondaryColor,
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
          child: Column(
            children: [
              ListTile(
                leading: const CircleAvatar(child: Icon(Icons.receipt)),
                title: Text('${transaction.description}'),
                subtitle: const Text('Description'),
              ),
              const Divider(height: 0),
              ListTile(
                leading: const CircleAvatar(child: Icon(Icons.calendar_today)),
                title: Text(transaction.date.toString().substring(0, 19)),
                subtitle: const Text('Date'),
              ),
              const Divider(height: 0),
              ListTile(
                leading: const CircleAvatar(child: Icon(Icons.attach_money)),
                title: Text('${transaction.amount! / 100.0}'),
                subtitle: const Text('Amount'),
              ),
              const Divider(height: 0),
              ListTile(
                leading: const CircleAvatar(child: Icon(Icons.import_export)),
                title: Text(Transaction.typeString(transaction.type!)),
                subtitle: const Text('Type'),
              ),
              const Divider(height: 0),
              ListTile(
                leading: const CircleAvatar(child: Icon(Icons.category)),
                title: Text('${transaction.category}'),
                subtitle: const Text('Category'),
              ),
              const Divider(height: 0),
              ListTile(
                leading: const CircleAvatar(child: Icon(Icons.account_balance)),
                title: Text('${transaction.account}'),
                subtitle: const Text('Account'),
              ),
              const Divider(height: 0),
              ListTile(
                leading: const CircleAvatar(child: Icon(Icons.comment)),
                title: Text(transaction.remark),
                subtitle: const Text('Remark'),
              ),
              const Divider(height: 0),
              ListTile(
                leading: const CircleAvatar(child: Icon(Icons.account_box)),
                title: Text(transaction.target),
                subtitle: const Text('Target'),
              ),
              const Divider(height: 0),
              ListTile(
                leading: const CircleAvatar(child: Icon(Icons.tag)),
                title: Text(transaction.tag),
                subtitle: const Text('Tag'),
              ),
              const Divider(height: 0),
            ],
          ),
        ),
      ),
    ]));
  }
}
