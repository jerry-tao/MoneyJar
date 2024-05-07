import 'dart:typed_data';

import 'package:csv/csv.dart';
import 'package:file_selector/file_selector.dart';
import 'package:flutter/material.dart';
import 'package:moneyjar/controllers/refresh.dart';
import 'package:moneyjar/data/database.dart';
import 'package:moneyjar/screens/accounts/accounts_view.dart';
import 'package:moneyjar/screens/categories/categories_view.dart';
import 'package:moneyjar/screens/dashboard/dashboard.dart';
import 'package:moneyjar/screens/stats/stats_view.dart';
import 'package:moneyjar/screens/transactions/transactions_view.dart';

class SideMenu extends StatelessWidget {
  const SideMenu({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        controller: ScrollController(),
        children: [
          DrawerHeader(
            child: Image.asset('assets/images/logo.png'),
          ),
          DrawerListTile(
            title: 'Dashboard',
            icon: const Icon(Icons.home),
            press: () {
              RefreshContext.of(context)!
                  .refreshWidget(const DashboardScreen(), 'Dashboard');
            },
          ),
          DrawerListTile(
            title: 'Transaction',
            icon: const Icon(Icons.receipt),
            press: () {
              RefreshContext.of(context)!
                  .refreshWidget(const TransactionsView(), 'Transactions');
            },
          ),
          DrawerListTile(
            title: 'Accounts',
            icon: const Icon(Icons.account_balance),
            press: () {
              RefreshContext.of(context)!
                  .refreshWidget(const AccountsView(), 'Accounts');
            },
          ),
          DrawerListTile(
            title: 'Categories',
            icon: const Icon(Icons.category),
            press: () {
              RefreshContext.of(context)!
                  .refreshWidget(const CategoriesView(), 'Categories');
            },
          ),
          DrawerListTile(
            title: 'Stats',
            icon: const Icon(Icons.bar_chart),
            press: () {
              RefreshContext.of(context)!
                  .refreshWidget(const StatsScreen(), 'Stats');
            },
          ),
          DrawerListTile(
            title: 'Import',
            icon: const Icon(Icons.import_export),
            press: () async {
              const xType = XTypeGroup(label: 'CSV', extensions: ['CSV']);
              final file = await openFile(acceptedTypeGroups: [xType]);
              if (file != null) {
                final myData = await file.readAsString();
                final csvTable = const CsvToListConverter().convert(myData);
                final success = await DBProvider.db.importCSV(csvTable);
                // show snackbar
                if (!context.mounted) {
                  return;
                }
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(success > 0
                        ? 'Imported $success from ${csvTable.length - 1} successfully'
                        : 'Import failed, please check the file format'),
                  ),
                );
              }
            },
          ),
          DrawerListTile(
              title: 'Export',
              icon: const Icon(Icons.file_upload),
              press: () async {
                final list = await DBProvider.db.exportCSV();
                list.insert(0, [
                  'Category',
                  'Description',
                  'Target',
                  'Amount',
                  'Type',
                  'Remark',
                  'DateTime',
                  'Account',
                  'Tag'
                ]);
                final csv = const ListToCsvConverter().convert(list);
                final fileName =
                    'export—${DateTime.now().millisecondsSinceEpoch}.csv';
                final result = await getSaveLocation(suggestedName: fileName);
                if (result == null) {
                  // Operation was canceled by the user.
                  return;
                }

                final fileData = Uint8List.fromList(csv.codeUnits);
                const mimeType = 'csv/text';
                final textFile = XFile.fromData(fileData,
                    mimeType: mimeType, name: fileName);
                await textFile.saveTo(result.path);
              })
        ],
      ),
    );
  }
}

class DrawerListTile extends StatelessWidget {
  const DrawerListTile({
    Key? key,
    // For selecting those three line once press "Command+D"
    required this.title,
    required this.icon,
    required this.press,
  }) : super(key: key);

  final String title;
  final Icon icon;
  final VoidCallback press;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: press,
      horizontalTitleGap: 0.0,
      leading: Container(
        padding: const EdgeInsets.all(8),
        child: icon,
      ),
      title: Text(
        title,
        style: const TextStyle(color: Colors.white54),
      ),
    );
  }
}
