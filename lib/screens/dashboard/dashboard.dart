import 'package:moneyjar/responsive.dart';
import 'package:moneyjar/screens/components/card_grid.dart';
import 'package:moneyjar/screens/transactions/transaction_table.dart';
import 'package:flutter/material.dart';
import 'package:moneyjar/data/database.dart';

import '../../constants.dart';

class DashboardScreen extends StatelessWidget {
  DashboardScreen();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        DashboardWidget(),
        SizedBox(height: defaultPadding),
        Expanded(
            child: TransactionTable(
          params: QueryParams(),
        )),
      ],
    );
  }
}

class DashboardWidget extends StatefulWidget {
  const DashboardWidget({
    Key? key,
  }) : super(key: key);

  @override
  _DashboardWidgetState createState() => _DashboardWidgetState();
}

class _DashboardWidgetState extends State<DashboardWidget> {
  Future<Map<String, String>>? _data;

  @override
  void initState() {
    super.initState();
    _data = DBProvider.db.getDashboardData();
  }

  @override
  Widget build(BuildContext context) {
    final Size _size = MediaQuery.of(context).size;
    return FutureBuilder(
        future: _data,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return Column(
              children: [
                SizedBox(height: defaultPadding),
                Responsive(
                  mobile: InfoCardGridView(
                    data:
                        (snapshot.data as Map<String, String>).entries.toList(),
                    crossAxisCount: _size.width < 650 ? 2 : 4,
                    childAspectRatio:
                        _size.width < 650 && _size.width > 350 ? 1.3 : 1,
                  ),
                  tablet: InfoCardGridView(
                    data:
                        (snapshot.data as Map<String, String>).entries.toList(),
                  ),
                  desktop: InfoCardGridView(
                    data:
                        (snapshot.data as Map<String, String>).entries.toList(),
                    childAspectRatio: _size.width < 1400 ? 1.1 : 1.4,
                  ),
                ),
              ],
            );
          } else {
            return CircularProgressIndicator();
          }
        });
  }
}
