class Budget {
  final String id;
  final String name;
  final String type; // 'category', 'project', 'envelope', 'percentage'
  final String? category;
  final double amount;
  final double spent;
  final String period;
  final DateTime startDate;
  final DateTime endDate;

  // Smart features
  final bool autoAllocate;
  final double? percentageOfIncome;
  final bool rolloverEnabled;
  final double rolloverAmount;

  // Project-based
  final bool isProject;
  final String? projectGoal;
  final List<String> linkedTransactionIds;

  // Alerts
  final double alertAt;
  final bool notificationsEnabled;

  // Analytics
  final double averageSpending;
  final double predictedSpending;

  // Metadata
  final DateTime createdAt;
  final DateTime updatedAt;
  final bool isActive;

  Budget({
    required this.id,
    required this.name,
    this.type = 'category',
    this.category,
    required this.amount,
    this.spent = 0,
    required this.period,
    required this.startDate,
    required this.endDate,
    this.autoAllocate = false,
    this.percentageOfIncome,
    this.rolloverEnabled = false,
    this.rolloverAmount = 0,
    this.isProject = false,
    this.projectGoal,
    this.linkedTransactionIds = const [],
    this.alertAt = 80,
    this.notificationsEnabled = true,
    this.averageSpending = 0,
    this.predictedSpending = 0,
    DateTime? createdAt,
    DateTime? updatedAt,
    this.isActive = true,
  }) : createdAt = createdAt ?? DateTime.now(),
       updatedAt = updatedAt ?? DateTime.now();

  // Legacy compatibility
  double get limit => amount;

  double get remaining => amount - spent;
  double get percentage => amount > 0 ? (spent / amount * 100) : 0;
  bool get isOverBudget => spent > amount;

  int get daysLeft => endDate.difference(DateTime.now()).inDays;
  int get totalDays => endDate.difference(startDate).inDays;
  int get daysElapsed => DateTime.now().difference(startDate).inDays;

  double get dailyBudget => daysLeft > 0 ? remaining / daysLeft : 0;
  double get expectedSpent =>
      totalDays > 0 ? amount * (daysElapsed / totalDays) : 0;

  String get paceStatus {
    if (spent > expectedSpent * 1.2) return 'fast';
    if (spent > expectedSpent) return 'ahead';
    return 'on-track';
  }

  bool get shouldAlert => percentage >= alertAt;

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'type': type,
    'category': category,
    'amount': amount,
    'spent': spent,
    'period': period,
    'startDate': startDate.toIso8601String(),
    'endDate': endDate.toIso8601String(),
    'autoAllocate': autoAllocate ? 1 : 0,
    'percentageOfIncome': percentageOfIncome,
    'rolloverEnabled': rolloverEnabled ? 1 : 0,
    'rolloverAmount': rolloverAmount,
    'isProject': isProject ? 1 : 0,
    'projectGoal': projectGoal,
    'linkedTransactionIds': linkedTransactionIds.join(','),
    'alertAt': alertAt,
    'notificationsEnabled': notificationsEnabled ? 1 : 0,
    'averageSpending': averageSpending,
    'predictedSpending': predictedSpending,
    'createdAt': createdAt.toIso8601String(),
    'updatedAt': updatedAt.toIso8601String(),
    'isActive': isActive ? 1 : 0,
  };

  factory Budget.fromJson(Map<String, dynamic> json) => Budget(
    id: json['id'],
    name: json['name'] ?? json['category'] ?? 'Budget',
    type: json['type'] ?? 'category',
    category: json['category'],
    amount: (json['amount'] ?? json['limit_amount'] ?? json['limit'] ?? 0)
        .toDouble(),
    spent: (json['spent'] ?? 0).toDouble(),
    period: json['period'] ?? 'Monthly',
    startDate: DateTime.parse(json['startDate']),
    endDate: DateTime.parse(json['endDate']),
    autoAllocate: (json['autoAllocate'] ?? 0) == 1,
    percentageOfIncome: json['percentageOfIncome']?.toDouble(),
    rolloverEnabled: (json['rolloverEnabled'] ?? 0) == 1,
    rolloverAmount: (json['rolloverAmount'] ?? 0).toDouble(),
    isProject: (json['isProject'] ?? 0) == 1,
    projectGoal: json['projectGoal'],
    linkedTransactionIds: json['linkedTransactionIds'] != null
        ? (json['linkedTransactionIds'] as String)
              .split(',')
              .where((s) => s.isNotEmpty)
              .toList()
        : [],
    alertAt: (json['alertAt'] ?? 80).toDouble(),
    notificationsEnabled: (json['notificationsEnabled'] ?? 1) == 1,
    averageSpending: (json['averageSpending'] ?? 0).toDouble(),
    predictedSpending: (json['predictedSpending'] ?? 0).toDouble(),
    createdAt: json['createdAt'] != null
        ? DateTime.parse(json['createdAt'])
        : DateTime.now(),
    updatedAt: json['updatedAt'] != null
        ? DateTime.parse(json['updatedAt'])
        : DateTime.now(),
    isActive: (json['isActive'] ?? 1) == 1,
  );

  Budget copyWith({
    String? id,
    String? name,
    String? type,
    String? category,
    double? amount,
    double? spent,
    String? period,
    DateTime? startDate,
    DateTime? endDate,
    bool? autoAllocate,
    double? percentageOfIncome,
    bool? rolloverEnabled,
    double? rolloverAmount,
    bool? isProject,
    String? projectGoal,
    List<String>? linkedTransactionIds,
    double? alertAt,
    bool? notificationsEnabled,
    double? averageSpending,
    double? predictedSpending,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? isActive,
  }) {
    return Budget(
      id: id ?? this.id,
      name: name ?? this.name,
      type: type ?? this.type,
      category: category ?? this.category,
      amount: amount ?? this.amount,
      spent: spent ?? this.spent,
      period: period ?? this.period,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      autoAllocate: autoAllocate ?? this.autoAllocate,
      percentageOfIncome: percentageOfIncome ?? this.percentageOfIncome,
      rolloverEnabled: rolloverEnabled ?? this.rolloverEnabled,
      rolloverAmount: rolloverAmount ?? this.rolloverAmount,
      isProject: isProject ?? this.isProject,
      projectGoal: projectGoal ?? this.projectGoal,
      linkedTransactionIds: linkedTransactionIds ?? this.linkedTransactionIds,
      alertAt: alertAt ?? this.alertAt,
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
      averageSpending: averageSpending ?? this.averageSpending,
      predictedSpending: predictedSpending ?? this.predictedSpending,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isActive: isActive ?? this.isActive,
    );
  }
}

class BudgetTemplate {
  final String id;
  final String name;
  final String description;
  final String budgetType;
  final Map<String, double> categories;
  final String icon;
  final bool isRecommended;

  BudgetTemplate({
    required this.id,
    required this.name,
    required this.description,
    required this.budgetType,
    required this.categories,
    required this.icon,
    this.isRecommended = false,
  });
}

class BudgetAlert {
  final String id;
  final String budgetId;
  final String type;
  final String message;
  final String severity;
  final DateTime timestamp;
  final bool isRead;

  BudgetAlert({
    required this.id,
    required this.budgetId,
    required this.type,
    required this.message,
    required this.severity,
    required this.timestamp,
    this.isRead = false,
  });
}
