import 'package:moneyjar/models/account.dart';
import 'package:moneyjar/screens/accounts/account_info.dart';
import 'package:moneyjar/screens/transactions/transaction_table.dart';
import 'package:flutter/material.dart';

import '../../constants.dart';

class AccountScreen extends StatefulWidget {
  AccountScreen({
    Key? key,
    required this.account, // 接收一个text参数
  }) : super(key: key);
  final Account account;

  @override
  AccountState createState() => AccountState(account: this.account);
}

class AccountState extends State<AccountScreen> {
  AccountState({
    required this.account, // 接收一个text参数
  });

  Account account;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AccountInfo(account: this.account),
        SizedBox(height: defaultPadding),
        Expanded(child:
        TransactionTable(
            showRemain: true,
            params: QueryParams(accountId: <int>[this.account.id!]))),
      ],
    );
  }
}
