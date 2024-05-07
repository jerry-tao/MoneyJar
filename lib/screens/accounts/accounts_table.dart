import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:moneyjar/controllers/refresh.dart';
import 'package:moneyjar/data/database.dart';
import 'package:moneyjar/models/account.dart';
import 'package:moneyjar/screens/accounts/account_form.dart';
import 'package:moneyjar/screens/accounts/account_view.dart';

import '../../../constants.dart';

class AccountTable extends StatefulWidget {
  const AccountTable({
    required this.accounts,
    Key? key,
  }) : super(key: key);
  final List<Account> accounts;

  @override
  State<AccountTable> createState() => _AccountTableState();
}

// TODO so for a update/delete should we update all accounts? or just the one that was updated?
class _AccountTableState extends State<AccountTable> {
  late List<Account> accounts;
  @override
  void initState() {
    super.initState();
    accounts = widget.accounts;
  }

  @override
  Widget build(BuildContext context) {
    return DataTable2(
      decoration: const BoxDecoration(
        color: secondaryColor,
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
      scrollController: ScrollController(),
      columnSpacing: defaultPadding,
      minWidth: 600,
      columns: const [
        DataColumn(
          label: Text('ID'),
        ),
        DataColumn(
          label: Text('Name'),
        ),
        DataColumn(
          label: Text('Type'),
        ),
        DataColumn(
          label: Text('Currency'),
        ),
        DataColumn(
          label: Text('Remain'),
        ),
        DataColumn(
          label: Text('NAV'),
        ),
        DataColumn(
          label: Text('TransactionCount'),
        ),
        DataColumn(
          label: Text('Action'),
        ),
      ],
      rows: buildRows(accounts),
    );
  }

  List<DataRow> buildRows(List<Account> accounts) {
    return accounts.map<DataRow>((account) {
      return DataRow(
        key: ValueKey<int>(account.id!),
        cells: [
          DataCell(Text('${account.id}'), onTap: () {}),
          DataCell(Text(account.name)),
          DataCell(Text(account.typeString)),
          DataCell(Text(account.currency)),
          DataCell(Text('${account.remain / 100.0}')),
          DataCell(Text('${account.nav / 100.0}')),
          DataCell(Text('${account.transactionCount}')),
          DataCell(
            // view,edit,delete
            Row(
              children: [
                Expanded(
                    child: IconButton(
                  icon: const Icon(Icons.remove_red_eye),
                  onPressed: () {
                    RefreshContext.of(context)!
                        .refresh(AccountView(account: account), account.name);
                  },
                )),
                Expanded(
                    child: IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () => _onPressed(account),
                )),
                Expanded(
                    child: IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () {
                    DBProvider.db.deleteAccount(account.id!);
                    setState(() {
                      accounts.remove(account);
                    });
                  },
                )),
              ],
            ),
          ),
        ],
      );
    }).toList();
  }

  void _onPressed(account) {
    showDialog<void>(
        context: context,
        builder: (context) => AccountForm(
            account: account,
            callback: (a) {
              DBProvider.db.saveAccount(a);
              setState(() {
                accounts[accounts.indexWhere((element) => element.id == a.id)] =
                    a;
              });
            }));
  }
}
