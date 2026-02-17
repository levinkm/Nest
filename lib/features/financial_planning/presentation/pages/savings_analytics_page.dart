import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../../../core/utils/savings_analytics.dart';
import '../../../../core/utils/currency_helper.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../transactions/presentation/bloc/transaction_bloc.dart';

class SavingsAnalyticsPage extends StatelessWidget {
  const SavingsAnalyticsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Savings Analytics',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SafeArea(
        child: BlocBuilder<TransactionBloc, TransactionState>(
          builder: (context, state) {
            return state.when(
              initial: () => const Center(child: Text('No data')),
              loading: () => const Center(child: CircularProgressIndicator()),
              loaded: (transactions) {
                return FutureBuilder<String>(
                  future: CurrencyHelper.getCurrency(),
                  builder: (context, currencySnapshot) {
                    final currency = currencySnapshot.data ?? 'KSh';

                    return FutureBuilder<SavingsMetrics>(
                      future: SavingsAnalytics.calculate(transactions),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }

                        final metrics = snapshot.data!;

                        return SingleChildScrollView(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildHealthScoreCard(metrics.healthScore),
                              const SizedBox(height: 16),
                              _buildSavingsRateCard(
                                metrics.savingsRate,
                                currency,
                                metrics.monthlySavings,
                              ),
                              const SizedBox(height: 16),
                              _buildSavingsPieChart(metrics, currency),
                              const SizedBox(height: 16),
                              _buildSavingsBreakdown(metrics, currency),
                              const SizedBox(height: 16),
                              _buildGoalProgressChart(
                                metrics.goalAnalytics,
                                currency,
                              ),
                              const SizedBox(height: 16),
                              _buildGoalAnalytics(
                                metrics.goalAnalytics,
                                currency,
                              ),
                              const SizedBox(height: 16),
                              _buildSmartSuggestions(metrics.suggestions),
                            ],
                          ),
                        );
                      },
                    );
                  },
                );
              },
              error: (msg) => Center(child: Text('Error: $msg')),
            );
          },
        ),
      ),
    );
  }

  Widget _buildHealthScoreCard(int score) {
    Color scoreColor;
    String scoreLabel;
    IconData scoreIcon;

    if (score >= 80) {
      scoreColor = Colors.green;
      scoreLabel = 'Excellent';
      scoreIcon = Icons.emoji_events;
    } else if (score >= 60) {
      scoreColor = Colors.blue;
      scoreLabel = 'Good';
      scoreIcon = Icons.thumb_up;
    } else if (score >= 40) {
      scoreColor = Colors.orange;
      scoreLabel = 'Fair';
      scoreIcon = Icons.warning_amber;
    } else {
      scoreColor = Colors.red;
      scoreLabel = 'Needs Work';
      scoreIcon = Icons.trending_down;
    }

    return Card(
      color: AppColors.surface,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Savings Health Score',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      scoreLabel,
                      style: TextStyle(
                        fontSize: 16,
                        color: scoreColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: scoreColor.withValues(alpha: 0.2),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(scoreIcon, size: 32, color: scoreColor),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: LinearProgressIndicator(
                      value: score / 100,
                      minHeight: 12,
                      backgroundColor: AppColors.surfaceLight,
                      color: scoreColor,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  '$score/100',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: scoreColor,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSavingsRateCard(
    double rate,
    String currency,
    double monthlySavings,
  ) {
    final isGood = rate >= 20;
    final color = isGood ? Colors.green : Colors.orange;

    return Card(
      color: AppColors.surface,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Savings Rate',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${rate.toStringAsFixed(1)}%',
                      style: TextStyle(
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                        color: color,
                      ),
                    ),
                    const Text(
                      'Target: 20%',
                      style: TextStyle(
                        fontSize: 14,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      '$currency ${monthlySavings.toStringAsFixed(0)}',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const Text(
                      'Monthly Savings',
                      style: TextStyle(
                        fontSize: 14,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 12),
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: (rate / 20).clamp(0.0, 1.0),
                minHeight: 8,
                backgroundColor: AppColors.surfaceLight,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSavingsBreakdown(SavingsMetrics metrics, String currency) {
    final total = metrics.totalSavings;
    final efPercent = total > 0 ? (metrics.emergencyFund / total) * 100 : 0.0;
    final goalsPercent = total > 0 ? (metrics.goalsSaved / total) * 100 : 0.0;

    return Card(
      color: AppColors.surface,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Savings Breakdown',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 16),
            _buildBreakdownRow(
              'Emergency Fund',
              metrics.emergencyFund,
              efPercent,
              Colors.orange,
              currency,
            ),
            const SizedBox(height: 12),
            _buildBreakdownRow(
              'Savings Goals',
              metrics.goalsSaved,
              goalsPercent,
              Colors.green,
              currency,
            ),
            const Divider(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Total Savings',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                Text(
                  '$currency ${total.toStringAsFixed(0)}',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBreakdownRow(
    String label,
    double amount,
    double percent,
    Color color,
    String currency,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: const TextStyle(
                fontSize: 14,
                color: AppColors.textPrimary,
              ),
            ),
            Text(
              '$currency ${amount.toStringAsFixed(0)} (${percent.toStringAsFixed(0)}%)',
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: percent / 100,
            minHeight: 6,
            backgroundColor: AppColors.surfaceLight,
            color: color,
          ),
        ),
      ],
    );
  }

  Widget _buildGoalAnalytics(List<GoalAnalytic> analytics, String currency) {
    if (analytics.isEmpty) {
      return const SizedBox.shrink();
    }

    return Card(
      color: AppColors.surface,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Goal Achievement Analytics',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 16),
            ...analytics
                .take(5)
                .map((goal) => _buildGoalAnalyticItem(goal, currency)),
          ],
        ),
      ),
    );
  }

  Widget _buildGoalAnalyticItem(GoalAnalytic goal, String currency) {
    Color statusColor;
    IconData statusIcon;

    switch (goal.status) {
      case 'completed':
        statusColor = Colors.green;
        statusIcon = Icons.check_circle;
        break;
      case 'on_track':
        statusColor = Colors.blue;
        statusIcon = Icons.trending_up;
        break;
      case 'at_risk':
        statusColor = Colors.orange;
        statusIcon = Icons.warning;
        break;
      case 'overdue':
        statusColor = Colors.red;
        statusIcon = Icons.error;
        break;
      default:
        statusColor = Colors.grey;
        statusIcon = Icons.info;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: statusColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: statusColor.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(statusIcon, size: 20, color: statusColor),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  goal.name,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
              Text(
                '${(goal.progress * 100).toStringAsFixed(0)}%',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: statusColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          if (goal.status != 'completed') ...[
            Text(
              goal.daysLeft > 0
                  ? '${goal.daysLeft} days left • Need $currency ${goal.requiredMonthly.toStringAsFixed(0)}/month'
                  : 'Overdue by ${-goal.daysLeft} days',
              style: const TextStyle(
                fontSize: 12,
                color: AppColors.textSecondary,
              ),
            ),
            if (goal.projectedCompletion != null) ...[
              const SizedBox(height: 4),
              Text(
                'Projected: ${goal.projectedCompletion!.year}-${goal.projectedCompletion!.month.toString().padLeft(2, '0')}-${goal.projectedCompletion!.day.toString().padLeft(2, '0')}',
                style: const TextStyle(
                  fontSize: 12,
                  color: AppColors.textSecondary,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ],
          ],
        ],
      ),
    );
  }

  Widget _buildSmartSuggestions(List<String> suggestions) {
    if (suggestions.isEmpty) {
      return const SizedBox.shrink();
    }

    return Card(
      color: AppColors.surface,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Icon(Icons.lightbulb, color: Colors.amber),
                SizedBox(width: 8),
                Text(
                  'Smart Suggestions',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ...suggestions.map(
              (suggestion) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('• ', style: TextStyle(fontSize: 16)),
                    Expanded(
                      child: Text(
                        suggestion,
                        style: const TextStyle(
                          fontSize: 14,
                          color: AppColors.textPrimary,
                        ),
                      ),
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

  Widget _buildSavingsPieChart(SavingsMetrics metrics, String currency) {
    if (metrics.totalSavings == 0) return const SizedBox.shrink();

    return Card(
      color: AppColors.surface,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Savings Distribution',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              height: 200,
              child: PieChart(
                PieChartData(
                  sectionsSpace: 2,
                  centerSpaceRadius: 60,
                  sections: [
                    PieChartSectionData(
                      value: metrics.emergencyFund,
                      title:
                          '${((metrics.emergencyFund / metrics.totalSavings) * 100).toStringAsFixed(0)}%',
                      color: Colors.orange,
                      radius: 50,
                      titleStyle: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    PieChartSectionData(
                      value: metrics.goalsSaved,
                      title:
                          '${((metrics.goalsSaved / metrics.totalSavings) * 100).toStringAsFixed(0)}%',
                      color: Colors.green,
                      radius: 50,
                      titleStyle: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildLegendItem(
                  'Emergency Fund',
                  Colors.orange,
                  currency,
                  metrics.emergencyFund,
                ),
                _buildLegendItem(
                  'Savings Goals',
                  Colors.green,
                  currency,
                  metrics.goalsSaved,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLegendItem(
    String label,
    Color color,
    String currency,
    double amount,
  ) {
    return Column(
      children: [
        Row(
          children: [
            Container(
              width: 16,
              height: 16,
              decoration: BoxDecoration(color: color, shape: BoxShape.circle),
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: const TextStyle(
                fontSize: 12,
                color: AppColors.textPrimary,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          '$currency ${amount.toStringAsFixed(0)}',
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
      ],
    );
  }

  Widget _buildGoalProgressChart(
    List<GoalAnalytic> analytics,
    String currency,
  ) {
    if (analytics.isEmpty) return const SizedBox.shrink();

    final topGoals = analytics.take(5).toList();

    return Card(
      color: AppColors.surface,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Goal Progress Overview',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              height: 200,
              child: BarChart(
                BarChartData(
                  alignment: BarChartAlignment.spaceAround,
                  maxY: 100,
                  barTouchData: BarTouchData(enabled: false),
                  titlesData: FlTitlesData(
                    show: true,
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          if (value.toInt() >= topGoals.length) {
                            return const Text('');
                          }
                          final goal = topGoals[value.toInt()];
                          return Padding(
                            padding: const EdgeInsets.only(top: 8),
                            child: Text(
                              goal.name.length > 8
                                  ? '${goal.name.substring(0, 8)}...'
                                  : goal.name,
                              style: const TextStyle(
                                fontSize: 10,
                                color: AppColors.textSecondary,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 40,
                        getTitlesWidget: (value, meta) => Text(
                          '${value.toInt()}%',
                          style: const TextStyle(
                            fontSize: 10,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ),
                    ),
                    topTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    rightTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                  ),
                  gridData: FlGridData(
                    show: true,
                    drawVerticalLine: false,
                    horizontalInterval: 25,
                  ),
                  borderData: FlBorderData(show: false),
                  barGroups: List.generate(topGoals.length, (index) {
                    final goal = topGoals[index];
                    Color barColor = goal.status == 'completed'
                        ? Colors.green
                        : goal.status == 'on_track'
                        ? Colors.blue
                        : goal.status == 'at_risk'
                        ? Colors.orange
                        : Colors.red;
                    return BarChartGroupData(
                      x: index,
                      barRods: [
                        BarChartRodData(
                          toY: (goal.progress * 100).clamp(0, 100),
                          color: barColor,
                          width: 20,
                          borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(4),
                          ),
                        ),
                      ],
                    );
                  }),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
