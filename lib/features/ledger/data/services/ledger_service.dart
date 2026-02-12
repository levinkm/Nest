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
      // Skip if not related to this account
      if (txn.accountId != accountId && txn.toAccountId != accountId) continue;

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

      // Add main transaction entry
      entries.add(LedgerEntry(
        id: uuid.v4(),
        transactionId: txn.id,
        accountId: accountId,
        date: txn.date,
        description: txn.description,
        debit: debit,
        credit: credit,
        balance: runningBalance,
        fee: 0.0,
        category: txn.category,
        reference: txn.transactionId,
      ));

      // Add fee entry if applicable
      if (txn.fee > 0) {
        runningBalance -= txn.fee;
        entries.add(LedgerEntry(
          id: uuid.v4(),
          transactionId: txn.id,
          accountId: accountId,
          date: txn.date,
          description: 'Transaction Fee - ${txn.description}',
          debit: txn.fee,
          credit: 0.0,
          balance: runningBalance,
          fee: txn.fee,
          category: 'Fees',
          reference: txn.transactionId,
        ));
      }
    }

    return entries;
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
