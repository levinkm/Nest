import '../../../transactions/data/datasources/local_database.dart';
import '../../../transactions/domain/entities/transaction.dart';
import 'dart:developer' as developer;

class FinancialAdvisorService {
  // Can I afford this?
  static Future<Map<String, dynamic>> canAfford(double amount) async {
    final db = LocalDatabase();
    final accounts = await db.getAccounts();
    final bills = await db.getBills();
    
    // Get current balance
    final mpesa = accounts.firstWhere((a) => a['id'] == 'mpesa_default');
    final currentBalance = mpesa['balance'] ?? 0.0;
    
    // Calculate upcoming bills
    final now = DateTime.now();
    final endOfMonth = DateTime(now.year, now.month + 1, 0);
    
    double upcomingBills = 0.0;
    for (var bill in bills) {
      if (bill['status'] == 'paid') continue;
      final dueDate = DateTime.parse(bill['dueDate']);
      if (dueDate.isBefore(endOfMonth)) {
        upcomingBills += bill['amount'] as double;
      }
    }
    
    final availableAfterBills = currentBalance - upcomingBills;
    final remainingAfterPurchase = availableAfterBills - amount;
    
    final canAfford = remainingAfterPurchase >= 0;
    final recommendation = _getAffordabilityRecommendation(
      currentBalance,
      upcomingBills,
      amount,
      remainingAfterPurchase,
    );
    
    return {
      'canAfford': canAfford,
      'currentBalance': currentBalance,
      'upcomingBills': upcomingBills,
      'availableAfterBills': availableAfterBills,
      'remainingAfterPurchase': remainingAfterPurchase,
      'recommendation': recommendation,
    };
  }
  
  static String _getAffordabilityRecommendation(
    double balance,
    double bills,
    double amount,
    double remaining,
  ) {
    if (remaining < 0) {
      return '❌ Not recommended. You\'ll be short by KSh ${remaining.abs().toStringAsFixed(0)}';
    } else if (remaining < 500) {
      return '⚠️ Risky. Only KSh ${remaining.toStringAsFixed(0)} left after bills';
    } else if (remaining < 2000) {
      return '⚡ Tight budget. Consider if this is essential';
    } else {
      return '✅ Affordable. KSh ${remaining.toStringAsFixed(0)} remaining';
    }
  }
  
  // Simulate new subscription impact
  static Future<Map<String, dynamic>> simulateSubscription(
    String name,
    double monthlyAmount,
  ) async {
    final db = LocalDatabase();
    final transactions = await db.getTransactions();
    
    // Calculate average monthly income
    final now = DateTime.now();
    final threeMonthsAgo = now.subtract(const Duration(days: 90));
    
    final incomeTransactions = transactions.where((t) => 
      t.type == 'income' && t.date.isAfter(threeMonthsAgo)
    ).toList();
    
    final totalIncome = incomeTransactions.fold<double>(0.0, (sum, t) => sum + t.amount);
    final avgMonthlyIncome = totalIncome / 3;
    
    // Calculate current monthly expenses
    final expenseTransactions = transactions.where((t) => 
      t.type == 'expense' && t.date.isAfter(threeMonthsAgo)
    ).toList();
    
    final totalExpenses = expenseTransactions.fold<double>(0.0, (sum, t) => sum + t.amount);
    final avgMonthlyExpenses = totalExpenses / 3;
    
    // Calculate impact
    final newMonthlyExpenses = avgMonthlyExpenses + monthlyAmount;
    final newSavingsRate = avgMonthlyIncome > 0 
      ? ((avgMonthlyIncome - newMonthlyExpenses) / avgMonthlyIncome * 100)
      : 0.0;
    
    final currentSavingsRate = avgMonthlyIncome > 0
      ? ((avgMonthlyIncome - avgMonthlyExpenses) / avgMonthlyIncome * 100)
      : 0.0;
    
    final impact = _getSubscriptionImpact(
      monthlyAmount,
      avgMonthlyIncome,
      currentSavingsRate,
      newSavingsRate,
    );
    
    return {
      'monthlyAmount': monthlyAmount,
      'avgMonthlyIncome': avgMonthlyIncome,
      'currentExpenses': avgMonthlyExpenses,
      'newExpenses': newMonthlyExpenses,
      'currentSavingsRate': currentSavingsRate,
      'newSavingsRate': newSavingsRate,
      'impact': impact,
    };
  }
  
  static String _getSubscriptionImpact(
    double amount,
    double income,
    double currentRate,
    double newRate,
  ) {
    final percentOfIncome = income > 0 ? (amount / income * 100) : 0.0;
    
    if (percentOfIncome > 10) {
      return '🚨 High impact: ${percentOfIncome.toStringAsFixed(1)}% of income';
    } else if (percentOfIncome > 5) {
      return '⚠️ Moderate impact: ${percentOfIncome.toStringAsFixed(1)}% of income';
    } else {
      return '✅ Low impact: ${percentOfIncome.toStringAsFixed(1)}% of income';
    }
  }
  
