import 'package:flutter/material.dart';
import '../data/models/budget_model.dart';

class AnalyticsScreen extends StatelessWidget {
  final Budget budget;

  const AnalyticsScreen({super.key, required this.budget});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Budget Analytics')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildSummaryCard(),
          const SizedBox(height: 24),
          _buildProgressCard(),
        ],
      ),
    );
  }

  Widget _buildSummaryCard() {
    final progress = budget.percentage;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              budget.category,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Spent', style: TextStyle(color: Colors.grey)),
                    Text(
                      '\$${budget.spent.toStringAsFixed(2)}',
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
                    const Text('Limit', style: TextStyle(color: Colors.grey)),
                    Text(
                      '\$${budget.limit.toStringAsFixed(2)}',
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProgressCard() {
    final progress = budget.percentage / 100;
    final color = budget.isOverBudget
        ? Colors.red
        : progress >= 0.8
        ? Colors.orange
        : Colors.green;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Budget Progress',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            LinearProgressIndicator(
              value: progress > 1.0 ? 1.0 : progress,
              backgroundColor: Colors.grey[300],
              color: color,
              minHeight: 10,
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${budget.percentage.toStringAsFixed(1)}% used',
                  style: TextStyle(color: color, fontWeight: FontWeight.bold),
                ),
                Text(
                  '\$${budget.remaining.toStringAsFixed(2)} remaining',
                  style: TextStyle(
                    color: budget.remaining < 0 ? Colors.red : Colors.green,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            if (budget.isOverBudget)
              const Padding(
                padding: EdgeInsets.only(top: 16),
                child: ListTile(
                  leading: Icon(Icons.warning, color: Colors.red),
                  title: Text('Budget Exceeded'),
                  subtitle: Text('You have exceeded your budget limit'),
                ),
              )
            else if (progress >= 0.8)
              const Padding(
                padding: EdgeInsets.only(top: 16),
                child: ListTile(
                  leading: Icon(Icons.info, color: Colors.orange),
                  title: Text('Approaching Limit'),
                  subtitle: Text('You are nearing your budget limit'),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
