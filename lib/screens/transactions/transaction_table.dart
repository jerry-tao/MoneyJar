import 'package:animations/animations.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:moneyjar/controllers/update_controller.dart';
import 'package:moneyjar/data/database.dart';
import 'package:moneyjar/models/transaction.dart';
import 'package:moneyjar/screens/transactions/transaction_form.dart';
import 'package:moneyjar/screens/transactions/transaction_view.dart';
import 'package:provider/provider.dart';

import '../../constants.dart';

class QueryParams {
  QueryParams(
      {this.accountId,
      this.categoryId,
      this.search,
      this.from = 0,
      this.count = 10});
  List<int>? accountId, categoryId;
  String? search;
  int from;
  int count;
}

class TransactionSource extends AsyncDataTableSource {
  TransactionSource(
      {required this.params, this.context, this.showRemain = false});
  QueryParams params;
  BuildContext? context;
  final bool showRemain;

  @override
  Future<AsyncRowsResponse> getRows(int startIndex, int count) async {
    params.from = startIndex;
    params.count = count;
    final queryResult = await DBProvider.db.getTransactions(params);
    final totalRecords = queryResult.totalCount;
    final result = AsyncRowsResponse(
        totalRecords,
        queryResult.transactions.map<DataRow>((transaction) {
          return DataRow(
            key: ValueKey<int>(transaction.id!),
            cells: [
              DataCell(OpenContainer(
                //背景颜色
                closedColor: Colors.transparent,
                //阴影
                closedElevation: 0.0,
                //圆角
                closedShape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(0.0)),
                ),
                openShape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(0)),
                ),
                closedBuilder: (context, action) =>
                    Text(transaction.category.toString()),
                openBuilder: (context, action) {
                  return TransactionView(transaction: transaction);
                },
              )),
              // DataCell(Text(transaction.category!) ,onTap: ()=>Navigator.push(context!, MaterialPageRoute(builder: (context){
              //   return TransactionScreen(transaction: transaction);
              // } ) )),

              DataCell(
                  Text(DateFormat('yyyy-MM-dd').format(transaction.date!))),
              DataCell(Text(transaction.description.toString())),
              DataCell(Text((transaction.amount! / 100.0).toString())),
              DataCell(Text(Transaction.typeString(transaction.type!))),
              DataCell(Text(transaction.account.toString())),
              if (showRemain)
                DataCell(Text((transaction.remain! / 100.0).toString())),
              DataCell(
                Row(
                  children: [
                    Expanded(
                        child: IconButton(
                      icon: const Icon(Icons.remove_red_eye),
                      onPressed: () {
                        // RefreshContext.of(context!)!.refresh(
                        //     TransactionScreen(transaction: transaction),
                        //     transaction.description);
                        showDialog<void>(
                            context: context!,
                            builder: (context) => TransactionView(
                                  transaction: transaction,
                                ));
                        // RefreshContext.of(context!)!.refresh(
                        // TransactionScreen(transaction: transaction));
                      },
                    )),
                    Expanded(
                        child: IconButton(
                      icon: const Icon(Icons.edit),
                      onPressed: () {
                        showDialog<void>(
                            context: context!,
                            builder: (context) => TransactionForm(
                                  callback: () {
                                    refreshDatasource();
                                  },
                                  transaction: transaction,
                                ));
                      },
                    )),
                    Expanded(
                        child: IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () {
                        DBProvider.db.deleteTransaction(transaction.id!);
                        refreshDatasource();
                      },
                    )),
                  ],
                ),
              ),
            ],
          );
        }).toList());
    return result;
  }
}

class TransactionTable extends StatefulWidget {
  const TransactionTable({
    this.showRemain = false,
    required this.params,
    Key? key,
  }) : super(key: key);

  final bool showRemain;
  final QueryParams params;

  @override
  State<TransactionTable> createState() => _TransactionTableState();
}

class _TransactionTableState extends State<TransactionTable> {
  late QueryParams params;
  late bool showRemain;

  @override
  void initState() {
    super.initState();
    params = widget.params;
    showRemain = widget.showRemain;
  }

  final PaginatorController _controller = PaginatorController();

  @override
  Widget build(BuildContext context) {
    return Consumer<UpdateController>(
      builder: (context, value, child) {
        return _buildTable(context, UniqueKey());
      },
    );
  }

  Container _buildTable(context, key) {
    return Container(
      key: key,
      padding: const EdgeInsets.all(defaultPadding),
      decoration: const BoxDecoration(
        color: secondaryColor,
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            // width: double.infinity,
            // height: 1000,
            child: AsyncPaginatedDataTable2(
              columnSpacing: defaultPadding,
              horizontalMargin: 20,
              rowsPerPage: 50,
              empty: Center(
                  child: Container(
                      height: 100,
                      padding: const EdgeInsets.all(20),
                      // color: Colors.grey[200],
                      child: const Text('No data'))),
              autoRowsToHeight: true,
              checkboxHorizontalMargin: 12,
              controller: _controller,
              wrapInCard: false,
              minWidth: 600,
              columns: [
                const DataColumn(
                  label: Text('Category'),
                ),
                const DataColumn(label: Text('Date')),
                const DataColumn(
                  label: Text('Description'),
                ),
                const DataColumn(
                  label: Text('Amount'),
                ),
                const DataColumn(
                  label: Text('Type'),
                  // numeric: true,
                ),
                const DataColumn(
                  label: Text('Account'),
                ),
                if (showRemain)
                  const DataColumn(
                    label: Text('Remain'),
                    // numeric: true,
                  ),
                const DataColumn(
                  label: Text('Action'),
                ),
              ],
              source: TransactionSource(
                  params: params, context: context, showRemain: showRemain),
            ),
          ),
        ],
      ),
    );
  }
}
