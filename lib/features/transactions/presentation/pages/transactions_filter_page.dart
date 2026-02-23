import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:share_plus/share_plus.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/utils/transaction_description_helper.dart';
import '../../data/datasources/local_database.dart';
import '../../data/services/transaction_export_service.dart';
import '../../domain/entities/transaction.dart';

class TransactionsFilterPage extends StatefulWidget {
  const TransactionsFilterPage({super.key});

  @override
  State<TransactionsFilterPage> createState() => _TransactionsFilterPageState();
}

class _TransactionsFilterPageState extends State<TransactionsFilterPage> {
  final _db = LocalDatabase();
  final _searchController = TextEditingController();
  List<Transaction> _allTransactions = [];
  List<Transaction> _filteredTransactions = [];
  List<Map<String, dynamic>> _accounts = [];

  final Set<String> _selectedCategories = {};
  final Set<String> _selectedTypes = {};
  final Set<String> _selectedPaymentMethods = {};
  DateTimeRange? _dateRange;
  double? _minAmount;
  double? _maxAmount;
  String _sortBy = 'date_desc';
  bool _loading = true;
  String? _expandedTransactionId;
  bool _showStatistics = true;
  bool _bulkSelectMode = false;
  final Set<String> _selectedTransactionIds = {};
  bool _showChart = false;
  bool _showFilters = false;

  @override
  void initState() {
    super.initState();
    _loadTransactions();
  }

  Future<void> _loadTransactions() async {
    final transactions = await _db.getTransactions();
    final accounts = await _db.getAccounts();
    setState(() {
      _allTransactions = transactions;
      _filteredTransactions = transactions;
      _accounts = accounts;
      _loading = false;
    });
  }

  void _applyFilters() {
    var filtered = _allTransactions.where((t) {
      if (_searchController.text.isNotEmpty &&
          !t.description.toLowerCase().contains(
            _searchController.text.toLowerCase(),
          )) {
        return false;
      }
      if (_selectedCategories.isNotEmpty &&
          !_selectedCategories.contains(t.category)) {
        return false;
      }
      if (_selectedTypes.isNotEmpty && !_selectedTypes.contains(t.type)) {
        return false;
      }
      if (_selectedPaymentMethods.isNotEmpty && t.accountId != null) {
        if (!_selectedPaymentMethods.contains(t.accountId)) return false;
      }
      if (_dateRange != null &&
          (t.date.isBefore(_dateRange!.start) ||
              t.date.isAfter(_dateRange!.end.add(const Duration(days: 1))))) {
        return false;
      }
      if (_minAmount != null && t.amount < _minAmount!) return false;
      if (_maxAmount != null && t.amount > _maxAmount!) return false;
      return true;
    }).toList();

    switch (_sortBy) {
      case 'date_desc':
        filtered.sort((a, b) => b.date.compareTo(a.date));
        break;
      case 'date_asc':
        filtered.sort((a, b) => a.date.compareTo(b.date));
        break;
      case 'amount_desc':
        filtered.sort((a, b) => b.amount.compareTo(a.amount));
        break;
      case 'amount_asc':
        filtered.sort((a, b) => a.amount.compareTo(b.amount));
        break;
    }

    setState(() => _filteredTransactions = filtered);
  }

