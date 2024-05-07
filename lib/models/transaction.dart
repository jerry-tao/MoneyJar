class Transaction {
  Transaction(
      {this.id,
      this.type,
      this.date,
      this.description,
      this.amount,
      this.remark = '',
      this.tag = '',
      this.target = '',
      this.categoryID,
      this.category,
      this.accountID,
      this.associationID,
      this.account,
      this.remain});

  factory Transaction.fromCSVMap(Map<String, dynamic> map) {
    final amount = (map['amount'] as num).toInt();
    final date = (map['date'] as String).replaceAll(' +0800 CST', '');
    return Transaction(
        type: map['type'],
        date: DateTime.parse(date),
        description: map['description'].toString(),
        amount: amount,
        remark: map['remark'],
        tag: map['tag'],
        target: map['target'].toString(),
        categoryID: map['category_id'],
        accountID: map['account_id'],
        associationID: map['association_id']);
  }

  factory Transaction.fromDBMap(Map<String, dynamic> map) {
    final t = Transaction(
        id: map['id'],
        type: map['type'],
        date: DateTime.fromMillisecondsSinceEpoch(map['date']),
        description: map['description'],
        amount: map['amount'],
        remark: map['remark'] ?? '',
        tag: map['tag'] ?? '',
        target: map['target'] ?? '',
        categoryID: map['category_id'],
        accountID: map['account_id'],
        remain: map['account_remain'] as int? ?? 0,
        associationID: map['association_id']);
    t.account = map['account_name'];
    t.category = map['category_name'];
    return t;
  }

  static const expense = 1;
  static const income = 2;
  static const transfer = 3;
  static String typeString(int type) {
    switch (type) {
      case 1:
        return '支出';
      case 2:
        return '收入';
      case 3:
        return '转移';
      default:
        return '未定义';
    }
  }

  int? id;

  /// 1: expense, 2: income, 3: transfer
  int? type;
  DateTime? date;
  String? description;
  int? amount;
  String remark = '';
  String tag = '';
  String target = '';
  int? categoryID;
  String? category;
  int? accountID;
  int? associationID;
  String? account;
  int? remain;

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
      'category_id': categoryID,
      'account_id': accountID,
      'association_id': associationID
    };
  }
}
