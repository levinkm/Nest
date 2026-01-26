import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../../features/transactions/domain/entities/transaction.dart';

class SavingsAnalytics {
  static Future<SavingsMetrics> calculate(List<Transaction> transactions) async {
    final prefs = await SharedPreferences.getInstance();
    
    // Get savings data
    final efData = prefs.getString('emergency_fund_transactions') ?? '[]';
    final efTransactions = List<Map<String, dynamic>>.from(jsonDecode(efData));
    double emergencyFund = 0.0;
    for (var t in efTransactions) {
      emergencyFund += t['amount'] as double;
    }
    
    final goalsData = prefs.getString('savings_goals') ?? '[]';
    final goals = List<Map<String, dynamic>>.from(jsonDecode(goalsData));
    double totalGoalsSaved = 0.0;
    for (var g in goals) {
      totalGoalsSaved += (g['currentAmount'] ?? 0.0) as double;
    }
    
    // Calculate income and expenses
    final now = DateTime.now();
    final thirtyDaysAgo = now.subtract(const Duration(days: 30));
    
    double monthlyIncome = 0.0;
    double monthlyExpense = 0.0;
    
    for (var t in transactions) {
      if (t.date.isAfter(thirtyDaysAgo)) {
        if (t.type.toLowerCase().contains('income') || t.type.toLowerCase().contains('received')) {
          monthlyIncome += t.amount;
        } else {
          monthlyExpense += t.amount;
        }
      }
    }
    
    final totalSavings = emergencyFund + totalGoalsSaved;
    final savingsRate = monthlyIncome > 0 ? (totalSavings / monthlyIncome) * 100 : 0.0;
    final monthlySavings = monthlyIncome - monthlyExpense;
    
    // Calculate health score
    final healthScore = _calculateHealthScore(
      emergencyFund,
      monthlyExpense * 3,
      savingsRate,
      goals,
      monthlySavings > 0,
    );
    
    // Goal analytics
    final goalAnalytics = _analyzeGoals(goals);
    
    // Smart suggestions
    final suggestions = _generateSuggestions(
      monthlyIncome,
      monthlyExpense,
      emergencyFund,
      monthlyExpense * 3,
      savingsRate,
      goals,
    );
    
    return SavingsMetrics(
      totalSavings: totalSavings,
      emergencyFund: emergencyFund,
      goalsSaved: totalGoalsSaved,
      savingsRate: savingsRate,
      monthlySavings: monthlySavings,
      healthScore: healthScore,
      goalAnalytics: goalAnalytics,
      suggestions: suggestions,
    );
  }
  
  static int _calculateHealthScore(
    double emergencyFund,
    double emergencyTarget,
    double savingsRate,
    List<Map<String, dynamic>> goals,
    bool isPositiveSavings,
  ) {
    int score = 0;
    
    // Emergency fund (30 points)
    final efProgress = (emergencyFund / emergencyTarget).clamp(0.0, 1.0);
    score += (efProgress * 30).round();
    
    // Savings rate (25 points)
    if (savingsRate >= 20) {
      score += 25;
    } else if (savingsRate >= 15) {
      score += 20;
    } else if (savingsRate >= 10) {
      score += 15;
    } else if (savingsRate >= 5) {
      score += 10;
    }
    
    // Goal progress (20 points)
    if (goals.isNotEmpty) {
      int onTrackGoals = 0;
      for (var goal in goals) {
        final current = goal['currentAmount'] ?? 0.0;
        final target = goal['targetAmount'] ?? 1.0;
        if (current / target >= 0.5) onTrackGoals++;
      }
      score += ((onTrackGoals / goals.length) * 20).round();
    }
    
    // Consistency (15 points)
    if (isPositiveSavings) score += 15;
    
    // Diversification (10 points)
    if (emergencyFund > 0) score += 5;
    if (goals.isNotEmpty) score += 5;
    
    return score.clamp(0, 100);
  }
  
