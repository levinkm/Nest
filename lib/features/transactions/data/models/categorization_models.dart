class CategorizationRule {
  final String id;
  final String name;
  final String category;
  final String matchType; // 'merchant', 'keyword', 'amount', 'date'
  final String matchValue;
  final bool isActive;
  final int priority;
  final DateTime createdAt;

  CategorizationRule({
    required this.id,
    required this.name,
    required this.category,
    required this.matchType,
    required this.matchValue,
    this.isActive = true,
    this.priority = 0,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'category': category,
    'matchType': matchType,
    'matchValue': matchValue,
    'isActive': isActive ? 1 : 0,
    'priority': priority,
    'createdAt': createdAt.toIso8601String(),
  };

  factory CategorizationRule.fromJson(Map<String, dynamic> json) =>
      CategorizationRule(
        id: json['id'],
        name: json['name'],
        category: json['category'],
        matchType: json['matchType'],
        matchValue: json['matchValue'],
        isActive: (json['isActive'] ?? 1) == 1,
        priority: json['priority'] ?? 0,
        createdAt: json['createdAt'] != null
            ? DateTime.parse(json['createdAt'])
            : DateTime.now(),
      );
}

class RecurringIncome {
  final String id;
  final String name;
  final String source;
  final double amount;
  final double? minAmount;
  final double? maxAmount;
  final String frequency;
  final int dayOfMonth;
  final int dayOfWeek;
  final String? merchantName;
  final bool autoMark;
  final DateTime? lastReceived;
  final DateTime? nextExpected;
  final bool isActive;
  final DateTime createdAt;

  RecurringIncome({
    required this.id,
    required this.name,
    required this.source,
    required this.amount,
    this.minAmount,
    this.maxAmount,
    required this.frequency,
    this.dayOfMonth = 1,
    this.dayOfWeek = 1,
    this.merchantName,
    this.autoMark = true,
    this.lastReceived,
    this.nextExpected,
    this.isActive = true,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  bool get isVariableAmount => minAmount != null && maxAmount != null;

  DateTime calculateNextExpected() {
    final now = DateTime.now();
    final base = lastReceived ?? now;

    switch (frequency) {
      case 'daily':
        return base.add(const Duration(days: 1));
      case 'monthly':
        // Try current month first
        var next = DateTime(now.year, now.month, dayOfMonth);
        // If the date has already passed this month, move to next month
        if (next.isBefore(now) || next.day == now.day) {
          next = DateTime(now.year, now.month + 1, dayOfMonth);
        }
        // Adjust for weekends - move to next Monday
        if (next.weekday == DateTime.saturday) {
          next = next.add(const Duration(days: 2));
        } else if (next.weekday == DateTime.sunday) {
          next = next.add(const Duration(days: 1));
        }
        return next;
      case 'weekly':
        var next = base.add(const Duration(days: 7));
        while (next.weekday != dayOfWeek) {
          next = next.add(const Duration(days: 1));
        }
        return next;
      case 'biweekly':
        return base.add(const Duration(days: 14));
      default:
        return base.add(const Duration(days: 30));
    }
  }

  bool shouldAutoMark(DateTime transactionDate) {
    if (!autoMark || !isActive) return false;
    if (frequency == 'daily') return true;
    final expected = nextExpected ?? calculateNextExpected();
    return transactionDate.difference(expected).inDays.abs() <= 3;
  }

  bool matchesAmount(double txnAmount) {
    if (isVariableAmount) {
      return txnAmount >= minAmount! && txnAmount <= maxAmount!;
    }
    return (txnAmount - amount).abs() < 100;
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'source': source,
    'amount': amount,
    'minAmount': minAmount,
    'maxAmount': maxAmount,
    'frequency': frequency,
    'dayOfMonth': dayOfMonth,
    'dayOfWeek': dayOfWeek,
    'merchantName': merchantName,
    'autoMark': autoMark ? 1 : 0,
    'lastReceived': lastReceived?.toIso8601String(),
    'nextExpected': nextExpected?.toIso8601String(),
    'isActive': isActive ? 1 : 0,
    'createdAt': createdAt.toIso8601String(),
  };

  factory RecurringIncome.fromJson(Map<String, dynamic> json) =>
      RecurringIncome(
        id: json['id'],
        name: json['name'],
        source: json['source'],
        amount: (json['amount'] ?? 0).toDouble(),
        minAmount: json['minAmount']?.toDouble(),
        maxAmount: json['maxAmount']?.toDouble(),
        frequency: json['frequency'],
        dayOfMonth: json['dayOfMonth'] ?? 1,
        dayOfWeek: json['dayOfWeek'] ?? 1,
        merchantName: json['merchantName'],
        autoMark: (json['autoMark'] ?? 1) == 1,
        lastReceived: json['lastReceived'] != null
            ? DateTime.parse(json['lastReceived'])
            : null,
        nextExpected: json['nextExpected'] != null
            ? DateTime.parse(json['nextExpected'])
            : null,
        isActive: (json['isActive'] ?? 1) == 1,
        createdAt: json['createdAt'] != null
            ? DateTime.parse(json['createdAt'])
            : DateTime.now(),
      );

  RecurringIncome copyWith({
    String? id,
    String? name,
    String? source,
    double? amount,
    double? minAmount,
    double? maxAmount,
    String? frequency,
    int? dayOfMonth,
    int? dayOfWeek,
    String? merchantName,
    bool? autoMark,
    DateTime? lastReceived,
    DateTime? nextExpected,
    bool? isActive,
    DateTime? createdAt,
  }) {
    return RecurringIncome(
      id: id ?? this.id,
      name: name ?? this.name,
      source: source ?? this.source,
      amount: amount ?? this.amount,
      minAmount: minAmount ?? this.minAmount,
      maxAmount: maxAmount ?? this.maxAmount,
      frequency: frequency ?? this.frequency,
      dayOfMonth: dayOfMonth ?? this.dayOfMonth,
      dayOfWeek: dayOfWeek ?? this.dayOfWeek,
      merchantName: merchantName ?? this.merchantName,
      autoMark: autoMark ?? this.autoMark,
      lastReceived: lastReceived ?? this.lastReceived,
      nextExpected: nextExpected ?? this.nextExpected,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
