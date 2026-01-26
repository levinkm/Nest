import '../../features/transactions/domain/entities/transaction.dart' as domain;
import 'financial_stats_calculator.dart';

class FinancialProjections {
  final double projectedMonthlyIncome;
  final double projectedMonthlyExpense;
  final double currentDebt;
  final double maxBorrowingCapacity;
  final double emergencyFundNeeded;
  final double monthlySavingsTarget;
  final double debtToIncomeRatio;
  final String financialHealth;

  FinancialProjections({
    required this.projectedMonthlyIncome,
    required this.projectedMonthlyExpense,
    required this.currentDebt,
    required this.maxBorrowingCapacity,
    required this.emergencyFundNeeded,
    required this.monthlySavingsTarget,
    required this.debtToIncomeRatio,
    required this.financialHealth,
  });
}

class FinancialProjectionsCalculator {
  static Future<FinancialProjections> calculate(List<domain.Transaction> transactions) async {
    final stats = await FinancialStatsCalculator.calculate(transactions);
    
    // Calculate average monthly income/expense (last 30 days)
    final last30Days = DateTime.now().subtract(const Duration(days: 30));
    final recentTransactions = transactions.where((t) => t.date.isAfter(last30Days)).toList();
    
    final monthlyIncome = recentTransactions
        .where((t) => t.type == 'income' && !t.isTransfer)
        .fold(0.0, (sum, t) => sum + t.amount);
    
    final monthlyExpense = recentTransactions
        .where((t) => t.type == 'expense' && !t.isTransfer)
        .fold(0.0, (sum, t) => sum + t.amount);
    
    // Debt-to-Income Ratio
    final debtToIncomeRatio = monthlyIncome > 0 ? (stats.totalDebt / monthlyIncome) : 0.0;
    
    // Max borrowing capacity (30% of monthly income rule)
    final maxMonthlyDebtPayment = monthlyIncome * 0.3;
    final currentMonthlyDebtPayment = stats.totalDebt * 0.1; // Assume 10% monthly repayment
    final maxBorrowingCapacity = (maxMonthlyDebtPayment - currentMonthlyDebtPayment) * 10;
    
    // Emergency fund (3-6 months of expenses)
    final emergencyFundNeeded = monthlyExpense * 3;
    
    // Savings target (20% of income after debt)
    final monthlySavingsTarget = (monthlyIncome - monthlyExpense - currentMonthlyDebtPayment) * 0.2;
    
    // Financial health assessment
    String financialHealth;
    if (debtToIncomeRatio > 0.5) {
      financialHealth = 'Critical';
    } else if (debtToIncomeRatio > 0.3) {
      financialHealth = 'Warning';
    } else if (monthlyIncome > monthlyExpense) {
      financialHealth = 'Good';
    } else {
      financialHealth = 'Fair';
    }
    
    return FinancialProjections(
      projectedMonthlyIncome: monthlyIncome,
      projectedMonthlyExpense: monthlyExpense,
      currentDebt: stats.totalDebt,
      maxBorrowingCapacity: maxBorrowingCapacity > 0 ? maxBorrowingCapacity : 0,
      emergencyFundNeeded: emergencyFundNeeded,
      monthlySavingsTarget: monthlySavingsTarget > 0 ? monthlySavingsTarget : 0,
      debtToIncomeRatio: debtToIncomeRatio,
      financialHealth: financialHealth,
    );
  }
}
