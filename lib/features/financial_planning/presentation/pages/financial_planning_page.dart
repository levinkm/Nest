import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nest/core/theme/app_colors.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../../../transactions/presentation/bloc/transaction_bloc.dart';
import '../../../../core/utils/financial_projections_calculator.dart';
import 'expected_income_page.dart';
import 'savings_goals_page.dart';
import 'emergency_fund_page.dart';
import 'savings_analytics_page.dart';
import 'automated_savings_rules_page.dart';
import '../../../../core/utils/currency_helper.dart';

class FinancialPlanningPage extends StatefulWidget {
  const FinancialPlanningPage({super.key});

  @override
  State<FinancialPlanningPage> createState() => _FinancialPlanningPageState();
}

class _FinancialPlanningPageState extends State<FinancialPlanningPage> {
  Future<double> _getExpectedMonthlyIncome() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString('expected_incomes') ?? '[]';
    final incomes = List<Map<String, dynamic>>.from(jsonDecode(data));

    double total = 0.0;
    for (var i in incomes.where((i) => i['isActive'] == true)) {
      final amount = i['amount'] as double;
      final frequency = i['frequency'] as String;
      if (frequency == 'monthly') {
        total += amount;
      } else if (frequency == 'weekly') {
        total += amount * 4;
      } else if (frequency == 'daily') {
        total += amount * 30;
      }
    }
    return total;
  }

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
          'Financial Planning',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.analytics, color: AppColors.textPrimary),
            tooltip: 'Savings Analytics',
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const SavingsAnalyticsPage()),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.auto_awesome, color: AppColors.textPrimary),
            tooltip: 'Automated Rules',
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => const AutomatedSavingsRulesPage(),
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.add_chart, color: AppColors.textPrimary),
            tooltip: 'Manage Expected Income',
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const ExpectedIncomePage()),
            ),
          ),
        ],
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

                    return FutureBuilder<double>(
                      future: _getExpectedMonthlyIncome(),
                      builder: (context, incomeSnapshot) {
                        final expectedIncome = incomeSnapshot.data ?? 0;

                        return FutureBuilder<FinancialProjections>(
                          future: FinancialProjectionsCalculator.calculate(
                            transactions,
                          ),
                          builder: (context, projSnapshot) {
                            if (!projSnapshot.hasData) {
                              return const Center(
                                child: CircularProgressIndicator(),
                              );
                            }

                            final projections = projSnapshot.data!;

                            return SingleChildScrollView(
                              padding: const EdgeInsets.all(16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  if (expectedIncome > 0) ...[
                                    _buildExpectedIncomeCard(
                                      expectedIncome,
                                      projections,
                                      currency,
                                    ),
                                    const SizedBox(height: 16),
                                  ],
                                  _buildHealthCard(projections),
                                  const SizedBox(height: 16),
                                  _buildProjectionsCard(projections, currency),
                                  const SizedBox(height: 16),
                                  _buildBorrowingCard(projections, currency),
                                  const SizedBox(height: 16),
                                  _buildSavingsCard(
                                    projections,
                                    currency,
                                    context,
                                  ),
                                  const SizedBox(height: 16),
                                  _buildRecommendations(
                                    projections,
                                    expectedIncome,
                                    currency,
                                  ),
                                ],
                              ),
                            );
                          },
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

  Widget _buildExpectedIncomeCard(
    double expectedIncome,
    FinancialProjections proj,
    String currency,
  ) {
    final variance = expectedIncome - proj.projectedMonthlyIncome;
    return Card(
      color: AppColors.surface,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Expected vs Actual Income',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 12),
            _buildProjectionRow(
              'Expected',
              expectedIncome,
              Colors.blue,
              currency,
            ),
            _buildProjectionRow(
              'Actual',
              proj.projectedMonthlyIncome,
              Colors.green,
              currency,
            ),
            _buildProjectionRow(
              'Variance',
              variance,
              variance >= 0 ? Colors.green : Colors.red,
              currency,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHealthCard(FinancialProjections proj) {
    Color healthColor;
    IconData healthIcon;
    switch (proj.financialHealth) {
      case 'Good':
        healthColor = Colors.green;
        healthIcon = Icons.check_circle;
        break;
      case 'Fair':
        healthColor = Colors.blue;
        healthIcon = Icons.info;
        break;
      case 'Warning':
        healthColor = Colors.orange;
        healthIcon = Icons.warning;
        break;
      default:
        healthColor = Colors.red;
        healthIcon = Icons.error;
    }
    return Card(
      color: AppColors.surface,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Icon(healthIcon, size: 48, color: healthColor),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Financial Health',
                    style: TextStyle(
                      fontSize: 16,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  Text(
                    proj.financialHealth,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: healthColor,
                    ),
                  ),
                  Text(
                    'Debt-to-Income: ${(proj.debtToIncomeRatio * 100).toStringAsFixed(1)}%',
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProjectionsCard(FinancialProjections proj, String currency) {
    return Card(
      color: AppColors.surface,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Monthly Projections',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 12),
            _buildProjectionRow(
              'Income',
              proj.projectedMonthlyIncome,
              Colors.green,
              currency,
            ),
            _buildProjectionRow(
              'Expenses',
              proj.projectedMonthlyExpense,
              Colors.red,
              currency,
            ),
            _buildProjectionRow(
              'Net',
              proj.projectedMonthlyIncome - proj.projectedMonthlyExpense,
              proj.projectedMonthlyIncome > proj.projectedMonthlyExpense
                  ? Colors.green
                  : Colors.red,
              currency,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProjectionRow(
    String label,
    double amount,
    Color color,
    String currency,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 16, color: AppColors.textPrimary),
          ),
          Text(
            '$currency ${amount.toStringAsFixed(2)}',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBorrowingCard(FinancialProjections proj, String currency) {
    return Card(
      color: AppColors.surface,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Borrowing Capacity',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 12),
            _buildInfoRow('Current Debt', proj.currentDebt, currency),
            _buildInfoRow(
              'Max Can Borrow',
              proj.maxBorrowingCapacity,
              currency,
            ),
            const SizedBox(height: 8),
            const Text(
              'Based on 30% debt-to-income ratio',
              style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSavingsCard(
    FinancialProjections proj,
    String currency,
    BuildContext context,
  ) {
    return FutureBuilder<Map<String, double>>(
      future: _getSavingsData(),
      builder: (context, snapshot) {
        final emergencyFund = snapshot.data?['emergencyFund'] ?? 0.0;
        final totalGoals = snapshot.data?['totalGoals'] ?? 0.0;
        final efProgress = (emergencyFund / proj.emergencyFundNeeded).clamp(
          0.0,
          1.0,
        );

        return Card(
          color: AppColors.surface,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Savings & Emergency Fund',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.savings, size: 20),
                      onPressed: () async {
                        await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const SavingsGoalsPage(),
                          ),
                        );
                        setState(() {});
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                GestureDetector(
                  onTap: () async {
                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => EmergencyFundPage(
                          targetAmount: proj.emergencyFundNeeded,
                        ),
                      ),
                    );
                    setState(() {});
                  },
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Emergency Fund',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: AppColors.textPrimary,
                              ),
                            ),
                            Text(
                              '$currency ${emergencyFund.toStringAsFixed(0)}',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: AppColors.primary,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(4),
                          child: LinearProgressIndicator(
                            value: efProgress,
                            minHeight: 8,
                            backgroundColor: Colors.grey.shade300,
                            color: efProgress >= 1.0
                                ? Colors.green
                                : Colors.orange,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${(efProgress * 100).toStringAsFixed(0)}% of $currency ${proj.emergencyFundNeeded.toStringAsFixed(0)} goal',
                          style: const TextStyle(
                            fontSize: 12,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                _buildInfoRow(
                  'Monthly Savings Target',
                  proj.monthlySavingsTarget,
                  currency,
                ),
                if (totalGoals > 0) ...[
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Active Savings Goals',
                          style: TextStyle(
                            fontSize: 14,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        Text(
                          '$currency ${totalGoals.toStringAsFixed(0)}',
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.green,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
                const SizedBox(height: 8),
                Text(
                  'Emergency fund = 3 months expenses',
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<Map<String, double>> _getSavingsData() async {
    final prefs = await SharedPreferences.getInstance();

    final efData = prefs.getString('emergency_fund_transactions') ?? '[]';
    final efTransactions = List<Map<String, dynamic>>.from(jsonDecode(efData));
    double emergencyFund = 0.0;
    for (var t in efTransactions) {
      emergencyFund += t['amount'] as double;
    }

    final goalsData = prefs.getString('savings_goals') ?? '[]';
    final goals = List<Map<String, dynamic>>.from(jsonDecode(goalsData));
    double totalGoals = 0.0;
    for (var g in goals) {
      totalGoals += (g['currentAmount'] ?? 0.0) as double;
    }

    return {'emergencyFund': emergencyFund, 'totalGoals': totalGoals};
  }

  Widget _buildInfoRow(String label, double amount, String currency) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 16, color: AppColors.textPrimary),
          ),
          Text(
            '$currency ${amount.toStringAsFixed(2)}',
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecommendations(
    FinancialProjections proj,
    double expectedIncome,
    String currency,
  ) {
    final recommendations = <String>[];
    if (expectedIncome > 0 &&
        proj.projectedMonthlyIncome < expectedIncome * 0.8) {
      recommendations.add(
        '⚠️ Actual income is ${((1 - proj.projectedMonthlyIncome / expectedIncome) * 100).toStringAsFixed(0)}% below expected',
      );
    }
    if (proj.debtToIncomeRatio > 0.5) {
      recommendations.add(
        '⚠️ High debt! Focus on paying down loans before new borrowing',
      );
    } else if (proj.debtToIncomeRatio > 0.3) {
      recommendations.add('⚠️ Moderate debt. Consider debt consolidation');
    }
    if (proj.projectedMonthlyExpense > proj.projectedMonthlyIncome) {
      recommendations.add(
        '🔴 Spending exceeds income. Cut non-essential expenses',
      );
    }
    if (proj.monthlySavingsTarget > 0) {
      recommendations.add(
        '💰 Save $currency ${proj.monthlySavingsTarget.toStringAsFixed(0)} monthly',
      );
    }
    if (proj.maxBorrowingCapacity > 0) {
      recommendations.add(
        '✅ Can borrow up to $currency ${proj.maxBorrowingCapacity.toStringAsFixed(0)}',
      );
    } else {
      recommendations.add(
        '🚫 No borrowing capacity. Pay off existing debt first',
      );
    }
    recommendations.add(
      '🎯 Build emergency fund of $currency ${proj.emergencyFundNeeded.toStringAsFixed(0)}',
    );

    return Card(
      color: AppColors.surface,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Recommendations',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 12),
            ...recommendations.map(
              (rec) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Text(
                  rec,
                  style: const TextStyle(
                    fontSize: 14,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
