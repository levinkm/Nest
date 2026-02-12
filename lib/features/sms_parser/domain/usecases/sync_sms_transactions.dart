import '../../../transactions/domain/entities/transaction.dart';
import '../../../transactions/domain/repositories/transaction_repository.dart';
import '../../../transactions/data/datasources/local_database.dart';
import '../../data/datasources/sms_parser_datasource.dart';
import 'package:uuid/uuid.dart';
import 'dart:developer' as developer;

class SyncSmsTransactionsUseCase {
  final SmsParserDataSource smsParser;
  final TransactionRepository transactionRepository;

  SyncSmsTransactionsUseCase(this.smsParser, this.transactionRepository);

  Future<int> execute({int daysBack = 30}) async {
    final hasPermission = await smsParser.requestPermissions();
    if (!hasPermission) throw Exception('SMS permission denied');

    // Get all SMS messages first
    final allMessages = await smsParser.parseAllSms(daysBack: daysBack);
    final db = LocalDatabase();
    
    int addedCount = 0;
    double? latestBalance;
    double? latestFulizaBalance;
    DateTime? latestFulizaDueDate;
    DateTime? latestSmsDate;
    double? latestZiidiBalance;
    DateTime? latestZiidiDate;

    // Process Fuliza messages separately
    await _processFulizaMessages(allMessages, db);

    // Process regular transactions
    final smsTransactions = await smsParser.parseTransactionSms(daysBack: daysBack);
    
    for (var sms in smsTransactions) {
      // Track latest balance info
      if (sms.recordedBalance != null) {
        if (latestSmsDate == null || sms.date.isAfter(latestSmsDate)) {
          latestBalance = sms.recordedBalance;
          latestSmsDate = sms.date;
        }
      }
      if (sms.fulizaBalance != null) {
        if (latestFulizaDueDate == null || sms.date.isAfter(latestSmsDate ?? DateTime(2000))) {
          latestFulizaBalance = sms.fulizaBalance;
          latestFulizaDueDate = sms.fulizaDueDate;
        }
      }
      if (sms.ziidiBalance != null) {
        if (latestZiidiDate == null || sms.date.isAfter(latestZiidiDate)) {
          latestZiidiBalance = sms.ziidiBalance;
          latestZiidiDate = sms.date;
        }
      }

      // Create unique ID from SMS content and timestamp to prevent duplicates
      final transactionId = '${sms.description.hashCode}_${sms.amount}_${sms.date.millisecondsSinceEpoch}';
      
      // Determine account based on transaction type and counterparty
      String accountId;
      String? toAccountId;
      
      if (sms.type == 'expense' && sms.counterparty != null) {
        // Money going out: from M-Pesa to counterparty
        accountId = 'mpesa_default';
        toAccountId = sms.counterparty!;
      } else if (sms.type == 'income' && sms.counterparty != null) {
        // Money coming in: from counterparty to M-Pesa
        accountId = sms.counterparty!;
        toAccountId = 'mpesa_default';
      } else {
        // Default to M-Pesa
        accountId = 'mpesa_default';
      }
      
      final transaction = Transaction(
        id: const Uuid().v4(),
        amount: sms.amount,
        category: sms.category,
        description: sms.description,
        date: sms.date,
        type: sms.type,
        transactionId: transactionId,
        fee: sms.fee,
        accountId: accountId,
        toAccountId: toAccountId,
      );
      await transactionRepository.addTransaction(transaction);
      addedCount++;
    }

    // Update recorded balance if found
    if (latestBalance != null && latestSmsDate != null) {
      await db.updateRecordedBalance('mpesa_default', latestBalance, latestSmsDate);
      // Also update the actual balance
      await db.updateAccountBalance('mpesa_default', latestBalance);
    }

    // Update Fuliza info if found
    if (latestFulizaBalance != null && latestFulizaBalance > 0) {
      developer.log('Updating Fuliza debt: $latestFulizaBalance');
      await db.insertDebt({
        'id': 'fuliza_mpesa',
        'name': 'M-Pesa Fuliza',
        'principal': latestFulizaBalance,
        'creditLimit': 1000.0,
        'interestRate': 0.0,
        'interestType': 'daily',
        'dueDate': latestFulizaDueDate?.toIso8601String(),
        'createdAt': DateTime.now().toIso8601String(),
        'isActive': 1,
      });
    } else if (latestFulizaBalance != null && latestFulizaBalance == 0) {
      // Fuliza fully paid, mark as inactive
      await db.updateDebt('fuliza_mpesa', {'isActive': 0});
    }

    // Update Ziidi balance if found
    if (latestZiidiBalance != null) {
      developer.log('Updating Ziidi balance: $latestZiidiBalance');
      // Ensure Ziidi account exists
      final ziidiAccount = await db.getAccount('ziidi_default');
      if (ziidiAccount == null) {
        await db.insertAccount({
          'id': 'ziidi_default',
          'name': 'Ziidi MMF',
          'type': 'ziidi',
          'balance': latestZiidiBalance,
          'recordedBalance': latestZiidiBalance,
          'creditLimit': 0.0,
          'lastSmsDate': latestZiidiDate?.toIso8601String(),
          'createdAt': DateTime.now().toIso8601String(),
          'updatedAt': DateTime.now().toIso8601String(),
        });
      } else {
        await db.updateAccountBalance('ziidi_default', latestZiidiBalance);
        await db.updateRecordedBalance('ziidi_default', latestZiidiBalance, latestZiidiDate!);
      }
    }

    return addedCount;
  }

