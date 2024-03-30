import 'package:moneyjar/controllers/update_controller.dart';
import 'package:moneyjar/screens/components/refresh.dart';
import 'package:animations/animations.dart';

import 'package:flutter/material.dart';
import 'package:moneyjar/controllers/menu_app_contoller.dart';
import 'package:provider/provider.dart';
import 'package:moneyjar/models/transaction.dart';
import 'package:moneyjar/screens/components/header.dart';
import '../responsive.dart';
import 'components/side_menu.dart';
import 'transactions/transaction_form.dart';
import 'dashboard/dashboard.dart';
import '../../constants.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Widget? child;
  String? title;

  _HomePageState();

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
    child = DashboardScreen();
  }

  @override
  Widget build(BuildContext context) {
    var controller = context.read<UpdateController>();
    return RefreshContext(
        refresh: changeChild,
        child: Scaffold(
            key: context.read<MenuAppController>().scaffoldKey,
            // This drawer will only be displayed when the width of the screen is less than 850 and clicking on the menu button
            drawer: SideMenu(),
            floatingActionButton: OpenContainer(
              closedColor: primaryColor,
              closedShape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(100.0)),
              ),
              closedBuilder: (BuildContext c, VoidCallback action) => Container(
                padding: EdgeInsets.all(defaultPadding * 0.75),
                margin: EdgeInsets.all(defaultPadding / 2),
                child: Icon(Icons.add),
              ),
              openBuilder: (BuildContext c, VoidCallback action) =>
                  TransactionForm(
                callback: () {
                  controller.update();
                },
                transaction: Transaction(),
              ),
              tappable: true,
            ),
            body: SafeArea(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // We want this side menu only for large screen
                  if (Responsive.isDesktop(context))
                    Expanded(
                      // default flex = 1
                      // and it takes 1/6 part of the screen
                      child: SideMenu(),
                    ),
                  Expanded(
                    // It takes 5/6 part of the screen
                    flex: 5,
                    child: Container(
                      padding: EdgeInsets.all(defaultPadding),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // TODO not very lovely.
                          Expanded(
                            child: Header(title: title!),
                            flex: 1,
                          ),
                          // SizedBox(height: defaultPadding),
                          Expanded(
                              child:  child!, flex: 10),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            )));
  }
}
