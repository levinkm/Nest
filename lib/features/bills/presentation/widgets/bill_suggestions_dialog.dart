import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../transactions/data/datasources/local_database.dart';
import '../../data/services/bill_detection_service.dart';
import '../../../transactions/domain/entities/transaction.dart';
import 'package:uuid/uuid.dart';
import 'package:intl/intl.dart';

class BillSuggestionsDialog {
  static Future<void> show(BuildContext context, List<Transaction> transactions) async {
    final suggestions = await BillDetectionService.detectRecurringBills(transactions);
    
    if (suggestions.isEmpty || !context.mounted) return;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.surface,
        title: const Text('💡 Recurring Bills Detected', style: TextStyle(color: AppColors.textPrimary)),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('We found recurring payments. Add them as bills?', style: TextStyle(color: AppColors.textSecondary)),
              const SizedBox(height: 16),
              ...suggestions.map((s) => _buildSuggestionCard(context, s)),
            ],
          ),
        ),
        actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text('Later'))],
      ),
    );
  }

  static Widget _buildSuggestionCard(BuildContext context, Map<String, dynamic> suggestion) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: AppColors.background, borderRadius: BorderRadius.circular(8)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(suggestion['merchant'], style: const TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          Text('KSh ${NumberFormat('#,##0').format(suggestion['amount'])} • ${suggestion['frequency']}', style: const TextStyle(color: AppColors.textSecondary, fontSize: 12)),
          Text('Detected ${suggestion['transactionCount']} times', style: const TextStyle(color: AppColors.textSecondary, fontSize: 11)),
          const SizedBox(height: 8),
          ElevatedButton(
            onPressed: () => _addBill(context, suggestion),
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary, minimumSize: const Size(double.infinity, 36)),
            child: const Text('Add as Bill'),
          ),
        ],
      ),
    );
  }

  static Future<void> _addBill(BuildContext context, Map<String, dynamic> suggestion) async {
    final db = LocalDatabase();
    final lastDate = suggestion['lastDate'] as DateTime;
    
    DateTime nextDue;
    if (suggestion['frequency'] == 'monthly') {
      nextDue = DateTime(lastDate.year, lastDate.month + 1, lastDate.day);
    } else {
      nextDue = lastDate.add(const Duration(days: 7));
    }

    await db.insertBill({
      'id': const Uuid().v4(),
      'name': suggestion['merchant'],
      'amount': suggestion['amount'],
      'dueDate': nextDue.toIso8601String(),
      'frequency': suggestion['frequency'],
      'category': suggestion['category'],
      'merchant': suggestion['merchant'],
      'status': 'upcoming',
      'isActive': 1,
      'autoDetected': 1,
      'createdAt': DateTime.now().toIso8601String(),
    });

    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Added ${suggestion['merchant']} as a bill')));
    }
  }
}
