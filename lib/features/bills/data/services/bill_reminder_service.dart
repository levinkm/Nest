import '../../../transactions/data/datasources/local_database.dart';
import 'dart:developer' as developer;

class BillReminderService {
  static Future<List<Map<String, dynamic>>> getUpcomingReminders() async {
    final db = LocalDatabase();
    final bills = await db.getBills();
    final now = DateTime.now();
    final reminders = <Map<String, dynamic>>[];

    for (var bill in bills) {
      if (bill['status'] == 'paid') continue;

      final dueDate = DateTime.parse(bill['dueDate']);
      final daysUntil = dueDate.difference(now).inDays;

      // Overdue
      if (daysUntil < 0) {
        reminders.add({
          'bill': bill,
          'type': 'overdue',
          'message': '⚠️ ${bill['name']} is ${daysUntil.abs()} days overdue!',
          'priority': 'high',
        });
      }
      // Due today
      else if (daysUntil == 0) {
        reminders.add({
          'bill': bill,
          'type': 'due_today',
          'message': '🔔 ${bill['name']} is due today!',
          'priority': 'high',
        });
      }
      // Due in 1 day
      else if (daysUntil == 1) {
        reminders.add({
          'bill': bill,
          'type': 'due_tomorrow',
          'message': '⏰ ${bill['name']} is due tomorrow',
          'priority': 'medium',
        });
      }
      // Due in 3 days
      else if (daysUntil == 3) {
        reminders.add({
          'bill': bill,
          'type': 'due_soon',
          'message': '📅 ${bill['name']} is due in 3 days',
          'priority': 'low',
        });
      }
    }

    developer.log('Found ${reminders.length} bill reminders');
    return reminders;
  }

  static Future<Map<String, dynamic>> getBalanceAwareReminder(String billId) async {
    final db = LocalDatabase();
    final bills = await db.getBills();
    final bill = bills.firstWhere((b) => b['id'] == billId);
    
    final accounts = await db.getAccounts();
    final mpesaAccount = accounts.firstWhere((a) => a['id'] == 'mpesa_default');
    final balance = mpesaAccount['balance'] ?? 0.0;
    final billAmount = bill['amount'] as double;
    
    if (balance < billAmount) {
      final shortage = billAmount - balance;
      return {
        'hasShortage': true,
        'shortage': shortage,
        'message': 'You are short by KSh ${shortage.toStringAsFixed(0)}',
      };
    }
    
    return {'hasShortage': false};
  }
}
