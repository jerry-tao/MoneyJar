class Transaction {
  static const Expense = 1;
  static const Income = 2;
  static const Transfer = 3;
  static typeString(int type) {
    switch (type) {
      case 1:
        return "Expense";
      case 2:
        return "Income";
      case 3:
        return "Transfer";
      default:
        return "Unknown";
    }
  }

  int? id;
  /**
     * 1: expense, 2: income, 3: transfer
     */
  int? type;
  DateTime? date;
  String? description;
  double? amount;
  String? remark;
  String? tag;
  String? target;
  int? category_id;
  String? category;
  int? account_id;
  int? association_id;
  String? account;
  double? remain;

  Transaction(
      {this.id,
      this.type,
      this.date,
      this.description,
      this.amount,
      this.remark,
      this.tag,
      this.target,
      this.category_id,
      this.category,
      this.account_id,
      this.association_id,
      this.account,
      this.remain});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'type': type,
      'date': date,
      'description': description,
      'amount': amount,
      'remark': remark,
      'tag': tag,
      'target': target,
      'category_id': category
    };
  }

  Map<String, dynamic> toDBMap() {
    return {
      'id': id,
      'type': type,
      'date': date!.millisecondsSinceEpoch,
      'description': description,
      'amount': amount,
      'remark': remark,
      'tag': tag,
      'target': target,
      'category_id': category_id,
      'account_id': account_id,
      'association_id': association_id
    };
  }

  factory Transaction.fromCSVMap(Map<String, dynamic> map) {
    double? amount = (map['amount'] as num).toDouble();
    var date =
        map['date'].substring(0, map['date'].length - " +0800 CST".length);
    return Transaction(
        type: map['type'],
        date: DateTime.parse(date),
        description: map["description"].toString(),
        amount: amount,
        remark: map["remark"],
        tag: map["tag"],
        target: map["target"].toString(),
        category_id: map["category_id"],
        account_id: map["account_id"],
        association_id: map["association_id"]);
  }

  factory Transaction.fromDBMap(Map<String, dynamic> map) {
    var t = Transaction(
        id: map["id"],
        type: map['type'],
        date: DateTime.fromMillisecondsSinceEpoch(map['date']),
        description: map["description"],
        amount: map["amount"],
        remark: map["remark"],
        tag: map["tag"],
        target: map["target"],
        category_id: map["category_id"],
        account_id: map["account_id"],
        remain: map["account_remain"] as double? ?? 0.0,
        association_id: map["association_id"]);
    t.account = map["account_name"];
    t.category = map["category_name"];
    return t;
  }

  factory Transaction.fromJson(Map<String, dynamic> map) {
    return Transaction(
        id: map["id"],
        type: map["type"],
        date: map['date'],
        description: map["description"],
        amount: map["amount"],
        remark: map["remark"],
        tag: map["tag"],
        target: map["target"],
        category_id: map["category_id"],
        account_id: map["account_id"],
        association_id: map["association_id"]);
  }
}