  // Predict next month shortfall
  static Future<Map<String, dynamic>> predictNextMonth() async {
    final db = LocalDatabase();
    final transactions = await db.getTransactions();
    final bills = await db.getBills();
    final accounts = await db.getAccounts();
    
    // Get current balance
    final mpesa = accounts.firstWhere((a) => a['id'] == 'mpesa_default');
    final currentBalance = mpesa['balance'] ?? 0.0;
    
    // Calculate average monthly income (last 3 months)
    final now = DateTime.now();
    final threeMonthsAgo = now.subtract(const Duration(days: 90));
    
    final incomeTransactions = transactions.where((t) => 
      t.type == 'income' && t.date.isAfter(threeMonthsAgo)
    ).toList();
    
    final avgMonthlyIncome = incomeTransactions.isEmpty ? 0.0 :
      incomeTransactions.fold<double>(0.0, (sum, t) => sum + t.amount) / 3;
    
    // Calculate average monthly expenses
    final expenseTransactions = transactions.where((t) => 
      t.type == 'expense' && t.date.isAfter(threeMonthsAgo)
    ).toList();
    
    final avgMonthlyExpenses = expenseTransactions.isEmpty ? 0.0 :
      expenseTransactions.fold<double>(0.0, (sum, t) => sum + t.amount) / 3;
    
    // Calculate next month bills
    double nextMonthBills = 0.0;
    for (var bill in bills) {
      final isActive = bill['isActive'];
      if (isActive == 0 || isActive == false) continue;
      
      final frequency = bill['frequency'];
      if (frequency == 'monthly' || frequency == 'one-time') {
        nextMonthBills += bill['amount'] as double;
      }
    }
    
    // Predict end balance
    final projectedIncome = avgMonthlyIncome;
    final projectedExpenses = avgMonthlyExpenses;
    final projectedEndBalance = currentBalance + projectedIncome - projectedExpenses - nextMonthBills;
    
    final hasShortfall = projectedEndBalance < 0;
    final warning = _getShortfallWarning(projectedEndBalance, avgMonthlyIncome);
    
    return {
      'currentBalance': currentBalance,
      'projectedIncome': projectedIncome,
      'projectedExpenses': projectedExpenses,
      'nextMonthBills': nextMonthBills,
      'projectedEndBalance': projectedEndBalance,
      'hasShortfall': hasShortfall,
      'shortfallAmount': hasShortfall ? projectedEndBalance.abs() : 0.0,
      'warning': warning,
    };
  }
  
  static String _getShortfallWarning(double endBalance, double income) {
    if (endBalance < 0) {
      return '🚨 Projected shortfall: KSh ${endBalance.abs().toStringAsFixed(0)}';
    } else if (endBalance < income * 0.1) {
      return '⚠️ Low buffer: Only KSh ${endBalance.toStringAsFixed(0)} remaining';
    } else if (endBalance < income * 0.2) {
      return '⚡ Tight month: KSh ${endBalance.toStringAsFixed(0)} projected';
    } else {
      return '✅ Healthy: KSh ${endBalance.toStringAsFixed(0)} projected';
    }
  }
  
  // Emergency fund status
  static Future<Map<String, dynamic>> getEmergencyFundStatus() async {
    final db = LocalDatabase();
    final transactions = await db.getTransactions();
    final accounts = await db.getAccounts();
    
    // Calculate monthly expenses
    final now = DateTime.now();
    final threeMonthsAgo = now.subtract(const Duration(days: 90));
    
    final expenseTransactions = transactions.where((t) => 
      t.type == 'expense' && t.date.isAfter(threeMonthsAgo)
    ).toList();
    
    final avgMonthlyExpenses = expenseTransactions.isEmpty ? 0.0 :
      expenseTransactions.fold<double>(0.0, (sum, t) => sum + t.amount) / 3;
    
    // Get savings balance
    final ziidiAccount = accounts.where((a) => a['type'] == 'ziidi').toList();
    final savingsBalance = ziidiAccount.isEmpty ? 0.0 :
      ziidiAccount.fold<double>(0.0, (sum, a) => sum + (a['balance'] ?? 0.0));
    
    // Calculate months covered
    final monthsCovered = avgMonthlyExpenses > 0 
      ? savingsBalance / avgMonthlyExpenses 
      : 0.0;
    
    final targetMonths = 6.0;
    final targetAmount = avgMonthlyExpenses * targetMonths;
    final percentComplete = targetAmount > 0 
      ? (savingsBalance / targetAmount * 100) 
      : 0.0;
    
    final status = _getEmergencyFundStatus(monthsCovered);
    
    return {
      'savingsBalance': savingsBalance,
      'avgMonthlyExpenses': avgMonthlyExpenses,
      'monthsCovered': monthsCovered,
      'targetMonths': targetMonths,
      'targetAmount': targetAmount,
      'percentComplete': percentComplete,
      'status': status,
    };
  }
  
  static String _getEmergencyFundStatus(double months) {
    if (months >= 6) {
      return '✅ Excellent: ${months.toStringAsFixed(1)} months covered';
    } else if (months >= 3) {
      return '👍 Good: ${months.toStringAsFixed(1)} months covered';
    } else if (months >= 1) {
      return '⚠️ Building: ${months.toStringAsFixed(1)} months covered';
    } else {
      return '🚨 Critical: Less than 1 month covered';
    }
  }
}
