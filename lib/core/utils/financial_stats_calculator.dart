import '../../features/transactions/domain/entities/transaction.dart' as domain;
import '../../features/transactions/data/datasources/local_database.dart';

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
  static Future<FinancialStats> calculate(
    List<domain.Transaction> transactions,
  ) async {
    double totalIncome = 0;
    double totalExpense = 0;
    double totalTransfers = 0;

    final expenseByCategory = <String, double>{};
    final incomeByCategory = <String, double>{};

    for (var t in transactions) {
      if (t.isTransfer) {
        totalTransfers += t.amount;
        continue;
      }

      if (t.type == 'income') {
        totalIncome += t.amount;
        incomeByCategory[t.category] =
            (incomeByCategory[t.category] ?? 0) + t.amount;
      } else if (t.type == 'expense') {
        totalExpense += t.amount;
        expenseByCategory[t.category] =
            (expenseByCategory[t.category] ?? 0) + t.amount;
      }
      // debt and debt_payment don't affect income/expense
    }

    // Get debt from debt table + Fuliza from account balance
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
    // Get debts from debt table
    final db = LocalDatabase();
    final debts = await db.getDebts();
    double debtTotal = debts.fold<double>(
      0.0,
      (sum, d) => sum + (d['principal'] as double),
    );

    // Add Fuliza debt from account balance
    final account = await db.getAccount('mpesa_default');
    if (account != null) {
      final balance = account['balance'] ?? 0.0;
      if (balance < 0) {
        debtTotal += balance.abs();
      }
    }

    return debtTotal;
  }

  static double calculateFulizaDebt(List<domain.Transaction> transactions) {
    // Fuliza debt is tracked in account balance (negative balance)
    // This method kept for backward compatibility
    return 0.0;
  }

  static Map<String, double> calculateMonthlyTrend(
    List<domain.Transaction> transactions,
  ) {
    final monthlyExpense = <String, double>{};

    for (var t in transactions.where(
      (t) => t.type == 'expense' && !t.isTransfer,
    )) {
      final monthKey =
          '${t.date.year}-${t.date.month.toString().padLeft(2, '0')}';
      monthlyExpense[monthKey] = (monthlyExpense[monthKey] ?? 0) + t.amount;
    }

    return monthlyExpense;
  }
}
