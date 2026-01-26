import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/uuid.dart';
import '../../data/models/budget_model.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/currency_helper.dart';
import '../../../../core/constants/app_constants.dart';
import '../../screens/budget_details_screen.dart';
import '../../../transactions/presentation/bloc/transaction_bloc.dart';
import '../../../transactions/data/datasources/local_database.dart';

class BudgetPage extends StatefulWidget {
  const BudgetPage({super.key});

  @override
  State<BudgetPage> createState() => _BudgetPageState();
}

class _BudgetPageState extends State<BudgetPage> {
  List<Budget> _budgets = [];
  String _currency = 'KSh';
  String _selectedPeriod = 'All';

  @override
  void initState() {
    super.initState();
    _loadBudgets();
    _syncBudgetsWithTransactions();
  }

  Future<void> _loadBudgets() async {
    _currency = await CurrencyHelper.getCurrency();
    final db = LocalDatabase();
    final list = await db.getBudgets();
    setState(() => _budgets = list);
  }

  Future<void> _syncBudgetsWithTransactions() async {
    final transactionBloc = context.read<TransactionBloc>();
    final state = transactionBloc.state;

    state.maybeWhen(
      loaded: (transactions) async {
        bool hasChanges = false;
        for (var i = 0; i < _budgets.length; i++) {
          final budget = _budgets[i];
          final categoryTransactions = transactions.where((t) {
            final isInPeriod =
                !t.date.isBefore(budget.startDate) &&
                !t.date.isAfter(budget.endDate);
            final isExpense = t.type.toLowerCase() == 'expense';
            final matchesCategory =
                t.category.trim().toLowerCase() ==
                budget.category.trim().toLowerCase();
            return isInPeriod && isExpense && matchesCategory;
          });

          final totalSpent = categoryTransactions.fold(
            0.0,
            (sum, t) => sum + t.amount,
          );

          if (totalSpent != budget.spent) {
            _budgets[i] = Budget(
              id: budget.id,
              category: budget.category,
              limit: budget.limit,
              spent: totalSpent,
              period: budget.period,
              startDate: budget.startDate,
              endDate: budget.endDate,
            );
            hasChanges = true;
          }
        }
        if (hasChanges) {
          await _saveBudgets();
          if (mounted) setState(() {});
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

  void _addBudget() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => SafeArea(
        child: _AddBudgetBottomSheet(
          currency: _currency,
          onSave: (budget) {
            setState(() => _budgets.add(budget));
            _saveBudgets();
          },
        ),
      ),
    );
  }

  void _updateSpent(Budget budget) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => SafeArea(
        child: _UpdateSpentBottomSheet(
          budget: budget,
          currency: _currency,
          onUpdate: (updatedBudget) {
            final index = _budgets.indexOf(budget);
            setState(() => _budgets[index] = updatedBudget);
            _saveBudgets();
          },
        ),
      ),
    );
  }

  void _deleteBudget(Budget budget) async {
    final db = LocalDatabase();
    await db.deleteBudget(budget.id);
    setState(() => _budgets.remove(budget));
  }

  @override
  Widget build(BuildContext context) {
    final filtered = _budgets
        .where((b) => _selectedPeriod == 'All' || b.period == _selectedPeriod)
        .toList();
    final totalBudget = filtered.fold(0.0, (sum, b) => sum + b.limit);
    final totalSpent = filtered.fold(0.0, (sum, b) => sum + b.spent);

    return BlocListener<TransactionBloc, TransactionState>(
      listener: (context, state) {
        state.maybeWhen(
          loaded: (_) => _syncBudgetsWithTransactions(),
          orElse: () {},
        );
      },
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          backgroundColor: AppColors.background,
          elevation: 0,
          title: const Text(
            'Budgets',
            style: TextStyle(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.bold,
            ),
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.refresh, color: AppColors.textPrimary),
              onPressed: _syncBudgetsWithTransactions,
            ),
            PopupMenuButton<String>(
              icon: const Icon(Icons.filter_list, color: AppColors.textPrimary),
              initialValue: _selectedPeriod,
              onSelected: (val) => setState(() => _selectedPeriod = val),
              color: AppColors.surface,
              itemBuilder: (context) =>
                  ['All', 'Daily', 'Weekly', 'Monthly', 'Yearly']
                      .map(
                        (p) => PopupMenuItem(
                          value: p,
                          child: Text(
                            p,
                            style: const TextStyle(
                              color: AppColors.textPrimary,
                            ),
                          ),
                        ),
                      )
                      .toList(),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: _addBudget,
          backgroundColor: AppColors.primary,
          icon: const Icon(Icons.add),
          label: const Text('New Budget'),
        ),
        body: Column(
          children: [
            if (_budgets.isNotEmpty) _buildSummaryCard(totalBudget, totalSpent),
            Expanded(
              child: filtered.isEmpty
                  ? _buildEmptyState()
                  : ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: filtered.length,
                      itemBuilder: (context, index) =>
                          _buildBudgetCard(filtered[index]),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryCard(double totalBudget, double totalSpent) {
    final progress = totalBudget > 0 ? totalSpent / totalBudget : 0.0;
    return Container(
      margin: const EdgeInsets.all(16),
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
            'Total Budget Overview',
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
                      ? AppColors.error.withOpacity(0.2)
                      : AppColors.success.withOpacity(0.2),
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
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => BudgetDetailsScreen(budget: budget),
            ),
          ),
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
                            budget.category,
                            style: const TextStyle(
                              color: AppColors.textPrimary,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '${budget.period} Budget',
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
                          onTap: () => Future.delayed(
                            Duration.zero,
                            () => _updateSpent(budget),
                          ),
                          child: const Row(
                            children: [
                              Icon(
                                Icons.edit,
                                color: AppColors.textPrimary,
                                size: 20,
                              ),
                              SizedBox(width: 12),
                              Text(
                                'Update Spent',
                                style: TextStyle(color: AppColors.textPrimary),
                              ),
                            ],
                          ),
                        ),
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
                      '$_currency ${budget.spent.toStringAsFixed(0)} / $_currency ${budget.limit.toStringAsFixed(0)}',
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
                if (budget.isOverBudget)
                  Padding(
                    padding: const EdgeInsets.only(top: 12),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.error.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.warning_rounded,
                            color: AppColors.error,
                            size: 16,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Over by $_currency ${(budget.spent - budget.limit).toStringAsFixed(0)}',
                            style: const TextStyle(
                              color: AppColors.error,
                              fontWeight: FontWeight.w600,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.account_balance_wallet_outlined,
            size: 80,
            color: AppColors.textSecondary.withOpacity(0.5),
          ),
          const SizedBox(height: 16),
          const Text(
            'No budgets yet',
            style: TextStyle(color: AppColors.textSecondary, fontSize: 18),
          ),
          const SizedBox(height: 8),
          const Text(
            'Tap the button below to create your first budget',
            style: TextStyle(color: AppColors.textSecondary, fontSize: 14),
          ),
        ],
      ),
    );
  }
}

class _AddBudgetBottomSheet extends StatefulWidget {
  final String currency;
  final Function(Budget) onSave;

