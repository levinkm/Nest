class Budget {
  final String id;
  final String category;
  final double limit;
  final double spent;
  final String period;
  final DateTime startDate;
  final DateTime endDate;

  Budget({
    required this.id,
    required this.category,
    required this.limit,
    required this.spent,
    required this.period,
    required this.startDate,
    required this.endDate,
  });

  double get remaining => limit - spent;
  double get percentage => spent / limit * 100;
  bool get isOverBudget => spent > limit;

  Map<String, dynamic> toJson() => {
    'id': id,
    'category': category,
    'limit': limit,
    'spent': spent,
    'period': period,
    'startDate': startDate.toIso8601String(),
    'endDate': endDate.toIso8601String(),
  };

  factory Budget.fromJson(Map<String, dynamic> json) => Budget(
    id: json['id'],
    category: json['category'],
    limit: json['limit'],
    spent: json['spent'],
    period: json['period'],
    startDate: DateTime.parse(json['startDate']),
    endDate: DateTime.parse(json['endDate']),
  );
}
