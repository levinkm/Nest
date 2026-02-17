import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:csv/csv.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';
import '../domain/entities/transaction.dart';
import 'package:uuid/uuid.dart';

class ImportService {
  final _uuid = const Uuid();

  Future<List<Transaction>> importFromCsv(File file) async {
    final content = await file.readAsString();
    final rows = const CsvToListConverter().convert(content);

    if (rows.isEmpty) return [];

    final transactions = <Transaction>[];

    // Skip header row
    for (var i = 1; i < rows.length; i++) {
      final row = rows[i];
      if (row.length < 6) continue;

      try {
        final transaction = _parseCsvRow(row);
        if (transaction != null) transactions.add(transaction);
      } catch (e) {
        if (kDebugMode) print('Error parsing row $i: $e');
      }
    }

    return transactions;
  }

  Transaction? _parseCsvRow(List<dynamic> row) {
    try {
      // M-Pesa CSV format: Receipt No., Completion Time, Details, Transaction Status, Paid In, Withdrawn, Balance
      final receiptNo = row[0]?.toString().trim();
      final dateStr = row[1]?.toString().trim();
      final details = row[2]?.toString().trim() ?? '';
      final paidIn = _parseAmount(row[4]);
      final withdrawn = _parseAmount(row[5]);

      if (receiptNo == null || receiptNo.isEmpty) return null;

      final amount = paidIn > 0 ? paidIn : withdrawn;
      if (amount == 0) return null;

      final type = paidIn > 0 ? 'income' : 'expense';
      final date = _parseDate(dateStr);

      return Transaction(
        id: _uuid.v4(),
        amount: amount,
        category: _categorizeFromDescription(details, type),
        description: details,
        date: date,
        type: type,
        transactionId: receiptNo,
      );
    } catch (e) {
      return null;
    }
  }

  Future<List<Transaction>> importFromPdf(File file, String password) async {
    try {
      final bytes = await file.readAsBytes();
      final document = PdfDocument(inputBytes: bytes, password: password);

      final textExtractor = PdfTextExtractor(document);
      final text = textExtractor.extractText();
      document.dispose();

      return _parsePdfText(text);
    } catch (e) {
      throw Exception('Failed to read PDF: $e');
    }
  }

  List<Transaction> _parsePdfText(String text) {
    final transactions = <Transaction>[];
    final lines = text.split('\n');

    for (var i = 0; i < lines.length; i++) {
      final line = lines[i].trim();

      // M-Pesa statement pattern: Receipt No | Date | Details | Amount | Balance
      final receiptMatch = RegExp(
        r'([A-Z0-9]{10,})\s+(\d{1,2}/\d{1,2}/\d{2,4})',
      ).firstMatch(line);
      if (receiptMatch == null) continue;

      final receiptNo = receiptMatch.group(1);
      final dateStr = receiptMatch.group(2);

      // Extract details and amount from surrounding text
      final detailsMatch = RegExp(
        r'(?:Paid to|Received from|Sent to|Withdraw from)\s+([^0-9]+)',
      ).firstMatch(line);
      final amountMatch = RegExp(r'Ksh\s*([\d,]+\.?\d*)').firstMatch(line);

      if (receiptNo == null || amountMatch == null) continue;

      final details = detailsMatch?.group(1)?.trim() ?? 'Transaction';
      final amount = _parseAmount(amountMatch.group(1));
      final type =
          line.contains('Paid to') ||
              line.contains('Sent to') ||
              line.contains('Withdraw')
          ? 'expense'
          : 'income';

      transactions.add(
        Transaction(
          id: _uuid.v4(),
          amount: amount,
          category: _categorizeFromDescription(details, type),
          description: details,
          date: _parseDate(dateStr),
          type: type,
          transactionId: receiptNo,
        ),
      );
    }

    return transactions;
  }

  double _parseAmount(dynamic value) {
    if (value == null) return 0.0;
    final str = value.toString().replaceAll(',', '').trim();
    return double.tryParse(str) ?? 0.0;
  }

  DateTime _parseDate(String? dateStr) {
    if (dateStr == null || dateStr.isEmpty) return DateTime.now();

    try {
      // Try DD/MM/YYYY format
      final parts = dateStr.split('/');
      if (parts.length == 3) {
        final day = int.parse(parts[0]);
        final month = int.parse(parts[1]);
        final year = int.parse(parts[2]);
        final fullYear = year < 100 ? 2000 + year : year;
        return DateTime(fullYear, month, day);
      }

      // Try ISO format
      return DateTime.parse(dateStr);
    } catch (e) {
      return DateTime.now();
    }
  }

  String _categorizeFromDescription(String description, String type) {
    final lower = description.toLowerCase();

    if (type == 'income') {
      if (lower.contains('salary') || lower.contains('payroll')) {
        return 'Salary';
      }
      if (lower.contains('business')) return 'Business';
      return 'Other Income';
    }

    // Expense categorization
    if (lower.contains('supermarket') || lower.contains('shop')) {
      return 'Groceries';
    }
    if (lower.contains('restaurant') || lower.contains('cafe')) return 'Dining';
    if (lower.contains('fuel') || lower.contains('petrol')) return 'Transport';
    if (lower.contains('electricity') ||
        lower.contains('water') ||
        lower.contains('rent')) {
      return 'Bills';
    }
    if (lower.contains('airtime') || lower.contains('data')) {
      return 'Airtime & Data';
    }
    if (lower.contains('withdraw') || lower.contains('atm')) {
      return 'Cash Withdrawal';
    }

    return 'Other';
  }
}
