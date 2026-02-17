import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../../core/theme/app_colors.dart';
import '../../data/services/financial_advisor_service.dart';

class FinancialInsightsPage extends StatefulWidget {
  const FinancialInsightsPage({super.key});

  @override
  State<FinancialInsightsPage> createState() => _FinancialInsightsPageState();
}

class _FinancialInsightsPageState extends State<FinancialInsightsPage> {
  bool _loading = true;
  Map<String, dynamic> _nextMonthPrediction = {};
  Map<String, dynamic> _emergencyFund = {};

  @override
  void initState() {
    super.initState();
    _loadInsights();
  }

  Future<void> _loadInsights() async {
    setState(() => _loading = true);

    final prediction = await FinancialAdvisorService.predictNextMonth();
    final emergency = await FinancialAdvisorService.getEmergencyFundStatus();

    setState(() {
      _nextMonthPrediction = prediction;
      _emergencyFund = emergency;
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        title: const Text(
          'Financial Insights',
          style: TextStyle(color: AppColors.textPrimary),
        ),
      ),
      body: _loading
          ? const Center(
              child: CircularProgressIndicator(color: AppColors.primary),
            )
          : RefreshIndicator(
              onRefresh: _loadInsights,
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  _buildCanAffordChecker(),
                  const SizedBox(height: 16),
                  _buildNextMonthPrediction(),
                  const SizedBox(height: 16),
                  _buildEmergencyFundCard(),
                  const SizedBox(height: 16),
                  _buildSubscriptionSimulator(),
                ],
              ),
            ),
    );
  }

  Widget _buildCanAffordChecker() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.shopping_cart, color: AppColors.primary, size: 20),
              SizedBox(width: 8),
              Text(
                'Can I Afford This?',
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Text(
            'Check if you can afford a purchase',
            style: TextStyle(color: AppColors.textSecondary, fontSize: 14),
          ),
          const SizedBox(height: 12),
          ElevatedButton(
            onPressed: _showAffordabilityChecker,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              minimumSize: const Size(double.infinity, 44),
            ),
            child: const Text('Check Affordability'),
          ),
        ],
      ),
    );
  }

  Widget _buildNextMonthPrediction() {
    final hasShortfall = _nextMonthPrediction['hasShortfall'] ?? false;
    final endBalance = _nextMonthPrediction['projectedEndBalance'] ?? 0.0;
    final warning = _nextMonthPrediction['warning'] ?? '';

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: hasShortfall
            ? AppColors.error.withValues(alpha: 0.1)
            : AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: hasShortfall
            ? Border.all(color: AppColors.error.withValues(alpha: 0.3))
            : null,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.calendar_month, color: AppColors.warning, size: 20),
              SizedBox(width: 8),
              Text(
                'Next Month Forecast',
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            warning,
            style: TextStyle(
              color: hasShortfall ? AppColors.error : AppColors.textPrimary,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 12),
          _buildRow(
            'Current Balance',
            _nextMonthPrediction['currentBalance'] ?? 0.0,
          ),
          _buildRow(
            'Expected Income',
            _nextMonthPrediction['projectedIncome'] ?? 0.0,
          ),
          _buildRow(
            'Expected Expenses',
            _nextMonthPrediction['projectedExpenses'] ?? 0.0,
          ),
          _buildRow(
            'Upcoming Bills',
            _nextMonthPrediction['nextMonthBills'] ?? 0.0,
          ),
          const Divider(color: AppColors.border, height: 24),
          _buildRow(
            'Projected Balance',
            endBalance,
            bold: true,
            color: endBalance >= 0 ? AppColors.income : AppColors.error,
          ),
        ],
      ),
    );
  }

  Widget _buildEmergencyFundCard() {
    final monthsCovered = _emergencyFund['monthsCovered'] ?? 0.0;
    final percentComplete = _emergencyFund['percentComplete'] ?? 0.0;
    final status = _emergencyFund['status'] ?? '';

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.shield, color: AppColors.income, size: 20),
              SizedBox(width: 8),
              Text(
                'Emergency Fund',
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            status,
            style: const TextStyle(color: AppColors.textPrimary, fontSize: 14),
          ),
          const SizedBox(height: 12),
          LinearProgressIndicator(
            value: (percentComplete / 100).clamp(0.0, 1.0),
            backgroundColor: AppColors.border,
            color: monthsCovered >= 6 ? AppColors.income : AppColors.warning,
            minHeight: 8,
          ),
          const SizedBox(height: 8),
          Text(
            '${percentComplete.toStringAsFixed(0)}% of 6-month target',
            style: const TextStyle(
              color: AppColors.textSecondary,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSubscriptionSimulator() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.subscriptions, color: AppColors.primary, size: 20),
              SizedBox(width: 8),
              Text(
                'Subscription Impact',
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Text(
            'See how a new subscription affects your budget',
            style: TextStyle(color: AppColors.textSecondary, fontSize: 14),
          ),
          const SizedBox(height: 12),
          ElevatedButton(
            onPressed: _showSubscriptionSimulator,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              minimumSize: const Size(double.infinity, 44),
            ),
            child: const Text('Simulate Subscription'),
          ),
        ],
      ),
    );
  }

  Widget _buildRow(
    String label,
    double value, {
    bool bold = false,
    Color? color,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              color: AppColors.textSecondary,
              fontWeight: bold ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          Text(
            'KSh ${NumberFormat('#,##0').format(value)}',
            style: TextStyle(
              color: color ?? AppColors.textPrimary,
              fontWeight: bold ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }

  void _showAffordabilityChecker() {
    final amountController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.surface,
        title: const Text(
          'Can I Afford This?',
          style: TextStyle(color: AppColors.textPrimary),
        ),
        content: TextField(
          controller: amountController,
          keyboardType: TextInputType.number,
          style: const TextStyle(color: AppColors.textPrimary),
          decoration: const InputDecoration(
            labelText: 'Amount (KSh)',
            labelStyle: TextStyle(color: AppColors.textSecondary),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              final amount = double.tryParse(amountController.text);
              if (amount != null) {
                Navigator.pop(context);
                final result = await FinancialAdvisorService.canAfford(amount);
                _showAffordabilityResult(result);
              }
            },
            child: const Text('Check'),
          ),
        ],
      ),
    );
  }

  void _showAffordabilityResult(Map<String, dynamic> result) {
    final canAfford = result['canAfford'];
    final recommendation = result['recommendation'];

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.surface,
        title: Text(
          canAfford ? '✅ Affordable' : '❌ Not Recommended',
          style: const TextStyle(color: AppColors.textPrimary),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              recommendation,
              style: const TextStyle(
                color: AppColors.textPrimary,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 16),
            _buildRow('Current Balance', result['currentBalance']),
            _buildRow('Upcoming Bills', result['upcomingBills']),
            _buildRow('Available', result['availableAfterBills']),
            const Divider(color: AppColors.border),
            _buildRow(
              'After Purchase',
              result['remainingAfterPurchase'],
              bold: true,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _showSubscriptionSimulator() {
    final nameController = TextEditingController();
    final amountController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.surface,
        title: const Text(
          'Simulate Subscription',
          style: TextStyle(color: AppColors.textPrimary),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              style: const TextStyle(color: AppColors.textPrimary),
              decoration: const InputDecoration(
                labelText: 'Subscription Name',
                labelStyle: TextStyle(color: AppColors.textSecondary),
              ),
            ),
            TextField(
              controller: amountController,
              keyboardType: TextInputType.number,
              style: const TextStyle(color: AppColors.textPrimary),
              decoration: const InputDecoration(
                labelText: 'Monthly Amount (KSh)',
                labelStyle: TextStyle(color: AppColors.textSecondary),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              final amount = double.tryParse(amountController.text);
              if (amount != null) {
                Navigator.pop(context);
                final result =
                    await FinancialAdvisorService.simulateSubscription(
                      nameController.text,
                      amount,
                    );
                _showSubscriptionResult(result);
              }
            },
            child: const Text('Simulate'),
          ),
        ],
      ),
    );
  }

  void _showSubscriptionResult(Map<String, dynamic> result) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.surface,
        title: const Text(
          'Subscription Impact',
          style: TextStyle(color: AppColors.textPrimary),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              result['impact'],
              style: const TextStyle(
                color: AppColors.textPrimary,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 16),
            _buildRow('Monthly Income', result['avgMonthlyIncome']),
            _buildRow('Current Expenses', result['currentExpenses']),
            _buildRow('New Expenses', result['newExpenses']),
            const Divider(color: AppColors.border),
            _buildRow('Current Savings Rate', result['currentSavingsRate']),
            _buildRow('New Savings Rate', result['newSavingsRate'], bold: true),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}
