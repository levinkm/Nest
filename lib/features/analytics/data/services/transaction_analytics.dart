import '../../../transactions/domain/entities/transaction.dart';

class TransactionAnalytics {
  // Top merchants by frequency and amount
  static Map<String, dynamic> getTopMerchants(
    List<Transaction> transactions, {
    int limit = 5,
  }) {
    final merchantData = <String, Map<String, dynamic>>{};

    for (var txn in transactions.where((t) => t.type == 'expense')) {
      final merchant = _extractMerchant(txn.description);
      if (merchant.isEmpty) continue;

      if (!merchantData.containsKey(merchant)) {
        merchantData[merchant] = {'count': 0, 'total': 0.0};
      }
      merchantData[merchant]!['count'] =
          (merchantData[merchant]!['count'] as int) + 1;
      merchantData[merchant]!['total'] =
          (merchantData[merchant]!['total'] as double) + txn.amount;
    }

    final sorted = merchantData.entries.toList()
      ..sort(
        (a, b) => (b.value['count'] as int).compareTo(a.value['count'] as int),
      );

    return {
      'merchants': sorted
          .take(limit)
          .map(
            (e) => {
              'name': e.key,
              'count': e.value['count'],
              'total': e.value['total'],
            },
          )
          .toList(),
    };
  }

  // Detect recurring payments
  static List<Map<String, dynamic>> detectRecurringPayments(
    List<Transaction> transactions,
  ) {
    final merchantTransactions = <String, List<Transaction>>{};

    for (var txn in transactions.where((t) => t.type == 'expense')) {
      final merchant = _extractMerchant(txn.description);
      if (merchant.isEmpty) continue;

      merchantTransactions.putIfAbsent(merchant, () => []).add(txn);
    }

    final recurring = <Map<String, dynamic>>[];

    for (var entry in merchantTransactions.entries) {
      if (entry.value.length < 2) continue;

      final sorted = entry.value..sort((a, b) => a.date.compareTo(b.date));
      final intervals = <int>[];

      for (var i = 1; i < sorted.length; i++) {
        intervals.add(sorted[i].date.difference(sorted[i - 1].date).inDays);
      }

      if (intervals.isEmpty) continue;

      final avgInterval = intervals.reduce((a, b) => a + b) / intervals.length;
      final avgAmount =
          sorted.map((t) => t.amount).reduce((a, b) => a + b) / sorted.length;

      // Consider recurring if interval is consistent (25-35 days for monthly)
      if (avgInterval >= 25 && avgInterval <= 35) {
        recurring.add({
          'merchant': entry.key,
          'frequency': 'Monthly',
          'avgAmount': avgAmount,
          'lastPayment': sorted.last.date,
          'nextExpected': sorted.last.date.add(
            Duration(days: avgInterval.round()),
          ),
          'count': sorted.length,
        });
      }
    }

    return recurring;
  }

  // Payment method breakdown
  static Map<String, dynamic> getPaymentMethodBreakdown(
    List<Transaction> transactions,
  ) {
    final methods = <String, Map<String, dynamic>>{
      'Till': {'count': 0, 'total': 0.0},
      'Paybill': {'count': 0, 'total': 0.0},
      'P2P': {'count': 0, 'total': 0.0},
      'Other': {'count': 0, 'total': 0.0},
    };

    for (var txn in transactions.where((t) => t.type == 'expense')) {
      final method = _detectPaymentMethod(txn.description);
      methods[method]!['count'] = (methods[method]!['count'] as int) + 1;
      methods[method]!['total'] =
          (methods[method]!['total'] as double) + txn.amount;
    }

    return methods;
  }

  // Time-based spending patterns
  static Map<String, dynamic> getSpendingPatterns(
    List<Transaction> transactions,
  ) {
    final hourly = List.filled(24, 0.0);
    final daily = List.filled(7, 0.0);

    for (var txn in transactions.where((t) => t.type == 'expense')) {
      hourly[txn.date.hour] += txn.amount;
      daily[txn.date.weekday - 1] += txn.amount;
    }

    return {
      'hourly': hourly,
      'daily': daily,
      'peakHour': hourly.indexOf(hourly.reduce((a, b) => a > b ? a : b)),
      'peakDay': daily.indexOf(daily.reduce((a, b) => a > b ? a : b)),
    };
  }

