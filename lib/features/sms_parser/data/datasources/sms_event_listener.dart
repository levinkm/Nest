import 'package:flutter/services.dart';
import 'dart:developer' as developer;
import '../models/sms_transaction.dart';

class SmsEventListener {
  static const platform = MethodChannel('com.nest.finance/sms_events');

  void initialize(Function(SmsTransaction) onTransactionReceived) {
    platform.setMethodCallHandler((call) async {
      if (call.method == 'onSmsReceived') {
        developer.log('SMS event received from native');
        final body = call.arguments['body'] as String;
        final timestamp = call.arguments['timestamp'] as int;
        final date = DateTime.fromMillisecondsSinceEpoch(timestamp);

        final transaction = _parseMessage(body, date);
        if (transaction != null) {
          developer.log('Transaction parsed from SMS event');
          onTransactionReceived(transaction);
        }
      }
    });
  }

  SmsTransaction? _parseMessage(String body, DateTime date) {
    if (_isFailedTransaction(body)) {
      developer.log('Skipping failed transaction');
      return null;
    }

    final amountRegex = RegExp(
      r'(?:Ksh\.?|KES|Rs\.?|INR|₹)\s*(\d+(?:,\d+)*(?:\.\d{2})?)',
    );
    final match = amountRegex.firstMatch(body);

    if (match == null) return null;

    final amount = double.tryParse(match.group(1)!.replaceAll(',', ''));
    if (amount == null) return null;

    final type = _determineTransactionType(body);
    if (type == null) return null;

    final transactionId = _extractTransactionId(body);
    final isTransfer = _isInternalTransfer(body);
    final category = isTransfer ? 'Transfer' : _categorizeTransaction(body);

    return SmsTransaction(
      amount: amount,
      category: category,
      description: body.substring(0, body.length > 100 ? 100 : body.length),
      date: date,
      type: type,
      transactionId: transactionId,
      isTransfer: isTransfer,
    );
  }

  String? _extractTransactionId(String body) {
    final mpesaRegex = RegExp(r'\b([A-Z0-9]{10})\b');
    final match = mpesaRegex.firstMatch(body);
    return match?.group(1);
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

  String? _determineTransactionType(String body) {
    final lowerBody = body.toLowerCase();

    // Fuliza repayment - expense (paying back loan)
    if (lowerBody.contains('fuliza') &&
        (lowerBody.contains('repay') ||
            lowerBody.contains('repaid') ||
            lowerBody.contains('available fuliza'))) {
      return 'expense';
    }

    // Fuliza borrowed - expense (taking loan)
    if (lowerBody.contains('fuliza') &&
        (lowerBody.contains('limit used') || lowerBody.contains('borrowed'))) {
      return 'expense';
    }

    if (lowerBody.contains('sent to') ||
        lowerBody.contains('paid to') ||
        lowerBody.contains('buy goods') ||
        lowerBody.contains('paybill') ||
        lowerBody.contains('withdraw') ||
        lowerBody.contains('airtime for')) {
      return 'expense';
    }

    if (lowerBody.contains('received from') ||
        lowerBody.contains('you have received') ||
        lowerBody.contains('deposited')) {
      return 'income';
    }

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
      'Loans': ['fuliza', 'loan', 'borrow', 'repay'],
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
}
