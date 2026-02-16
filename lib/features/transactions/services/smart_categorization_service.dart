import 'package:nest/features/transactions/data/models/categorization_models.dart';
import 'package:nest/features/transactions/domain/entities/transaction.dart';
import '../../../core/services/remote_config_service.dart';
import '../../../core/services/ml_categorization_service.dart';
import '../data/datasources/local_database.dart';

class SmartCategorizationService {
  final RemoteConfigService _remoteConfig = RemoteConfigService();
  final MLCategorizationService _mlService = MLCategorizationService();
  final LocalDatabase _database = LocalDatabase();

  Future<List<CategorizationRule>> getRules() async {
    final remoteRules = await _remoteConfig.getClassificationRules();
    if (remoteRules != null && remoteRules.isNotEmpty) {
      return remoteRules;
    }
    final localRules = await _database.getCategorizationRules();
    return localRules.map((m) => CategorizationRule.fromJson(m)).toList();
  }

  Future<String?> categorizeTransaction(Transaction transaction) async {
    // Try ML-based categorization first
    final mlCategory = _mlService.categorizeTransaction(transaction);
    if (mlCategory != null) return mlCategory;

    // Fallback to rule-based categorization
    final rules = await getRules();
    final sortedRules = rules.where((r) => r.isActive).toList()
      ..sort((a, b) => b.priority.compareTo(a.priority));

    for (final rule in sortedRules) {
      if (_matchesRule(transaction, rule)) return rule.category;
    }
    return null;
  }

  bool _matchesRule(Transaction transaction, CategorizationRule rule) {
    switch (rule.matchType) {
      case 'merchant':
        return transaction.description.toLowerCase().contains(
          rule.matchValue.toLowerCase(),
        );
      case 'keyword':
        final keywords = rule.matchValue.toLowerCase().split(',');
        final desc = transaction.description.toLowerCase();
        return keywords.any((keyword) => desc.contains(keyword.trim()));
      case 'amount':
        final targetAmount = double.tryParse(rule.matchValue) ?? 0;
        return (transaction.amount - targetAmount).abs() < 1.0;
      case 'date':
        final day = int.tryParse(rule.matchValue) ?? 0;
        return transaction.date.day == day;
      default:
        return false;
    }
  }

  RecurringIncome? matchRecurringIncome(
    Transaction transaction,
    List<RecurringIncome> incomes,
  ) {
    if (transaction.type.toLowerCase() != 'income') return null;

    for (final income in incomes.where((i) => i.isActive)) {
      if (income.merchantName != null &&
          transaction.description.toLowerCase().contains(
            income.merchantName!.toLowerCase(),
          )) {
        if (income.matchesAmount(transaction.amount)) return income;
      }

      final amountMatch = income.matchesAmount(transaction.amount);
      final dateMatch = income.shouldAutoMark(transaction.date);

      if (amountMatch && dateMatch) return income;
    }
    return null;
  }

  List<CategorizationRule> getDefaultRules() {
    return [
      CategorizationRule(
        id: 'rule_mpesa_airtime',
        name: 'M-Pesa Airtime',
        category: 'Airtime & Data',
        matchType: 'keyword',
        matchValue: 'airtime,bundles',
        priority: 10,
      ),
      CategorizationRule(
        id: 'rule_mpesa_paybill',
        name: 'M-Pesa Bills',
        category: 'Bills & Utilities',
        matchType: 'keyword',
        matchValue: 'paybill,till',
        priority: 8,
      ),
      CategorizationRule(
        id: 'rule_transport',
        name: 'Transport',
        category: 'Transportation',
        matchType: 'keyword',
        matchValue: 'uber,bolt,matatu,taxi',
        priority: 9,
      ),
    ];
  }
}
