import '../../../transactions/domain/entities/transaction.dart';
import '../../../transactions/data/datasources/local_database.dart';

class AccountBalanceService {
  static Future<void> updateMpesaBalance(List<Transaction> transactions) async {
    double balance = 0.0;

    // Sort by date
    final sorted = List<Transaction>.from(transactions)
      ..sort((a, b) => a.date.compareTo(b.date));

    for (final txn in sorted) {
      if (txn.accountId != 'mpesa_default') continue;

      if (txn.type == 'income') {
        balance += txn.amount;
      } else if (txn.type == 'expense') {
        balance -= txn.amount;
      } else if (txn.type == 'debt') {
        // Fuliza borrowed - money comes in
        balance += txn.amount;
      } else if (txn.type == 'debt_payment') {
        // Fuliza repayment - money goes out
        balance -= txn.amount;
      }

      // Deduct fees
      balance -= txn.fee;
    }

    // Update database
    final db = LocalDatabase();
    await db.updateAccountBalance('mpesa_default', balance);
  }

  static Future<Map<String, double>> getMpesaBalances() async {
    final db = LocalDatabase();
    final account = await db.getAccount('mpesa_default');

    if (account == null) {
      return {'balance': 0.0, 'creditLimit': 0.0, 'debtBalance': 0.0};
    }

    final balance = account['balance'] ?? 0.0;
    final creditLimit = account['creditLimit'] ?? 0.0;
    final debtBalance = balance < 0 ? balance.abs() : 0.0;

    return {
      'balance': balance,
      'creditLimit': creditLimit,
      'debtBalance': debtBalance,
      'availableCredit': creditLimit - debtBalance,
    };
  }

  static Future<void> updateFulizaLimit(double limit) async {
    final db = LocalDatabase();
    await db.database.then(
      (database) => database.update(
        'accounts',
        {'creditLimit': limit, 'updatedAt': DateTime.now().toIso8601String()},
        where: 'id = ?',
        whereArgs: ['mpesa_default'],
      ),
    );
  }
}
