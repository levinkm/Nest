import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import '../../../features/transactions/data/datasources/local_database.dart';
import '../../../core/theme/app_colors.dart';

class DebugMenuPage extends StatelessWidget {
  const DebugMenuPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        title: const Text(
          'Debug Menu',
          style: TextStyle(color: AppColors.textPrimary),
        ),
        iconTheme: const IconThemeData(color: AppColors.textPrimary),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildSection('Database', [
            _buildDebugTile(
              context,
              'Clear All Transactions',
              'Delete all transactions from database',
              Icons.delete_forever,
              Colors.red,
              () => _clearTransactions(context),
            ),
            _buildDebugTile(
              context,
              'Database Info',
              'View database statistics',
              Icons.info,
              Colors.blue,
              () => _showDatabaseInfo(context),
            ),
          ]),
          const SizedBox(height: 16),
          _buildSection('Testing', [
            _buildDebugTile(
              context,
              'Test Crash',
              'Trigger a test crash for Crashlytics',
              Icons.bug_report,
              Colors.orange,
              () {
                try {
                  FirebaseCrashlytics.instance.crash();
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Crashlytics not configured: $e')),
                  );
                }
              },
            ),
            _buildDebugTile(
              context,
              'Log Test Error',
              'Log a non-fatal error',
              Icons.error,
              Colors.yellow,
              () => _logTestError(),
            ),
          ]),
          const SizedBox(height: 16),
          _buildSection('App Info', [
            _buildInfoTile('Version', '1.0.0+1'),
            _buildInfoTile('Database Version', '12'),
            _buildInfoTile('Environment', 'Development'),
          ]),
        ],
      ),
    );
  }

  Widget _buildSection(String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 8),
          child: Text(
            title,
            style: const TextStyle(
              color: AppColors.textSecondary,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(children: children),
        ),
      ],
    );
  }

  Widget _buildDebugTile(
    BuildContext context,
    String title,
    String subtitle,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.2),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, color: color, size: 20),
      ),
      title: Text(title, style: const TextStyle(color: AppColors.textPrimary)),
      subtitle: Text(
        subtitle,
        style: const TextStyle(color: AppColors.textSecondary, fontSize: 12),
      ),
      onTap: onTap,
    );
  }

  Widget _buildInfoTile(String label, String value) {
    return ListTile(
      title: Text(
        label,
        style: const TextStyle(color: AppColors.textSecondary, fontSize: 14),
      ),
      trailing: Text(
        value,
        style: const TextStyle(
          color: AppColors.textPrimary,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Future<void> _clearTransactions(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.surface,
        title: const Text(
          'Clear All Transactions?',
          style: TextStyle(color: AppColors.textPrimary),
        ),
        content: const Text(
          'This will delete all transactions. This action cannot be undone.',
          style: TextStyle(color: AppColors.textSecondary),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirmed == true && context.mounted) {
      final db = LocalDatabase();
      final transactions = await db.getTransactions();
      for (var txn in transactions) {
        await db.deleteTransaction(txn.id);
      }

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('All transactions deleted'),
            backgroundColor: Colors.green,
          ),
        );
      }
    }
  }

  Future<void> _showDatabaseInfo(BuildContext context) async {
    final db = LocalDatabase();
    final transactions = await db.getTransactions();
    final budgets = await db.getBudgets(activeOnly: false);
    final debts = await db.getDebts();
    final bills = await db.getBills(activeOnly: false);

    if (context.mounted) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          backgroundColor: AppColors.surface,
          title: const Text(
            'Database Statistics',
            style: TextStyle(color: AppColors.textPrimary),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildStatRow('Transactions', transactions.length),
              _buildStatRow('Budgets', budgets.length),
              _buildStatRow('Debts', debts.length),
              _buildStatRow('Bills', bills.length),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Close'),
            ),
          ],
        ),
      );
    }
  }

  Widget _buildStatRow(String label, int count) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: AppColors.textSecondary)),
          Text(
            '$count',
            style: const TextStyle(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  void _logTestError() {
    try {
      FirebaseCrashlytics.instance.log('Test error logged from debug menu');
      FirebaseCrashlytics.instance.recordError(
        Exception('Test exception from debug menu'),
        StackTrace.current,
        reason: 'Testing error logging',
      );
    } catch (e) {
      if (kDebugMode) {
        print('Crashlytics not configured: $e');
      }
    }
  }
}
