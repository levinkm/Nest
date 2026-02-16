import 'dart:io';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import '../../services/import_service.dart';
import '../../data/datasources/local_database.dart';
import '../../domain/entities/transaction.dart';
import '../../../../core/theme/app_colors.dart';

class ImportTransactionsBottomSheet extends StatefulWidget {
  const ImportTransactionsBottomSheet({super.key});

  @override
  State<ImportTransactionsBottomSheet> createState() =>
      _ImportTransactionsBottomSheetState();
}

class _ImportTransactionsBottomSheetState
    extends State<ImportTransactionsBottomSheet> {
  final _importService = ImportService();
  final _database = LocalDatabase();
  final _passwordController = TextEditingController();

  bool _isLoading = false;

  @override
  void dispose() {
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _pickAndImportFile(String type) async {
    try {
      setState(() => _isLoading = true);

      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: type == 'csv' ? ['csv'] : ['pdf'],
      );

      if (result == null) {
        setState(() => _isLoading = false);
        return;
      }

      final file = File(result.files.single.path!);
      List<Transaction> transactions;

      if (type == 'pdf') {
        final password = await _showPasswordDialog();
        if (password == null) {
          setState(() => _isLoading = false);
          return;
        }
        transactions = await _importService.importFromPdf(file, password);
      } else {
        transactions = await _importService.importFromCsv(file);
      }

      int imported = 0;
      int duplicates = 0;

      for (final transaction in transactions) {
        final existing = await _database.database.then(
          (db) => db.query(
            'transactions',
            where: 'transactionId = ?',
            whereArgs: [transaction.transactionId],
            limit: 1,
          ),
        );

        if (existing.isEmpty) {
          await _database.insertTransaction(transaction);
          imported++;
        } else {
          duplicates++;
        }
      }

      if (mounted) {
        Navigator.pop(context, imported);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Imported $imported transactions. Skipped $duplicates duplicates.',
            ),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Import failed: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<String?> _showPasswordDialog() async {
    return showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.surface,
        title: const Text(
          'PDF Password',
          style: TextStyle(color: Colors.white),
        ),
        content: TextField(
          controller: _passwordController,
          obscureText: true,
          style: const TextStyle(color: Colors.white),
          decoration: const InputDecoration(
            hintText: 'Enter PDF password',
            hintStyle: TextStyle(color: Colors.grey),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, _passwordController.text),
            child: const Text('Import'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        decoration: const BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.textSecondary.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Select Import Source',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 24),

            _buildImportCard(
              icon: Icons.table_chart,
              title: 'M-Pesa CSV Ledger',
              subtitle: 'Import from M-Pesa statement CSV file',
              onTap: () => _pickAndImportFile('csv'),
            ),

            const SizedBox(height: 16),

            _buildImportCard(
              icon: Icons.picture_as_pdf,
              title: 'M-Pesa PDF Statement',
              subtitle: 'Import from password-protected PDF',
              onTap: () => _pickAndImportFile('pdf'),
            ),

            if (_isLoading) ...[
              const SizedBox(height: 24),
              const Center(child: CircularProgressIndicator()),
            ],

            SizedBox(height: MediaQuery.of(context).viewInsets.bottom),
          ],
        ),
      ),
    );
  }

  Widget _buildImportCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: _isLoading ? null : onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.surfaceLight,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Icon(icon, size: 40, color: Colors.blue),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_ios, color: Colors.grey),
          ],
        ),
      ),
    );
  }
}
