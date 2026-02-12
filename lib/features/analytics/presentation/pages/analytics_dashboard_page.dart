import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../transactions/data/datasources/local_database.dart';
import '../../../accounts/data/services/account_aggregation_service.dart';
import '../../data/services/transaction_analytics.dart';

class AnalyticsDashboardPage extends StatefulWidget {
  const AnalyticsDashboardPage({super.key});

  @override
  State<AnalyticsDashboardPage> createState() => _AnalyticsDashboardPageState();
}

class _AnalyticsDashboardPageState extends State<AnalyticsDashboardPage> {
  bool _loading = true;
  Map<String, dynamic> _aggregation = {};
  Map<String, dynamic> _topMerchants = {};
  List<Map<String, dynamic>> _recurring = [];
  Map<String, dynamic> _paymentMethods = {};
  Map<String, dynamic> _dailyLimit = {};
  List _failed = [];
  List _international = [];
  Map<String, dynamic> _p2p = {};

  @override
  void initState() {
    super.initState();
    _loadAnalytics();
  }

  Future<void> _loadAnalytics() async {
    setState(() => _loading = true);
    
    final db = LocalDatabase();
    final transactions = await db.getTransactions();
    
    final aggregation = await AccountAggregationService.getAggregatedBalances();
    final topMerchants = TransactionAnalytics.getTopMerchants(transactions);
    final recurring = TransactionAnalytics.detectRecurringPayments(transactions);
    final paymentMethods = TransactionAnalytics.getPaymentMethodBreakdown(transactions);
    final dailyLimit = TransactionAnalytics.getDailyLimitUsage(transactions);
    final failed = TransactionAnalytics.getFailedTransactions(transactions);
    final international = TransactionAnalytics.getInternationalTransactions(transactions);
    final p2p = TransactionAnalytics.getP2PLending(transactions);
    
    setState(() {
      _aggregation = aggregation;
      _topMerchants = topMerchants;
      _recurring = recurring;
      _paymentMethods = paymentMethods;
      _dailyLimit = dailyLimit;
      _failed = failed;
      _international = international;
      _p2p = p2p;
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        title: const Text('Analytics', style: TextStyle(color: AppColors.textPrimary)),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator(color: AppColors.primary))
          : RefreshIndicator(
              onRefresh: _loadAnalytics,
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  _buildAggregationCard(),
                  const SizedBox(height: 16),
                  _buildDailyLimitCard(),
                  const SizedBox(height: 16),
                  _buildTopMerchantsCard(),
                  const SizedBox(height: 16),
                  _buildRecurringPaymentsCard(),
                  const SizedBox(height: 16),
                  _buildPaymentMethodsCard(),
                  const SizedBox(height: 16),
                  if (_failed.isNotEmpty) _buildFailedTransactionsCard(),
                  if (_failed.isNotEmpty) const SizedBox(height: 16),
                  if (_international.isNotEmpty) _buildInternationalCard(),
                  if (_international.isNotEmpty) const SizedBox(height: 16),
                  _buildP2PLendingCard(),
                ],
              ),
            ),
    );
  }

  Widget _buildAggregationCard() {
    final fmt = NumberFormat('#,##0.00');
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Total Balances', style: TextStyle(color: AppColors.textPrimary, fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          _buildRow('Cash', _aggregation['totalCash'] ?? 0.0, AppColors.income, fmt),
          _buildRow('Investments', _aggregation['totalInvestments'] ?? 0.0, AppColors.primary, fmt),
          _buildRow('Debt', _aggregation['totalDebt'] ?? 0.0, AppColors.error, fmt),
          const Divider(color: AppColors.border, height: 24),
          _buildRow('Net Worth', _aggregation['netWorth'] ?? 0.0, AppColors.textPrimary, fmt, bold: true),
        ],
      ),
    );
  }

  Widget _buildDailyLimitCard() {
    final fmt = NumberFormat('#,##0.00');
    final percentage = _dailyLimit['percentage'] ?? 0.0;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Daily Transaction Limit', style: TextStyle(color: AppColors.textPrimary, fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          Text('KSh ${fmt.format(_dailyLimit['used'] ?? 0)} / ${fmt.format(_dailyLimit['limit'] ?? 0)}', 
            style: const TextStyle(color: AppColors.textSecondary)),
          const SizedBox(height: 8),
          LinearProgressIndicator(
            value: percentage / 100,
            backgroundColor: AppColors.border,
            color: percentage > 80 ? AppColors.error : AppColors.primary,
          ),
          const SizedBox(height: 8),
          Text('${percentage.toStringAsFixed(1)}% used', style: const TextStyle(color: AppColors.textSecondary, fontSize: 12)),
        ],
      ),
    );
  }

  Widget _buildTopMerchantsCard() {
    final merchants = _topMerchants['merchants'] ?? [];
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Top Merchants', style: TextStyle(color: AppColors.textPrimary, fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          if (merchants.isEmpty)
            const Text('No merchant data', style: TextStyle(color: AppColors.textSecondary))
          else
            ...merchants.map((m) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(child: Text(m['name'], style: const TextStyle(color: AppColors.textPrimary))),
                  Text('${m['count']}x • KSh ${NumberFormat('#,##0').format(m['total'])}', 
                    style: const TextStyle(color: AppColors.textSecondary, fontSize: 12)),
                ],
              ),
            )),
        ],
      ),
    );
  }

  Widget _buildRecurringPaymentsCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Recurring Payments', style: TextStyle(color: AppColors.textPrimary, fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          if (_recurring.isEmpty)
            const Text('No recurring payments detected', style: TextStyle(color: AppColors.textSecondary))
          else
            ..._recurring.map((r) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(r['merchant'], style: const TextStyle(color: AppColors.textPrimary)),
                  Text('${r['frequency']} • ~KSh ${NumberFormat('#,##0').format(r['avgAmount'])}', 
                    style: const TextStyle(color: AppColors.textSecondary, fontSize: 12)),
                ],
              ),
            )),
        ],
      ),
    );
  }

  Widget _buildPaymentMethodsCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Payment Methods', style: TextStyle(color: AppColors.textPrimary, fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          ..._paymentMethods.entries.map((e) => Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(e.key, style: const TextStyle(color: AppColors.textPrimary)),
                Text('${e.value['count']}x • KSh ${NumberFormat('#,##0').format(e.value['total'])}', 
                  style: const TextStyle(color: AppColors.textSecondary, fontSize: 12)),
              ],
            ),
          )),
        ],
      ),
    );
  }

  Widget _buildFailedTransactionsCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.warning, color: AppColors.warning, size: 20),
              const SizedBox(width: 8),
              Text('Failed Transactions (${_failed.length})', 
                style: const TextStyle(color: AppColors.textPrimary, fontSize: 18, fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 12),
          ..._failed.take(3).map((t) => Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Text(t.description, 
              style: const TextStyle(color: AppColors.textSecondary, fontSize: 12),
              maxLines: 2,
              overflow: TextOverflow.ellipsis),
          )),
        ],
      ),
    );
  }

  Widget _buildInternationalCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('International Transactions (${_international.length})', 
            style: const TextStyle(color: AppColors.textPrimary, fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          ..._international.take(3).map((t) => Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Text('KSh ${NumberFormat('#,##0').format(t.amount)} - ${t.description}', 
              style: const TextStyle(color: AppColors.textSecondary, fontSize: 12),
              maxLines: 1,
              overflow: TextOverflow.ellipsis),
          )),
        ],
      ),
    );
  }

  Widget _buildP2PLendingCard() {
    final lending = _p2p['lending'] ?? {};
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Money Sent to People', style: TextStyle(color: AppColors.textPrimary, fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          if (lending.isEmpty)
            const Text('No P2P transactions', style: TextStyle(color: AppColors.textSecondary))
          else
            ...lending.entries.take(5).map((e) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(child: Text(e.key, style: const TextStyle(color: AppColors.textPrimary))),
                  Text('KSh ${NumberFormat('#,##0').format(e.value['total'])}', 
                    style: const TextStyle(color: AppColors.textSecondary, fontSize: 12)),
                ],
              ),
            )),
        ],
      ),
    );
  }

  Widget _buildRow(String label, double value, Color color, NumberFormat fmt, {bool bold = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(color: AppColors.textSecondary, fontWeight: bold ? FontWeight.bold : FontWeight.normal)),
          Text('KSh ${fmt.format(value)}', 
            style: TextStyle(color: color, fontWeight: bold ? FontWeight.bold : FontWeight.normal)),
        ],
      ),
    );
  }
}
