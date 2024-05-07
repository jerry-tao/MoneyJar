import 'package:flutter/material.dart';
import 'package:moneyjar/models/account.dart';
import 'package:moneyjar/screens/accounts/account_header.dart';
import 'package:moneyjar/screens/transactions/transaction_table.dart';

import '../../constants.dart';

class AccountView extends StatelessWidget {
  const AccountView({
    Key? key,
    required this.account,
  }) : super(key: key);
  final Account account;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AccountHeader(account: account),
        const SizedBox(height: defaultPadding),
        Expanded(
            child: TransactionTable(
                showRemain: true,
                params: QueryParams(accountId: <int>[account.id!]))),
      ],
    );
  }
}
