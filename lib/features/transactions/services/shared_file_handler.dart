import 'dart:io';
import 'package:receive_sharing_intent/receive_sharing_intent.dart';
import '../services/import_service.dart';
import '../data/datasources/local_database.dart';
import '../domain/entities/transaction.dart';

class SharedFileHandler {
  final ImportService _importService = ImportService();
  final LocalDatabase _database = LocalDatabase();

  Future<SharedFileResult> handleSharedFile(SharedMediaFile file) async {
    try {
      final filePath = file.path;
      final fileExtension = filePath.split('.').last.toLowerCase();
      
      if (fileExtension == 'csv') {
        return await _handleCsvFile(File(filePath));
      } else if (fileExtension == 'pdf') {
        return SharedFileResult(
          success: false,
          requiresPassword: true,
          filePath: filePath,
        );
      } else {
        return SharedFileResult(
          success: false,
          error: 'Unsupported file type: $fileExtension',
        );
      }
    } catch (e) {
      return SharedFileResult(
        success: false,
        error: e.toString(),
      );
    }
  }

  Future<SharedFileResult> _handleCsvFile(File file) async {
    try {
      final transactions = await _importService.importFromCsv(file);
      final result = await _importTransactions(transactions);
      return result;
    } catch (e) {
      return SharedFileResult(
        success: false,
        error: 'Failed to import CSV: $e',
      );
    }
  }

  Future<SharedFileResult> handlePdfWithPassword(String filePath, String password) async {
    try {
      final transactions = await _importService.importFromPdf(File(filePath), password);
      return await _importTransactions(transactions);
    } catch (e) {
      return SharedFileResult(
        success: false,
        error: 'Failed to import PDF: $e',
      );
    }
  }

  Future<SharedFileResult> _importTransactions(List<Transaction> transactions) async {
    int imported = 0;
    int duplicates = 0;

    for (final transaction in transactions) {
      final existing = await _database.database.then((db) => 
        db.query('transactions', 
          where: 'transactionId = ?', 
          whereArgs: [transaction.transactionId],
          limit: 1
        )
      );

      if (existing.isEmpty) {
        await _database.insertTransaction(transaction);
        imported++;
      } else {
        duplicates++;
      }
    }

    return SharedFileResult(
      success: true,
      imported: imported,
      duplicates: duplicates,
    );
  }
}

class SharedFileResult {
  final bool success;
  final int imported;
  final int duplicates;
  final String? error;
  final bool requiresPassword;
  final String? filePath;

  SharedFileResult({
    required this.success,
    this.imported = 0,
    this.duplicates = 0,
    this.error,
    this.requiresPassword = false,
    this.filePath,
  });
}
