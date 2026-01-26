import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../../transactions/presentation/bloc/transaction_bloc.dart';
import '../../../../core/utils/financial_stats_calculator.dart';
import '../../../../core/theme/app_colors.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../sms_parser/presentation/bloc/sms_sync_bloc.dart';
import '../../../../core/utils/currency_helper.dart';
import '../../../transactions/data/datasources/local_database.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
      future: CurrencyHelper.getCurrency(),
      builder: (context, currencySnapshot) {
        final currency = currencySnapshot.data ?? 'KSh';

        return Scaffold(
          backgroundColor: AppColors.background,
          body: SafeArea(
            child: BlocBuilder<TransactionBloc, TransactionState>(
              builder: (context, state) {
                return state.when(
                  initial: () => Center(
                    child: Text(
                      'No data',
                      style: TextStyle(color: AppColors.textSecondary),
                    ),
                  ),
                  loading: () => const Center(
                    child: CircularProgressIndicator(color: AppColors.primary),
                  ),
                  loaded: (transactions) {
                    return FutureBuilder<FinancialStats>(
                      future: FinancialStatsCalculator.calculate(transactions),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) {
                          return const Center(
                            child: CircularProgressIndicator(
                              color: AppColors.primary,
                            ),
                          );
                        }

                        final stats = snapshot.data!;
                        final fulizaDebt =
                            FinancialStatsCalculator.calculateFulizaDebt(
                              transactions,
                            );

                        return RefreshIndicator(
                          onRefresh: () => _syncSms(context),
                          color: AppColors.primary,
                          child: CustomScrollView(
                            slivers: [
                              SliverToBoxAdapter(
                                child: Padding(
                                  padding: const EdgeInsets.all(20),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        'Dashboard',
                                        style: TextStyle(
                                          color: AppColors.textPrimary,
                                          fontSize: 28,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(height: 24),
                                      _buildBalanceCard(
                                        stats.netBalance,
                                        currency,
                                      ),
                                      const SizedBox(height: 16),

                                      Row(
                                        children: [
                                          Expanded(
                                            child: _buildStatCard(
                                              'Income',
                                              stats.totalIncome,
                                              AppColors.income,
                                              Icons.arrow_downward_rounded,
                                              currency,
                                            ),
                                          ),
                                          const SizedBox(width: 12),
                                          Expanded(
                                            child: _buildStatCard(
                                              'Expense',
                                              stats.totalExpense,
                                              AppColors.expense,
                                              Icons.arrow_upward_rounded,
                                              currency,
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 12),
                                      Row(
                                        children: [
                                          Expanded(
                                            child: _buildStatCard(
                                              'Debt',
                                              stats.totalDebt,
                                              AppColors.warning,
                                              Icons.credit_card_rounded,
                                              currency,
                                            ),
                                          ),
                                          const SizedBox(width: 12),
                                          Expanded(
                                            child: _buildStatCard(
                                              'Fuliza',
                                              fulizaDebt,
                                              AppColors.error,
                                              Icons
                                                  .account_balance_wallet_rounded,
                                              currency,
                                            ),
                                          ),
                                        ],
                                      ),
                                      // const SizedBox(height: 24),
                                      // _buildInsightsCard(
                                      //   stats,
                                      //   fulizaDebt,
                                      //   currency,
                                      // ),
                                      const SizedBox(height: 16),
                                      _buildSpendingTrendChart(
                                        transactions,
                                        currency,
                                      ),
                                      const SizedBox(height: 16),
                                      _buildCategoryPieChart(
                                        stats.expenseByCategory,
                                        currency,
                                      ),
                                      const SizedBox(height: 16),
                                      _buildCategoryBreakdown(
                                        stats.expenseByCategory,
                                        currency,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  },
                  error: (msg) => Center(
                    child: Text(
                      'Error: $msg',
                      style: const TextStyle(color: AppColors.error),
                    ),
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }

  Future<void> _syncSms(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    final daysBack = prefs.getInt('sms_days_back') ?? 30;
    
    // Clean ALL duplicates first
    final localDb = LocalDatabase();
    await localDb.removeDuplicateTransactions();
    
    // Reload to show cleaned data immediately
    context.read<TransactionBloc>().add(const TransactionEvent.loadTransactions());
    
    // Then sync new SMS
    context.read<SmsSyncBloc>().add(SmsSyncEvent.syncSms(daysBack: daysBack));
    
    // Wait for sync to complete
    await Future.delayed(const Duration(seconds: 2));
    
    // Clean duplicates again after sync
    await localDb.removeDuplicateTransactions();
    
    // Final reload
    context.read<TransactionBloc>().add(const TransactionEvent.loadTransactions());
  }

  Widget _buildBalanceCard(double balance, String currency) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.cardGradientStart, AppColors.cardGradientEnd],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Net Balance',
            style: TextStyle(color: AppColors.textSecondary, fontSize: 14),
          ),
          const SizedBox(height: 8),
          Text(
            '$currency ${balance.toStringAsFixed(2)}',
            style: TextStyle(
              color: balance >= 0 ? AppColors.income : AppColors.expense,
              fontSize: 36,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(
    String title,
    double amount,
    Color color,
    IconData icon,
    String currency,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: color, size: 20),
              const SizedBox(width: 8),
              Text(
                title,
                style: const TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 13,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            '$currency ${amount.toStringAsFixed(0)}',
            style: const TextStyle(
              color: AppColors.textPrimary,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryBreakdown(
    Map<String, double> categories,
    String currency,
  ) {
    if (categories.isEmpty) return const SizedBox.shrink();

    final sorted = categories.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    final top5 = sorted.take(5).toList();
    final total = categories.values.fold(0.0, (sum, val) => sum + val);

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Top Categories',
            style: TextStyle(
              color: AppColors.textPrimary,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          ...top5.map((entry) {
            final percentage = (entry.value / total * 100);
            return Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        entry.key,
                        style: const TextStyle(
                          color: AppColors.textPrimary,
                          fontSize: 14,
                        ),
                      ),
                      Text(
                        '$currency ${entry.value.toStringAsFixed(0)}',
                        style: const TextStyle(
                          color: AppColors.textPrimary,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: LinearProgressIndicator(
                      value: percentage / 100,
                      backgroundColor: AppColors.surfaceLight,
                      color: AppColors.primary,
                      minHeight: 6,
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildInsightsCard(
    FinancialStats stats,
    double fulizaDebt,
    String currency,
  ) {
    final savingsRate = stats.totalIncome > 0
        ? ((stats.totalIncome - stats.totalExpense) / stats.totalIncome * 100)
        : 0.0;
    final insights = <Map<String, dynamic>>[];

    if (savingsRate > 20) {
      insights.add({
        'icon': Icons.trending_up,
        'color': Colors.green,
        'text': 'Great! Saving ${savingsRate.toStringAsFixed(0)}% of income',
      });
    } else if (savingsRate < 0) {
      insights.add({
        'icon': Icons.warning,
        'color': Colors.red,
        'text':
            'Spending exceeds income by $currency ${(stats.totalExpense - stats.totalIncome).toStringAsFixed(0)}',
      });
    }

    if (fulizaDebt > 0) {
      insights.add({
        'icon': Icons.priority_high,
        'color': Colors.orange,
        'text': 'Fuliza debt: $currency ${fulizaDebt.toStringAsFixed(0)}',
      });
    }

    if (stats.totalDebt > stats.totalIncome * 0.3) {
      insights.add({
        'icon': Icons.info,
        'color': Colors.blue,
        'text':
            'Debt is ${((stats.totalDebt / stats.totalIncome) * 100).toStringAsFixed(0)}% of income',
      });
    }

    if (insights.isEmpty) {
      insights.add({
        'icon': Icons.check_circle,
        'color': Colors.green,
        'text': 'Financial health looks good!',
      });
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.lightbulb, color: Colors.amber, size: 20),
              SizedBox(width: 8),
              Text(
                'Quick Insights',
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ...insights.map(
            (insight) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                children: [
                  Icon(insight['icon'], color: insight['color'], size: 16),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      insight['text'],
                      style: const TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 13,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSpendingTrendChart(List<dynamic> transactions, String currency) {
    final last7Days = <String, double>{};
    final now = DateTime.now();

    for (int i = 6; i >= 0; i--) {
      final date = now.subtract(Duration(days: i));
      final key = '${date.month}/${date.day}';
      last7Days[key] = 0.0;
    }

    for (var t in transactions) {
      final date = t.date;
      if (date.isAfter(now.subtract(const Duration(days: 7))) &&
          t.type == 'expense') {
        final key = '${date.month}/${date.day}';
        if (last7Days.containsKey(key)) {
          last7Days[key] = last7Days[key]! + t.amount;
        }
      }
    }

    final maxY = last7Days.values.isEmpty
        ? 100.0
        : last7Days.values.reduce((a, b) => a > b ? a : b) * 1.2;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '7-Day Spending Trend',
            style: TextStyle(
              color: AppColors.textPrimary,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 150,
            child: LineChart(
              LineChartData(
                gridData: FlGridData(show: true, drawVerticalLine: false),
                titlesData: FlTitlesData(
                  leftTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  rightTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  topTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        if (value.toInt() >= last7Days.length)
                          return const Text('');
                        return Text(
                          last7Days.keys.elementAt(value.toInt()).split('/')[1],
                          style: const TextStyle(
                            color: AppColors.textSecondary,
                            fontSize: 10,
                          ),
                        );
                      },
                    ),
                  ),
                ),
                borderData: FlBorderData(show: false),
                minY: 0,
                maxY: maxY,
                lineBarsData: [
                  LineChartBarData(
                    spots: last7Days.values
                        .toList()
                        .asMap()
                        .entries
                        .map((e) => FlSpot(e.key.toDouble(), e.value))
                        .toList(),
                    isCurved: true,
                    color: AppColors.expense,
                    barWidth: 3,
                    dotData: const FlDotData(show: true),
                    belowBarData: BarAreaData(
                      show: true,
                      color: AppColors.expense.withOpacity(0.1),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryPieChart(
    Map<String, double> categories,
    String currency,
  ) {
    if (categories.isEmpty) return const SizedBox.shrink();

    final sorted = categories.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    final top5 = sorted.take(5).toList();
    final total = top5.fold(0.0, (sum, e) => sum + e.value);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Expense Distribution',
            style: TextStyle(
              color: AppColors.textPrimary,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 180,
            child: PieChart(
              PieChartData(
                sectionsSpace: 2,
                centerSpaceRadius: 40,
                sections: top5.asMap().entries.map((entry) {
                  final colors = [
                    Colors.blue,
                    Colors.red,
                    Colors.green,
                    Colors.orange,
                    Colors.purple,
                  ];
                  final percent = (entry.value.value / total * 100);
                  return PieChartSectionData(
                    value: entry.value.value,
                    title: '${percent.toStringAsFixed(0)}%',
                    color: colors[entry.key % colors.length],
                    radius: 50,
                    titleStyle: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
