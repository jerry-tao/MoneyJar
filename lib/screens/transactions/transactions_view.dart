import 'package:flutter/material.dart';
import 'transaction_table.dart';

// TODO this is useless
class TransactionsView extends StatelessWidget {

  const TransactionsView({Key? key, this.params}) : super(key: key);
  final QueryParams? params;
  @override
  Widget build(BuildContext context) {
    return TransactionTable(
      params: params ?? QueryParams(),
    );
  }
}
