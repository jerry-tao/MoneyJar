import 'package:flutter/material.dart';
import 'package:moneyjar/models/transaction.dart';

import '../../constants.dart';

class TransactionView extends StatelessWidget {

  const TransactionView({Key? key, required this.transaction})
      : super(key: key);
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
                leading: const CircleAvatar(child: Icon(Icons.translate)),
                title: Text('${transaction.description}'),
                subtitle: const Text('Description'),
              ),
              const Divider(height: 0),
              ListTile(
                leading: const CircleAvatar(child: Icon(Icons.translate)),
                title: Text(transaction.date.toString().substring(0, 19)),
                subtitle: const Text('Date'),
              ),
              const Divider(height: 0),
              ListTile(
                leading: const CircleAvatar(child: Icon(Icons.translate)),
                title: Text('${transaction.amount! / 100.0}'),
                subtitle:
                    Text('Amount ${Transaction.typeString(transaction.type!)}'),
              ),
              const Divider(height: 0),
              ListTile(
                leading: const CircleAvatar(child: Icon(Icons.translate)),
                title: Text('${transaction.category}'),
                subtitle: const Text('Category'),
              ),
              const Divider(height: 0),
              ListTile(
                leading: const CircleAvatar(child: Icon(Icons.translate)),
                title: Text('${transaction.account}'),
                subtitle: const Text('Account'),
              ),
              const Divider(height: 0),
              ListTile(
                leading: const CircleAvatar(child: Icon(Icons.translate)),
                title: Text(transaction.remark),
                subtitle: const Text('Remark'),
              ),
              const Divider(height: 0),
              ListTile(
                leading: const CircleAvatar(child: Icon(Icons.translate)),
                title: Text(transaction.target),
                subtitle: const Text('Target'),
              ),
              const Divider(height: 0),
              ListTile(
                leading: const CircleAvatar(child: Icon(Icons.translate)),
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
