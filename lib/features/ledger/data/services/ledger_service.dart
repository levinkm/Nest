import '../../../transactions/domain/entities/transaction.dart';
import '../../domain/entities/ledger_entry.dart';
import 'package:uuid/uuid.dart';

class LedgerService {
  static List<LedgerEntry> generateLedger(
    List<Transaction> transactions,
    String accountId,
  ) {
    final entries = <LedgerEntry>[];
    double runningBalance = 0.0;
    final uuid = const Uuid();

    // Sort by date
    final sorted = List<Transaction>.from(transactions)
      ..sort((a, b) => a.date.compareTo(b.date));

    for (final txn in sorted) {
      double debit = 0.0;
      double credit = 0.0;

      // Determine debit/credit based on transaction type
      if (txn.type == 'income' || txn.toAccountId == accountId) {
        credit = txn.amount;
        runningBalance += txn.amount;
      } else if (txn.type == 'expense' || txn.accountId == accountId) {
        debit = txn.amount;
        runningBalance -= txn.amount;
      } else if (txn.type == 'debt') {
        // Debt borrowed - money comes in (credit), but it's a liability
        credit = txn.amount;
        runningBalance += txn.amount;
      } else if (txn.type == 'debt_payment') {
        // Debt repayment - money goes out (debit), reduces liability
        debit = txn.amount;
        runningBalance -= txn.amount;
      }

      // Use actual account balance from SMS if available, otherwise use calculated
      final actualBalance = txn.accountBalance ?? runningBalance;

      // Add main transaction entry
      entries.add(
        LedgerEntry(
          id: uuid.v4(),
          transactionId: txn.id,
          accountId: accountId,
          date: txn.date,
          description: _getCleanDescription(txn),
          debit: debit,
          credit: credit,
          balance: actualBalance,
          fee: 0.0,
          category: txn.category,
          reference: txn.transactionId,
        ),
      );

      // Add fee entry if applicable
      if (txn.fee > 0) {
        final balanceAfterFee = txn.accountBalance != null
            ? actualBalance
            : runningBalance - txn.fee;
        entries.add(
          LedgerEntry(
            id: uuid.v4(),
            transactionId: txn.id,
            accountId: accountId,
            date: txn.date,
            description: 'Transaction Fee - ${_getCleanDescription(txn)}',
            debit: txn.fee,
            credit: 0.0,
            balance: balanceAfterFee,
            fee: txn.fee,
            category: 'Fees',
            reference: txn.transactionId,
          ),
        );
        if (txn.accountBalance == null) runningBalance -= txn.fee;
      }
    }

    return entries;
  }

  static String _getCleanDescription(Transaction txn) {
    if (txn.counterparty != null && txn.counterparty!.isNotEmpty) {
      if (txn.type == 'income') {
        return '${txn.counterparty} → M-Pesa';
      } else {
        return 'M-Pesa → ${txn.counterparty}';
      }
    }

    // Fallback: Extract counterparty from description
    final desc = txn.description;

    // Check for ZIIDI first
    if (desc.toLowerCase().contains('ziidi')) {
      if (txn.type == 'income') {
        return 'ZIIDI → M-Pesa';
      } else {
        return 'M-Pesa → ZIIDI';
      }
    }

    // For expenses: "sent to NAME" or "paid to NAME"
    if (txn.type == 'expense') {
      final sentToRegex = RegExp(
        r'sent to ([A-Z][A-Z0-9\s&.-]+?)(?:\s+for|\s+\d{10}|\s+on|\.|\s+New)',
        caseSensitive: false,
      );
      final sentMatch = sentToRegex.firstMatch(desc);
      if (sentMatch != null) {
        return 'M-Pesa → ${sentMatch.group(1)!.trim()}';
      }

      final paidToRegex = RegExp(
        r'paid to ([A-Z][A-Z0-9\s&.-]+?)(?:\s+via|\.|\s+on|\s+New)',
        caseSensitive: false,
      );
      final paidMatch = paidToRegex.firstMatch(desc);
      if (paidMatch != null) {
        return 'M-Pesa → ${paidMatch.group(1)!.trim()}';
      }

      if (desc.toLowerCase().contains('sent') ||
          desc.toLowerCase().contains('paid')) {
        return 'M-Pesa → Expense';
      }
    }

    // For income: "received...from NAME" or "You have received...from NAME"
    if (txn.type == 'income') {
      final receivedRegex = RegExp(
        r'received\s+ksh[\d,.]+\s+from\s+([A-Z][A-Z\s&.]+?)(?:\s+on|\.|\s+new\s+m)',
        caseSensitive: false,
      );
      final receivedMatch = receivedRegex.firstMatch(desc);
      if (receivedMatch != null) {
        return '${receivedMatch.group(1)!.trim()} → M-Pesa';
      }

      if (desc.toLowerCase().contains('received') &&
          desc.toLowerCase().contains('ksh')) {
        return 'Income → M-Pesa';
      }
    }

    return desc.length > 50 ? '${desc.substring(0, 50)}...' : desc;
  }

  static Map<String, dynamic> getLedgerSummary(List<LedgerEntry> entries) {
    double totalDebits = 0.0;
    double totalCredits = 0.0;
    double totalFees = 0.0;

    for (final entry in entries) {
      totalDebits += entry.debit;
      totalCredits += entry.credit;
      totalFees += entry.fee;
    }

    return {
      'totalDebits': totalDebits,
      'totalCredits': totalCredits,
      'totalFees': totalFees,
      'netBalance': totalCredits - totalDebits,
      'entryCount': entries.length,
    };
  }
}
