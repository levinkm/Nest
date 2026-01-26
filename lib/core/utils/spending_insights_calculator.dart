import '../../features/transactions/domain/entities/transaction.dart' as domain;

class SpendingInsight {
  final String category;
  final double currentAmount;
  final double previousAmount;
  final double percentageChange;
  final int transactionCount;

  SpendingInsight({
    required this.category,
    required this.currentAmount,
    required this.previousAmount,
    required this.percentageChange,
    required this.transactionCount,
  });

  bool get isIncreasing => percentageChange > 0;
}

class SpendingInsightsCalculator {
  static List<SpendingInsight> calculate(
    List<domain.Transaction> transactions,
  ) {
    final now = DateTime.now();
    final currentMonthStart = DateTime(now.year, now.month, 1);
    final previousMonthStart = DateTime(now.year, now.month - 1, 1);

    // Current month expenses
    final currentExpenses = <String, double>{};
    final currentCounts = <String, int>{};

    for (var t in transactions.where(
      (t) =>
          t.type == 'expense' &&
          !t.isTransfer &&
          t.date.isAfter(currentMonthStart),
    )) {
      currentExpenses[t.category] =
          (currentExpenses[t.category] ?? 0) + t.amount;
      currentCounts[t.category] = (currentCounts[t.category] ?? 0) + 1;
    }

    // Previous month expenses
    final previousExpenses = <String, double>{};

    for (var t in transactions.where(
      (t) =>
          t.type == 'expense' &&
          !t.isTransfer &&
          t.date.isAfter(previousMonthStart) &&
          t.date.isBefore(currentMonthStart),
    )) {
      previousExpenses[t.category] =
          (previousExpenses[t.category] ?? 0) + t.amount;
    }

    // Calculate insights
    final insights = <SpendingInsight>[];

    for (var category in currentExpenses.keys) {
      final current = currentExpenses[category]!;
      final previous = previousExpenses[category] ?? 0;
      final change = previous > 0
          ? ((current - previous) / previous) * 100
          : 100;

      insights.add(
        SpendingInsight(
          category: category,
          currentAmount: current,
          previousAmount: previous,
          percentageChange: double.parse(change.toString()),
          transactionCount: currentCounts[category] ?? 0,
        ),
      );
    }

    // Sort by percentage change (highest increase first)
    insights.sort((a, b) => b.percentageChange.compareTo(a.percentageChange));

    return insights;
  }

  static List<SpendingInsight> getTopSpendingCategories(
    List<domain.Transaction> transactions, {
    int limit = 5,
  }) {
    final now = DateTime.now();
    final currentMonthStart = DateTime(now.year, now.month, 1);

    final categoryExpenses = <String, double>{};
    final categoryCounts = <String, int>{};

    for (var t in transactions.where(
      (t) =>
          t.type == 'expense' &&
          !t.isTransfer &&
          t.date.isAfter(currentMonthStart),
    )) {
      categoryExpenses[t.category] =
          (categoryExpenses[t.category] ?? 0) + t.amount;
      categoryCounts[t.category] = (categoryCounts[t.category] ?? 0) + 1;
    }

    final insights = categoryExpenses.entries
        .map(
          (e) => SpendingInsight(
            category: e.key,
            currentAmount: e.value,
            previousAmount: 0,
            percentageChange: 0,
            transactionCount: categoryCounts[e.key] ?? 0,
          ),
        )
        .toList();

    insights.sort((a, b) => b.currentAmount.compareTo(a.currentAmount));

    return insights.take(limit).toList();
  }
}
