import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/models/budget_model.dart';
import '../../services/smart_budget_service.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/currency_helper.dart';
import '../../../transactions/presentation/bloc/transaction_bloc.dart';
import '../../../transactions/data/datasources/local_database.dart';

class EnhancedBudgetPage extends StatefulWidget {
  const EnhancedBudgetPage({super.key});

  @override
  State<EnhancedBudgetPage> createState() => _EnhancedBudgetPageState();
}

class _EnhancedBudgetPageState extends State<EnhancedBudgetPage>
    with SingleTickerProviderStateMixin {
  List<Budget> _budgets = [];
  String _currency = 'KSh';
  final String _filter = 'All';
  late TabController _tabController;
  final _smartService = SmartBudgetService();
  int _healthScore = 0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _loadBudgets();
    _syncBudgets();
  }

  Future<void> _loadBudgets() async {
    _currency = await CurrencyHelper.getCurrency();
    final db = LocalDatabase();
    final list = await db.getBudgets();
    setState(() {
      _budgets = list;
      _calculateHealth();
    });
  }

  void _calculateHealth() {
    final transactionBloc = context.read<TransactionBloc>();
    transactionBloc.state.maybeWhen(
      loaded: (transactions) {
        final income = transactions
            .where((t) => t.type.toLowerCase() == 'income')
            .fold(0.0, (sum, t) => sum + t.amount);
        _healthScore = _smartService.calculateBudgetHealth(_budgets, income);
      },
      orElse: () {},
    );
  }

  Future<void> _syncBudgets() async {
    final transactionBloc = context.read<TransactionBloc>();
    transactionBloc.state.maybeWhen(
      loaded: (transactions) async {
        bool hasChanges = false;
        for (var i = 0; i < _budgets.length; i++) {
          final budget = _budgets[i];
          final categoryTxns = transactions.where((t) {
            final inPeriod =
                !t.date.isBefore(budget.startDate) &&
                !t.date.isAfter(budget.endDate);
            final isExpense = t.type.toLowerCase() == 'expense';
            final matches =
                t.category.trim().toLowerCase() ==
                budget.category!.trim().toLowerCase();
            return inPeriod && isExpense && matches;
          }).toList();

          final totalSpent = categoryTxns.fold(0.0, (sum, t) => sum + t.amount);
          final predicted = _smartService.predictMonthlySpending(budget);

          if (totalSpent != budget.spent) {
            _budgets[i] = budget.copyWith(
              spent: totalSpent,
              predictedSpending: predicted,
            );
            hasChanges = true;
          }
        }
        if (hasChanges) {
          await _saveBudgets();
          if (mounted) setState(() => _calculateHealth());
        }
      },
      orElse: () {},
    );
  }

  Future<void> _saveBudgets() async {
    final db = LocalDatabase();
    for (var budget in _budgets) {
      await db.insertBudget(budget);
    }
  }

  void _showSmartOnboarding() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => SmartBudgetOnboarding(onComplete: _loadBudgets),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final filtered = _budgets
        .where((b) => _filter == 'All' || b.type == _filter.toLowerCase())
        .toList();

    return BlocListener<TransactionBloc, TransactionState>(
      listener: (context, state) {
        state.maybeWhen(loaded: (_) => _syncBudgets(), orElse: () {});
      },
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          backgroundColor: AppColors.background,
          elevation: 0,
          title: const Text(
            'Smart Budgets',
            style: TextStyle(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.bold,
            ),
          ),
          bottom: TabBar(
            controller: _tabController,
            indicatorColor: AppColors.primary,
            labelColor: AppColors.primary,
            unselectedLabelColor: AppColors.textSecondary,
            tabs: const [
              Tab(text: 'Overview'),
              Tab(text: 'Budgets'),
              Tab(text: 'Projects'),
              Tab(text: 'Insights'),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: _budgets.isEmpty ? _showSmartOnboarding : _addBudget,
          backgroundColor: AppColors.primary,
          icon: const Icon(Icons.add),
          label: Text(_budgets.isEmpty ? 'Get Started' : 'New Budget'),
        ),
        body: TabBarView(
          controller: _tabController,
          children: [
            _buildOverviewTab(filtered),
            _buildBudgetsTab(filtered),
            _buildProjectsTab(),
            _buildInsightsTab(),
          ],
        ),
      ),
    );
  }

  Widget _buildOverviewTab(List<Budget> budgets) {
    if (budgets.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.account_balance_wallet_outlined,
              size: 80,
              color: AppColors.textSecondary.withValues(alpha: 0.5),
            ),
            const SizedBox(height: 16),
            const Text(
              'No budgets yet',
              style: TextStyle(color: AppColors.textSecondary, fontSize: 18),
            ),
            const SizedBox(height: 8),
            const Text(
              'Tap "Get Started" for smart setup',
              style: TextStyle(color: AppColors.textSecondary, fontSize: 14),
            ),
          ],
        ),
      );
    }

    final totalBudget = budgets.fold(0.0, (sum, b) => sum + b.amount);
    final totalSpent = budgets.fold(0.0, (sum, b) => sum + b.spent);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          _buildHealthCard(),
          const SizedBox(height: 16),
          _buildSummaryCard(totalBudget, totalSpent),
          const SizedBox(height: 16),
          ...budgets
              .take(3)
              .map(
                (b) => Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: _buildBudgetCard(b),
                ),
              ),
        ],
      ),
    );
  }

  Widget _buildHealthCard() {
    final color = _healthScore >= 75
        ? AppColors.success
        : _healthScore >= 60
        ? AppColors.warning
        : AppColors.error;
    final status = _healthScore >= 75
        ? 'Excellent'
        : _healthScore >= 60
        ? 'Good'
        : 'Needs Work';

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [color.withValues(alpha: 0.2), color.withValues(alpha: 0.1)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.2),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                '$_healthScore',
                style: TextStyle(
                  color: color,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Budget Health',
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 14,
                  ),
                ),
                Text(
                  status,
                  style: TextStyle(
                    color: color,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryCard(double totalBudget, double totalSpent) {
    final progress = totalBudget > 0 ? totalSpent / totalBudget : 0.0;
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.cardGradientStart, AppColors.cardGradientEnd],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Total Budget',
            style: TextStyle(color: AppColors.textSecondary, fontSize: 14),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '$_currency ${totalSpent.toStringAsFixed(0)}',
                    style: const TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'of $_currency ${totalBudget.toStringAsFixed(0)}',
                    style: const TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: progress >= 1.0
                      ? AppColors.error.withValues(alpha: 0.2)
                      : AppColors.success.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  '${(progress * 100).toStringAsFixed(0)}%',
                  style: TextStyle(
                    color: progress >= 1.0
                        ? AppColors.error
                        : AppColors.success,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: progress > 1.0 ? 1.0 : progress,
              backgroundColor: AppColors.surfaceLight,
              color: progress >= 1.0
                  ? AppColors.error
                  : progress >= 0.8
                  ? AppColors.warning
                  : AppColors.success,
              minHeight: 8,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBudgetsTab(List<Budget> budgets) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: budgets.length,
      itemBuilder: (context, index) => _buildBudgetCard(budgets[index]),
    );
  }

  Widget _buildProjectsTab() {
    final projects = _budgets.where((b) => b.isProject).toList();
    if (projects.isEmpty) {
      return Center(
        child: Text(
          'No projects yet',
          style: TextStyle(color: AppColors.textSecondary),
        ),
      );
    }
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: projects.length,
      itemBuilder: (context, index) => _buildBudgetCard(projects[index]),
    );
  }

  Widget _buildInsightsTab() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Text('Coming Soon', style: TextStyle(color: AppColors.textSecondary)),
      ],
    );
  }

  Widget _buildBudgetCard(Budget budget) {
    final progress = budget.percentage / 100;
    final color = budget.isOverBudget
        ? AppColors.error
        : progress >= 0.8
        ? AppColors.warning
        : AppColors.success;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () {},
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            budget.name,
                            style: const TextStyle(
                              color: AppColors.textPrimary,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '${budget.period} • ${budget.daysLeft} days left',
                            style: const TextStyle(
                              color: AppColors.textSecondary,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                    PopupMenuButton(
                      icon: const Icon(
                        Icons.more_vert,
                        color: AppColors.textSecondary,
                      ),
                      color: AppColors.surfaceLight,
                      itemBuilder: (context) => [
                        PopupMenuItem(
                          onTap: () => _deleteBudget(budget),
                          child: const Row(
                            children: [
                              Icon(
                                Icons.delete,
                                color: AppColors.error,
                                size: 20,
                              ),
                              SizedBox(width: 12),
                              Text(
                                'Delete',
                                style: TextStyle(color: AppColors.error),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: LinearProgressIndicator(
                    value: progress > 1.0 ? 1.0 : progress,
                    backgroundColor: AppColors.surfaceLight,
                    color: color,
                    minHeight: 8,
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '$_currency ${budget.spent.toStringAsFixed(0)} / $_currency ${budget.amount.toStringAsFixed(0)}',
                      style: const TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 14,
                      ),
                    ),
                    Text(
                      '${budget.percentage.toStringAsFixed(0)}%',
                      style: TextStyle(
                        color: color,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
                if (budget.dailyBudget > 0) ...[
                  const SizedBox(height: 8),
                  Text(
                    'Daily budget: $_currency ${budget.dailyBudget.toStringAsFixed(0)}',
                    style: const TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 12,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _addBudget() {
    // Simple add for now
  }

  void _deleteBudget(Budget budget) async {
    final db = LocalDatabase();
    await db.deleteBudget(budget.id);
    _loadBudgets();
  }
}

class SmartBudgetOnboarding extends StatelessWidget {
  final VoidCallback onComplete;

  const SmartBudgetOnboarding({super.key, required this.onComplete});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        title: const Text(
          'Smart Budget Setup',
          style: TextStyle(color: AppColors.textPrimary),
        ),
      ),
      body: Center(
        child: Text(
          'Onboarding Coming Soon',
          style: TextStyle(color: AppColors.textSecondary),
        ),
      ),
    );
  }
}
