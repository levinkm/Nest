import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../../transactions/domain/entities/transaction.dart';

class ExpenseTrendChart extends StatelessWidget {
  final List<Transaction> transactions;

  const ExpenseTrendChart({super.key, required this.transactions});

  @override
  Widget build(BuildContext context) {
    final last7Days = _getLast7DaysData();

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Last 7 Days', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            SizedBox(
              height: 200,
              child: LineChart(
                LineChartData(
                  gridData: const FlGridData(show: false),
                  titlesData: const FlTitlesData(show: false),
                  borderData: FlBorderData(show: false),
                  lineBarsData: [
                    LineChartBarData(
                      spots: last7Days.asMap().entries.map((e) => FlSpot(e.key.toDouble(), e.value)).toList(),
                      isCurved: true,
                      color: Colors.red,
                      barWidth: 3,
                      dotData: const FlDotData(show: true),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<double> _getLast7DaysData() {
    final now = DateTime.now();
    final data = List.generate(7, (_) => 0.0);

    for (var t in transactions.where((t) => t.type == 'expense')) {
      final diff = now.difference(t.date).inDays;
      if (diff >= 0 && diff < 7) {
        data[6 - diff] += t.amount;
      }
    }

    return data;
  }
}
