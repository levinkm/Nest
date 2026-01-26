import '../../features/transactions/domain/entities/transaction.dart' as domain;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class FinancialStats {
  final double totalIncome;
  final double totalExpense;
  final double netBalance;
  final double totalDebt;
  final double totalTransfers;
  final Map<String, double> expenseByCategory;
  final Map<String, double> incomeByCategory;

  FinancialStats({
    required this.totalIncome,
    required this.totalExpense,
    required this.netBalance,
    required this.totalDebt,
    required this.totalTransfers,
    required this.expenseByCategory,
    required this.incomeByCategory,
  });
}

class FinancialStatsCalculator {
  static Future<FinancialStats> calculate(List<domain.Transaction> transactions) async {
    double totalIncome = 0;
    double totalExpense = 0;
    double totalTransfers = 0;
    
    final expenseByCategory = <String, double>{};
    final incomeByCategory = <String, double>{};

    for (var t in transactions) {
      if (t.isTransfer) {
        // Transfers don't affect net balance
        totalTransfers += t.amount;
        continue;
      }

      if (t.type == 'income') {
        totalIncome += t.amount;
        incomeByCategory[t.category] = (incomeByCategory[t.category] ?? 0) + t.amount;
      } else if (t.type == 'expense') {
        totalExpense += t.amount;
        expenseByCategory[t.category] = (expenseByCategory[t.category] ?? 0) + t.amount;
      }
    }

    // Get actual debt from debt management
    final totalDebt = await _getTotalDebt();
    final netBalance = totalIncome - totalExpense;

    return FinancialStats(
      totalIncome: totalIncome,
      totalExpense: totalExpense,
      netBalance: netBalance,
      totalDebt: totalDebt,
      totalTransfers: totalTransfers,
      expenseByCategory: expenseByCategory,
      incomeByCategory: incomeByCategory,
    );
  }

  static Future<double> _getTotalDebt() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString('debts') ?? '[]';
    final debts = List<Map<String, dynamic>>.from(jsonDecode(data));
    return debts.where((d) => d['isActive'] == true).fold<double>(0.0, (sum, d) => sum + (d['remainingAmount'] as double));
  }

  static double calculateFulizaDebt(List<domain.Transaction> transactions) {
    // Get the most recent Fuliza transaction to extract outstanding balance
    final fulizaTransactions = transactions.where((t) => 
      t.description.toLowerCase().contains('fuliza')
    ).toList();

    print('Found ${fulizaTransactions.length} Fuliza transactions');

    if (fulizaTransactions.isEmpty) return 0.0;

    // Sort by date descending to get most recent
    fulizaTransactions.sort((a, b) => b.date.compareTo(a.date));
    
    // Check most recent transaction for outstanding balance
    final mostRecent = fulizaTransactions.first.description;
    print('Most recent Fuliza transaction: $mostRecent');
    
    final mostRecentLower = mostRecent.toLowerCase();
    
    // Extract outstanding balance from messages like:
    // "Total Fuliza M-Pesa outstanding amount is Ksh336.50"
    // "outstanding Fuliza M-PESA balance is Ksh100.00"
    // "partially pay your outstanding F uliza M-PESA balance of Ksh100.00"
    final patterns = [
      RegExp(r'outstanding amount is ksh?\s*([\d,]+\.?\d*)', caseSensitive: false),
      RegExp(r'outstanding.*?(?:is|of).*?ksh?\s*([\d,]+\.?\d*)', caseSensitive: false),
    ];
    
    for (final pattern in patterns) {
      final match = pattern.firstMatch(mostRecentLower);
      if (match != null) {
        final balanceStr = match.group(1)?.replaceAll(',', '') ?? '0';
        final balance = double.tryParse(balanceStr) ?? 0.0;
        print('Extracted Fuliza balance: $balance from pattern: ${pattern.pattern}');
        return balance;
      }
    }

    print('No Fuliza balance pattern matched');
    return 0.0;
  }

  static Map<String, double> calculateMonthlyTrend(List<domain.Transaction> transactions) {
    final monthlyExpense = <String, double>{};
    
    for (var t in transactions.where((t) => t.type == 'expense' && !t.isTransfer)) {
      final monthKey = '${t.date.year}-${t.date.month.toString().padLeft(2, '0')}';
      monthlyExpense[monthKey] = (monthlyExpense[monthKey] ?? 0) + t.amount;
    }

    return monthlyExpense;
  }
}
