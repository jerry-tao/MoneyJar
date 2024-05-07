class Category {
  Category({this.id, this.name, this.description, this.icon, this.color});

  factory Category.fromDBMap(Map<String, dynamic> map) {
    final c = Category(
        id: map['id'],
        name: map['name'],
        description: map['description'],
        icon: map['icon'],
        color: map['color']);
    c.amount = map['amount'] as int? ?? 0;
    c.currentMonthlyAmount =
        (map['current_month_amount'] as num?)?.toInt() ?? 0;
    c.lastMonthlyAmount = (map['last_month_amount'] as num?)?.toInt() ?? 0;
    c.monthlyAverage = map['monthly_average'] as int? ?? 0;
    c.transactionCount = map['transaction_count'] ?? 0;
    return c;
  }

  int? id;
  String? name;
  String? description;
  String? icon;
  int? color;

  int? amount;
  int? transactionCount;
  int? currentMonthlyAmount;
  int? lastMonthlyAmount;
  int? monthlyAverage;

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'icon': icon,
      'color': color,
      'amount': amount ?? 0.0,
      'transaction_count': transactionCount ?? 0
    };
  }

  Map<String, dynamic> toDBMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'icon': icon,
      'color': color,
    };
  }
}
