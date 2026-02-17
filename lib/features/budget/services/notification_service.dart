import 'package:flutter/foundation.dart';
import '../data/models/budget_model.dart';

class NotificationService {
  static Future<void> checkBudgetAlerts(Budget budget) async {
    final progress = budget.percentage / 100;

    if (progress >= 1.0) {
      if (kDebugMode) {
        print('Alert: Budget exceeded for ${budget.category}');
      }
    } else if (progress >= 0.8) {
      if (kDebugMode) {
        print(
          'Warning: ${(progress * 100).toStringAsFixed(0)}% used for ${budget.category}',
        );
      }
    }
  }
}
