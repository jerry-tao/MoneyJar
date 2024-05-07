class Currency {
  Currency(
      {this.id,
      required this.name,
      required this.code,
      required this.symbol,
      required this.value,
      required this.isDefault});

  factory Currency.fromDBMap(Map<String, dynamic> map) {
    return Currency(
        id: map['id'],
        name: map['name'],
        code: map['code'],
        symbol: map['symbol'],
        value: map['value'],
        isDefault: map['is_default'] == 1);
  }
  final int? id;
  final String name;
  final String code;
  final String symbol;
  final int value;
  final bool isDefault;

  Map<String, dynamic> toDBMap() {
    return {
      'id': id,
      'name': name,
      'code': code,
      'symbol': symbol,
      'value': value,
      'is_default': isDefault ? 1 : 0
    };
  }
}
