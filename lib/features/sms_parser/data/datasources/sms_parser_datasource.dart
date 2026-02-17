import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';
import '../models/sms_transaction.dart';
import 'dart:developer' as developer;
import 'transaction_classifier.dart';

class SmsParserDataSource {
  static const platform = MethodChannel('com.nest.finance/sms');
  final TransactionClassifier _classifier = TransactionClassifier();
  bool _classifierInitialized = false;

  Future<void> initialize() async {
    await _classifier.initialize();
    _classifierInitialized = true;
  }

  Future<bool> requestPermissions() async {
    developer.log('Requesting SMS permissions');
    final status = await Permission.sms.request();
    developer.log('SMS permission status: ${status.isGranted}');
    return status.isGranted;
  }

  Future<List<SmsTransaction>> parseTransactionSms({int daysBack = 30}) async {
    try {
      developer.log('Calling native SMS reader for last $daysBack days');
      final List<dynamic> messages = await platform.invokeMethod(
        'getInboxSms',
        {'daysBack': daysBack},
      );
      developer.log('Received ${messages.length} messages from native');

      List<SmsTransaction> transactions = [];

      for (var msg in messages) {
        final body = msg['body'] as String? ?? '';
        final timestamp =
            msg['date'] as int? ?? DateTime.now().millisecondsSinceEpoch;
        final date = DateTime.fromMillisecondsSinceEpoch(timestamp);

        final parsed = await parseMessage(body, date);
        if (parsed != null) {
          transactions.add(parsed);
          developer.log(
            'Parsed transaction: ${parsed.amount} - ${parsed.category}',
          );
        }
      }

      developer.log('Total transactions parsed: ${transactions.length}');
      return transactions;
    } catch (e) {
      developer.log('Error parsing SMS: $e', error: e);
      return [];
    }
  }

  Future<List<Map<String, dynamic>>> parseAllSms({int daysBack = 30}) async {
    try {
      final List<dynamic> messages = await platform.invokeMethod(
        'getInboxSms',
        {'daysBack': daysBack},
      );
      return messages.map((msg) => Map<String, dynamic>.from(msg)).toList();
    } catch (e) {
      developer.log('Error getting all SMS: $e', error: e);
      return [];
    }
  }

  Future<SmsTransaction?> parseMessage(String body, DateTime date) async {
    if (_isFailedTransaction(body)) {
      developer.log('Skipping failed transaction');
      return null;
    }

    if (_isNotificationOnly(body)) {
      developer.log('Skipping notification/reminder message');
      return null;
    }

    // Skip standalone Fuliza Access Fees (no transaction code)
    if (body.toLowerCase().contains('fuliza access fees') &&
        !RegExp(r'\b[A-Z0-9]{10}\b').hasMatch(body)) {
      developer.log('Skipping standalone Fuliza Access Fees notification');
      return null;
    }

    // Extract balance and Fuliza info
    final balanceInfo = _extractBalanceInfo(body);

    final amountRegex = RegExp(
      r'(?:Ksh\.?|KES|Rs\.?|INR|₹)\s*(\d+(?:,\d+)*(?:\.\d{2})?)',
    );
    final match = amountRegex.firstMatch(body);

    if (match == null) return null;

    final amount = double.tryParse(match.group(1)!.replaceAll(',', ''));
    if (amount == null) return null;

    // Extract transaction fee
    final fee = _extractTransactionFee(body);

    // Use ML classifier if available, otherwise fallback to rules
    String? type;
    String category;

    if (_classifierInitialized) {
      final classification = await _classifier.classify(body);
      type = classification['type'];
      category = classification['category'] ?? 'Other';

      if (type == 'skip') {
        developer.log('ML classifier marked as skip');
        return null;
      }
    } else {
      type = _determineTransactionType(body);
      if (type == null) return null;

      final isTransfer = _isInternalTransfer(body);
      category = isTransfer ? 'Transfer' : _categorizeTransaction(body);
    }

    final transactionId = _extractTransactionId(body);
    final isTransfer = category == 'Transfer';
    final counterparty = _extractCounterparty(body, type ?? 'expense');

    return SmsTransaction(
      amount: amount,
      category: category,
      description: body.substring(0, body.length > 100 ? 100 : body.length),
      date: date,
      type: type ?? 'expense',
      transactionId: transactionId,
      isTransfer: isTransfer,
      fee: fee,
      recordedBalance: balanceInfo['balance'],
      fulizaBalance: balanceInfo['fulizaBalance'],
      fulizaDueDate: balanceInfo['dueDate'],
      ziidiBalance: balanceInfo['ziidiBalance'],
      counterparty: counterparty,
    );
  }

  String? _extractTransactionId(String body) {
    // M-Pesa transaction code pattern
    final mpesaRegex = RegExp(r'\b([A-Z0-9]{10})\b');
    final match = mpesaRegex.firstMatch(body);
    return match?.group(1);
  }

