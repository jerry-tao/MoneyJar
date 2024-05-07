class Account {
  Account(
      {this.id,
      this.name = '',
      this.type = 1,
      this.archived = false,
      this.currency = 'CNY',
      this.initialAmount = 0,
      this.limitation = 0});

  factory Account.fromDBMap(Map<String, dynamic> map) {
    final a = Account(
        id: map['id'],
        name: map['name'],
        currency: map['currency'],
        type: map['type'],
        archived: map['archived'] == 1,
        initialAmount: (map['initial_amount'] as num).toInt(),
        limitation: (map['limitation'] as num).toInt());
    a.transactionCount = map['transaction_count'];
    a.transactionAmount = map['total_amount'] as int? ?? 0;
    return a;
  }
  static const creditAccountType = 1;
  static const cashAccountType = 2;
  static const investmentAccountType = 3;

  int? id;

  /// 1: cash/bank, 2: credit/loan in future we may support invest and other types
  int type = 0;

  /// account name
  String name = '';

  /// account initial amount, should be decimal
  int initialAmount = 0; //  should be decimal
  /// credit limit, only used when account type is credit ,should be decimal
  int limitation = 0; // credit limit should be decimal

  bool archived = false;
  String currency = 'CNY';

  /// transaction count, this is dynamic from database.
  int transactionCount = 0;
  int transactionAmount = 0;
  // Curre
  int currencyValue = 10000;

  /// remain amount, this is dynamic from database.
  int get remain {
    return ((initialAmount + transactionAmount) * currencyValue / 10000)
        .round();
  }

  int get nav {
    switch (type) {
      case cashAccountType:
        return remain;
      case creditAccountType:
        return remain - limitation;
      case investmentAccountType:
        return remain;
      default:
        return 0;
    }
  }

  String get typeString {
    switch (type) {
      case creditAccountType:
        return '信用账户';
      case cashAccountType:
        return '现金账户';
      case investmentAccountType:
        return '投资账户';
      default:
        return 'Unknown';
    }
  }

  Map<String, dynamic> toDBMap() {
    return {
      'id': id,
      'type': type,
      'archived': archived ? 1 : 0,
      'name': name,
      'currency': currency,
      'initial_amount': initialAmount,
      'limitation': limitation,
    };
  }
}
