import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:intl/intl.dart';
import '../../domain/entities/transaction.dart';

class TransactionExportService {
  static Future<File> exportTransactionsToCSV(
    List<Transaction> transactions,
    String filterDescription,
  ) async {
    final dateFormat = DateFormat('yyyy-MM-dd HH:mm');
    final currencyFormat = NumberFormat('#,##0.00');
    final buffer = StringBuffer();

    buffer.writeln('Transactions Export - $filterDescription');
    buffer.writeln('Generated: ${dateFormat.format(DateTime.now())}');
    buffer.writeln('');

    final totalIncome = transactions
        .where((t) => t.type == 'income')
        .fold(0.0, (sum, t) => sum + t.amount);
    final totalExpense = transactions
        .where((t) => t.type == 'expense')
        .fold(0.0, (sum, t) => sum + t.amount);
    final totalFees = transactions.fold(0.0, (sum, t) => sum + t.fee);

    buffer.writeln('Summary');
    buffer.writeln('Total Transactions,${transactions.length}');
    buffer.writeln('Total Income,${currencyFormat.format(totalIncome)}');
    buffer.writeln('Total Expense,${currencyFormat.format(totalExpense)}');
    buffer.writeln('Total Fees,${currencyFormat.format(totalFees)}');
    buffer.writeln(
      'Net Amount,${currencyFormat.format(totalIncome - totalExpense)}',
    );
    buffer.writeln('');

    buffer.writeln('Date,Type,Category,Description,Amount,Fee,Transaction ID');

    for (final t in transactions) {
      buffer.writeln(
        [
          dateFormat.format(t.date),
          t.type,
          t.category,
          '"${t.description.replaceAll('"', '""')}"',
          currencyFormat.format(t.amount),
          t.fee > 0 ? currencyFormat.format(t.fee) : '',
          t.transactionId ?? '',
        ].join(','),
      );
    }

    final directory = await getApplicationDocumentsDirectory();
    final timestamp = DateFormat('yyyyMMdd_HHmmss').format(DateTime.now());
    final file = File('${directory.path}/Transactions_Export_$timestamp.csv');
    await file.writeAsString(buffer.toString());
    return file;
  }
}
