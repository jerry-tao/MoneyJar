import 'package:flutter/material.dart';
import 'package:moneyjar/data/database.dart';
import 'package:moneyjar/models/account.dart';
import 'package:moneyjar/responsive.dart';
import 'package:moneyjar/screens/accounts/account_form.dart';
import 'package:moneyjar/screens/accounts/accounts_table.dart';

import '../../constants.dart';

class AccountsView extends StatefulWidget {
  const AccountsView({Key? key}) : super(key: key);

  @override
  State<AccountsView> createState() => _AccountsState();
}

class _AccountsState extends State<AccountsView> {
  _AccountsState();
  late Future<List<Account>> _accounts;

  @override
  void initState() {
    super.initState();
    _accounts = DBProvider.db.getAccounts();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _accounts,
        builder: (context, snap) {
          if (snap.connectionState == ConnectionState.done) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: defaultPadding, width: double.infinity),
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
                        builder: (context) => AccountForm(callback: (a) {
                              DBProvider.db.saveAccount(a);
                              setState(() {
                                _accounts = DBProvider.db.getAccounts();
                              });
                            }));
                  },
                  icon: const Icon(Icons.add),
                  label: const Text('Add New'),
                ),
                const SizedBox(height: defaultPadding, width: double.infinity),
                Expanded(
                  child: snap.data == null || (snap.data! as List).isEmpty
                      ? const Center(child: Text('No Account found'))
                      : AccountTable(accounts: snap.data! as List<Account>),
                ),
              ],
            );
          }
          return const CircularProgressIndicator();
        });
  }
}