  // Failed transactions
  static List<Transaction> getFailedTransactions(
    List<Transaction> transactions,
  ) {
    return transactions
        .where(
          (t) =>
              t.description.toLowerCase().contains('failed') ||
              t.description.toLowerCase().contains('unsuccessful') ||
              t.description.toLowerCase().contains('declined'),
        )
        .toList();
  }

  // International transactions
  static List<Transaction> getInternationalTransactions(
    List<Transaction> transactions,
  ) {
    return transactions
        .where(
          (t) =>
              t.description.contains('USD') ||
              t.description.contains('EUR') ||
              t.description.contains('GBP') ||
              t.description.toLowerCase().contains('international'),
        )
        .toList();
  }

  // P2P lending tracker (money sent to people)
  static Map<String, dynamic> getP2PLending(List<Transaction> transactions) {
    final lending = <String, Map<String, dynamic>>{};

    for (var txn in transactions) {
      if (txn.type == 'expense' && _isP2PTransaction(txn.description)) {
        final person = _extractRecipient(txn.description);
        if (person.isEmpty) continue;

        lending.putIfAbsent(
          person,
          () => {'total': 0.0, 'count': 0, 'lastDate': txn.date},
        );
        lending[person]!['total'] =
            (lending[person]!['total'] as double) + txn.amount;
        lending[person]!['count'] = (lending[person]!['count'] as int) + 1;
        if (txn.date.isAfter(lending[person]!['lastDate'] as DateTime)) {
          lending[person]!['lastDate'] = txn.date;
        }
      }
    }

    return {'lending': lending};
  }

  // Daily transaction limit tracking
  static Map<String, dynamic> getDailyLimitUsage(
    List<Transaction> transactions,
  ) {
    final today = DateTime.now();
    final todayTransactions = transactions.where(
      (t) =>
          t.date.year == today.year &&
          t.date.month == today.month &&
          t.date.day == today.day &&
          t.type == 'expense',
    );

    final totalToday = todayTransactions.fold<double>(
      0.0,
      (sum, t) => sum + t.amount,
    );
    const dailyLimit = 500000.0; // KES 500,000 default M-Pesa limit

    return {
      'used': totalToday,
      'limit': dailyLimit,
      'remaining': dailyLimit - totalToday,
      'percentage': (totalToday / dailyLimit) * 100,
      'transactionCount': todayTransactions.length,
    };
  }

  // Helper methods
  static String _extractMerchant(String description) {
    // Extract merchant from "paid to MERCHANT" or "sent to MERCHANT for account"
    final patterns = [
      RegExp(r'paid to ([A-Z\s&]+?)(?:\.|via|on|\s+\d)', caseSensitive: false),
      RegExp(r'sent to ([A-Z\s]+?) for account', caseSensitive: false),
      RegExp(r'to ([A-Z\s]+?) on', caseSensitive: false),
    ];

    for (var pattern in patterns) {
      final match = pattern.firstMatch(description);
      if (match != null) return match.group(1)!.trim();
    }

    return '';
  }

  static String _detectPaymentMethod(String description) {
    final lower = description.toLowerCase();
    if (lower.contains('till') || lower.contains('kopo kopo')) return 'Till';
    if (lower.contains('paybill') || lower.contains('for account')) {
      return 'Paybill';
    }
    if (lower.contains('sent to') && !lower.contains('for account')) {
      return 'P2P';
    }
    return 'Other';
  }

  static bool _isP2PTransaction(String description) {
    return description.toLowerCase().contains('sent to') &&
        !description.toLowerCase().contains('for account');
  }

  static String _extractRecipient(String description) {
    final pattern = RegExp(r'sent to ([A-Z\s]+?)\s+\d', caseSensitive: false);
    final match = pattern.firstMatch(description);
    return match?.group(1)?.trim() ?? '';
  }
}
