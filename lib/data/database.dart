import 'package:moneyjar/models/account.dart';
import 'package:moneyjar/models/category.dart';
import 'package:moneyjar/models/transaction.dart' as model;
import 'package:moneyjar/screens/transactions/transaction_table.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class TransactionResult {
  final List<model.Transaction> transactions;
  final int totalCount;
  TransactionResult({required this.transactions, required this.totalCount});
}

class DBProvider {
  DBProvider._();

  static final DBProvider db = DBProvider._();

  Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await initDB();
    return _database!;
  }

  initDB() async {
    var dabase = openDatabase(
      // Set the path to the database. Note: Using the `join` function from the
      // `path` package is best practice to ensure the path is correctly
      // constructed for each platform.
      join(await getDatabasesPath(), 'moneyjar.db'),
      onCreate: (db, version) {
        // Run the CREATE TABLE statement on the database.
        db.execute('''CREATE TABLE accounts(
          id INTEGER PRIMARY KEY,
          type INTEGER,
          name TEXT,
          archived INTEGER,
          initial_amount REAL,
          limitation REAL)''');
        db.execute('''CREATE TABLE transactions(
            id INTEGER PRIMARY KEY,
            type INTEGER,
            date INTEGER,
            description TEXT,
            amount REAL,
            remark TEXT,
            tag TEXT,
            target TEXT,
            category_id INTEGER,
            account_id INTEGER,
            association_id INTEGER
          )''');
        db.execute('''
          CREATE TABLE categories(
            id INTEGER PRIMARY KEY,
            name TEXT,
            description TEXT,
            icon TEXT,
            color INTEGER
          )
        ''');
        var exampleCategories = [
          Category(
              name: 'Food',
              description: 'Food and drink',
              icon: 'food',
              color: 0xFFE57373),
          Category(
              name: 'Transport',
              description: 'Transportation',
              icon: 'directions_bus',
              color: 0xFF81C784)
        ];
        exampleCategories.forEach((element) {
          db.insert('categories', element.toDBMap());
        });
        var initialAccounts = [
          Account(name: 'Cash', type: 1, initialAmount: 0.0, limitation: 0.0),
          Account(name: 'Loan', type: 2, initialAmount: 0.0, limitation: 0.0)
        ];
        initialAccounts.forEach((element) {
          db.insert('accounts', element.toDBMap());
        });
      },
      // Set the version. This executes the onCreate function and provides a
      // path to perform database upgrades and downgrades.
      version: 1,
    );
    return dabase;
  }

  Future<List<Category>> getCategories() async {
    final db = await database;
    final res = await db.rawQuery('''
    SELECT 
      categories.*, 
      COALESCE(SUM(transactions.amount), 0.0) AS amount, 
      COALESCE(SUM(CASE WHEN strftime('%Y-%m', datetime(transactions.date/1000, 'unixepoch')) = strftime('%Y-%m', 'now', 'start of month') THEN transactions.amount ELSE 0 END), 0.0) AS current_month_amount,
      COALESCE(SUM(CASE WHEN strftime('%Y-%m', datetime(transactions.date/1000, 'unixepoch')) = strftime('%Y-%m', 'now', 'start of month', '-1 month') THEN transactions.amount ELSE 0 END), 0.0) AS last_month_amount,
      COALESCE(COUNT(transactions.id), 0) AS transaction_count
    FROM categories
    LEFT JOIN transactions ON categories.id = transactions.category_id
    GROUP BY categories.id
  ''');

    List<Category> list =
        res.isEmpty ? [] : res.map((c) => Category.fromDBMap(c)).toList();
    return list;
  }

  Future<List<Account>> getAccounts() async {
    final db = await database;
    final res = await db.rawQuery('''
      SELECT 
        accounts.*, 
        Round(COALESCE(SUM(transactions.amount), 0.0),2) AS total_amount, 
        COALESCE(COUNT(transactions.id), 0) AS transaction_count
      FROM accounts
      LEFT JOIN transactions ON accounts.id = transactions.account_id
      WHERE accounts.archived = 0
      GROUP BY accounts.id
  ''');

    List<Account> list = res.isEmpty
        ? []
        : res.map((c) {
            return Account.fromDBMap(c);
          }).toList();
    return list;
  }

  Future<Category> getCategory(int id) async {
    final db = await database;
    final List<Map<String, dynamic>> maps =
        await db.query('categories', where: 'id = ?', whereArgs: [id]);
    return Category.fromJson(maps[0]);
  }

  Future<TransactionResult> getTransactions(QueryParams params) async {
    final db = await database;
    String whereString = "";
    List<dynamic> whereArguments = [];

    if (params.categoryId != null && params.categoryId!.isNotEmpty) {
      whereString +=
          "category_id IN (${params.categoryId!.map((_) => '?').join(', ')}) ";
      whereArguments.addAll(params.categoryId!);
    }

    if (params.accountId != null && params.accountId!.isNotEmpty) {
      if (whereString.isNotEmpty) {
        whereString += "AND ";
      }
      whereString +=
          "account_id IN (${params.accountId!.map((_) => '?').join(', ')}) ";
      whereArguments.addAll(params.accountId!);
    }

    if (params.search != null && params.search!.isNotEmpty) {
      if (whereString.isNotEmpty) {
        whereString += "AND ";
      }
      whereString += "transactions.description LIKE ? ";
      whereArguments.add('%${params.search}%');
    }

    final res = await db.rawQuery('''
    SELECT 
      transactions.*, 
      categories.name as category_name, 
      accounts.name as account_name,
      Round((accounts.initial_amount + IFNULL((SELECT SUM(amount) FROM transactions as t WHERE t.account_id = transactions.account_id AND t.date <= transactions.date), 0)),2) as account_remain
    FROM transactions
    LEFT JOIN categories ON transactions.category_id = categories.id
    LEFT JOIN accounts ON transactions.account_id = accounts.id
    WHERE ${whereString.isEmpty ? '1' : whereString}
    LIMIT 8 OFFSET ${params.from}''',
        whereArguments.isEmpty ? null : whereArguments);

    var transactions = List.generate(res.length, (i) {
      return model.Transaction.fromDBMap(res[i]);
    });

    final totalCount = Sqflite.firstIntValue(await db.rawQuery(
        'SELECT COUNT(*) FROM transactions' +
            (whereString.isEmpty ? '' : ' WHERE $whereString'),
        whereArguments.isEmpty ? null : whereArguments));

    return TransactionResult(
        transactions: transactions, totalCount: totalCount ?? 0);
  }

  Future<int> saveAccount(Account account) async {
    final db = await database;
    if (account.id != null && account.id! > 0) {
      return await db.update('accounts', account.toDBMap(),
          where: 'id = ?', whereArgs: [account.id]);
    } else {
      return await db.insert('accounts', account.toDBMap());
    }
  }

  Future<int> saveTransaction(model.Transaction transaction) async {
    final db = await database;
    if (transaction.id != null && transaction.id! > 0) {
      return await db.update('transactions', transaction.toDBMap(),
          where: 'id = ?', whereArgs: [transaction.id]);
    } else {
      return await db.insert('transactions', transaction.toDBMap());
    }
  }

  Future<int> saveCategory(Category category) async {
    final db = await database;
    if (category.id != null && category.id! > 0) {
      return await db.update('categories', category.toDBMap(),
          where: 'id = ?', whereArgs: [category.id]);
    } else {
      return await db.insert('categories', category.toDBMap());
    }
  }

  deleteCategory(int id) async {
    final db = await database;
    return db.delete('categories', where: 'id = ?', whereArgs: [id]);
  }

  deleteAccount(int id) async {
    final db = await database;
    return db.delete('accounts', where: 'id = ?', whereArgs: [id]);
  }

  deleteTransaction(int id) async {
    final db = await database;
    return db.delete('transactions', where: 'id = ?', whereArgs: [id]);
  }

  Future<List<Map<String, dynamic>>> getPieData(int start, end) async {
    final db = await database;
    return db.rawQuery('''
      SELECT 
        categories.name as name, 
        Round(COALESCE(SUM(transactions.amount), 0.0),2) as value
    FROM transactions
    LEFT JOIN categories ON transactions.category_id = categories.id
    WHERE date >= ? AND date <= ?
    GROUP BY categories.id
    HAVING value < 0
    ORDER BY value ASC
    ''', [start, end]);
  }

  Future<List<Map>> getLineData(int start, end) async {
    // return every month's remain amount
    final db = await database;
    //  sum accounts initial amount as initialAmount
    var initialAmount = await db.rawQuery('''
      SELECT 
        Round(COALESCE(SUM(initial_amount-limitation), 0.0)  ,2) as value
      FROM accounts
    ''');
    var iv = initialAmount[0]['value'];
    var beforeTransactionAmount = await db.rawQuery('''
      SELECT 
        Round(COALESCE(SUM(amount), 0.0),2) as value
      FROM transactions
      WHERE date < ?
    ''', [start]);
    var before = beforeTransactionAmount[0]['value'];
    return db.rawQuery('''
        SELECT 
          strftime('%Y-%m', datetime(date / 1000, 'unixepoch')) as name, 
          ROUND(COALESCE(SUM(amount), 0.0),2)  as value
        FROM transactions
        WHERE date >= ? AND date <= ?
        GROUP BY strftime('%Y-%m', datetime(date / 1000, 'unixepoch'))
      ''', [start, end]).then((value) {
      // value+initialAmount+beforeTransactionAmount+lastTotal;
      var lastTotal = (iv as double) + (before as double);
      var result = value.map((e) {
        var v = e['value'];
        lastTotal += v as double;
        return {"name": e['name'], "value": lastTotal};
      }).toList();
      return result;
    });
  }

  Future<Map<String, List<Map>>> getBarData(int start, end) async {
    final db = await database;
    var expense = await db.rawQuery('''
      SELECT 
        strftime('%Y-%m', datetime(date / 1000, 'unixepoch')) as name,
        COALESCE(SUM(CASE WHEN type = 1 THEN amount ELSE 0 END), 0.0) as value
      FROM transactions
      WHERE date >= ? AND date <= ?
      GROUP BY strftime('%Y-%m', datetime(date / 1000, 'unixepoch'))
    ''', [start, end]);
    var income = await db.rawQuery('''
      SELECT 
        strftime('%Y-%m', datetime(date / 1000, 'unixepoch')) as name,
        COALESCE(SUM(CASE WHEN type = 2 THEN amount ELSE 0 END), 0.0) as value
      FROM transactions
      WHERE date >= ? AND date <= ?
      GROUP BY strftime('%Y-%m', datetime(date / 1000, 'unixepoch'))
    ''', [start, end]);
    return {"expense": expense, "income": income};
  }

  Future<Map<String, String>> getDashboardData() async {
    final db = await database;

    var totalTransactionAmount = await db.rawQuery('''
      SELECT 
        COALESCE(SUM(amount), 0.0) as value
      FROM transactions
    ''');
    var totalAccountAmount = await db.rawQuery('''
      SELECT 
        ROUND(COALESCE(SUM(CASE WHEN type = 1 THEN initial_amount - limitation ELSE initial_amount END), 0.0),2) as value
      FROM accounts
    ''');

    var ms = DateTime(DateTime.now().year, DateTime.now().month)
        .millisecondsSinceEpoch;
    var me = DateTime(DateTime.now().year, DateTime.now().month + 1)
        .millisecondsSinceEpoch;

    var monthIncome = await db.rawQuery('''
      SELECT 
        COALESCE(SUM(CASE WHEN type = 2 THEN amount ELSE 0 END), 0.0) as value
      FROM transactions
      WHERE date >= $ms AND date < $me
    ''');

    var monthExpense = await db.rawQuery('''
      SELECT 
        COALESCE(SUM(CASE WHEN type = 1 THEN amount ELSE 0 END), 0.0) as value
      FROM transactions
      WHERE date >= $ms AND date < $me
    ''');
    // sum credit account initial_amount + sum(transactions.amount) - limitation
    var totalCreditAmount = await db.rawQuery('''
      SELECT 
        COALESCE(SUM(CASE WHEN type = 2 THEN initial_amount + (SELECT COALESCE(SUM(amount), 0.0) FROM transactions WHERE account_id = accounts.id) - limitation ELSE 0 END), 0.0) as value
      FROM accounts 
    ''');
    var nav = (totalAccountAmount[0]['value']! as double) +
        (totalTransactionAmount[0]['value']! as double);
    return {
      "NAV": nav.toString(),
      "Month Income": monthIncome[0]['value'].toString(),
      "Month Expence": monthExpense[0]['value'].toString(),
      "Debt": totalCreditAmount[0]['value'].toString()
    };
  }

  importCSV(List<dynamic> list) async {
    final db = await database;
    var accounts = await db.rawQuery('''
      SELECT 
        id, name
      FROM accounts
    ''');
    var categories = await db.rawQuery('''
      SELECT 
        id, name
      FROM categories
    ''');
    List<Map<String, dynamic>> result = [];

    // 获取 CSV 文件的标题行
    List<dynamic> titles = list.removeAt(0);

    list.forEach((row) {
      Map<String, dynamic> rowMap = {};
      for (var i = 0; i < titles.length; i++) {
        rowMap[titles[i]] = row[i];
      }
      result.add(rowMap);
    });
    result.forEach((element) {
      var account = accounts.firstWhere((a) => a['name'] == element['Account']);
      var category =
          categories.firstWhere((c) => c['name'] == element['Category']);
      element['account_id'] = account['id'];
      element['category_id'] = category['id'];
      // var targetAccount =
      //     accounts.firstWhere((a) => a['name'] == element['target_account']);
      switch (element['Type']) {
        case '收入':
          element['type'] = model.Transaction.Income;
          break;
        case '支出':
          element['type'] = model.Transaction.Expense;
          break;
        case '转移':
          element['type'] = model.Transaction.Transfer;
          break;
      }
      element['date'] = element['DateTime'];
      element['amount'] = element['Amount'];
      element['remark'] = element['Remark'];
      element['tag'] = element['Tag'];
      element['target'] = element['Target'];
      element['description'] = element['Description'];
      var t = model.Transaction.fromCSVMap(element);
      db.insert('transactions', t.toDBMap());
    });
  }
}
