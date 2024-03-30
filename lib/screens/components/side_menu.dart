import 'package:flutter/material.dart';
import 'package:csv/csv.dart';
import 'package:file_selector/file_selector.dart';
import 'package:moneyjar/screens/components/refresh.dart';
import 'package:moneyjar/screens/dashboard/dashboard.dart';
import 'package:moneyjar/screens/transactions/transactions.dart';
import 'package:moneyjar/screens/accounts/accounts.dart';
import 'package:moneyjar/screens/categories/categories.dart';
import 'package:moneyjar/screens/stats/stats_screen.dart';
import 'package:moneyjar/data/database.dart';

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
            child: Image.asset("assets/images/logo.png"),
          ),
          DrawerListTile(
            title: "Dashboard",
            icon: Icon(Icons.home),
            press: () {
              RefreshContext.of(context)!
                  .refresh(DashboardScreen(), 'Dashboard');
            },
          ),
          DrawerListTile(
            title: "Transaction",
            icon: Icon(Icons.receipt),
            press: () {
              RefreshContext.of(context)!
                  .refresh(Transactions(), 'Transactions');
            },
          ),
          DrawerListTile(
            title: "Accounts",
            icon: Icon(Icons.account_balance),
            press: () {
              RefreshContext.of(context)!.refresh(Accounts(), 'Accounts');
            },
          ),
          DrawerListTile(
            title: "Categories",
            icon: Icon(Icons.category),
            press: () {
              RefreshContext.of(context)!.refresh(Categories(), 'Categories');
            },
          ),
          DrawerListTile(
            title: "Stats",
            icon: Icon(Icons.bar_chart),
            press: () {
              RefreshContext.of(context)!.refresh(StatsScreen(), 'Stats');
            },
          ),
          DrawerListTile(
            title: "Import",
            icon: Icon(Icons.import_export),
            press: () async {
              final xType = XTypeGroup(label: 'CSV', extensions: ['CSV']);
              final XFile? file = await openFile(acceptedTypeGroups: [xType]);
              if (file != null) {
                var myData = await file.readAsString();
                List<List<dynamic>> csvTable =
                    CsvToListConverter().convert(myData);
                DBProvider.db.importCSV(csvTable);
              }
            },
          ),
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
        padding: EdgeInsets.all(8),
        child: icon,
      ),
      title: Text(
        title,
        style: TextStyle(color: Colors.white54),
      ),
    );
  }
}
