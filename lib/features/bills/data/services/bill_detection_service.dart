import '../../../transactions/domain/entities/transaction.dart';
import '../../../transactions/data/datasources/local_database.dart';
import 'package:uuid/uuid.dart';
import 'dart:developer' as developer;

class BillDetectionService {
  static const int daysTolerance = 3;
  static const double amountTolerancePercent = 0.05; // 5% tolerance

  static Future<List<Map<String, dynamic>>> detectRecurringBills(
    List<Transaction> transactions,
  ) async {
    final suggestions = <Map<String, dynamic>>[];
    final merchantGroups = <String, List<Transaction>>{};

    for (var t in transactions) {
      if (t.type == 'expense' && t.toAccountId != null) {
        final merchant = t.toAccountId!;
        merchantGroups.putIfAbsent(merchant, () => []).add(t);
      }
    }

    for (var entry in merchantGroups.entries) {
      final merchant = entry.key;
      final txns = entry.value;

      if (txns.length < 2) continue;

      txns.sort((a, b) => a.date.compareTo(b.date));

      final amounts = txns.map((t) => t.amount).toList();
      final avgAmount = amounts.reduce((a, b) => a + b) / amounts.length;
      final isConsistentAmount = amounts.every((a) => (a - avgAmount).abs() < avgAmount * 0.1);

      final intervals = <int>[];
      for (int i = 1; i < txns.length; i++) {
        intervals.add(txns[i].date.difference(txns[i - 1].date).inDays);
      }

      if (intervals.isEmpty) continue;

      final avgInterval = intervals.reduce((a, b) => a + b) / intervals.length;
      final isMonthly = avgInterval >= 25 && avgInterval <= 35;
      final isWeekly = avgInterval >= 6 && avgInterval <= 8;

      if ((isMonthly || isWeekly) && isConsistentAmount) {
        suggestions.add({
          'merchant': merchant,
          'amount': avgAmount,
          'frequency': isMonthly ? 'monthly' : 'weekly',
          'category': txns.first.category,
          'transactionCount': txns.length,
          'lastDate': txns.last.date,
        });
      }
    }

    return suggestions;
  }

  static Future<void> autoMatchBillPayments() async {
    final db = LocalDatabase();
    final bills = await db.getBills();
    final transactions = await db.getTransactions();

    for (var billData in bills) {
      if (billData['status'] == 'paid') continue;

      final dueDate = DateTime.parse(billData['dueDate']);
      final billAmount = billData['amount'] as double;
      final merchant = billData['merchant'];
      final billId = billData['id'];

      final matches = _findMatchingTransactions(
        transactions,
        dueDate,
        billAmount,
        merchant,
      );

      if (matches.isEmpty) continue;

      // Handle different payment scenarios
      final totalPaid = matches.fold<double>(0.0, (sum, t) => sum + t.amount);
      
      if (_isFullPayment(totalPaid, billAmount)) {
        // Full payment (single or multiple transactions)
        await db.markBillAsPaid(billId, matches.first.id, matches.first.date);
        developer.log('✓ Full payment matched: ${billData['name']}');
      } else if (_isPartialPayment(totalPaid, billAmount)) {
        // Partial payment - create note
        await db.updateBill(billId, {
          'status': 'partial',
          'paidTransactionId': matches.map((t) => t.id).join(','),
        });
        developer.log('⚠ Partial payment: ${billData['name']} (${totalPaid}/${billAmount})');
      }
    }
  }

  static List<Transaction> _findMatchingTransactions(
    List<Transaction> transactions,
    DateTime dueDate,
    double billAmount,
    String? merchant,
  ) {
    final matches = <Transaction>[];
    
    for (var txn in transactions) {
      if (txn.type != 'expense') continue;

      final daysDiff = txn.date.difference(dueDate).inDays.abs();
      final amountDiff = (txn.amount - billAmount).abs();
      final amountTolerance = billAmount * amountTolerancePercent;
      
      final isWithinDateWindow = daysDiff <= daysTolerance;
      final isAmountMatch = amountDiff <= amountTolerance;
      final isMerchantMatch = merchant == null || 
                              _fuzzyMerchantMatch(txn.toAccountId, merchant);

      if (isWithinDateWindow && isAmountMatch && isMerchantMatch) {
        matches.add(txn);
      }
    }

    return matches;
  }

  static bool _fuzzyMerchantMatch(String? txnMerchant, String billMerchant) {
    if (txnMerchant == null) return false;
    
    final txnLower = txnMerchant.toLowerCase();
    final billLower = billMerchant.toLowerCase();
    
    // Exact match
    if (txnLower == billLower) return true;
    
    // Contains match
    if (txnLower.contains(billLower) || billLower.contains(txnLower)) return true;
    
    // Remove common words and check
    final commonWords = ['ltd', 'limited', 'co', 'company', 'inc'];
    var txnClean = txnLower;
    var billClean = billLower;
    
    for (var word in commonWords) {
      txnClean = txnClean.replaceAll(word, '').trim();
      billClean = billClean.replaceAll(word, '').trim();
    }
    
    return txnClean == billClean;
  }

  static bool _isFullPayment(double paid, double billAmount) {
    final diff = (paid - billAmount).abs();
    return diff <= billAmount * amountTolerancePercent;
  }

  static bool _isPartialPayment(double paid, double billAmount) {
    return paid > 0 && paid < billAmount * 0.95; // Less than 95% is partial
  }

  static Future<Map<String, dynamic>> getBillForecast() async {
    final db = LocalDatabase();
    final bills = await db.getBills();
    final now = DateTime.now();
    final endOfMonth = DateTime(now.year, now.month + 1, 0);

    double totalUpcoming = 0.0;
    double totalOverdue = 0.0;
    int upcomingCount = 0;
    int overdueCount = 0;

    for (var bill in bills) {
      if (bill['status'] == 'paid') continue;

      final dueDate = DateTime.parse(bill['dueDate']);
      final amount = bill['amount'] as double;

      if (dueDate.isBefore(now)) {
        totalOverdue += amount;
        overdueCount++;
      } else if (dueDate.isBefore(endOfMonth)) {
        totalUpcoming += amount;
        upcomingCount++;
      }
    }

    return {
      'totalUpcoming': totalUpcoming,
      'totalOverdue': totalOverdue,
      'upcomingCount': upcomingCount,
      'overdueCount': overdueCount,
      'totalThisMonth': totalUpcoming + totalOverdue,
    };
  }
}
