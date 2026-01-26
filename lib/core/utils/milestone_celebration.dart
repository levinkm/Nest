import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class MilestoneCelebration {
  static Future<void> checkAndCelebrate(BuildContext context, String currency) async {
    final prefs = await SharedPreferences.getInstance();
    final celebratedMilestones = prefs.getStringList('celebrated_milestones') ?? [];
    
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
    int completedGoals = 0;
    for (var g in goals) {
      final current = g['currentAmount'] ?? 0.0;
      final target = g['targetAmount'] ?? 1.0;
      totalGoalsSaved += current;
      if (current >= target) completedGoals++;
    }
    
    final totalSavings = emergencyFund + totalGoalsSaved;
    
    // Check milestones
    final milestones = <Map<String, dynamic>>[];
    
    // First 1000 saved
    if (totalSavings >= 1000 && !celebratedMilestones.contains('first_1000')) {
      milestones.add({
        'id': 'first_1000',
        'title': '🎉 First 1,000 Saved!',
        'message': 'Congratulations! You\'ve saved your first $currency 1,000. This is just the beginning!',
        'icon': Icons.emoji_events,
        'color': Colors.amber,
      });
    }
    
    // Emergency fund 50% complete
    if (emergencyFund >= 5000 && !celebratedMilestones.contains('ef_50')) {
      milestones.add({
        'id': 'ef_50',
        'title': '🛡️ Emergency Fund Milestone!',
        'message': 'You\'re building a strong safety net. Keep going!',
        'icon': Icons.security,
        'color': Colors.orange,
      });
    }
    
    // First goal completed
    if (completedGoals >= 1 && !celebratedMilestones.contains('first_goal')) {
      milestones.add({
        'id': 'first_goal',
        'title': '🎯 First Goal Achieved!',
        'message': 'Amazing! You completed your first savings goal. You\'re unstoppable!',
        'icon': Icons.flag,
        'color': Colors.green,
      });
    }
    
    // 10,000 milestone
    if (totalSavings >= 10000 && !celebratedMilestones.contains('ten_k')) {
      milestones.add({
        'id': 'ten_k',
        'title': '💎 10K Club!',
        'message': 'You\'ve saved $currency 10,000! You\'re in the top tier of savers!',
        'icon': Icons.diamond,
        'color': Colors.purple,
      });
    }
    
    // 6-month streak (simplified check)
    final efCount = efTransactions.length;
    if (efCount >= 6 && !celebratedMilestones.contains('six_month_streak')) {
      milestones.add({
        'id': 'six_month_streak',
        'title': '🔥 Consistency Champion!',
        'message': 'You\'ve been consistently saving. Habits like this build wealth!',
        'icon': Icons.local_fire_department,
        'color': Colors.red,
      });
    }
    
    // Show celebrations
    for (var milestone in milestones) {
      if (context.mounted) {
        await _showCelebration(context, milestone);
        celebratedMilestones.add(milestone['id']);
      }
    }
    
    // Save celebrated milestones
    await prefs.setStringList('celebrated_milestones', celebratedMilestones);
  }
  
  static Future<void> _showCelebration(BuildContext context, Map<String, dynamic> milestone) async {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            gradient: LinearGradient(
              colors: [
                (milestone['color'] as Color).withOpacity(0.1),
                Colors.white,
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: (milestone['color'] as Color).withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  milestone['icon'],
                  size: 64,
                  color: milestone['color'],
                ),
              ),
              const SizedBox(height: 20),
              Text(
                milestone['title'],
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              Text(
                milestone['message'],
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey.shade700,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: milestone['color'],
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: const Text('Awesome!'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
