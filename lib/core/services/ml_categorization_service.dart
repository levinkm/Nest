import 'dart:math';
import '../../features/transactions/domain/entities/transaction.dart';

class MLCategorizationService {
  static final MLCategorizationService _instance = MLCategorizationService._();
  factory MLCategorizationService() => _instance;
  MLCategorizationService._();

  // Simple keyword-based ML model (can be replaced with TFLite model)
  final Map<String, List<String>> _categoryKeywords = {
    'Groceries': ['supermarket', 'naivas', 'carrefour', 'quickmart', 'shop'],
    'Transport': ['uber', 'bolt', 'matatu', 'taxi', 'fuel', 'petrol'],
    'Dining': ['restaurant', 'cafe', 'kfc', 'pizza', 'food'],
    'Bills': ['electricity', 'water', 'rent', 'kplc', 'nairobi water'],
    'Airtime & Data': ['airtime', 'bundles', 'data', 'safaricom'],
    'Entertainment': ['cinema', 'movie', 'netflix', 'spotify'],
    'Health': ['hospital', 'pharmacy', 'clinic', 'doctor'],
    'Shopping': ['jumia', 'kilimall', 'amazon', 'store'],
  };

  String? categorizeTransaction(Transaction transaction) {
    final description = transaction.description.toLowerCase();
    final scores = <String, double>{};

    for (final entry in _categoryKeywords.entries) {
      double score = 0;
      for (final keyword in entry.value) {
        if (description.contains(keyword)) {
          score += 1.0;
        }
      }
      if (score > 0) {
        scores[entry.key] = score / entry.value.length;
      }
    }

    if (scores.isEmpty) return null;
    
    final sorted = scores.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    
    return sorted.first.key;
  }

  bool detectAnomaly(Transaction transaction, List<Transaction> history) {
    if (history.isEmpty) return false;

    final categoryTransactions = history
        .where((t) => t.category == transaction.category && t.type == transaction.type)
        .toList();

    if (categoryTransactions.length < 3) return false;

    final amounts = categoryTransactions.map((t) => t.amount).toList();
    final mean = amounts.reduce((a, b) => a + b) / amounts.length;
    final variance = amounts.map((a) => pow(a - mean, 2)).reduce((a, b) => a + b) / amounts.length;
    final stdDev = sqrt(variance);

    // Flag if transaction is more than 2 standard deviations from mean
    return (transaction.amount - mean).abs() > (2 * stdDev);
  }

  Map<String, dynamic> getSpendingInsights(List<Transaction> transactions) {
    if (transactions.isEmpty) {
      return {'hasInsights': false};
    }

    final expenses = transactions.where((t) => t.type == 'expense').toList();
    if (expenses.isEmpty) {
      return {'hasInsights': false};
    }

    final categorySpending = <String, double>{};
    for (final tx in expenses) {
      categorySpending[tx.category] = (categorySpending[tx.category] ?? 0) + tx.amount;
    }

    final total = categorySpending.values.reduce((a, b) => a + b);
    final topCategory = categorySpending.entries.reduce((a, b) => a.value > b.value ? a : b);

    final last30Days = expenses.where((t) => 
      t.date.isAfter(DateTime.now().subtract(const Duration(days: 30)))
    ).toList();

    final avgDailySpending = last30Days.isEmpty 
        ? 0.0 
        : last30Days.map((t) => t.amount).reduce((a, b) => a + b) / 30;

    return {
      'hasInsights': true,
      'topCategory': topCategory.key,
      'topCategoryAmount': topCategory.value,
      'topCategoryPercentage': (topCategory.value / total * 100).toStringAsFixed(1),
      'avgDailySpending': avgDailySpending.toStringAsFixed(0),
      'totalCategories': categorySpending.length,
    };
  }

  List<String> getSuggestions(List<Transaction> transactions) {
    final insights = getSpendingInsights(transactions);
    if (!insights['hasInsights']) return [];

    final suggestions = <String>[];
    
    final topCategoryPct = double.parse(insights['topCategoryPercentage']);
    if (topCategoryPct > 40) {
      suggestions.add('${insights['topCategory']} takes ${insights['topCategoryPercentage']}% of spending. Consider reducing.');
    }

    final avgDaily = double.parse(insights['avgDailySpending']);
    if (avgDaily > 1000) {
      suggestions.add('Average daily spending is KSh ${insights['avgDailySpending']}. Set a daily budget.');
    }

    final anomalies = transactions.where((t) => detectAnomaly(t, transactions)).toList();
    if (anomalies.isNotEmpty) {
      suggestions.add('${anomalies.length} unusual transactions detected. Review for accuracy.');
    }

    return suggestions;
  }
}
