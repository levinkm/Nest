import '../data/models/budget_model.dart';
import '../../transactions/domain/entities/transaction.dart';

class SmartBudgetService {
  // Suggest budget amount based on transaction history
  double suggestBudget(String category, List<Transaction> history) {
    final categoryTxns = history
        .where(
          (t) =>
              t.category.toLowerCase() == category.toLowerCase() &&
              t.type.toLowerCase() == 'expense',
        )
        .toList();

    if (categoryTxns.isEmpty) return 0;

    final amounts = categoryTxns.map((t) => t.amount).toList();
    amounts.sort();

    // Use median + 10% buffer (more stable than average)
    final median = amounts.length.isOdd
        ? amounts[amounts.length ~/ 2]
        : (amounts[amounts.length ~/ 2 - 1] + amounts[amounts.length ~/ 2]) / 2;

    return median * 1.1;
  }

  // Predict monthly spending based on current pace
  double predictMonthlySpending(Budget budget) {
    if (budget.daysElapsed == 0) return budget.spent;

    final dailyRate = budget.spent / budget.daysElapsed;
    return dailyRate * budget.totalDays;
  }

  // Calculate budget health score (0-100)
  int calculateBudgetHealth(List<Budget> budgets, double income) {
    if (budgets.isEmpty) return 0;

    final activeBudgets = budgets.where((b) => b.isActive).toList();
    if (activeBudgets.isEmpty) return 0;

    // Adherence: % of budgets not exceeded
    final adherence =
        activeBudgets.where((b) => !b.isOverBudget).length /
        activeBudgets.length;

    // Savings rate
    final totalSpent = activeBudgets.fold(0.0, (sum, b) => sum + b.spent);
    final savingsRate = income > 0
        ? ((income - totalSpent) / income).clamp(0.0, 1.0)
        : 0;

    // Coverage: % of spending that's budgeted
    final totalBudgeted = activeBudgets.fold(0.0, (sum, b) => sum + b.amount);
    final coverage = totalSpent > 0
        ? (totalBudgeted / totalSpent).clamp(0.0, 1.0)
        : 1.0;

    // Weighted score
    final score = (adherence * 0.4 + savingsRate * 0.3 + coverage * 0.3) * 100;
    return score.round();
  }

  // Generate smart insights
  List<String> generateInsights(Budget budget, List<Transaction> transactions) {
    final insights = <String>[];

    // Pace analysis
    if (budget.paceStatus == 'fast') {
      final predicted = predictMonthlySpending(budget);
      final overage = predicted - budget.amount;
      insights.add(
        '⚠️ Spending 20% faster than planned. May exceed by KSh ${overage.toStringAsFixed(0)}',
      );
    }

    // Weekend spending
    final weekendTxns = transactions.where((t) {
      final day = t.date.weekday;
      return day == 6 || day == 7;
    }).toList();

    if (weekendTxns.isNotEmpty) {
      final weekendSpent = weekendTxns.fold(0.0, (sum, t) => sum + t.amount);
      final weekdaySpent = budget.spent - weekendSpent;
      if (weekendSpent > weekdaySpent * 0.5) {
        insights.add(
          '📊 You spend ${((weekendSpent / budget.spent) * 100).toStringAsFixed(0)}% on weekends',
        );
      }
    }

    // Rollover suggestion
    if (!budget.rolloverEnabled && budget.remaining > budget.amount * 0.2) {
      insights.add('💡 Enable rollover to carry forward unused budget');
    }

    return insights;
  }

  // Generate budget templates
  List<BudgetTemplate> getTemplates() {
    return [
      BudgetTemplate(
        id: '50-30-20',
        name: '50/30/20 Rule',
        description: '50% Needs, 30% Wants, 20% Savings',
        budgetType: 'percentage',
        categories: {
          'Food & Dining': 25,
          'Bills & Utilities': 15,
          'Transportation': 10,
          'Shopping': 15,
          'Entertainment': 15,
          'Savings': 20,
        },
        icon: '📊',
        isRecommended: true,
      ),
      BudgetTemplate(
        id: 'essentials',
        name: 'Essentials Only',
        description: 'Focus on needs, minimize wants',
        budgetType: 'percentage',
        categories: {
          'Food & Dining': 30,
          'Bills & Utilities': 25,
          'Transportation': 15,
          'Airtime & Data': 10,
          'Savings': 20,
        },
        icon: '🎯',
        isRecommended: false,
      ),
      BudgetTemplate(
        id: 'balanced',
        name: 'Balanced Budget',
        description: 'Equal focus on all categories',
        budgetType: 'category',
        categories: {
          'Food & Dining': 20,
          'Transportation': 15,
          'Bills & Utilities': 15,
          'Shopping': 15,
          'Entertainment': 10,
          'Airtime & Data': 10,
          'Savings': 15,
        },
        icon: '⚖️',
        isRecommended: false,
      ),
    ];
  }

  // Calculate average spending for a category
  double calculateAverageSpending(
    String category,
    List<Transaction> history,
    int months,
  ) {
    final cutoff = DateTime.now().subtract(Duration(days: months * 30));
    final categoryTxns = history
        .where(
          (t) =>
              t.category.toLowerCase() == category.toLowerCase() &&
              t.type.toLowerCase() == 'expense' &&
              t.date.isAfter(cutoff),
        )
        .toList();

    if (categoryTxns.isEmpty) return 0;

    final total = categoryTxns.fold(0.0, (sum, t) => sum + t.amount);
    return total / months;
  }

  // Detect if user needs a budget for uncategorized spending
  Map<String, double> detectMissingBudgets(
    List<Budget> existingBudgets,
    List<Transaction> transactions,
  ) {
    final budgetedCategories = existingBudgets
        .map((b) => b.category?.toLowerCase())
        .toSet();
    final missing = <String, double>{};

    for (final txn in transactions) {
      if (txn.type.toLowerCase() == 'expense' &&
          !budgetedCategories.contains(txn.category.toLowerCase())) {
        missing[txn.category] = (missing[txn.category] ?? 0) + txn.amount;
      }
    }

    return missing;
  }

  // Generate end-of-month report
  Map<String, dynamic> generateMonthlyReport(
    Budget budget,
    List<Transaction> transactions,
  ) {
    final variance = budget.remaining;
    final status = budget.isOverBudget ? 'over' : 'under';

    return {
      'budget': budget,
      'variance': variance,
      'status': status,
      'transactionCount': transactions.length,
      'averageTransaction': transactions.isNotEmpty
          ? transactions.fold(0.0, (sum, t) => sum + t.amount) /
                transactions.length
          : 0,
      'largestTransaction': transactions.isNotEmpty
          ? transactions.map((t) => t.amount).reduce((a, b) => a > b ? a : b)
          : 0,
    };
  }
}
