import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../core/theme/app_colors.dart';
import '../../core/utils/transaction_description_helper.dart';

class ExpandableTransactionItem extends StatelessWidget {
  final dynamic transaction;
  final bool isExpanded;
  final VoidCallback onTap;

  const ExpandableTransactionItem({
    super.key,
    required this.transaction,
    required this.isExpanded,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppColors.surfaceLight,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        TransactionDescriptionHelper.getCleanDescription(
                          transaction.description,
                          transaction.counterparty,
                          transaction.type,
                        ),
                        style: const TextStyle(
                          color: AppColors.textPrimary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        DateFormat('MMM dd, yyyy').format(transaction.date),
                        style: const TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                Text(
                  'KSh ${transaction.amount.toStringAsFixed(0)}',
                  style: const TextStyle(
                    color: AppColors.expense,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            if (isExpanded) ...[
              const Divider(color: AppColors.border, height: 24),
              if (transaction.transactionId != null)
                _buildDetailRow('Reference', transaction.transactionId!),
              _buildDetailRow(
                'Category',
                transaction.category ?? 'Uncategorized',
              ),
              _buildDetailRow('Type', transaction.type),
              if (transaction.accountBalance != null)
                _buildDetailRow(
                  'Balance',
                  'KSh ${transaction.accountBalance!.toStringAsFixed(0)}',
                ),
              _buildDetailRow(
                'Time',
                DateFormat('HH:mm:ss').format(transaction.date),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              color: AppColors.textSecondary,
              fontSize: 13,
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              color: AppColors.textPrimary,
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
