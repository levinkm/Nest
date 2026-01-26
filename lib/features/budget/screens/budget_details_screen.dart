import 'package:flutter/material.dart';
import '../data/models/budget_model.dart';
import '../services/export_service.dart';

class BudgetDetailsScreen extends StatelessWidget {
  final Budget budget;

  const BudgetDetailsScreen({Key? key, required this.budget}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(budget.category),
        actions: [
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: () => ExportService.exportToPdf(budget),
          ),
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildSummaryCard(),
        ],
      ),
    );
  }

  Widget _buildSummaryCard() {
    final remaining = budget.remaining;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Total Budget',
                      style: TextStyle(color: Colors.grey),
                    ),
                    Text(
                      '\$${budget.limit.toStringAsFixed(2)}',
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    const Text(
                      'Remaining',
                      style: TextStyle(color: Colors.grey),
                    ),
                    Text(
                      '\$${remaining.toStringAsFixed(2)}',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: remaining < 0 ? Colors.red : Colors.green,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16),
            LinearProgressIndicator(
              value: budget.spent / budget.limit,
              backgroundColor: Colors.grey[300],
              color: budget.isOverBudget ? Colors.red : Colors.green,
            ),
          ],
        ),
      ),
    );
  }
}
