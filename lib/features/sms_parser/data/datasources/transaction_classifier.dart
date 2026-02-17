import 'dart:developer' as developer;
import '../../../../core/utils/classification_rules.dart';

class TransactionClassifier {
  ClassificationRules? _rules;

  Future<void> initialize() async {
    _rules = await ClassificationRules.load();
    developer.log('Loaded classification rules');
  }

  Future<Map<String, String>> classify(String smsBody) async {
    _rules ??= ClassificationRules.getDefaults();
    return _classifyWithRules(smsBody, _rules!);
  }

  Map<String, String> _classifyWithRules(
    String body,
    ClassificationRules rules,
  ) {
    final lowerBody = body.toLowerCase();

    // Check for failures
    if (rules.failureKeywords.any((kw) => lowerBody.contains(kw))) {
      return {'type': 'skip', 'category': 'Other'};
    }

    // Determine type
    String type = 'expense'; // default

    // Check income keywords
    for (var keywords in rules.incomeKeywords.values) {
      if (keywords.any((kw) => lowerBody.contains(kw))) {
        type = 'income';
        break;
      }
    }

    // Check transfer keywords
    for (var keywords in rules.transferKeywords.values) {
      if (keywords.any((kw) => lowerBody.contains(kw))) {
        type = 'transfer';
        break;
      }
    }

    // If not income or transfer, check expense keywords
    if (type == 'expense') {
      for (var keywords in rules.expenseKeywords.values) {
        if (keywords.any((kw) => lowerBody.contains(kw))) {
          type = 'expense';
          break;
        }
      }
    }

    // Determine category
    String category = 'Other';
    for (var entry in rules.categoryKeywords.entries) {
      if (entry.value.any((kw) => lowerBody.contains(kw))) {
        category = entry.key;
        break;
      }
    }

    if (type == 'transfer') {
      category = 'Transfer';
    }

    return {'type': type, 'category': category};
  }

  void dispose() {
    // No resources to dispose
  }
}
