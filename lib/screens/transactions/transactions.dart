import 'package:flutter/material.dart';
import 'transaction_table.dart';

class Transactions extends StatelessWidget {
  final QueryParams? params;

  const Transactions({Key? key, this.params}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return TransactionTable(
      params: params ?? QueryParams(),
    );
  }
}