  void _clearFilters() {
    setState(() {
      _searchController.clear();
      _selectedCategories.clear();
      _selectedTypes.clear();
      _selectedPaymentMethods.clear();
      _dateRange = null;
      _minAmount = null;
      _maxAmount = null;
      _sortBy = 'date_desc';
      _filteredTransactions = _allTransactions;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        title: const Text(
          'Filter Transactions',
          style: TextStyle(color: AppColors.textPrimary),
        ),
        iconTheme: const IconThemeData(color: AppColors.textPrimary),
        actions: [
          if (_bulkSelectMode) ...[
            IconButton(
              icon: const Icon(Icons.delete, color: AppColors.error),
              onPressed: _bulkDelete,
            ),
            IconButton(
              icon: const Icon(Icons.category, color: AppColors.textSecondary),
              onPressed: _bulkChangeCategory,
            ),
            IconButton(
              icon: const Icon(Icons.close, color: AppColors.textSecondary),
              onPressed: () => setState(() {
                _bulkSelectMode = false;
                _selectedTransactionIds.clear();
              }),
            ),
          ] else ...[
            IconButton(
              icon: Icon(
                _showChart ? Icons.list : Icons.show_chart,
                color: AppColors.textSecondary,
              ),
              onPressed: () => setState(() => _showChart = !_showChart),
            ),
            IconButton(
              icon: const Icon(Icons.bar_chart, color: AppColors.textSecondary),
              onPressed: () =>
                  setState(() => _showStatistics = !_showStatistics),
            ),
            IconButton(
              icon: const Icon(Icons.checklist, color: AppColors.textSecondary),
              onPressed: () => setState(() => _bulkSelectMode = true),
            ),
            IconButton(
              icon: const Icon(Icons.file_download, color: AppColors.primary),
              onPressed: _exportTransactions,
            ),
            if (_hasActiveFilters())
              TextButton(
                onPressed: _clearFilters,
                child: const Text(
                  'Clear',
                  style: TextStyle(color: AppColors.primary),
                ),
              ),
          ],
        ],
      ),
      body: _loading
          ? const Center(
              child: CircularProgressIndicator(color: AppColors.primary),
            )
          : Column(
              children: [
                _buildSearchAndFilterBar(),
                if (_showStatistics && _filteredTransactions.isNotEmpty)
                  _buildStatistics(),
                if (_showChart && _filteredTransactions.isNotEmpty)
                  _buildChart(),
                if (_bulkSelectMode && _selectedTransactionIds.isNotEmpty)
                  Container(
                    padding: const EdgeInsets.all(12),
                    color: AppColors.primary.withOpacity(0.1),
                    child: Text(
                      '${_selectedTransactionIds.length} selected',
                      style: const TextStyle(
                        color: AppColors.primary,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                Expanded(
                  child: _filteredTransactions.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.search_off,
                                size: 64,
                                color: AppColors.textSecondary.withOpacity(0.5),
                              ),
                              const SizedBox(height: 16),
                              const Text(
                                'No transactions found',
                                style: TextStyle(
                                  color: AppColors.textSecondary,
                                ),
                              ),
                            ],
                          ),
                        )
                      : ListView.builder(
                          padding: const EdgeInsets.all(16),
                          itemCount: _filteredTransactions.length,
                          itemBuilder: (context, index) {
                            final t = _filteredTransactions[index];
                            final isExpanded = _expandedTransactionId == t.id;
                            final isSelected = _selectedTransactionIds.contains(
                              t.id,
                            );

                            return Slidable(
                              key: Key(t.id),
                              endActionPane: ActionPane(
                                motion: const ScrollMotion(),
                                children: [
                                  SlidableAction(
                                    onPressed: (_) => _editTransaction(t),
                                    backgroundColor: AppColors.primary,
                                    foregroundColor: Colors.white,
                                    icon: Icons.edit,
                                    label: 'Edit',
                                  ),
                                  SlidableAction(
                                    onPressed: (_) => _deleteTransaction(t.id),
                                    backgroundColor: AppColors.error,
                                    foregroundColor: Colors.white,
                                    icon: Icons.delete,
                                    label: 'Delete',
                                  ),
                                ],
                              ),
                              child: GestureDetector(
                                onTap: () {
                                  if (_bulkSelectMode) {
                                    setState(() {
                                      if (isSelected) {
                                        _selectedTransactionIds.remove(t.id);
                                      } else {
                                        _selectedTransactionIds.add(t.id);
                                      }
                                    });
                                  } else {
                                    setState(() {
                                      _expandedTransactionId = isExpanded
                                          ? null
                                          : t.id;
                                    });
                                  }
                                },
                                onLongPress: () {
                                  if (!_bulkSelectMode) {
                                    setState(() {
                                      _bulkSelectMode = true;
                                      _selectedTransactionIds.add(t.id);
                                    });
                                  }
                                },
                                child: AnimatedContainer(
                                  duration: const Duration(milliseconds: 300),
                                  curve: Curves.easeInOut,
                                  margin: const EdgeInsets.only(bottom: 12),
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: isSelected
                                        ? AppColors.primary.withOpacity(0.15)
                                        : AppColors.surface,
                                    border: isSelected
                                        ? Border.all(
                                            color: AppColors.primary,
                                            width: 2,
                                          )
                                        : null,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Column(
                                    children: [
                                      Row(
                                        children: [
                                          Container(
                                            padding: const EdgeInsets.all(8),
                                            decoration: BoxDecoration(
                                              color: t.type == 'income'
                                                  ? AppColors.income
                                                        .withOpacity(0.2)
                                                  : AppColors.expense
                                                        .withOpacity(0.2),
                                              borderRadius:
                                                  BorderRadius.circular(8),
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
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  TransactionDescriptionHelper.getCleanDescription(
                                                    t.description,
                                                    t.counterparty,
                                                    t.type,
                                                  ),
                                                  style: const TextStyle(
                                                    color:
                                                        AppColors.textPrimary,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                                Text(
                                                  '${t.category} • ${DateFormat('MMM dd, yyyy').format(t.date)}',
                                                  style: const TextStyle(
                                                    color:
                                                        AppColors.textSecondary,
                                                    fontSize: 12,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Text(
                                            'KSh ${t.amount.toStringAsFixed(0)}',
                                            style: TextStyle(
                                              color: t.type == 'income'
                                                  ? AppColors.income
                                                  : AppColors.expense,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                      if (isExpanded) ...[
                                        const Divider(
                                          color: AppColors.border,
                                          height: 24,
                                        ),
                                        if (t.transactionId != null &&
                                            t.transactionId!.length == 10)
                                          _buildDetailRow(
                                            'Transaction ID',
                                            t.transactionId!,
                                          ),
                                        _buildDetailRow(
                                          'Type',
                                          t.type.toUpperCase(),
                                        ),
                                        _buildDetailRow('Category', t.category),
                                        _buildDetailRow(
                                          'Date',
                                          DateFormat(
                                            'MMM dd, yyyy HH:mm',
                                          ).format(t.date),
                                        ),
                                        _buildDetailRow(
                                          'Amount',
                                          'KSh ${t.amount.toStringAsFixed(2)}',
                                        ),
                                        if (t.fee > 0)
                                          _buildDetailRow(
                                            'Fee',
                                            'KSh ${t.fee.toStringAsFixed(2)}',
                                          ),
                                        if (t.accountId != null)
                                          _buildDetailRow(
                                            'Account',
                                            _getAccountName(t.accountId!),
                                          ),
                                      ],
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                ),
              ],
            ),
    );
  }

  Widget _buildSearchAndFilterBar() {
    return Container(
      padding: const EdgeInsets.all(16),
      color: AppColors.surface,
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _searchController,
                  style: const TextStyle(color: AppColors.textPrimary),
                  decoration: InputDecoration(
                    hintText: 'Search...',
                    hintStyle: const TextStyle(color: AppColors.textSecondary),
                    prefixIcon: const Icon(
                      Icons.search,
                      color: AppColors.textSecondary,
                      size: 20,
                    ),
                    filled: true,
                    fillColor: AppColors.surfaceLight,
                    contentPadding: const EdgeInsets.symmetric(vertical: 12),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  onChanged: (_) => _applyFilters(),
                ),
              ),
              const SizedBox(width: 8),
              IconButton(
                icon: Icon(
                  _showFilters ? Icons.filter_list_off : Icons.filter_list,
                  color: _hasActiveFilters()
                      ? AppColors.primary
                      : AppColors.textSecondary,
                ),
                onPressed: () => setState(() => _showFilters = !_showFilters),
              ),
            ],
          ),
          if (_showFilters) ...[
            const SizedBox(height: 12),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _buildQuickDateChip('Today', () => _applyQuickDate(0)),
                  _buildQuickDateChip('Week', () => _applyQuickDate(7)),
                  _buildQuickDateChip('Month', () => _applyQuickDate(30)),
                  _buildQuickDateChip('Year', () => _applyQuickDate(365)),
                ],
              ),
            ),
            const SizedBox(height: 8),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _buildFilterChip(
                    'Categories',
                    Icons.category,
                    _selectedCategories.isNotEmpty,
                    _showCategoryFilter,
                  ),
                  _buildFilterChip(
                    'Type',
                    Icons.swap_horiz,
                    _selectedTypes.isNotEmpty,
                    _showTypeFilter,
                  ),
                  _buildFilterChip(
                    'Payment',
                    Icons.payment,
                    _selectedPaymentMethods.isNotEmpty,
                    _showPaymentFilter,
                  ),
                  _buildFilterChip(
                    'Date',
                    Icons.calendar_today,
                    _dateRange != null,
                    _showDatePicker,
                  ),
                  _buildFilterChip(
                    'Amount',
                    Icons.attach_money,
                    _minAmount != null || _maxAmount != null,
                    _showAmountPicker,
                  ),
                  _buildFilterChip('Sort', Icons.sort, false, _showSortOptions),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildFilterChip(
    String label,
    IconData icon,
    bool active,
    VoidCallback onTap,
  ) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: FilterChip(
        label: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 16,
              color: active ? Colors.white : AppColors.textSecondary,
            ),
            const SizedBox(width: 4),
            Text(
              label,
              style: TextStyle(
                color: active ? Colors.white : AppColors.textPrimary,
                fontSize: 12,
              ),
            ),
          ],
        ),
        selected: active,
        selectedColor: AppColors.primary,
        backgroundColor: AppColors.surfaceLight,
        onSelected: (_) => onTap(),
      ),
    );
  }

  void _showCategoryFilter() {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => StatefulBuilder(
        builder: (context, setModalState) => Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Filter by Category',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 16),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: AppConstants.transactionCategories.map((cat) {
                  final selected = _selectedCategories.contains(cat);
                  return FilterChip(
                    label: Text(cat),
                    selected: selected,
                    selectedColor: AppColors.primary,
                    backgroundColor: AppColors.surfaceLight,
                    labelStyle: TextStyle(
                      color: selected ? Colors.white : AppColors.textPrimary,
                    ),
                    onSelected: (value) {
                      setModalState(() {
                        if (value) {
                          _selectedCategories.add(cat);
                        } else {
                          _selectedCategories.remove(cat);
                        }
                      });
                      setState(() {});
                      _applyFilters();
                    },
                  );
                }).toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showTypeFilter() {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => StatefulBuilder(
        builder: (context, setModalState) => Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Filter by Type',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 16),
              CheckboxListTile(
                title: const Row(
                  children: [
                    Icon(
                      Icons.arrow_downward,
                      color: AppColors.income,
                      size: 20,
                    ),
                    SizedBox(width: 8),
                    Text(
                      'Income',
                      style: TextStyle(color: AppColors.textPrimary),
                    ),
                  ],
                ),
                value: _selectedTypes.contains('income'),
                activeColor: AppColors.primary,
                onChanged: (value) {
                  setModalState(() {
                    if (value!) {
                      _selectedTypes.add('income');
                    } else {
                      _selectedTypes.remove('income');
                    }
                  });
                  setState(() {});
                  _applyFilters();
                },
              ),
              CheckboxListTile(
                title: const Row(
                  children: [
                    Icon(
                      Icons.arrow_upward,
                      color: AppColors.expense,
                      size: 20,
                    ),
                    SizedBox(width: 8),
                    Text(
                      'Expense',
                      style: TextStyle(color: AppColors.textPrimary),
                    ),
                  ],
                ),
                value: _selectedTypes.contains('expense'),
                activeColor: AppColors.primary,
                onChanged: (value) {
                  setModalState(() {
                    if (value!) {
                      _selectedTypes.add('expense');
                    } else {
                      _selectedTypes.remove('expense');
                    }
                  });
                  setState(() {});
                  _applyFilters();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _showDatePicker() async {
    final range = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      initialDateRange: _dateRange,
      builder: (context, child) => Theme(
        data: ThemeData.dark().copyWith(
          colorScheme: const ColorScheme.dark(
            primary: AppColors.primary,
            surface: AppColors.surface,
          ),
        ),
        child: child!,
      ),
    );
    if (range != null) {
      setState(() => _dateRange = range);
      _applyFilters();
    }
  }

  void _showAmountPicker() {
    final minController = TextEditingController(
      text: _minAmount?.toString() ?? '',
    );
    final maxController = TextEditingController(
      text: _maxAmount?.toString() ?? '',
    );
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surface,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          left: 16,
          right: 16,
          top: 16,
          bottom: MediaQuery.of(context).viewInsets.bottom + 16,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Filter by Amount',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: minController,
              keyboardType: TextInputType.number,
              style: const TextStyle(color: AppColors.textPrimary),
              decoration: InputDecoration(
                labelText: 'Minimum Amount',
                labelStyle: const TextStyle(color: AppColors.textSecondary),
                filled: true,
                fillColor: AppColors.surfaceLight,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: maxController,
              keyboardType: TextInputType.number,
              style: const TextStyle(color: AppColors.textPrimary),
              decoration: InputDecoration(
                labelText: 'Maximum Amount',
                labelStyle: const TextStyle(color: AppColors.textSecondary),
                filled: true,
                fillColor: AppColors.surfaceLight,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  setState(() {
                    _minAmount = double.tryParse(minController.text);
                    _maxAmount = double.tryParse(maxController.text);
                  });
                  _applyFilters();
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
                  'Apply',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showPaymentFilter() {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => StatefulBuilder(
        builder: (context, setModalState) => Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Filter by Payment Method',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 16),
              ..._accounts.map((account) {
                final selected = _selectedPaymentMethods.contains(
                  account['id'],
                );
                return CheckboxListTile(
                  title: Text(
                    account['name'] as String,
                    style: const TextStyle(color: AppColors.textPrimary),
                  ),
                  value: selected,
                  activeColor: AppColors.primary,
                  onChanged: (value) {
                    setModalState(() {
                      if (value!) {
                        _selectedPaymentMethods.add(account['id'] as String);
                      } else {
                        _selectedPaymentMethods.remove(account['id']);
                      }
                    });
                    setState(() {});
                    _applyFilters();
                  },
                );
              }),
            ],
          ),
        ),
      ),
    );
  }

  void _showSortOptions() {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Sort By',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 16),
            RadioListTile<String>(
              title: const Text(
                'Date (Newest First)',
                style: TextStyle(color: AppColors.textPrimary),
              ),
              value: 'date_desc',
              groupValue: _sortBy,
              activeColor: AppColors.primary,
              onChanged: (value) {
                setState(() => _sortBy = value!);
                _applyFilters();
                Navigator.pop(context);
              },
            ),
            RadioListTile<String>(
              title: const Text(
                'Date (Oldest First)',
                style: TextStyle(color: AppColors.textPrimary),
              ),
              value: 'date_asc',
              groupValue: _sortBy,
              activeColor: AppColors.primary,
              onChanged: (value) {
                setState(() => _sortBy = value!);
                _applyFilters();
                Navigator.pop(context);
              },
            ),
            RadioListTile<String>(
              title: const Text(
                'Amount (Highest First)',
                style: TextStyle(color: AppColors.textPrimary),
              ),
              value: 'amount_desc',
              groupValue: _sortBy,
              activeColor: AppColors.primary,
              onChanged: (value) {
                setState(() => _sortBy = value!);
                _applyFilters();
                Navigator.pop(context);
              },
            ),
            RadioListTile<String>(
              title: const Text(
                'Amount (Lowest First)',
                style: TextStyle(color: AppColors.textPrimary),
              ),
              value: 'amount_asc',
              groupValue: _sortBy,
              activeColor: AppColors.primary,
              onChanged: (value) {
                setState(() => _sortBy = value!);
                _applyFilters();
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  bool _hasActiveFilters() {
    return _searchController.text.isNotEmpty ||
        _selectedCategories.isNotEmpty ||
        _selectedTypes.isNotEmpty ||
        _selectedPaymentMethods.isNotEmpty ||
        _dateRange != null ||
        _minAmount != null ||
        _maxAmount != null;
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              color: AppColors.textSecondary,
              fontSize: 13,
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              color: AppColors.textPrimary,
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  String _getAccountName(String accountId) {
    final account = _accounts.firstWhere(
      (a) => a['id'] == accountId,
      orElse: () => {'name': 'Unknown'},
    );
    return account['name'] as String;
  }

  Future<void> _exportTransactions() async {
    try {
      final file = await TransactionExportService.exportTransactionsToCSV(
        _filteredTransactions,
        'Filtered Results',
      );
      await Share.shareXFiles([XFile(file.path)], text: 'Transactions Export');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Transactions exported successfully')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Export failed: $e')));
      }
    }
  }

  void _applyQuickDate(int days) {
    final now = DateTime.now();
    setState(() {
      if (days == 0) {
        _dateRange = DateTimeRange(
          start: DateTime(now.year, now.month, now.day),
          end: now,
        );
      } else {
        _dateRange = DateTimeRange(
          start: now.subtract(Duration(days: days)),
          end: now,
        );
      }
    });
    _applyFilters();
  }

  Widget _buildQuickDateChip(String label, VoidCallback onTap) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: ActionChip(
        label: Text(label, style: const TextStyle(fontSize: 12)),
        backgroundColor: AppColors.surfaceLight,
        labelStyle: const TextStyle(color: AppColors.textPrimary),
        onPressed: onTap,
      ),
    );
  }

  Widget _buildStatistics() {
    final income = _filteredTransactions
        .where((t) => t.type == 'income')
        .fold(0.0, (sum, t) => sum + t.amount);
    final expense = _filteredTransactions
        .where((t) => t.type == 'expense')
        .fold(0.0, (sum, t) => sum + t.amount);
    final avgAmount = _filteredTransactions.isEmpty
        ? 0.0
        : (_filteredTransactions.fold(0.0, (sum, t) => sum + t.amount) /
              _filteredTransactions.length);
    final categoryCount = <String, int>{};
    for (var t in _filteredTransactions) {
      categoryCount[t.category] = (categoryCount[t.category] ?? 0) + 1;
    }
    final topCategory = categoryCount.entries.isEmpty
        ? 'N/A'
        : categoryCount.entries.reduce((a, b) => a.value > b.value ? a : b).key;

    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Statistics',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _buildStatItem(
                  'Count',
                  '${_filteredTransactions.length}',
                  Icons.receipt,
                ),
              ),
              Expanded(
                child: _buildStatItem(
                  'Income',
                  'KSh ${income.toStringAsFixed(0)}',
                  Icons.arrow_downward,
                  AppColors.income,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: _buildStatItem(
                  'Expense',
                  'KSh ${expense.toStringAsFixed(0)}',
                  Icons.arrow_upward,
                  AppColors.expense,
                ),
              ),
              Expanded(
                child: _buildStatItem(
                  'Average',
                  'KSh ${avgAmount.toStringAsFixed(0)}',
                  Icons.analytics,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          _buildStatItem('Top Category', topCategory, Icons.category),
        ],
      ),
    );
  }

  Widget _buildStatItem(
    String label,
    String value,
    IconData icon, [
    Color? color,
  ]) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: AppColors.surfaceLight,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(icon, size: 16, color: color ?? AppColors.textSecondary),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 10,
                    color: AppColors.textSecondary,
                  ),
                ),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: color ?? AppColors.textPrimary,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _bulkDelete() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.surface,
        title: const Text(
          'Delete Transactions',
          style: TextStyle(color: AppColors.textPrimary),
        ),
        content: Text(
          'Delete ${_selectedTransactionIds.length} transactions?',
          style: const TextStyle(color: AppColors.textSecondary),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text(
              'Delete',
              style: TextStyle(color: AppColors.error),
            ),
          ),
        ],
      ),
    );
    if (confirm == true) {
      await _db.bulkDeleteTransactions(_selectedTransactionIds.toList());
      await _loadTransactions();
      setState(() {
        _bulkSelectMode = false;
        _selectedTransactionIds.clear();
      });
      _applyFilters();
    }
  }

  Future<void> _bulkChangeCategory() async {
    final category = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.surface,
        title: const Text(
          'Change Category',
          style: TextStyle(color: AppColors.textPrimary),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: AppConstants.transactionCategories
              .map(
                (cat) => ListTile(
                  title: Text(
                    cat,
                    style: const TextStyle(color: AppColors.textPrimary),
                  ),
                  onTap: () => Navigator.pop(context, cat),
                ),
              )
              .toList(),
        ),
      ),
    );
    if (category != null) {
      await _db.bulkUpdateCategory(_selectedTransactionIds.toList(), category);
      await _loadTransactions();
      setState(() {
        _bulkSelectMode = false;
        _selectedTransactionIds.clear();
      });
      _applyFilters();
    }
  }

  Future<void> _deleteTransaction(String id) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.surface,
        title: const Text(
          'Delete Transaction',
          style: TextStyle(color: AppColors.textPrimary),
        ),
        content: const Text(
          'Are you sure?',
          style: TextStyle(color: AppColors.textSecondary),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text(
              'Delete',
              style: TextStyle(color: AppColors.error),
            ),
          ),
        ],
      ),
    );
    if (confirm == true) {
      await _db.deleteTransaction(id);
      await _loadTransactions();
      _applyFilters();
    }
  }

  void _editTransaction(Transaction t) {
    final categoryController = TextEditingController(text: t.category);
    final notesController = TextEditingController(text: t.notes ?? '');

    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surface,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          left: 16,
          right: 16,
          top: 16,
          bottom: MediaQuery.of(context).viewInsets.bottom + 16,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Edit Transaction',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: t.category,
              dropdownColor: AppColors.surfaceLight,
              decoration: InputDecoration(
                labelText: 'Category',
                labelStyle: const TextStyle(color: AppColors.textSecondary),
                filled: true,
                fillColor: AppColors.surfaceLight,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
              items: AppConstants.transactionCategories
                  .map(
                    (cat) => DropdownMenuItem(
                      value: cat,
                      child: Text(
                        cat,
                        style: const TextStyle(color: AppColors.textPrimary),
                      ),
                    ),
                  )
                  .toList(),
              onChanged: (value) => categoryController.text = value!,
            ),
            const SizedBox(height: 12),
            TextField(
              controller: notesController,
              style: const TextStyle(color: AppColors.textPrimary),
              maxLines: 3,
              decoration: InputDecoration(
                labelText: 'Notes',
                labelStyle: const TextStyle(color: AppColors.textSecondary),
                filled: true,
                fillColor: AppColors.surfaceLight,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () async {
                  await _db.updateTransaction(t.id, {
                    'category': categoryController.text,
                    'notes': notesController.text,
                  });
                  await _loadTransactions();
                  _applyFilters();
                  if (context.mounted) Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Save',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChart() {
    final dailyData = <DateTime, double>{};
    for (var t in _filteredTransactions) {
      final day = DateTime(t.date.year, t.date.month, t.date.day);
      dailyData[day] =
          (dailyData[day] ?? 0) + (t.type == 'expense' ? t.amount : 0);
    }

    final sortedDays = dailyData.keys.toList()..sort();
    if (sortedDays.isEmpty) return const SizedBox.shrink();

    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      height: 200,
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Daily Spending',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: BarChart(
              BarChartData(
                alignment: BarChartAlignment.spaceAround,
                maxY: dailyData.values.isEmpty
                    ? 100
                    : dailyData.values.reduce((a, b) => a > b ? a : b) * 1.2,
                barTouchData: BarTouchData(enabled: false),
                titlesData: FlTitlesData(
                  show: true,
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        if (value.toInt() >= sortedDays.length) {
                          return const Text('');
                        }
                        final date = sortedDays[value.toInt()];
                        return Text(
                          DateFormat('dd').format(date),
                          style: const TextStyle(
                            color: AppColors.textSecondary,
                            fontSize: 10,
                          ),
                        );
                      },
                    ),
                  ),
                  leftTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  topTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  rightTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                ),
                gridData: const FlGridData(show: false),
                borderData: FlBorderData(show: false),
                barGroups: sortedDays.asMap().entries.map((entry) {
                  return BarChartGroupData(
                    x: entry.key,
                    barRods: [
                      BarChartRodData(
                        toY: dailyData[entry.value] ?? 0,
                        color: AppColors.expense,
                        width: 16,
                        borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(4),
                        ),
                      ),
                    ],
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
