import 'dart:math';
import '../../features/transactions/domain/entities/transaction.dart';
import '../constants/app_constants.dart';

class MLCategorizationService {
  static final MLCategorizationService _instance = MLCategorizationService._();
  factory MLCategorizationService() => _instance;
  MLCategorizationService._();

  // Simple keyword-based ML model (can be replaced with TFLite model)
  final Map<String, List<String>> _categoryKeywords = {
    'Food & Dining': ['restaurant', 'cafe', 'kfc', 'pizza', 'food', 'dining', 'eatery'],
    'Shopping': ['supermarket', 'naivas', 'carrefour', 'quickmart', 'shop', 'jumia', 'kilimall', 'store'],
    'Transportation': ['uber', 'bolt', 'matatu', 'taxi', 'fuel', 'petrol', 'transport'],
    'Bills & Utilities': ['electricity', 'water', 'rent', 'kplc', 'nairobi water', 'bill', 'utility', 'paybill'],
    'Airtime & Data': ['airtime', 'bundles', 'data', 'safaricom', 'airtel'],
    'Entertainment': ['cinema', 'movie', 'netflix', 'spotify', 'entertainment'],
    'Mobile Money': ['mpesa', 'm-pesa', 'send money', 'withdraw', 'agent'],
    'Interest & Fees': ['fee', 'charge', 'interest', 'penalty'],
    'Salary': ['salary', 'payroll', 'wages'],
    'Transfer': ['transfer', 'sent to', 'received from'],
    'Other': [],
  };

  final List<String> _financialKeywords = [
    'ksh', 'kes', 'paid', 'received', 'sent', 'balance', 'account',
    'mpesa', 'm-pesa', 'transaction', 'withdraw', 'deposit', 'transfer',
    'confirmed', 'receipt', 'charge', 'fee', 'amount', 'payment',
    'bank', 'atm', 'paybill', 'till', 'buy goods', 'airtime',
  ];

  final List<String> _reminderKeywords = [
    'reminder', 'due', 'upcoming', 'expires', 'renew', 'subscription',
    'will be', 'please', 'kindly', 'remember', 'don\'t forget',
  ];

  bool isFinancialMessage(String message) {
    final lower = message.toLowerCase();
    
    // Check if it's a reminder/notification
    if (_isReminderMessage(lower)) return false;
    
    int matchCount = 0;
    for (final keyword in _financialKeywords) {
      if (lower.contains(keyword)) {
        matchCount++;
      }
    }

    // Consider it financial if it has 2+ financial keywords
    return matchCount >= 2;
  }

  bool _isReminderMessage(String message) {
    int reminderCount = 0;
    for (final keyword in _reminderKeywords) {
      if (message.contains(keyword)) {
        reminderCount++;
      }
    }
    // It's a reminder if it has reminder keywords but no transaction confirmation
    return reminderCount > 0 && !message.contains('confirmed');
  }

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
