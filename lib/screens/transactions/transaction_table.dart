import 'package:intl/intl.dart';
import 'package:moneyjar/controllers/update_controller.dart';
import 'package:moneyjar/data/database.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:animations/animations.dart';
import 'package:moneyjar/screens/transactions/transaction_form.dart';
import 'package:moneyjar/screens/transactions/transaction_screen.dart';
import 'package:provider/provider.dart';
import '../../constants.dart';

class QueryParams {
  QueryParams({this.accountId, this.categoryId, this.search, this.from = 0});
  List<int>? accountId, categoryId;
  String? search;
  int from;
}

class TransactionSource extends AsyncDataTableSource {
  QueryParams params;
  BuildContext? context;
  final showRemain;

  TransactionSource(
      {required this.params, this.context, this.showRemain = false});

  @override
  Future<AsyncRowsResponse> getRows(int start, int end) async {
    params.from = start;
    var queryResult = await DBProvider.db.getTransactions(params);
    var totalRecords = queryResult.totalCount;
    var result = AsyncRowsResponse(
        totalRecords,
        queryResult.transactions.map<DataRow>((transaction) {
          var tType;
          switch (transaction.type) {
            case 1:
              tType = "Expense";
              break;
            case 2:
              tType = "Income";
              break;
            case 3:
              tType = "Transfer";
              break;
            default:
              tType = "Unknown";
          }
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
                  return TransactionScreen(transaction: transaction);
                },
              )),
              // DataCell(Text(transaction.category!) ,onTap: ()=>Navigator.push(context!, MaterialPageRoute(builder: (context){
              //   return TransactionScreen(transaction: transaction);
              // } ) )),

              DataCell(
                  Text(DateFormat('yyyy-MM-dd').format(transaction.date!))),
              DataCell(Text(transaction.description.toString())),
              DataCell(Text(transaction.amount.toString())),
              DataCell(Text(tType)),
              DataCell(Text(transaction.account.toString())),
              if (showRemain) DataCell(Text(transaction.remain.toString())),
              DataCell(
                Row(
                  children: [
                    IconButton(
                      icon: Icon(Icons.remove_red_eye),
                      onPressed: () {
                        // RefreshContext.of(context!)!.refresh(
                        //     TransactionScreen(transaction: transaction),
                        //     transaction.description);
                        showDialog<void>(
                            context: context!,
                            builder: (context) => TransactionScreen(
                                  transaction: transaction,
                                ));
                        // RefreshContext.of(context!)!.refresh(
                        //     TransactionScreen(transaction: transaction));
                      },
                    ),
                    IconButton(
                      icon: Icon(Icons.edit),
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
                    ),
                    IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () {
                        DBProvider.db.deleteTransaction(transaction.id!);
                        refreshDatasource();
                      },
                    ),
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
  TransactionTable({
    this.showRemain = false,
    required this.params,
    Key? key,
  }) : super(key: key);

  final showRemain;
  final QueryParams params;

  @override
  _TransactionTableState createState() => _TransactionTableState(
        params: this.params,
        showRemain: this.showRemain,
      );
}

class _TransactionTableState extends State<TransactionTable> {
  QueryParams params;
  final showRemain;
  _TransactionTableState({
    required this.params,
    this.showRemain = false,
  });

  void sort(
    String column,
    bool ascending,
  ) {}

  PaginatorController _controller = PaginatorController();

  @override
  Widget build(BuildContext context) {
    return Consumer<UpdateController>(
      builder: (context, value, child) {
        return _buildTable(context, UniqueKey());
      },
    );
  }

  _buildTable(context, key) {
    return Container(
      key: key,
      padding: EdgeInsets.all(defaultPadding),
      decoration: BoxDecoration(
        color: secondaryColor,
        borderRadius: const BorderRadius.all(Radius.circular(10)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Transactions",
            style: Theme.of(context).textTheme.titleMedium,
          ),
          SizedBox(
            width: double.infinity,
            height: 500,
            child: AsyncPaginatedDataTable2(
              columnSpacing: defaultPadding,
              horizontalMargin: 20,
              rowsPerPage: 50,
              empty: Center(
                  child: Container(
                      height: 100,
                      padding: EdgeInsets.all(20),
                      // color: Colors.grey[200],
                      child: Text('No data'))),
              autoRowsToHeight: true,
              checkboxHorizontalMargin: 12,
              controller: _controller,
              wrapInCard: false,
              minWidth: 600,
              columns: [
                DataColumn(
                  label: Text('Category'),
                ),
                DataColumn(
                  label: Text('Date'),
                  onSort: (columnIndex, ascending) => sort("date", ascending),
                ),
                DataColumn(
                  label: Text('Description'),
                ),
                DataColumn(
                  label: Text('Amount'),
                  // numeric: true,
                  onSort: (columnIndex, ascending) => sort("amount", ascending),
                ),
                DataColumn(
                  label: Text('Type'),
                  // numeric: true,
                ),
                DataColumn(
                  label: Text('Account'),
                ),
                if (showRemain)
                  DataColumn(
                    label: Text('Remain'),
                    // numeric: true,
                  ),
                DataColumn(
                  label: Text('Action'),
                ),
              ],
              source: TransactionSource(
                  params: this.params,
                  context: context,
                  showRemain: showRemain),
            ),
          ),
        ],
      ),
    );
  }
}
