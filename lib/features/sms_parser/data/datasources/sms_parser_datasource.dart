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
      final List<dynamic> messages = await platform.invokeMethod('getInboxSms', {'daysBack': daysBack});
      developer.log('Received ${messages.length} messages from native');
      
      List<SmsTransaction> transactions = [];
      
      for (var msg in messages) {
        final body = msg['body'] as String? ?? '';
        final timestamp = msg['date'] as int? ?? DateTime.now().millisecondsSinceEpoch;
        final date = DateTime.fromMillisecondsSinceEpoch(timestamp);
        
        final parsed = await _parseMessage(body, date);
        if (parsed != null) {
          transactions.add(parsed);
          developer.log('Parsed transaction: ${parsed.amount} - ${parsed.category}');
        }
      }

      developer.log('Total transactions parsed: ${transactions.length}');
      return transactions;
    } catch (e) {
      developer.log('Error parsing SMS: $e', error: e);
      return [];
    }
  }

  Future<SmsTransaction?> _parseMessage(String body, DateTime date) async {
    if (_isFailedTransaction(body)) {
      developer.log('Skipping failed transaction');
      return null;
    }

    final amountRegex = RegExp(r'(?:Ksh\.?|KES|Rs\.?|INR|₹)\s*(\d+(?:,\d+)*(?:\.\d{2})?)');
    final match = amountRegex.firstMatch(body);
    
    if (match == null) return null;

    final amount = double.tryParse(match.group(1)!.replaceAll(',', ''));
    if (amount == null) return null;

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

    return SmsTransaction(
      amount: amount,
      category: category,
      description: body.substring(0, body.length > 100 ? 100 : body.length),
      date: date,
      type: type ?? 'expense',
      transactionId: transactionId,
      isTransfer: isTransfer,
    );
  }

  String? _extractTransactionId(String body) {
    // M-Pesa transaction code pattern
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
        (lowerBody.contains('repay') || lowerBody.contains('repaid') || lowerBody.contains('available fuliza'))) {
      return 'expense';
    }
    
    // Fuliza borrowed - expense (taking loan)
    if (lowerBody.contains('fuliza') && 
        (lowerBody.contains('limit used') || lowerBody.contains('borrowed'))) {
      return 'expense';
    }
    
    // M-Pesa & Mobile Money patterns
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
    
    return transferPatterns.any((pattern) => 
      RegExp(pattern, caseSensitive: false).hasMatch(body)
    );
  }

  String _categorizeTransaction(String message) {
    final keywords = {
      'Food & Dining': ['swiggy', 'zomato', 'restaurant', 'food', 'cafe', 'hotel', 'eatery'],
      'Shopping': ['amazon', 'flipkart', 'shopping', 'mall', 'supermarket', 'shop', 'store'],
      'Transportation': ['uber', 'ola', 'petrol', 'fuel', 'matatu', 'boda', 'taxi', 'transport'],
      'Bills & Utilities': ['electricity', 'water', 'bill', 'recharge', 'kplc', 'nairobi water', 'token'],
      'Entertainment': ['netflix', 'movie', 'spotify', 'showmax', 'dstv', 'gotv'],
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