  String? _extractCounterparty(String body, String type) {
    final lowerBody = body.toLowerCase();

    // Ziidi transactions
    if (lowerBody.contains('ziidi')) {
      return 'ZIIDI';
    }

    // For expenses (sent to/paid to)
    if (type == 'expense') {
      // "sent to PERSON NAME" or "sent to COMPANY for account"
      final sentToRegex = RegExp(
        r'sent to ([A-Z][A-Z\s&.]+?)(?:\s+for account|\s+\d{10}|\s+on)',
        caseSensitive: false,
      );
      final sentMatch = sentToRegex.firstMatch(body);
      if (sentMatch != null) {
        return sentMatch.group(1)!.trim();
      }

      // "paid to MERCHANT"
      final paidToRegex = RegExp(
        r'paid to ([A-Z][A-Z\s&.]+?)(?:\s+via|\.|\s+on)',
        caseSensitive: false,
      );
      final paidMatch = paidToRegex.firstMatch(body);
      if (paidMatch != null) {
        return paidMatch.group(1)!.trim();
      }
    }

    // For income (received from)
    if (type == 'income') {
      // "received from PERSON NAME"
      final receivedRegex = RegExp(
        r'(?:received from|from) ([A-Z][A-Z\s&.]+?)(?:\s+\d{10}|\s+on)',
        caseSensitive: false,
      );
      final receivedMatch = receivedRegex.firstMatch(body);
      if (receivedMatch != null) {
        return receivedMatch.group(1)!.trim();
      }
    }

    return null;
  }

  bool _isFailedTransaction(String body) {
    final failureKeywords = [
      'failed',
      'unsuccessful',
      'declined',
      'rejected',
      'insufficient',
      'error',
      'could not',
      'unable to',
    ];
    return failureKeywords.any((kw) => body.toLowerCase().contains(kw));
  }

  bool _isNotificationOnly(String body) {
    final lowerBody = body.toLowerCase();

    // Standalone Fuliza Access Fees messages (no transaction code)
    if (lowerBody.contains('fuliza access fees') &&
        !lowerBody.contains('confirmed')) {
      return true;
    }

    // Loan reminders/notifications (not actual transactions)
    if ((lowerBody.contains('due on') || lowerBody.contains('is due')) &&
        !lowerBody.contains('confirmed') &&
        !lowerBody.contains('fuliza m-pesa amount') &&
        !lowerBody.contains('fuliza access fees')) {
      return true;
    }

    // OTP/verification codes
    if (lowerBody.contains('verification code') ||
        lowerBody.contains('otp') ||
        lowerBody.contains('do not share')) {
      return true;
    }

    // Marketing/promotional messages
    if (lowerBody.contains('congratulations') ||
        lowerBody.contains('you qualify') ||
        lowerBody.contains('apply now')) {
      return true;
    }

    return false;
  }

  String? _determineTransactionType(String body) {
    final lowerBody = body.toLowerCase();

    // Fuliza repayment - skip (handled separately in debt manager)
    if (lowerBody.contains('fuliza') &&
        (lowerBody.contains('used to') &&
            (lowerBody.contains('pay') || lowerBody.contains('repay')))) {
      return null; // Skip - will be handled by debt manager
    }

    // Fuliza borrowed - skip (handled separately in debt manager)
    if (lowerBody.contains('fuliza m-pesa amount is')) {
      return null; // Skip - will be handled by debt manager
    }

    // Ziidi/investment withdrawals - income (money coming to M-Pesa)
    if (lowerBody.contains('withdrawn') &&
        (lowerBody.contains('ziidi') ||
            lowerBody.contains('transaction code'))) {
      return 'income';
    }

    // Ziidi/investment deposits - expense (money leaving M-Pesa)
    if (lowerBody.contains('invested') && lowerBody.contains('ziidi')) {
      return 'expense';
    }

    // M-Pesa received money
    if (lowerBody.contains('received from') ||
        lowerBody.contains('you have received')) {
      return 'income';
    }

    // M-Pesa & Mobile Money patterns
    if (lowerBody.contains('sent to') ||
        lowerBody.contains('paid to') ||
        lowerBody.contains('buy goods') ||
        lowerBody.contains('paybill') ||
        lowerBody.contains('airtime for')) {
      return 'expense';
    }

    if (lowerBody.contains('deposited')) {
      return 'income';
    }

    // Bank patterns
    if (lowerBody.contains('debited') ||
        lowerBody.contains('spent') ||
        lowerBody.contains('paid')) {
      return 'expense';
    }

    if (lowerBody.contains('credited') ||
        lowerBody.contains('salary') ||
        lowerBody.contains('refund')) {
      return 'income';
    }

    return null;
  }

  bool _isInternalTransfer(String body) {
    // Detect bank-to-mpesa or mpesa-to-bank transfers
    final transferPatterns = [
      'withdraw.*m-pesa',
      'mpesa.*withdraw',
      'transfer.*m-pesa',
      'mpesa.*transfer',
      'to your.*account',
      'from your.*account',
    ];

    return transferPatterns.any(
      (pattern) => RegExp(pattern, caseSensitive: false).hasMatch(body),
    );
  }

