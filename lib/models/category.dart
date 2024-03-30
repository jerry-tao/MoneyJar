class Category {
  int? id;
  String? name;
  String? description;
  String? icon;
  int? color;

  double? amount;
  int? transactionCount;
  double? currentMonthlyAmount;
  double? lastMonthlyAmount;
  double? monthlyAverage;

  Category({this.id, this.name, this.description, this.icon, this.color});

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

  factory Category.fromDBMap(Map<String, dynamic> map) {
    var c = Category(
        id: map["id"],
        name: map["name"],
        description: map['description'],
        icon: map["icon"],
        color: map["color"]);
    var amount = double.parse((map["amount"] as double).toStringAsFixed(2));
    c.amount = amount;
    c.currentMonthlyAmount = (map["current_month_amount"] as num).toDouble();
    c.lastMonthlyAmount = (map["last_month_amount"] as num).toDouble();
    c.monthlyAverage = map["monthly_average"] as double? ?? 0.0;
    c.transactionCount = map["transaction_count"];
    return c;
  }

  factory Category.fromJson(Map<String, dynamic> map) {
    return Category(
        id: map["id"],
        name: map["name"],
        description: map['description'],
        icon: map["icon"],
        color: map["color"]);
  }
}
