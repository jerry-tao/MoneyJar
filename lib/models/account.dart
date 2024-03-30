class Account {
  static const CreditAccountType = 1;
  static const CashAccountType = 2;
  static const InvestmentAccountType = 3;

  int? id;
  /**
   * 1: cash/bank, 2: credit/loan in future we may support invest and other types
   */
  int? type;
  /**
   * account name
   */
  String? name;
  /**
   * account initial amount, should be decimal
   */
  double? initialAmount; //  should be decimal
  /**
   * credit limit, only used when account type is credit ,should be decimal
   */
  double? limitation; // credit limit should be decimal

  bool archived = false;
  //  final currency; // not support for now
  /**
   * transaction count, this is dynamic from database.
   */
  int? transactionCount;
  double? transactionAmount;

  /**
   * remain amount, this is dynamic from database.
   */
  double get remain {
    if (initialAmount == null || transactionAmount == null) {
      return 0;
    }
    //  5001.56 + 89.01=5090.570000000001;
    // TODO consider using decimal or int to avoid this issue
    return double.parse(
        (initialAmount! + transactionAmount!).toStringAsFixed(2));
  }

  String get typeString {
    switch (type) {
      case CreditAccountType:
        return "Credit";
      case CashAccountType:
        return "Cash";
      case InvestmentAccountType:
        return "Investment";
      default:
        return "Unknown";
    }
  }

  Account(
      {this.id,
      this.name,
      this.type,
      this.archived = false,
      this.initialAmount,
      this.limitation});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'type': type,
      'name': name,
      "initial_amount": initialAmount,
      "limitation": limitation,
      "transaction_count": transactionCount ?? 0
    };
  }

  Map<String, dynamic> toDBMap() {
    return {
      'id': id,
      'type': type,
      'archived': archived ? 1 : 0,
      'name': name,
      "initial_amount": initialAmount,
      "limitation": limitation,
    };
  }

  factory Account.fromMap(Map<String, dynamic> map) {
    return Account(
        id: map["id"],
        name: map["name"],
        type: map['type'],
        initialAmount: map["initial_amount"],
        limitation: map["limitation"]);
  }

  factory Account.fromDBMap(Map<String, dynamic> map) {
    var a = Account(
        id: map["id"],
        name: map["name"],
        type: map['type'],
        archived: map["archived"] == 1,
        initialAmount: (map['initial_amount'] as num).toDouble(),
        limitation: (map['limitation'] as num).toDouble());
    a.transactionCount = map["transaction_count"];
    a.transactionAmount = map["total_amount"] as double? ?? 0.0;
    return a;
  }
}