  const _AddBudgetBottomSheet({required this.currency, required this.onSave});

  @override
  State<_AddBudgetBottomSheet> createState() => _AddBudgetBottomSheetState();
}

class _AddBudgetBottomSheetState extends State<_AddBudgetBottomSheet> {
  final _categoryController = TextEditingController();
  final _limitController = TextEditingController();
  String _period = 'Monthly';
  String? _selectedCategory;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Create Budget',
                    style: TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(
                      Icons.close,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              const Text(
                'Category',
                style: TextStyle(color: AppColors.textSecondary, fontSize: 14),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: AppConstants.transactionCategories.map((cat) {
                  final isSelected = _selectedCategory == cat;
                  return GestureDetector(
                    onTap: () => setState(() {
                      _selectedCategory = cat;
                      _categoryController.text = cat;
                    }),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 10,
                      ),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? AppColors.primary
                            : AppColors.surfaceLight,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        cat,
                        style: TextStyle(
                          color: isSelected
                              ? Colors.white
                              : AppColors.textPrimary,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 24),
              TextField(
                controller: _limitController,
                keyboardType: TextInputType.number,
                style: const TextStyle(color: AppColors.textPrimary),
                decoration: InputDecoration(
                  labelText: 'Budget Limit',
                  labelStyle: const TextStyle(color: AppColors.textSecondary),
                  prefixText: '${widget.currency} ',
                  prefixStyle: const TextStyle(color: AppColors.textPrimary),
                  filled: true,
                  fillColor: AppColors.surfaceLight,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Period',
                style: TextStyle(color: AppColors.textSecondary, fontSize: 14),
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: AppColors.surfaceLight,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: DropdownButton<String>(
                  value: _period,
                  isExpanded: true,
                  underline: const SizedBox(),
                  dropdownColor: AppColors.surfaceLight,
                  style: const TextStyle(color: AppColors.textPrimary),
                  items: ['Daily', 'Weekly', 'Monthly', 'Yearly']
                      .map((p) => DropdownMenuItem(value: p, child: Text(p)))
                      .toList(),
                  onChanged: (val) => setState(() => _period = val!),
                ),
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    if (_categoryController.text.isNotEmpty &&
                        _limitController.text.isNotEmpty) {
                      final now = DateTime.now();
                      final endDate = _period == 'Daily'
                          ? now.add(const Duration(days: 1))
                          : _period == 'Weekly'
                          ? now.add(const Duration(days: 7))
                          : _period == 'Monthly'
                          ? DateTime(now.year, now.month + 1, now.day)
                          : DateTime(now.year + 1, now.month, now.day);

                      widget.onSave(
                        Budget(
                          id: const Uuid().v4(),
                          category: _categoryController.text,
                          limit: double.parse(_limitController.text),
                          spent: 0,
                          period: _period,
                          startDate: now,
                          endDate: endDate,
                        ),
                      );
                      Navigator.pop(context);
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Create Budget',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _UpdateSpentBottomSheet extends StatefulWidget {
  final Budget budget;
  final String currency;
  final Function(Budget) onUpdate;

  const _UpdateSpentBottomSheet({
    required this.budget,
    required this.currency,
    required this.onUpdate,
  });

  @override
  State<_UpdateSpentBottomSheet> createState() =>
      _UpdateSpentBottomSheetState();
}

class _UpdateSpentBottomSheetState extends State<_UpdateSpentBottomSheet> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.budget.spent.toString());
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Update ${widget.budget.category}',
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close, color: AppColors.textSecondary),
                ),
              ],
            ),
            const SizedBox(height: 24),
            TextField(
              controller: _controller,
              keyboardType: TextInputType.number,
              autofocus: true,
              style: const TextStyle(color: AppColors.textPrimary),
              decoration: InputDecoration(
                labelText: 'Amount Spent',
                labelStyle: const TextStyle(color: AppColors.textSecondary),
                prefixText: '${widget.currency} ',
                prefixStyle: const TextStyle(color: AppColors.textPrimary),
                filled: true,
                fillColor: AppColors.surfaceLight,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  widget.onUpdate(
                    Budget(
                      id: widget.budget.id,
                      category: widget.budget.category,
                      limit: widget.budget.limit,
                      spent: double.parse(_controller.text),
                      period: widget.budget.period,
                      startDate: widget.budget.startDate,
                      endDate: widget.budget.endDate,
                    ),
                  );
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Update',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
