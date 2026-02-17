import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:intl/intl.dart';
import '../../domain/entities/ledger_entry.dart';
import '../services/ledger_service.dart';

class ExcelExportService {
  static Future<File> exportLedgerToCSV(
    List<LedgerEntry> entries,
    String accountName,
  ) async {
    final summary = LedgerService.getLedgerSummary(entries);
    final dateFormat = DateFormat('yyyy-MM-dd HH:mm');
    final currencyFormat = NumberFormat('#,##0.00');

    // Build CSV content
    final buffer = StringBuffer();
    
    // Header
    buffer.writeln('$accountName Ledger Report');
    buffer.writeln('Generated: ${dateFormat.format(DateTime.now())}');
    buffer.writeln('');
    
    // Summary
    buffer.writeln('Summary');
    buffer.writeln('Total Credits,${currencyFormat.format(summary['totalCredits'])}');
    buffer.writeln('Total Debits,${currencyFormat.format(summary['totalDebits'])}');
    buffer.writeln('Total Fees,${currencyFormat.format(summary['totalFees'])}');
    buffer.writeln('Net Balance,${currencyFormat.format(summary['netBalance'])}');
    buffer.writeln('Total Entries,${summary['entryCount']}');
    buffer.writeln('');
    
    // Column headers
    buffer.writeln('Date,Reference,Description,Category,Debit,Credit,Fee,Balance');
    
    // Data rows
    for (final entry in entries) {
      buffer.writeln([
        dateFormat.format(entry.date),
        entry.reference ?? '',
        '"${entry.description.replaceAll('"', '""')}"',
        entry.category ?? '',
        entry.debit > 0 ? '"${entry.debit.toStringAsFixed(2)}"' : '',
        entry.credit > 0 ? '"${entry.credit.toStringAsFixed(2)}"' : '',
        entry.fee > 0 ? '"${entry.fee.toStringAsFixed(2)}"' : '',
        '"${entry.balance.toStringAsFixed(2)}"',
      ].join(','));
    }

    // Save to file
    final directory = await getApplicationDocumentsDirectory();
    final timestamp = DateFormat('yyyyMMdd_HHmmss').format(DateTime.now());
    final fileName = '${accountName.replaceAll(' ', '_')}_Ledger_$timestamp.csv';
    final file = File('${directory.path}/$fileName');
    
    await file.writeAsString(buffer.toString());
    return file;
  }

  static Future<File> exportAllAccountsToCSV(
    Map<String, List<LedgerEntry>> accountLedgers,
  ) async {
    final dateFormat = DateFormat('yyyy-MM-dd HH:mm');
    final currencyFormat = NumberFormat('#,##0.00');
    final buffer = StringBuffer();
    
    buffer.writeln('All Accounts Ledger Report');
    buffer.writeln('Generated: ${dateFormat.format(DateTime.now())}');
    buffer.writeln('');

    for (final entry in accountLedgers.entries) {
      final accountName = entry.key;
      final entries = entry.value;
      final summary = LedgerService.getLedgerSummary(entries);
      
      buffer.writeln('');
      buffer.writeln('Account: $accountName');
      buffer.writeln('Net Balance,${currencyFormat.format(summary['netBalance'])}');
      buffer.writeln('');
      buffer.writeln('Date,Reference,Description,Category,Debit,Credit,Fee,Balance');
      
      for (final ledgerEntry in entries) {
        buffer.writeln([
          dateFormat.format(ledgerEntry.date),
          ledgerEntry.reference ?? '',
          '"${ledgerEntry.description.replaceAll('"', '""')}"',
          ledgerEntry.category ?? '',
          ledgerEntry.debit > 0 ? '"${ledgerEntry.debit.toStringAsFixed(2)}"' : '',
          ledgerEntry.credit > 0 ? '"${ledgerEntry.credit.toStringAsFixed(2)}"' : '',
          ledgerEntry.fee > 0 ? '"${ledgerEntry.fee.toStringAsFixed(2)}"' : '',
          '"${ledgerEntry.balance.toStringAsFixed(2)}"',
        ].join(','));
      }
      
      buffer.writeln('');
    }

    final directory = await getApplicationDocumentsDirectory();
    final timestamp = DateFormat('yyyyMMdd_HHmmss').format(DateTime.now());
    final file = File('${directory.path}/All_Accounts_Ledger_$timestamp.csv');
    
    await file.writeAsString(buffer.toString());
    return file;
  }
}
