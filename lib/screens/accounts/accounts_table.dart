import 'package:moneyjar/data/database.dart';
import 'package:moneyjar/models/account.dart';
import 'package:moneyjar/screens/accounts/account_form.dart';
import 'package:moneyjar/screens/accounts/account_screen.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:moneyjar/screens/components/refresh.dart';
import 'package:flutter/material.dart';

import '../../../constants.dart';

class AccountTable extends StatefulWidget {
  final List<Account> accounts;

  AccountTable({
    required this.accounts,
    Key? key,
  }) : super(key: key);

  @override
  _AccountTableState createState() => _AccountTableState(accounts: accounts);
}

class _AccountTableState extends State<AccountTable> {
  List<Account> accounts;
  _AccountTableState({required this.accounts});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(child: Container(
      padding: EdgeInsets.all(defaultPadding),
      decoration: BoxDecoration(
        color: secondaryColor,
        borderRadius: const BorderRadius.all(Radius.circular(10)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Accounts",
            style: Theme.of(context).textTheme.titleMedium,
          ),
          SizedBox(
            height: 720,
            child: DataTable2(
              scrollController: ScrollController(),
              columnSpacing: defaultPadding,
              minWidth: 600,
              columns: [
                DataColumn(
                  label: Text("ID"),
                ),
                DataColumn(
                  label: Text("Name"),
                ),
                DataColumn(
                  label: Text("Type"),
                ),
                DataColumn(
                  label: Text("Remain"),
                ),
                DataColumn(
                  label: Text("TransactionCount"),
                ),
                DataColumn(
                  label: Text("Action"),
                ),
              ],
              rows: buildRows(accounts),
            ),
          ),
        ],
      ),
    ));
  }

  List<DataRow> buildRows(List<Account> accounts) {
    return accounts.map<DataRow>((account) {
      String accountType;
      switch (account.type) {
        case Account.CashAccountType:
          accountType = 'Cash';
          break;
        case Account.CreditAccountType:
          accountType = 'Credit';
          break;
        case Account.InvestmentAccountType:
          accountType = 'Investment';
          break;
        default:
          accountType = 'Unknown';
      }
      return DataRow(
        key: ValueKey<int>(account.id!),
        cells: [
          DataCell(Text("${account.id}"), onTap: () {
            ;
          }),
          DataCell(Text("${account.name}")),
          DataCell(Text(accountType)),
          DataCell(Text("${account.remain}")),
          DataCell(Text("${account.transactionCount}")),
          DataCell(
            // view,edit,delete
            Row(
              children: [
                IconButton(
                  icon: Icon(Icons.remove_red_eye),
                  onPressed: () {
                    RefreshContext.of(context)!.refresh(
                        AccountScreen(account: account), account.name!);
                  },
                ),
                IconButton(
                  icon: Icon(Icons.edit),
                  onPressed: () {
                    showDialog<void>(
                        context: context,
                        builder: (context) => AccountForm(
                            account: account,
                            callback: (a) {
                              DBProvider.db.saveAccount(a);
                              setState(() {
                                accounts[accounts.indexWhere(
                                    (element) => element.id == a.id)] = a;
                              });
                            }));
                  },
                ),
                IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () {
                    DBProvider.db.deleteAccount(account.id!);
                    setState(() {
                      accounts.remove(account);
                    });
                  },
                ),
              ],
            ),
          ),
        ],
      );
    }).toList();
  }
}
