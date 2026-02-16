import 'package:nest/features/transactions/domain/entities/transaction.dart'
    as domain;
import 'package:uuid/uuid.dart';
import '../data/models/categorization_models.dart';
import '../data/datasources/local_database.dart';

class RecurringIncomeService {
  // Check and create due recurring income transactions
  Future<void> processRecurringIncomes() async {
    final db = LocalDatabase();
    final incomes = await db.getRecurringIncomes(activeOnly: true);
    final now = DateTime.now();

    for (final incomeData in incomes) {
      final income = RecurringIncome.fromJson(incomeData);

      // Skip if merchant name is set (SMS-based)
      if (income.merchantName != null && income.merchantName!.isNotEmpty)
        continue;

      // Check if income is due
      final nextExpected =
          income.nextExpected ?? income.calculateNextExpected();

      if (_isDue(now, nextExpected, income.frequency)) {
        await _createIncomeTransaction(income);

        // Update next expected date
        await db.updateRecurringIncome(income.id, {
          'lastReceived': now.toIso8601String(),
          'nextExpected': income.calculateNextExpected().toIso8601String(),
        });
      }
    }
  }

  bool _isDue(DateTime now, DateTime expected, String frequency) {
    if (frequency == 'daily') {
      return now.day != expected.day || now.isAfter(expected);
    } else if (frequency == 'weekly') {
      return now.isAfter(expected) || now.day == expected.day;
    } else if (frequency == 'monthly') {
      return now.day == expected.day && now.month == expected.month;
    }
    return now.isAfter(expected);
  }

  Future<void> _createIncomeTransaction(RecurringIncome income) async {
    final db = LocalDatabase();

    // Check if already created today
    final transactions = await db.getTransactions();
    final today = DateTime.now();
    final alreadyExists = transactions.any(
      (t) =>
          t.date.year == today.year &&
          t.date.month == today.month &&
          t.date.day == today.day &&
          t.description.contains(income.name),
    );

    if (alreadyExists) return;

    final transaction = domain.Transaction(
      id: const Uuid().v4(),
      amount: income.amount,
      category: income.source == 'salary' ? 'Salary' : 'Income',
      description: income.name,
      date: DateTime.now(),
      type: 'income',
      transactionId:
          'recurring_${income.id}_${DateTime.now().millisecondsSinceEpoch}',
    );

    await db.insertTransaction(transaction);
  }

  // Call this on app startup
  static Future<void> initialize() async {
    final service = RecurringIncomeService();
    await service.processRecurringIncomes();
  }
}
