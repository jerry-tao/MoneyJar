import 'package:moneyjar/models/account.dart';
import 'package:moneyjar/models/category.dart';
import 'package:moneyjar/models/currency.dart';
import 'package:moneyjar/models/transaction.dart' as model;
import 'package:moneyjar/screens/transactions/transaction_table.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class TransactionResult {
  TransactionResult({required this.transactions, required this.totalCount});
  final List<model.Transaction> transactions;
  final int totalCount;
}

class DBProvider {
  DBProvider._();
  static late Map<String, Currency> currencies;
  static final DBProvider db = DBProvider._();

  Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await initDB();
    final values = await _database!.rawQuery('''
      SELECT 
        id, name, code, symbol, value, is_default
      FROM currencies
    ''');
    currencies = {
      for (var v in values) (v['code'] as String): Currency.fromDBMap(v)
    };
    return _database!;
  }

  Future<Database> initDB() async {
    final dabase = openDatabase(
      // Set the path to the database. Note: Using the `join` function from the
      // `path` package is best practice to ensure the path is correctly
      // constructed for each platform.
      join(await getDatabasesPath(), 'release/moneyjar.db'),
      onCreate: (db, version) {
        // Run the CREATE TABLE statement on the database.
        db.execute('''CREATE TABLE accounts(
          id INTEGER PRIMARY KEY,
          type INTEGER,
          name TEXT,
          archived INTEGER,
          initial_amount INTEGER,
          limitation INTEGER)''');
        db.execute('''CREATE TABLE transactions(
            id INTEGER PRIMARY KEY,
            type INTEGER,
            date INTEGER,
            description TEXT,
            amount INTEGER,
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
        final exampleCategories = [
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
        for (var element in exampleCategories) {
          db.insert('categories', element.toDBMap());
        }
        final initialAccounts = [
          Account(name: 'Cash', type: 1, initialAmount: 0, limitation: 0),
          Account(name: 'Loan', type: 2, initialAmount: 0, limitation: 0)
        ];
        for (var element in initialAccounts) {
          db.insert('accounts', element.toDBMap());
        }
        db.execute('''
            ALTER TABLE accounts ADD COLUMN currency TEXT
          ''');
        db.execute('''
            UPDATE accounts SET currency = 'CNY'
          ''');
        db.execute('''
            CREATE TABLE IF NOT EXISTS currencies(
              id INTEGER PRIMARY KEY,
              name TEXT,
              symbol TEXT,
              code TEXT,
              is_default INTEGER,
              value INTEGER
            )
          ''');

        // version 2
        final defaultCurrencies = [
          Currency(
              name: 'Chinese Yuan',
              code: 'CNY',
              symbol: '¥',
              value: 10000,
              isDefault: true),
          Currency(
              name: 'US Dollar',
              code: 'USD',
              symbol: '\$',
              value: 70000, // 1 USD = 7 CNY
              isDefault: false),
          Currency(
              name: 'Euro',
              code: 'EUR',
              symbol: '€',
              value: 10000,
              isDefault: false),
          Currency(
              name: 'British Pound',
              code: 'GBP',
              symbol: '£',
              value: 10000,
              isDefault: false),
          Currency(
              name: 'Japanese Yen',
              code: 'JPY',
              symbol: '¥',
              value: 469, // 1 JPY = 0.0469 CNY
              isDefault: false),
          Currency(
              name: 'Korean Won',
              code: 'KRW',
              symbol: '₩',
              value: 10000,
              isDefault: false),
          Currency(
              name: 'Australian Dollar',
              code: 'AUD',
              symbol: '\$',
              value: 10000,
              isDefault: false),
          Currency(
              name: 'Canadian Dollar',
              code: 'CAD',
              symbol: '\$',
              value: 10000,
              isDefault: false),
          Currency(
              name: 'Swiss Franc',
              code: 'CHF',
              symbol: 'CHF',
              value: 10000,
              isDefault: false),
          Currency(
              name: 'Hong Kong Dollar',
              code: 'HKD',
              symbol: 'HK\$',
              value: 10000,
              isDefault: false),
          Currency(
              name: 'New Zealand Dollar',
              code: 'NZD',
              symbol: '\$',
              value: 10000,
              isDefault: false),
          Currency(
              name: 'Swedish Krona',
              code: 'SEK',
              symbol: 'kr',
              value: 10000,
              isDefault: false),
          Currency(
              name: 'Singapore Dollar',
              code: 'SGD',
              symbol: '\$',
              value: 10000,
              isDefault: false),
          Currency(
              name: 'Norwegian Krone',
              code: 'NOK',
              symbol: 'kr',
              value: 10000,
              isDefault: false),
        ];
        for (var element in defaultCurrencies) {
          db.insert('currencies', element.toDBMap());
        }
      },
      onUpgrade: (db, oldVersion, newVersion) {
        if (oldVersion < 2) {
          db.execute('''
            ALTER TABLE accounts ADD COLUMN currency TEXT
          ''');
          db.execute('''
            UPDATE accounts SET currency = 'CNY'
          ''');
          db.execute('''
            CREATE TABLE IF NOT EXISTS currencies(
              id INTEGER PRIMARY KEY,
              name TEXT,
              symbol TEXT,
              code TEXT,
              is_default INTEGER,
              value INTEGER
            )
          ''');
          final defaultCurrencies = [
            Currency(
                name: 'Chinese Yuan',
                code: 'CNY',
                symbol: '¥',
                value: 10000,
                isDefault: true),
            Currency(
                name: 'US Dollar',
                code: 'USD',
                symbol: '\$',
                value: 70000, // 1 USD = 7 CNY
                isDefault: false),
            Currency(
                name: 'Euro',
                code: 'EUR',
                symbol: '€',
                value: 10000,
                isDefault: false),
            Currency(
                name: 'British Pound',
                code: 'GBP',
                symbol: '£',
                value: 10000,
                isDefault: false),
            Currency(
                name: 'Japanese Yen',
                code: 'JPY',
                symbol: '¥',
                value: 469, // 1 JPY = 0.0469 CNY
                isDefault: false),
            Currency(
                name: 'Korean Won',
                code: 'KRW',
                symbol: '₩',
                value: 10000,
                isDefault: false),
            Currency(
                name: 'Australian Dollar',
                code: 'AUD',
                symbol: '\$',
                value: 10000,
                isDefault: false),
            Currency(
                name: 'Canadian Dollar',
                code: 'CAD',
                symbol: '\$',
                value: 10000,
                isDefault: false),
            Currency(
                name: 'Swiss Franc',
                code: 'CHF',
                symbol: 'CHF',
                value: 10000,
                isDefault: false),
            Currency(
                name: 'Hong Kong Dollar',
                code: 'HKD',
                symbol: 'HK\$',
                value: 10000,
                isDefault: false),
            Currency(
                name: 'New Zealand Dollar',
                code: 'NZD',
                symbol: '\$',
                value: 10000,
                isDefault: false),
            Currency(
                name: 'Swedish Krona',
                code: 'SEK',
                symbol: 'kr',
                value: 10000,
                isDefault: false),
            Currency(
                name: 'Singapore Dollar',
                code: 'SGD',
                symbol: '\$',
                value: 10000,
                isDefault: false),
            Currency(
                name: 'Norwegian Krone',
                code: 'NOK',
                symbol: 'kr',
                value: 10000,
                isDefault: false),
          ];
          for (var element in defaultCurrencies) {
            db.insert('currencies', element.toDBMap());
          }
        }
      },
      // Set the version. This executes the onCreate function and provides a
      // path to perform database upgrades and downgrades.
      version: 2,
    );
    return dabase;
  }

  Future<List<Category>> getCategories() async {
    final db = await database;
    final res = await db.rawQuery('''
    SELECT 
      categories.*, 
      COALESCE(SUM(transactions.amount), 0) AS amount, 
      COALESCE(SUM(CASE WHEN strftime('%Y-%m', datetime(transactions.date/1000, 'unixepoch')) = strftime('%Y-%m', 'now', 'start of month') THEN transactions.amount ELSE 0 END), 0) AS current_month_amount,
      COALESCE(SUM(CASE WHEN strftime('%Y-%m', datetime(transactions.date/1000, 'unixepoch')) = strftime('%Y-%m', 'now', 'start of month', '-1 month') THEN transactions.amount ELSE 0 END), 0) AS last_month_amount,
      COALESCE(COUNT(transactions.id), 0) AS transaction_count
    FROM categories
    LEFT JOIN transactions ON categories.id = transactions.category_id
    GROUP BY categories.id
  ''');

    final list = res.isEmpty
        ? <Category>[]
        : res.map((c) => Category.fromDBMap(c)).toList();
    return list;
  }

  Future<List<Account>> getAccounts() async {
    final db = await database;
    final res = await db.rawQuery('''
      SELECT 
        accounts.*, 
        COALESCE(SUM(transactions.amount), 0) AS total_amount, 
        COALESCE(COUNT(transactions.id), 0) AS transaction_count
      FROM accounts
      LEFT JOIN transactions ON accounts.id = transactions.account_id
      WHERE accounts.archived = 0
      GROUP BY accounts.id
  ''');

    final list = res.isEmpty
        ? <Account>[]
        : res.map((c) {
            final account = Account.fromDBMap(c);
            account.currencyValue = currencies[account.currency]!.value;
            return account;
          }).toList();
    return list;
  }

  Future<List<List<dynamic>>> exportCSV() async {
    final db = await database;
    final res = await db.rawQuery('''
      SELECT 
        transactions.*, 
        categories.name as category_name, 
        accounts.name as account_name,
        (accounts.initial_amount + IFNULL((SELECT SUM(amount) FROM transactions as t WHERE t.account_id = transactions.account_id AND t.date <= transactions.date), 0)) as account_remain
      FROM transactions
      LEFT JOIN categories ON transactions.category_id = categories.id
      LEFT JOIN accounts ON transactions.account_id = accounts.id
      ORDER BY date DESC
      ''');

    final transactions = List.generate(res.length, (i) {
      return model.Transaction.fromDBMap(res[i]);
    });
    return transactions.map((e) {
      return [
        e.category,
        e.description,
        e.target,
        (e.amount! / 100.0),
        model.Transaction.typeString(e.type!),
        e.remark,
        e.date,
        e.account,
        e.tag,
      ];
    }).toList();
  }

  Future<Category> getCategory(int id) async {
    final db = await database;
    final List<Map<String, dynamic>> maps =
        await db.query('categories', where: 'id = ?', whereArgs: [id]);
    return Category.fromDBMap(maps[0]);
  }

  Future<TransactionResult> getTransactions(QueryParams params) async {
    final db = await database;
    var whereString = '';
    final whereArguments = <dynamic>[];

    if (params.categoryId != null && params.categoryId!.isNotEmpty) {
      whereString +=
          "category_id IN (${params.categoryId!.map((_) => '?').join(', ')}) ";
      whereArguments.addAll(params.categoryId!);
    }

    if (params.accountId != null && params.accountId!.isNotEmpty) {
      if (whereString.isNotEmpty) {
        whereString += 'AND ';
      }
      whereString +=
          "account_id IN (${params.accountId!.map((_) => '?').join(', ')}) ";
      whereArguments.addAll(params.accountId!);
    }

    if (params.search != null && params.search!.isNotEmpty) {
      if (whereString.isNotEmpty) {
        whereString += 'AND ';
      }
      whereString += 'transactions.description LIKE ? ';
      whereArguments.add('%${params.search}%');
    }

    final res = await db.rawQuery('''
    SELECT 
      transactions.*, 
      categories.name as category_name, 
      accounts.name as account_name,
      (accounts.initial_amount + IFNULL((SELECT SUM(amount) FROM transactions as t WHERE t.account_id = transactions.account_id AND t.date <= transactions.date), 0)) as account_remain
    FROM transactions
    LEFT JOIN categories ON transactions.category_id = categories.id
    LEFT JOIN accounts ON transactions.account_id = accounts.id
    WHERE ${whereString.isEmpty ? '1' : whereString}
    ORDER BY date DESC
    LIMIT ${params.count} OFFSET ${params.from}''',
        whereArguments.isEmpty ? null : whereArguments);
    final transactions = List.generate(res.length, (i) {
      return model.Transaction.fromDBMap(res[i]);
    });

    final totalCount = Sqflite.firstIntValue(await db.rawQuery(
        'SELECT COUNT(*) FROM transactions${whereString.isEmpty ? '' : ' WHERE $whereString'}',
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

  Future<Future<int>> deleteCategory(int id) async {
    final db = await database;
    return db.delete('categories', where: 'id = ?', whereArgs: [id]);
  }

  Future<Future<int>> deleteAccount(int id) async {
    final db = await database;
    return db.delete('accounts', where: 'id = ?', whereArgs: [id]);
  }

  Future<Future<int>> deleteTransaction(int id) async {
    final db = await database;
    return db.delete('transactions', where: 'id = ?', whereArgs: [id]);
  }

  Future<List<Map<String, dynamic>>> getPieData(int start, end) async {
    final db = await database;
    return db.rawQuery('''
      SELECT 
        categories.name as name, 
        COALESCE(SUM(transactions.amount), 0) as value
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
    final initialAmount = await db.rawQuery('''
      SELECT 
        COALESCE(SUM(initial_amount-limitation), 0) as value
      FROM accounts
    ''');
    final iv = initialAmount[0]['value'];
    final beforeTransactionAmount = await db.rawQuery('''
      SELECT 
        COALESCE(SUM(amount), 0) as value
      FROM transactions
      WHERE date < ?
    ''', [start]);
    final before = beforeTransactionAmount[0]['value'];
    return db.rawQuery('''
        SELECT 
          strftime('%Y-%m', datetime(date / 1000, 'unixepoch')) as name, 
          COALESCE(SUM(amount), 0)  as value
        FROM transactions
        WHERE date >= ? AND date <= ?
        GROUP BY strftime('%Y-%m', datetime(date / 1000, 'unixepoch'))
      ''', [start, end]).then((value) {
      // value+initialAmount+beforeTransactionAmount+lastTotal;
      var lastTotal = (iv as int) + (before as int);
      final result = value.map((e) {
        final v = e['value'];
        lastTotal += v as int;
        return {'name': e['name'], 'value': lastTotal};
      }).toList();
      return result;
    });
  }

  Future<Map<String, List<Map>>> getBarData(
      int start, end, int categoryId) async {
    final db = await database;
    var whereClause = ' WHERE date >= ? AND date <= ? ';
    if (categoryId > 0) {
      whereClause += 'AND category_id = $categoryId ';
    }
    final expense = await db.rawQuery('''
      SELECT 
        strftime('%Y-%m', datetime(date / 1000, 'unixepoch')) as name,
        COALESCE(SUM(CASE WHEN type = 1 THEN amount ELSE 0 END), 0) as value
      FROM transactions
       $whereClause
      GROUP BY strftime('%Y-%m', datetime(date / 1000, 'unixepoch'))
    ''', [start, end]);
    final income = await db.rawQuery('''
      SELECT 
        strftime('%Y-%m', datetime(date / 1000, 'unixepoch')) as name,
        COALESCE(SUM(CASE WHEN type = 2 THEN amount ELSE 0 END), 0) as value
      FROM transactions
      $whereClause
      GROUP BY strftime('%Y-%m', datetime(date / 1000, 'unixepoch'))
    ''', [start, end]);
    return {'expense': expense, 'income': income};
  }

  Future<Map<String, String>> getDashboardData() async {
    final db = await database;

    final totalTransactionAmount = await db.rawQuery('''
     SELECT 
        accounts.currency,
        COALESCE(SUM(amount), 0) as value
      FROM transactions
      JOIN accounts ON transactions.account_id = accounts.id
      GROUP BY accounts.currency
    ''');
    final totalAccountAmount = await db.rawQuery('''
      SELECT 
        currency,
        COALESCE(SUM(CASE WHEN type = 1 THEN initial_amount - limitation ELSE initial_amount END), 0) as value
      FROM accounts
      GROUP BY currency
    ''');

    final ms = DateTime(DateTime.now().year, DateTime.now().month)
        .millisecondsSinceEpoch;
    final me = DateTime(DateTime.now().year, DateTime.now().month + 1)
        .millisecondsSinceEpoch;

    final monthIncome = await db.rawQuery('''
      SELECT 
        COALESCE(SUM(CASE WHEN type = 2 THEN amount ELSE 0 END), 0) as value
      FROM transactions
      WHERE date >= $ms AND date < $me
    ''');

    final monthExpense = await db.rawQuery('''
      SELECT 
        COALESCE(SUM(CASE WHEN type = 1 THEN amount ELSE 0 END), 0) as value
      FROM transactions
      WHERE date >= $ms AND date < $me
    ''');

    // sum credit account initial_amount + sum(transactions.amount) - limitation
    final totalCreditAmount = await db.rawQuery('''
SELECT 
  COALESCE(
    SUM(
          initial_amount + 
          (
            SELECT 
              COALESCE(SUM(amount), 0) 
            FROM 
              transactions 
            WHERE 
              account_id = accounts.id
          ) - limitation 
    ), 
    0
  ) as value
FROM 
  accounts
  WHERE type = 1
    ''');

    var nav = totalAccountAmount.fold(0, (int previousValue, element) {
      return previousValue +
          ((element['value'] as int) *
                  currencies[element['currency']]!.value /
                  10000)
              .round();
    });
    nav = totalTransactionAmount.fold(nav, (previousValue, element) {
      return previousValue +
          ((element['value'] as int) *
                  currencies[element['currency']]!.value /
                  10000)
              .round();
    });
    return {
      'NAV': (nav / 100.0).toString(),
      'Month Income': ((monthIncome[0]['value'] as int) / 100.0).toString(),
      'Month Expence': ((monthExpense[0]['value'] as int) / 100.0).toString(),
      'Debt': ((totalCreditAmount[0]['value'] as int) / 100.0).toString()
    };
  }

  Future<int> importCSV(List<List<dynamic>> list) async {
    final db = await database;
    final accounts = await db.rawQuery('''
      SELECT 
        id, name
      FROM accounts
    ''');
    final categories = await db.rawQuery('''
      SELECT 
        id, name
      FROM categories
    ''');
    final result = <Map<String, dynamic>>[];

    // 获取 CSV 文件的标题行
    final titles = list.removeAt(0);

    for (var row in list) {
      final rowMap = <String, dynamic>{};
      for (var i = 0; i < titles.length; i++) {
        rowMap[titles[i].toString()] = row[i];
      }
      result.add(rowMap);
    }
    var success = 0;
    for (var element in result) {
      final account =
          accounts.firstWhere((a) => a['name'] == element['Account']);
      final category =
          categories.firstWhere((c) => c['name'] == element['Category']);
      element['account_id'] = account['id'];
      element['category_id'] = category['id'];
      // var targetAccount =
      //     accounts.firstWhere((a) => a['name'] == element['target_account']);
      switch (element['Type']) {
        case '收入':
          element['type'] = model.Transaction.income;
          break;
        case '支出':
          element['type'] = model.Transaction.expense;
          break;
        case '转移':
          element['type'] = model.Transaction.transfer;
          break;
      }
      element['date'] = element['DateTime'];
      element['amount'] = ((element['Amount'] as int) * 100.0).round();
      element['remark'] = element['Remark'];
      element['tag'] = element['Tag'];
      element['target'] = element['Target'];
      element['description'] = element['Description'];
      final t = model.Transaction.fromCSVMap(element);
      final value = await db.insert('transactions', t.toDBMap());
      if (value > 0) {
        success += 1;
      }
    }
    return success;
  }
}
