import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:share_plus/share_plus.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/classification_rules.dart';
import '../../../transactions/data/datasources/local_database.dart';
import '../../../transactions/presentation/pages/transactions_filter_page.dart';
import '../../data/services/ledger_service.dart';
import '../../data/services/excel_export_service.dart';
import '../../domain/entities/ledger_entry.dart';

class LedgerPage extends StatefulWidget {
  const LedgerPage({super.key});

  @override
  State<LedgerPage> createState() => _LedgerPageState();
}

class _LedgerPageState extends State<LedgerPage>
    with SingleTickerProviderStateMixin {
  List<LedgerEntry> _entries = [];
  List<LedgerEntry> _displayedEntries = [];
  bool _loading = true;
  bool _loadingMore = false;
  Map<String, dynamic>? _summary;
  final ScrollController _scrollController = ScrollController();
  static const int _pageSize = 50;
  int _currentPage = 0;
  String? _expandedEntryId;
  bool _bulkSelectMode = false;
  final Set<String> _selectedEntryIds = {};
  late TabController _tabController;
  int _currentTab = 0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() {
      if (_tabController.indexIsChanging) {
        setState(() => _currentTab = _tabController.index);
      }
    });
    _loadLedger();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    final filteredEntries = _getFilteredEntries();
    if (_loadingMore || _displayedEntries.length >= filteredEntries.length) {
      return;
    }

    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.position.pixels;

    if (currentScroll >= maxScroll - 100) {
      _loadMoreEntries();
    }
  }

  void _loadMoreEntries() {
    final filteredEntries = _getFilteredEntries();
    if (_loadingMore || _displayedEntries.length >= filteredEntries.length) {
      return;
    }

    setState(() => _loadingMore = true);

    final nextPage = _currentPage + 1;
    final startIndex = nextPage * _pageSize;
    final endIndex = (startIndex + _pageSize).clamp(0, filteredEntries.length);

    if (startIndex < filteredEntries.length) {
      setState(() {
        _displayedEntries.addAll(filteredEntries.sublist(startIndex, endIndex));
        _currentPage = nextPage;
        _loadingMore = false;
      });
    } else {
      setState(() => _loadingMore = false);
    }
  }

  List<LedgerEntry> _getFilteredEntries() {
    final filtered = _currentTab == 0
        ? _entries
              .where(
                (e) => e.category != 'Fees' && e.category != 'Interest & Fees',
              )
              .toList()
        : _entries
              .where(
                (e) => e.category == 'Fees' || e.category == 'Interest & Fees',
              )
              .toList();

    filtered.sort((a, b) => b.date.compareTo(a.date));
    return filtered;
  }

  Future<void> _loadLedger() async {
    setState(() => _loading = true);

    final db = LocalDatabase();
    final transactions = await db.getTransactions();

    // Generate ledger
    final entries = LedgerService.generateLedger(transactions, 'mpesa_default');
    final summary = LedgerService.getLedgerSummary(entries);

    // Load first page based on current tab
    final filteredEntries = _currentTab == 0
        ? entries
              .where(
                (e) => e.category != 'Fees' && e.category != 'Interest & Fees',
              )
              .toList()
        : entries
              .where(
                (e) => e.category == 'Fees' || e.category == 'Interest & Fees',
              )
              .toList();
    final firstPage = filteredEntries.take(_pageSize).toList();

    setState(() {
      _entries = entries;
      _displayedEntries = firstPage;
      _summary = summary;
      _currentPage = 0;
      _loading = false;
    });
  }

  Future<void> _exportLedger() async {
    try {
      final file = await ExcelExportService.exportLedgerToCSV(
        _entries,
        'Ledger',
      );
      await Share.shareXFiles([XFile(file.path)], text: 'Ledger Export');

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Ledger exported successfully')),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        title: const Text(
          'Ledger',
          style: TextStyle(color: AppColors.textPrimary),
        ),
        actions: [
          if (_bulkSelectMode) ...[
            IconButton(
              icon: const Icon(Icons.close, color: AppColors.textSecondary),
              onPressed: () => setState(() {
                _bulkSelectMode = false;
                _selectedEntryIds.clear();
              }),
            ),
          ] else ...[
            IconButton(
              icon: const Icon(Icons.checklist, color: AppColors.textSecondary),
              onPressed: () => setState(() => _bulkSelectMode = true),
            ),
            IconButton(
              icon: const Icon(
                Icons.filter_list,
                color: AppColors.textSecondary,
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const TransactionsFilterPage(),
                  ),
                );
              },
            ),
            IconButton(
              icon: const Icon(Icons.file_download, color: AppColors.primary),
              onPressed: _exportLedger,
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
                if (_summary != null) _buildSummaryCard(),
                Container(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceLight,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: TabBar(
                    controller: _tabController,
                    labelColor: AppColors.textPrimary,
                    unselectedLabelColor: AppColors.textSecondary,
                    indicator: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    indicatorSize: TabBarIndicatorSize.tab,
                    dividerColor: Colors.transparent,
                    labelStyle: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                    unselectedLabelStyle: const TextStyle(
                      fontWeight: FontWeight.normal,
                      fontSize: 14,
                    ),
                    tabs: const [
                      Tab(text: 'Transactions'),
                      Tab(text: 'Fees'),
                    ],
                    onTap: (index) {
                      setState(() {
                        _currentTab = index;
                        _currentPage = 0;
                        final filteredEntries = _getFilteredEntries();
                        _displayedEntries = filteredEntries
                            .take(_pageSize)
                            .toList();
                      });
                    },
                  ),
                ),
                if (_bulkSelectMode && _selectedEntryIds.isNotEmpty)
                  Container(
                    padding: const EdgeInsets.all(12),
                    color: AppColors.primary.withOpacity(0.1),
                    child: Text(
                      '${_selectedEntryIds.length} selected',
                      style: const TextStyle(
                        color: AppColors.primary,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                Expanded(child: _buildLedgerList()),
              ],
            ),
    );
  }

  Widget _buildSummaryCard() {
    // Get M-Pesa balance from last transaction with accountBalance
    final lastTransactionWithBalance = _entries.reversed.firstWhere(
      (e) => e.balance != 0.0,
      orElse: () => _entries.isNotEmpty
          ? _entries.last
          : LedgerEntry(
              id: '',
              transactionId: '',
              accountId: '',
              date: DateTime.now(),
              description: '',
              debit: 0,
              credit: 0,
              balance: 0,
              fee: 0,
            ),
    );
    final mpesaBalance = lastTransactionWithBalance.balance;

    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          _buildSummaryRow(
            'M-Pesa Balance',
            mpesaBalance,
            AppColors.primary,
            large: true,
          ),
          const Divider(color: AppColors.border, height: 24),
          _buildSummaryRow(
            'Total Credits',
            _summary!['totalCredits'],
            AppColors.income,
          ),
          const SizedBox(height: 8),
          _buildSummaryRow(
            'Total Debits',
            _summary!['totalDebits'],
            AppColors.expense,
          ),
          const SizedBox(height: 8),
          _buildSummaryRow(
            'Total Fees',
            _summary!['totalFees'],
            AppColors.warning,
          ),
          const Divider(color: AppColors.border, height: 24),
          _buildSummaryRow(
            'Net Balance',
            _summary!['netBalance'],
            AppColors.textPrimary,
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryRow(
    String label,
    double value,
    Color color, {
    bool large = false,
  }) {
    final currencyFormat = NumberFormat('#,##0.00');

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            color: large ? AppColors.textPrimary : AppColors.textSecondary,
            fontSize: large ? 16 : 14,
            fontWeight: large ? FontWeight.bold : FontWeight.normal,
          ),
        ),
        Text(
          'KSh ${currencyFormat.format(value)}',
          style: TextStyle(
            color: color,
            fontWeight: FontWeight.bold,
            fontSize: large ? 20 : 14,
          ),
        ),
      ],
    );
  }

  Widget _buildLedgerList() {
    if (_displayedEntries.isEmpty) {
      return const Center(
        child: Text(
          'No ledger entries',
          style: TextStyle(color: AppColors.textSecondary),
        ),
      );
    }

    return ListView.builder(
      controller: _scrollController,
      itemCount: _displayedEntries.length + (_loadingMore ? 1 : 0),
      itemBuilder: (context, index) {
        if (index == _displayedEntries.length) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: CircularProgressIndicator(color: AppColors.primary),
            ),
          );
        }
        final entry = _displayedEntries[index];
        return _buildLedgerEntry(entry);
      },
    );
  }

  Widget _buildLedgerEntry(LedgerEntry entry) {
    final dateFormat = DateFormat('MMM dd, yyyy HH:mm');
    final currencyFormat = NumberFormat('#,##0.00');
    final isExpanded = _expandedEntryId == entry.transactionId;
    final isSelected = _selectedEntryIds.contains(entry.transactionId);

    return GestureDetector(
      onTap: () {
        if (_bulkSelectMode) {
          setState(() {
            if (isSelected) {
              _selectedEntryIds.remove(entry.transactionId);
            } else {
              _selectedEntryIds.add(entry.transactionId);
            }
          });
        } else {
          setState(() {
            _expandedEntryId = isExpanded ? null : entry.transactionId;
          });
        }
      },
      onLongPress: () {
        if (!_bulkSelectMode) {
          setState(() {
            _bulkSelectMode = true;
            _selectedEntryIds.add(entry.transactionId);
          });
        }
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primary.withOpacity(0.15)
              : AppColors.surface,
          border: isSelected
              ? Border.all(color: AppColors.primary, width: 2)
              : null,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    entry.description,
                    style: const TextStyle(color: AppColors.textPrimary),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Text(
                  'KSh ${currencyFormat.format(entry.balance)}',
                  style: const TextStyle(
                    color: AppColors.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  dateFormat.format(entry.date),
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 12,
                  ),
                ),
                Row(
                  children: [
                    if (entry.debit > 0)
                      Text(
                        'DR: ${currencyFormat.format(entry.debit)}',
                        style: const TextStyle(
                          color: AppColors.expense,
                          fontSize: 12,
                        ),
                      ),
                    if (entry.credit > 0)
                      Text(
                        'CR: ${currencyFormat.format(entry.credit)}',
                        style: const TextStyle(
                          color: AppColors.income,
                          fontSize: 12,
                        ),
                      ),
                    if (entry.fee > 0) ...[
                      const SizedBox(width: 8),
                      Text(
                        'Fee: ${currencyFormat.format(entry.fee)}',
                        style: const TextStyle(
                          color: AppColors.warning,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            ),
            if (entry.category != null) ...[
              const SizedBox(height: 4),
              Text(
                entry.category!,
                style: const TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 11,
                ),
              ),
            ],
            if (isExpanded) ...[
              const Divider(color: AppColors.border, height: 24),
              if (entry.reference != null &&
                  _isValidMpesaCode(entry.reference!))
                _buildDetailRow('Reference', entry.reference!),
              _buildDetailRow(
                'M-Pesa Balance',
                'KSh ${currencyFormat.format(entry.balance)}',
              ),
              if (entry.debit > 0)
                _buildDetailRow(
                  'Debit',
                  'KSh ${currencyFormat.format(entry.debit)}',
                ),
              if (entry.credit > 0)
                _buildDetailRow(
                  'Credit',
                  'KSh ${currencyFormat.format(entry.credit)}',
                ),
              if (entry.fee > 0)
                _buildDetailRow(
                  'Fee',
                  'KSh ${currencyFormat.format(entry.fee)}',
                ),
              _buildDetailRow('Date & Time', dateFormat.format(entry.date)),
              if (entry.category != null)
                GestureDetector(
                  onTap: () => _showCategoryPicker(context, entry),
                  child: Container(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Category',
                          style: TextStyle(
                            color: AppColors.textSecondary,
                            fontSize: 13,
                          ),
                        ),
                        Row(
                          children: [
                            Text(
                              entry.category!,
                              style: const TextStyle(
                                color: AppColors.textPrimary,
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(width: 4),
                            const Icon(
                              Icons.edit,
                              color: AppColors.primary,
                              size: 14,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ],
        ),
      ),
    );
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

  bool _isValidMpesaCode(String code) {
    // M-Pesa codes are 10 characters, all uppercase letters and numbers
    return code.length == 10 && RegExp(r'^[A-Z0-9]{10}$').hasMatch(code);
  }

  void _showCategoryPicker(BuildContext context, LedgerEntry entry) async {
    final categories = {
      'Food & Dining': Icons.restaurant,
      'Shopping': Icons.shopping_bag,
      'Transportation': Icons.directions_car,
      'Bills & Utilities': Icons.receipt_long,
      'Entertainment': Icons.movie,
      'Airtime & Data': Icons.phone_android,
      'Mobile Money': Icons.account_balance_wallet,
      'Family & Friends': Icons.people,
      'Investments': Icons.trending_up,
      'Other': Icons.category,
    };

    final selected = await showModalBottomSheet<String>(
      context: context,
      backgroundColor: AppColors.surface,
      builder: (context) => SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Padding(
              padding: EdgeInsets.all(16),
              child: Text(
                'Select Category',
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 2,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                childAspectRatio: 2.5,
                children: categories.entries
                    .map(
                      (entry) => GestureDetector(
                        onTap: () => Navigator.pop(context, entry.key),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.surfaceLight,
                            borderRadius: BorderRadius.circular(12),
                            border: entry.key == entry.key
                                ? Border.all(
                                    color: AppColors.primary.withOpacity(0.3),
                                  )
                                : null,
                          ),
                          child: Row(
                            children: [
                              Icon(
                                entry.value,
                                color: AppColors.primary,
                                size: 20,
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  entry.key,
                                  style: const TextStyle(
                                    color: AppColors.textPrimary,
                                    fontSize: 12,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    )
                    .toList(),
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );

    if (selected != null) {
      final db = LocalDatabase();
      final transactions = await db.getTransactions();
      final currentTxn = transactions.firstWhere(
        (t) => t.id == entry.transactionId,
      );

      if (currentTxn.counterparty != null &&
          currentTxn.counterparty!.isNotEmpty) {
        // Save classification rule
        await _saveClassificationRule(currentTxn.counterparty!, selected);

        // Update all transactions with same counterparty
        for (var txn in transactions) {
          if (txn.counterparty == currentTxn.counterparty) {
            await db.updateTransaction(txn.id, {'category': selected});
          }
        }
      } else {
        await db.updateTransaction(entry.transactionId, {'category': selected});
      }

      _loadLedger();
    }
  }

  Future<void> _saveClassificationRule(
    String counterparty,
    String category,
  ) async {
    final rules = await ClassificationRules.load();
    final updated = Map<String, List<String>>.from(rules.categoryKeywords);

    if (!updated.containsKey(category)) {
      updated[category] = [];
    }

    if (!updated[category]!.contains(counterparty.toLowerCase())) {
      updated[category]!.add(counterparty.toLowerCase());
    }

    final newRules = ClassificationRules(
      incomeKeywords: rules.incomeKeywords,
      expenseKeywords: rules.expenseKeywords,
      transferKeywords: rules.transferKeywords,
      failureKeywords: rules.failureKeywords,
      categoryKeywords: updated,
    );

    await newRules.save();
  }
}
