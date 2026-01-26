import 'package:flutter/material.dart';
import '../data/models/budget_model.dart';

class BudgetCard extends StatelessWidget {
  final Budget budget;

  const BudgetCard({Key? key, required this.budget}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final progress = budget.percentage / 100;
    final color = progress >= 1.0 ? Colors.red : progress >= 0.8 ? Colors.orange : Colors.green;

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: InkWell(
        onTap: () => Navigator.pushNamed(context, '/budget/details', arguments: budget),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(budget.category, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  Text(budget.period.toUpperCase(), style: TextStyle(color: Colors.grey[600])),
                ],
              ),
              const SizedBox(height: 8),
              Text('\$${budget.spent.toStringAsFixed(2)} / \$${budget.limit.toStringAsFixed(2)}'),
              const SizedBox(height: 8),
              LinearProgressIndicator(value: progress > 1.0 ? 1.0 : progress, backgroundColor: Colors.grey[300], color: color),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${budget.percentage.toStringAsFixed(1)}% used',
                    style: TextStyle(color: color, fontWeight: FontWeight.w500),
                  ),
                  Text(
                    '\$${budget.remaining.toStringAsFixed(2)} left',
                    style: TextStyle(
                      color: budget.remaining < 0 ? Colors.red : Colors.green,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
