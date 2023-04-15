class Account {
  final int amount;
  final String fullTitle;
  final String description;

  bool get isPositive => amount > 0;
  String get icon => String.fromCharCode(fullTitle.runes.first);
  String get title => String.fromCharCodes(fullTitle.runes, 2);

  const Account(
    this.amount,
    this.fullTitle,
    this.description,
  );

  factory Account.fromJson(Map<String, dynamic> json) {
    return Account(
      json['amount'] as int,
      json['title'] as String,
      json['description'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'amount': amount,
      'title': fullTitle,
      'description': description,
    };
  }
}

class IncomeAndCost {
  final int income;
  final int cost;

  const IncomeAndCost(this.income, this.cost);
}
