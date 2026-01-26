import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class ClassificationRules {
  final Map<String, List<String>> incomeKeywords;
  final Map<String, List<String>> expenseKeywords;
  final Map<String, List<String>> transferKeywords;
  final List<String> failureKeywords;
  final Map<String, List<String>> categoryKeywords;

  ClassificationRules({
    required this.incomeKeywords,
    required this.expenseKeywords,
    required this.transferKeywords,
    required this.failureKeywords,
    required this.categoryKeywords,
  });

  static ClassificationRules getDefaults() {
    return ClassificationRules(
      incomeKeywords: {
        'received': ['received', 'credited', 'deposited', 'salary'],
      },
      expenseKeywords: {
        'sent': ['sent to', 'paid to', 'debited'],
        'purchase': ['buy goods', 'paybill', 'withdraw'],
      },
      transferKeywords: {
        'account': ['to your account', 'from your account', 'transfer'],
      },
      failureKeywords: ['failed', 'unsuccessful', 'declined', 'rejected', 'insufficient'],
      categoryKeywords: {
        'Food & Dining': ['cafe', 'hotel', 'restaurant', 'food', 'eatery'],
        'Shopping': ['shop', 'mall', 'store', 'supermarket'],
        'Transportation': ['uber', 'taxi', 'matatu', 'boda', 'fuel', 'petrol'],
        'Bills & Utilities': ['kplc', 'water', 'electricity', 'bill', 'token'],
        'Entertainment': ['netflix', 'movie', 'dstv', 'gotv', 'showmax'],
        'Airtime & Data': ['airtime', 'data', 'bundle'],
        'Mobile Money': ['mpesa', 'm-pesa', 'agent', 'ziidi'],
        'Loans': ['fuliza', 'loan', 'borrow'],
        'Salary': ['salary', 'wages'],
      },
    );
  }

  Future<void> save() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('classification_rules', jsonEncode({
      'incomeKeywords': incomeKeywords,
      'expenseKeywords': expenseKeywords,
      'transferKeywords': transferKeywords,
      'failureKeywords': failureKeywords,
      'categoryKeywords': categoryKeywords,
    }));
  }

  static Future<ClassificationRules> load() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString('classification_rules');
    
    if (data == null) {
      return getDefaults();
    }

    try {
      final json = jsonDecode(data);
      return ClassificationRules(
        incomeKeywords: Map<String, List<String>>.from(
          json['incomeKeywords'].map((k, v) => MapEntry(k, List<String>.from(v)))),
        expenseKeywords: Map<String, List<String>>.from(
          json['expenseKeywords'].map((k, v) => MapEntry(k, List<String>.from(v)))),
        transferKeywords: Map<String, List<String>>.from(
          json['transferKeywords'].map((k, v) => MapEntry(k, List<String>.from(v)))),
        failureKeywords: List<String>.from(json['failureKeywords']),
        categoryKeywords: Map<String, List<String>>.from(
          json['categoryKeywords'].map((k, v) => MapEntry(k, List<String>.from(v)))),
      );
    } catch (e) {
      return getDefaults();
    }
  }
}
