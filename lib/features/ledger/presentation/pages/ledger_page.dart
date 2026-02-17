import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:share_plus/share_plus.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../transactions/data/datasources/local_database.dart';
import '../../data/services/ledger_service.dart';
import '../../data/services/excel_export_service.dart';
import '../../domain/entities/ledger_entry.dart';

class LedgerPage extends StatefulWidget {
  const LedgerPage({super.key});

  @override
  State<LedgerPage> createState() => _LedgerPageState();
}

class _LedgerPageState extends State<LedgerPage> {
  List<LedgerEntry> _entries = [];
  List<LedgerEntry> _displayedEntries = [];
  bool _loading = true;
  bool _loadingMore = false;
  Map<String, dynamic>? _summary;
  final ScrollController _scrollController = ScrollController();
  static const int _pageSize = 50;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _loadLedger();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent * 0.9) {
      _loadMoreEntries();
    }
  }

  void _loadMoreEntries() {
    if (_loadingMore || _displayedEntries.length >= _entries.length) return;

    setState(() => _loadingMore = true);

    Future.delayed(const Duration(milliseconds: 300), () {
      final nextPage = _currentPage + 1;
      final startIndex = nextPage * _pageSize;
      final endIndex = (startIndex + _pageSize).clamp(0, _entries.length);

      if (startIndex < _entries.length) {
        setState(() {
          _displayedEntries.addAll(_entries.sublist(startIndex, endIndex));
          _currentPage = nextPage;
          _loadingMore = false;
        });
      } else {
        setState(() => _loadingMore = false);
      }
    });
  }

  Future<void> _loadLedger() async {
    setState(() => _loading = true);

    final db = LocalDatabase();
    final transactions = await db.getTransactions();

    // Generate ledger for M-Pesa account
    final entries = LedgerService.generateLedger(transactions, 'mpesa_default');
    final summary = LedgerService.getLedgerSummary(entries);

    // Load first page
    final firstPage = entries.take(_pageSize).toList();

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
        'M-Pesa',
      );
      await Share.shareXFiles([XFile(file.path)], text: 'M-Pesa Ledger Export');

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
          'M-Pesa Ledger',
          style: TextStyle(color: AppColors.textPrimary),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.file_download, color: AppColors.primary),
            onPressed: _exportLedger,
          ),
        ],
      ),
      body: _loading
          ? const Center(
              child: CircularProgressIndicator(color: AppColors.primary),
            )
          : Column(
              children: [
                if (_summary != null) _buildSummaryCard(),
                Expanded(child: _buildLedgerList()),
              ],
            ),
    );
  }

  Widget _buildSummaryCard() {
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
            AppColors.primary,
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryRow(String label, double value, Color color) {
    final currencyFormat = NumberFormat('#,##0.00');

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(color: AppColors.textSecondary)),
        Text(
          'KSh ${currencyFormat.format(value)}',
          style: TextStyle(color: color, fontWeight: FontWeight.bold),
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

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.surface,
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
        ],
      ),
    );
  }
}
