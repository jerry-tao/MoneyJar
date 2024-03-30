import 'package:moneyjar/data/database.dart';
import 'package:moneyjar/responsive.dart';
import 'package:moneyjar/screens/accounts/account_form.dart';
import 'package:moneyjar/screens/accounts/accounts_table.dart';
import 'package:moneyjar/models/account.dart';
import 'package:flutter/material.dart';

import '../../constants.dart';

class Accounts extends StatefulWidget {
  Accounts();
  @override
  _AccountsState createState() => _AccountsState();
}

class _AccountsState extends State {
  late Future<List<Account>> _accounts;

  _AccountsState();

  final List<DropdownMenuItem<int>> types = [
    DropdownMenuItem(child: Text("Cash"), value: 1),
    DropdownMenuItem(child: Text("Credit"), value: 2)
  ];
  Future<List<Account>> getRows() async {
    var accounts = await DBProvider.db.getAccounts();
    return accounts;
  }

  @override
  void initState() {
    super.initState();
    _accounts = getRows();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _accounts,
        builder: (context, snap) {
          if (snap.connectionState == ConnectionState.done) {
            return Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ElevatedButton.icon(
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.symmetric(
                          horizontal: defaultPadding * 1.5,
                          vertical: defaultPadding /
                              (Responsive.isMobile(context) ? 2 : 1),
                        ),
                      ),
                      onPressed: () {
                        showDialog<void>(
                            context: context,
                            builder: (context) => AccountForm(
                                account: Account(),
                                callback: (a) {
                                  DBProvider.db.saveAccount(a);
                                  setState(() {
                                    _accounts = getRows();
                                  });
                                }));
                      },
                      icon: Icon(Icons.add),
                      label: Text("Add New"),
                    ),
                  ],
                ),
                SizedBox(height: defaultPadding, width: double.infinity),
                Expanded(
                  child: snap.data == null || (snap.data! as List).length == 0
                      ? Center(child: Text("No Account found"))
                      : AccountTable(accounts: snap.data! as List<Account>),flex: 10,)
                ,
              ],
            );
          }
          return CircularProgressIndicator();
        });
  }
}
