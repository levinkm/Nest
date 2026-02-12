import '../../../transactions/data/datasources/local_database.dart';

class AccountAggregationService {
  static Future<Map<String, dynamic>> getAggregatedBalances() async {
    final db = LocalDatabase();
    final accounts = await db.getAccounts();
    
    double totalCash = 0.0;
    double totalDebt = 0.0;
    double totalInvestments = 0.0;
    
    final accountBalances = <Map<String, dynamic>>[];
    
    for (var account in accounts) {
      final balance = account['balance'] ?? 0.0;
      final type = account['type'] ?? '';
      final name = account['name'] ?? '';
      
      if (type == 'ziidi' || name.toLowerCase().contains('ziidi')) {
        totalInvestments += balance;
      } else {
        if (balance > 0) {
          totalCash += balance;
        } else {
          totalDebt += balance.abs();
        }
      }
      
      accountBalances.add({
        'id': account['id'],
        'name': name,
        'type': type,
        'balance': balance,
        'recordedBalance': account['recordedBalance'] ?? 0.0,
      });
    }
    
    return {
      'totalCash': totalCash,
      'totalDebt': totalDebt,
      'totalInvestments': totalInvestments,
      'netWorth': totalCash + totalInvestments - totalDebt,
      'accounts': accountBalances,
    };
  }

  static Future<void> createZiidiAccount() async {
    final db = LocalDatabase();
    await db.insertAccount({
      'id': 'ziidi_default',
      'name': 'Ziidi MMF',
      'type': 'ziidi',
      'balance': 0.0,
      'recordedBalance': 0.0,
      'creditLimit': 0.0,
      'lastSmsDate': null,
      'createdAt': DateTime.now().toIso8601String(),
      'updatedAt': DateTime.now().toIso8601String(),
    });
  }
}