  String _categorizeTransaction(String message) {
    final keywords = {
      'Investments': ['ziidi', 'invested', 'investment', 'mmf'],
      'Food & Dining': [
        'swiggy',
        'zomato',
        'restaurant',
        'food',
        'cafe',
        'hotel',
        'eatery',
      ],
      'Shopping': [
        'amazon',
        'flipkart',
        'shopping',
        'mall',
        'supermarket',
        'shop',
        'store',
      ],
      'Transportation': [
        'uber',
        'ola',
        'petrol',
        'fuel',
        'matatu',
        'boda',
        'taxi',
        'transport',
      ],
      'Bills & Utilities': [
        'electricity',
        'water',
        'bill',
        'recharge',
        'kplc',
        'nairobi water',
        'token',
      ],
      'Entertainment': [
        'netflix',
        'movie',
        'spotify',
        'showmax',
        'dstv',
        'gotv',
      ],
      'Airtime & Data': ['airtime', 'data', 'bundle', 'safaricom', 'airtel'],
      'Mobile Money': ['m-pesa', 'mpesa', 'agent'],
      'Interest & Fees': ['fuliza interest', 'fuliza fee', 'overdraft charge'],
      'Salary': ['salary', 'wages', 'payment received'],
    };

    final lowerMsg = message.toLowerCase();
    for (var entry in keywords.entries) {
      if (entry.value.any((kw) => lowerMsg.contains(kw))) {
        return entry.key;
      }
    }
    return 'Other';
  }

  double _extractTransactionFee(String body) {
    // Skip fee extraction for Fuliza Access Fees (the transaction itself is the fee)
    if (body.toLowerCase().contains('fuliza access fees')) {
      return 0.0;
    }

    // M-Pesa fee patterns - multiple variations
    final feePatterns = [
      RegExp(
        r'transaction cost[,:]?\s*ksh\.?\s*([\d,]+\.?\d*)',
        caseSensitive: false,
      ),
      RegExp(
        r'access fee charged\s*ksh\.?\s*([\d,]+\.?\d*)',
        caseSensitive: false,
      ),
      RegExp(
        r'transaction fee[,:]?\s*ksh\.?\s*([\d,]+\.?\d*)',
        caseSensitive: false,
      ),
    ];

    for (var pattern in feePatterns) {
      final match = pattern.firstMatch(body);
      if (match != null) {
        final feeStr = match.group(1)!.replaceAll(',', '');
        final fee = double.tryParse(feeStr) ?? 0.0;
        developer.log(
          'Extracted fee: $fee from: ${body.substring(0, body.length > 100 ? 100 : body.length)}',
        );
        return fee;
      }
    }

    return 0.0;
  }

  Map<String, dynamic> _extractBalanceInfo(String body) {
    // M-Pesa balance: "New M-PESA balance is Ksh152.95"
    final mpesaBalanceRegex = RegExp(
      r'(?:new )?m-pesa balance is ksh\s*([\d,]+\.?\d*)',
      caseSensitive: false,
    );
    final mpesaMatch = mpesaBalanceRegex.firstMatch(body);
    final mpesaBalance = mpesaMatch != null
        ? double.tryParse(mpesaMatch.group(1)!.replaceAll(',', ''))
        : null;

    // Fuliza balance: "Total Fuliza M-Pesa outstanding amount is Ksh336.50 due on 12/02/26"
    final fulizaBalanceRegex = RegExp(
      r'(?:total )?fuliza.*?outstanding.*?ksh\s*([\d,]+\.?\d*)',
      caseSensitive: false,
    );
    final fulizaMatch = fulizaBalanceRegex.firstMatch(body);
    final fulizaBalance = fulizaMatch != null
        ? double.tryParse(fulizaMatch.group(1)!.replaceAll(',', ''))
        : null;

    // Fuliza due date: "due on 12/02/26"
    final dueDateRegex = RegExp(
      r'due on (\d{1,2})/(\d{1,2})/(\d{2})',
      caseSensitive: false,
    );
    final dueDateMatch = dueDateRegex.firstMatch(body);
    DateTime? dueDate;
    if (dueDateMatch != null) {
      final day = int.parse(dueDateMatch.group(1)!);
      final month = int.parse(dueDateMatch.group(2)!);
      final year = 2000 + int.parse(dueDateMatch.group(3)!);
      dueDate = DateTime(year, month, day);
    }

    // Ziidi balance: "Your ZIIDI balance is Ksh. 10,075.58"
    final ziidiBalanceRegex = RegExp(
      r'ziidi balance is ksh\.?\s*([\d,]+\.?\d*)',
      caseSensitive: false,
    );
    final ziidiMatch = ziidiBalanceRegex.firstMatch(body);
    final ziidiBalance = ziidiMatch != null
        ? double.tryParse(ziidiMatch.group(1)!.replaceAll(',', ''))
        : null;

    return {
      'balance': mpesaBalance,
      'fulizaBalance': fulizaBalance,
      'dueDate': dueDate,
      'ziidiBalance': ziidiBalance,
    };
  }
}
