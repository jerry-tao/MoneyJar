import 'package:flutter/material.dart';
import 'package:moneyjar/controllers/menu_app_contoller.dart';
import 'package:moneyjar/controllers/refresh.dart';
import 'package:moneyjar/controllers/update_controller.dart';
import 'package:moneyjar/models/transaction.dart';
import 'package:moneyjar/screens/components/header.dart';
import 'package:provider/provider.dart';

import '../../constants.dart';
import '../responsive.dart';
import 'components/side_menu.dart';
import 'dashboard/dashboard.dart';
import 'transactions/transaction_form.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Widget child;
  late String title;

  void changeChild(Widget widget, String title) {
    setState(() {
      child = widget;
      this.title = title;
    });
  }

  @override
  void initState() {
    super.initState();
    title = 'Dashboard';
    child = const DashboardScreen();
  }

  @override
  Widget build(BuildContext context) {
    final controller = context.read<UpdateController>();
    return RefreshContext(
        refresh: changeChild,
        child: Scaffold(
            key: context.read<MenuAppController>().scaffoldKey,
            // This drawer will only be displayed when the width of the screen is less than 850 and clicking on the menu button
            drawer: const SideMenu(),
            floatingActionButton: FloatingActionButton(
                backgroundColor: primaryColor,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(100.0)),
                ),
                child: const Icon(Icons.add),
                onPressed: () {
                  showDialog<void>(
                      context: context,
                      builder: (context) => TransactionForm(
                            callback: () {
                              controller.update();
                            },
                            transaction: Transaction(),
                          ));
                }),
            body: SafeArea(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // We want this side menu only for large screen
                  if (Responsive.isDesktop(context))
                    const Expanded(
                      // default flex = 1
                      // and it takes 1/6 part of the screen
                      child: SideMenu(),
                    ),
                  Expanded(
                    // It takes 5/6 part of the screen
                    flex: 5,
                    child: Container(
                      padding: const EdgeInsets.all(defaultPadding),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            flex: 1,
                            child: Header(title: title),
                          ),
                          // SizedBox(height: defaultPadding),
                          Expanded(flex: 10, child: child),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            )));
  }
}