  Future<void> _processFulizaMessages(List<Map<String, dynamic>> messages, LocalDatabase db) async {
    double? latestFulizaBalance;
    DateTime? latestFulizaDueDate;
    DateTime? latestDate;
    double totalFulizaFees = 0.0;

    for (var msg in messages) {
      final body = msg['body'] as String? ?? '';
      final timestamp = msg['date'] as int? ?? DateTime.now().millisecondsSinceEpoch;
      final date = DateTime.fromMillisecondsSinceEpoch(timestamp);
      final lowerBody = body.toLowerCase();

      // Extract Fuliza outstanding balance
      if (lowerBody.contains('fuliza m-pesa amount is')) {
        final balanceRegex = RegExp(
          r'total fuliza.*?outstanding.*?ksh\s*([\d,]+\.?\d*)',
          caseSensitive: false,
        );
        final match = balanceRegex.firstMatch(body);
        if (match != null) {
          final balance = double.tryParse(match.group(1)!.replaceAll(',', ''));
          if (balance != null && (latestDate == null || date.isAfter(latestDate))) {
            latestFulizaBalance = balance;
            latestDate = date;
            
            // Extract due date
            final dueDateRegex = RegExp(r'due on (\d{1,2})/(\d{1,2})/(\d{2})');
            final dueDateMatch = dueDateRegex.firstMatch(body);
            if (dueDateMatch != null) {
              final day = int.parse(dueDateMatch.group(1)!);
              final month = int.parse(dueDateMatch.group(2)!);
              final year = 2000 + int.parse(dueDateMatch.group(3)!);
              latestFulizaDueDate = DateTime(year, month, day);
            }
          }
        }
        
        // Extract and track Fuliza access fee
        final feeRegex = RegExp(r'access fee charged\s*ksh\s*([\d,]+\.?\d*)', caseSensitive: false);
        final feeMatch = feeRegex.firstMatch(body);
        if (feeMatch != null) {
          final fee = double.tryParse(feeMatch.group(1)!.replaceAll(',', '')) ?? 0.0;
          totalFulizaFees += fee;
        }
      }

      // Check for full repayment
      if (lowerBody.contains('fully pay your outstanding fuliza')) {
        if (latestDate == null || date.isAfter(latestDate)) {
          latestFulizaBalance = 0.0;
          latestDate = date;
        }
      }
    }

    // Update Fuliza debt in database
    if (latestFulizaBalance != null) {
      if (latestFulizaBalance > 0) {
        developer.log('Inserting/Updating Fuliza debt: $latestFulizaBalance');
        await db.insertDebt({
          'id': 'fuliza_mpesa',
          'name': 'M-Pesa Fuliza',
          'principal': latestFulizaBalance,
          'creditLimit': 1000.0,
          'interestRate': 0.0,
          'interestType': 'daily',
          'dueDate': latestFulizaDueDate?.toIso8601String(),
          'createdAt': DateTime.now().toIso8601String(),
          'isActive': 1,
        });
      } else {
        developer.log('Fuliza fully paid, marking as inactive');
        await db.updateDebt('fuliza_mpesa', {'isActive': 0});
      }
    }
    
    // Create a fee transaction for Fuliza access fees if any
    if (totalFulizaFees > 0) {
      developer.log('Creating fee transaction for Fuliza fees: $totalFulizaFees');
      await db.insertTransaction(
        Transaction(
          id: 'fuliza_fees_${DateTime.now().millisecondsSinceEpoch}',
          amount: totalFulizaFees,
          category: 'Interest & Fees',
          description: 'Fuliza Access Fees',
          date: DateTime.now(),
          type: 'expense',
          fee: totalFulizaFees,
          accountId: 'mpesa_default',
        ),
      );
    }
  }
}