  static List<GoalAnalytic> _analyzeGoals(List<Map<String, dynamic>> goals) {
    final analytics = <GoalAnalytic>[];
    
    for (var goal in goals) {
      final current = goal['currentAmount'] ?? 0.0;
      final target = goal['targetAmount'] ?? 1.0;
      final targetDate = DateTime.parse(goal['targetDate']);
      final daysLeft = targetDate.difference(DateTime.now()).inDays;
      final progress = (current / target).clamp(0.0, 1.0);
      
      final remaining = target - current;
      final requiredMonthly = daysLeft > 0 ? remaining / (daysLeft / 30) : 0.0;
      
      final isRecurring = goal['isRecurring'] ?? false;
      final recurringAmount = goal['recurringAmount'] ?? 0.0;
      
      String status;
      if (progress >= 1.0) {
        status = 'completed';
      } else if (daysLeft < 0) {
        status = 'overdue';
      } else if (isRecurring && recurringAmount >= requiredMonthly) {
        status = 'on_track';
      } else if (progress >= 0.7) {
        status = 'on_track';
      } else if (progress >= 0.3) {
        status = 'at_risk';
      } else {
        status = 'behind';
      }
      
      DateTime? projectedCompletion;
      if (isRecurring && recurringAmount > 0) {
        final monthsToComplete = remaining / recurringAmount;
        projectedCompletion = DateTime.now().add(Duration(days: (monthsToComplete * 30).round()));
      }
      
      analytics.add(GoalAnalytic(
        id: goal['id'],
        name: goal['name'],
        progress: progress,
        status: status,
        daysLeft: daysLeft,
        requiredMonthly: requiredMonthly,
        projectedCompletion: projectedCompletion,
      ));
    }
    
    // Sort by priority (overdue > at_risk > behind > on_track > completed)
    analytics.sort((a, b) {
      final priorityMap = {'overdue': 0, 'at_risk': 1, 'behind': 2, 'on_track': 3, 'completed': 4};
      return (priorityMap[a.status] ?? 5).compareTo(priorityMap[b.status] ?? 5);
    });
    
    return analytics;
  }
  
  static List<String> _generateSuggestions(
    double income,
    double expense,
    double emergencyFund,
    double emergencyTarget,
    double savingsRate,
    List<Map<String, dynamic>> goals,
  ) {
    final suggestions = <String>[];
    
    // Emergency fund suggestions
    if (emergencyFund < emergencyTarget * 0.5) {
      suggestions.add('🚨 Priority: Build emergency fund to at least 50% (${((emergencyTarget * 0.5 - emergencyFund)).toStringAsFixed(0)} more needed)');
    }
    
    // Savings rate suggestions
    if (savingsRate < 10) {
      suggestions.add('📈 Increase savings rate to at least 10% (currently ${savingsRate.toStringAsFixed(1)}%)');
    } else if (savingsRate < 20) {
      suggestions.add('💪 Good progress! Aim for 20% savings rate (currently ${savingsRate.toStringAsFixed(1)}%)');
    } else {
      suggestions.add('🌟 Excellent! Your ${savingsRate.toStringAsFixed(1)}% savings rate exceeds the 20% goal');
    }
    
    // Income-based suggestions
    final potentialSavings = income - expense;
    if (potentialSavings > 0) {
      suggestions.add('💰 You can save ${potentialSavings.toStringAsFixed(0)} more this month');
    }
    
    // Goal-specific suggestions
    for (var goal in goals) {
      final current = goal['currentAmount'] ?? 0.0;
      final target = goal['targetAmount'] ?? 1.0;
      final daysLeft = DateTime.parse(goal['targetDate']).difference(DateTime.now()).inDays;
      
      if (daysLeft > 0 && daysLeft < 30 && current < target) {
        final remaining = target - current;
        suggestions.add('⏰ Goal "${goal['name']}" due in $daysLeft days. Need ${remaining.toStringAsFixed(0)} more');
      }
    }
    
    // Automation suggestions
    final hasRecurring = goals.any((g) => g['isRecurring'] == true);
    if (!hasRecurring && goals.isNotEmpty) {
      suggestions.add('🤖 Enable recurring savings on your goals for automatic progress');
    }
    
    return suggestions.take(5).toList();
  }
}

class SavingsMetrics {
  final double totalSavings;
  final double emergencyFund;
  final double goalsSaved;
  final double savingsRate;
  final double monthlySavings;
  final int healthScore;
  final List<GoalAnalytic> goalAnalytics;
  final List<String> suggestions;
  
  SavingsMetrics({
    required this.totalSavings,
    required this.emergencyFund,
    required this.goalsSaved,
    required this.savingsRate,
    required this.monthlySavings,
    required this.healthScore,
    required this.goalAnalytics,
    required this.suggestions,
  });
}

class GoalAnalytic {
  final String id;
  final String name;
  final double progress;
  final String status;
  final int daysLeft;
  final double requiredMonthly;
  final DateTime? projectedCompletion;
  
  GoalAnalytic({
    required this.id,
    required this.name,
    required this.progress,
    required this.status,
    required this.daysLeft,
    required this.requiredMonthly,
    this.projectedCompletion,
  });
}
