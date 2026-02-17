import 'dart:developer' as developer;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nest/features/bills/presentation/pages/bills_page.dart';
import 'package:nest/features/transactions/presentation/pages/transactions_page.dart';
import 'package:nest/features/transactions/presentation/pages/import_transactions_page.dart';
import '../../../transactions/presentation/bloc/transaction_bloc.dart';
import '../../../ledger/presentation/pages/ledger_page.dart';
import '../../../../core/utils/financial_stats_calculator.dart';
import '../../../../core/theme/app_colors.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../sms_parser/presentation/bloc/sms_sync_bloc.dart';
import '../../../../core/utils/currency_helper.dart';
import '../../../transactions/data/datasources/local_database.dart';
import '../../../bills/presentation/widgets/bill_suggestions_dialog.dart';

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
          extendBodyBehindAppBar: false,
          body: AnnotatedRegion<SystemUiOverlayStyle>(
            value: const SystemUiOverlayStyle(
              statusBarColor: Colors.transparent,
              statusBarIconBrightness: Brightness.light,
            ),
            child: SafeArea(
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
                      child: CircularProgressIndicator(
                        color: AppColors.primary,
                      ),
                    ),
                    loaded: (transactions) {
                      return FutureBuilder<FinancialStats>(
                        future: FinancialStatsCalculator.calculate(
                          transactions,
                        ),
                        builder: (context, snapshot) {
                          if (!snapshot.hasData) {
                            return const Center(
                              child: CircularProgressIndicator(
                                color: AppColors.primary,
                              ),
                            );
                          }

                          final stats = snapshot.data!;

                          return RefreshIndicator(
                            onRefresh: () => _syncSms(context),
                            color: AppColors.primary,
                            child: CustomScrollView(
                              slivers: [
                                SliverAppBar(
                                  pinned: true,
                                  backgroundColor: AppColors.background,
                                  elevation: 0,
                                  toolbarHeight: 80,
                                  automaticallyImplyLeading: false,
                                  flexibleSpace: Padding(
                                    padding: const EdgeInsets.fromLTRB(
                                      20,
                                      20,
                                      20,
                                      10,
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        const Text(
                                          'Dashboard',
                                          style: TextStyle(
                                            color: AppColors.textPrimary,
                                            fontSize: 28,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        IconButton(
                                          icon: const Icon(
                                            Icons.add_circle_rounded,
                                            color: AppColors.primary,
                                            size: 28,
                                          ),
                                          onPressed: () =>
                                              _showAddTransactionDialog(
                                                context,
                                              ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                SliverToBoxAdapter(
                                  child: Padding(
                                    padding: const EdgeInsets.all(20),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
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
                                                'Fees',
                                                _calculateTotalFees(
                                                  transactions,
                                                ),
                                                AppColors.error,
                                                Icons.receipt_rounded,
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
                                        _buildUpcomingBillsWidget(),
                                        const SizedBox(height: 16),
                                        _buildRecentTransactions(
                                          transactions,
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
          ),
        );
      },
    );
  }

  void _showAddTransactionDialog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => AddTransactionBottomSheet(
        onImportTap: () {
          Navigator.pop(context);
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            backgroundColor: Colors.transparent,
            builder: (_) => const ImportTransactionsBottomSheet(),
          ).then((imported) {
            if (imported != null && context.mounted) {
              context.read<TransactionBloc>().add(
                const TransactionEvent.loadTransactions(),
              );
            }
          });
        },
      ),
    );
  }

  Future<void> _syncSms(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    final daysBack = prefs.getInt('sms_days_back') ?? 30;

    final localDb = LocalDatabase();
    await localDb.removeDuplicateTransactions();
    if (!context.mounted) return;

    context.read<TransactionBloc>().add(
      const TransactionEvent.loadTransactions(),
    );
    context.read<SmsSyncBloc>().add(SmsSyncEvent.syncSms(daysBack: daysBack));

    await Future.delayed(const Duration(seconds: 2));
    await localDb.removeDuplicateTransactions();

    if (!context.mounted) return;

    context.read<TransactionBloc>().add(
      const TransactionEvent.loadTransactions(),
    );

    // Show bill suggestions after sync
    final transactions = await localDb.getTransactions();
    if (context.mounted) {
      BillSuggestionsDialog.show(context, transactions);
    }
  }

  double _calculateTotalFees(List<dynamic> transactions) {
    final total = transactions.fold<double>(0.0, (sum, t) => sum + t.fee);
    developer.log(
      'Total fees calculated: $total from ${transactions.length} transactions',
    );
    return total;
  }

  Widget _buildUpcomingBillsWidget() {
    return FutureBuilder<Map<String, dynamic>>(
      future: _getUpcomingBills(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return const SizedBox.shrink();

        final data = snapshot.data!;
        final upcomingCount = data['upcomingCount'] ?? 0;
        final totalAmount = data['totalUpcoming'] ?? 0.0;

        if (upcomingCount == 0) return const SizedBox.shrink();

        return GestureDetector(
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const BillsPage()),
          ),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.warning.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.receipt_long,
                    color: AppColors.warning,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '$upcomingCount Bills Due Soon',
                        style: const TextStyle(
                          color: AppColors.textPrimary,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'Total: KSh ${totalAmount.toStringAsFixed(0)}',
                        style: const TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
                const Icon(Icons.chevron_right, color: AppColors.textSecondary),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<Map<String, dynamic>> _getUpcomingBills() async {
    final db = LocalDatabase();
    final bills = await db.getBills();
    final now = DateTime.now();
    final next7Days = now.add(const Duration(days: 7));

    int upcomingCount = 0;
    double totalUpcoming = 0.0;

    for (var bill in bills) {
      if (bill['status'] == 'paid') continue;
      final dueDate = DateTime.parse(bill['dueDate']);
      if (dueDate.isAfter(now) && dueDate.isBefore(next7Days)) {
        upcomingCount++;
        totalUpcoming += bill['amount'] as double;
      }
    }

    return {'upcomingCount': upcomingCount, 'totalUpcoming': totalUpcoming};
  }

  Widget _buildBalanceCard(double balance, String currency) {
    return Container(
      width: double.infinity,
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

  Widget _buildRecentTransactions(List<dynamic> transactions, String currency) {
    final recent = transactions.take(5).toList();
    if (recent.isEmpty) return const SizedBox.shrink();

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
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Recent Transactions',
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Builder(
                builder: (context) => GestureDetector(
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const LedgerPage()),
                  ),
                  child: const Text(
                    'View More',
                    style: TextStyle(
                      color: AppColors.primary,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ...recent.map(
            (t) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: t.type == 'income'
                          ? AppColors.income.withOpacity(0.2)
                          : AppColors.expense.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      t.type == 'income'
                          ? Icons.arrow_downward
                          : Icons.arrow_upward,
                      color: t.type == 'income'
                          ? AppColors.income
                          : AppColors.expense,
                      size: 16,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          t.description,
                          style: const TextStyle(
                            color: AppColors.textPrimary,
                            fontSize: 14,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          '${t.date.day}/${t.date.month}/${t.date.year}',
                          style: const TextStyle(
                            color: AppColors.textSecondary,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    '${t.type == 'income' ? '+' : '-'}$currency ${t.amount.toStringAsFixed(0)}',
                    style: TextStyle(
                      color: t.type == 'income'
                          ? AppColors.income
                          : AppColors.expense,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
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
}
