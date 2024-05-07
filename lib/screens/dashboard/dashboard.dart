import 'package:flutter/material.dart';
import 'package:moneyjar/data/database.dart';
import 'package:moneyjar/responsive.dart';
import 'package:moneyjar/screens/components/card_grid.dart';
import 'package:moneyjar/screens/transactions/transaction_table.dart';

import '../../constants.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const DashboardWidget(),
        const SizedBox(height: defaultPadding),
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
  State<DashboardWidget> createState() => _DashboardWidgetState();
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
    final size = MediaQuery.of(context).size;
    return FutureBuilder(
        future: _data,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return Column(
              children: [
                const SizedBox(height: defaultPadding),
                Responsive(
                  mobile: InfoCardGridView(
                    data:
                        (snapshot.data as Map<String, String>).entries.toList(),
                    crossAxisCount: size.width < 650 ? 2 : 4,
                    childAspectRatio:
                        size.width < 650 && size.width > 350 ? 1.3 : 1,
                  ),
                  tablet: InfoCardGridView(
                    data:
                        (snapshot.data as Map<String, String>).entries.toList(),
                  ),
                  desktop: InfoCardGridView(
                    data:
                        (snapshot.data as Map<String, String>).entries.toList(),
                    childAspectRatio: size.width < 1400 ? 1.1 : 1.4,
                  ),
                ),
              ],
            );
          } else {
            return const CircularProgressIndicator();
          }
        });
  }
}
