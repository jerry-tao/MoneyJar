import 'package:moneyjar/models/account.dart';
import 'package:moneyjar/responsive.dart';
import 'package:moneyjar/screens/components/card_grid.dart';
import 'package:flutter/material.dart';

class AccountInfo extends StatelessWidget {
  const AccountInfo({Key? key, required this.account}) : super(key: key);

  final Account account;

  @override
  Widget build(BuildContext context) {
    final Size _size = MediaQuery.of(context).size;
    final List<MapEntry> data = [
      MapEntry("Type", account.typeString),
      MapEntry("Remain", account.remain),
      MapEntry("Limitation", account.limitation),
      MapEntry("Transaction Count", account.transactionCount),
    ];
    return Column(
      children: [
        Responsive(
          mobile: InfoCardGridView(
            data: data,
            crossAxisCount: _size.width < 650 ? 2 : 4,
            childAspectRatio: _size.width < 650 && _size.width > 350 ? 1.3 : 1,
          ),
          tablet: InfoCardGridView(
            data: data,
          ),
          desktop: InfoCardGridView(
            data: data,
            childAspectRatio: _size.width < 1400 ? 1.1 : 1.4,
          ),
        ),
      ],
    );
  }
}
