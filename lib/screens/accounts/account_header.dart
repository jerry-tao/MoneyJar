import 'package:flutter/material.dart';
import 'package:moneyjar/models/account.dart';
import 'package:moneyjar/responsive.dart';
import 'package:moneyjar/screens/components/card_grid.dart';

class AccountHeader extends StatelessWidget {
  const AccountHeader({Key? key, required this.account}) : super(key: key);

  final Account account;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final data = <MapEntry>[
      MapEntry('类型', account.typeString),
      MapEntry('余额', account.remain / 100.0),
      MapEntry('限额', account.limitation / 100.0),
      MapEntry('交易数', account.transactionCount),
    ];
    return Column(
      children: [
        Responsive(
          mobile: InfoCardGridView(
            data: data,
            crossAxisCount: size.width < 650 ? 2 : 4,
            childAspectRatio: size.width < 650 && size.width > 350 ? 1.3 : 1,
          ),
          tablet: InfoCardGridView(
            data: data,
          ),
          desktop: InfoCardGridView(
            data: data,
            childAspectRatio: size.width < 1400 ? 1.1 : 1.4,
          ),
        ),
      ],
    );
  }
}
