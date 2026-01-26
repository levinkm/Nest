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
    double fulizaBorrowed = 0;
    double fulizaRepaid = 0;

    for (var t in transactions) {
      if (t.category == 'Loans' && t.description.toLowerCase().contains('fuliza')) {
        if (t.description.toLowerCase().contains('repay') || 
            t.description.toLowerCase().contains('outstanding')) {
          fulizaRepaid += t.amount;
        } else if (t.description.toLowerCase().contains('limit used') ||
                   t.description.toLowerCase().contains('amount is')) {
          fulizaBorrowed += t.amount;
        }
      }
    }

    return fulizaBorrowed - fulizaRepaid;
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
