import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';
import 'dart:convert';
import '../../../../core/theme/app_colors.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../transactions/presentation/bloc/transaction_bloc.dart';
import '../../../transactions/domain/entities/transaction.dart' as domain;

class DebtManagementPage extends StatefulWidget {
  const DebtManagementPage({super.key});

  @override
  State<DebtManagementPage> createState() => _DebtManagementPageState();
}

class _DebtManagementPageState extends State<DebtManagementPage> {
  List<Map<String, dynamic>> _debts = [];

  @override
  void initState() {
    super.initState();
    _loadDebts();
  }

  Future<void> _loadDebts() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString('debts') ?? '[]';
    setState(() {
      _debts = List<Map<String, dynamic>>.from(jsonDecode(data));
    });
  }

  Future<void> _saveDebts() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('debts', jsonEncode(_debts));
  }

  double get totalDebt => _debts
      .where((d) => d['isActive'] == true)
      .fold(0.0, (sum, d) => sum + (d['remainingAmount'] as double));

  double get totalInterest =>
      _debts.where((d) => d['isActive'] == true).fold(0.0, (sum, d) {
        final remaining = d['remainingAmount'] as double;
        final rate = d['interestRate'] as double;
        final period = (d['interestPeriod'] as String?) ?? 'yearly';
        final months = d['remainingMonths'] as int;

        if (period == 'monthly') {
          return sum + (remaining * rate / 100 * months);
        } else if (period == 'yearly') {
          return sum + (remaining * rate / 100 * months / 12);
        } else {
          return sum + (remaining * rate / 100);
        }
      });

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
          'Debt Manager',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.add_circle_rounded,
              color: AppColors.primary,
              size: 28,
            ),
            onPressed: _addDebt,
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [
                    AppColors.cardGradientStart,
                    AppColors.cardGradientEnd,
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Total Debt',
                            style: TextStyle(
                              color: AppColors.textSecondary,
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'KSh ${totalDebt.toStringAsFixed(2)}',
                            style: const TextStyle(
                              color: AppColors.error,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          const Text(
                            'Total Interest',
                            style: TextStyle(
                              color: AppColors.textSecondary,
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'KSh ${totalInterest.toStringAsFixed(2)}',
                            style: const TextStyle(
                              color: AppColors.warning,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: _debts.isEmpty
                  ? Center(
                      child: Text(
                        'No debts tracked',
                        style: TextStyle(color: AppColors.textSecondary),
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      itemCount: _debts.length,
                      itemBuilder: (context, index) {
                        final debt = _debts[index];
                        final remaining = debt['remainingAmount'] as double;
                        final rate = debt['interestRate'] as double;
                        final period =
                            debt['interestPeriod'] as String? ?? 'yearly';
                        final months = debt['remainingMonths'] as int;

                        double interest;
                        if (period == 'monthly') {
                          interest = remaining * rate / 100 * months;
                        } else if (period == 'yearly') {
                          interest = remaining * rate / 100 * months / 12;
                        } else {
                          interest = remaining * rate / 100;
                        }
                        return Container(
                          margin: const EdgeInsets.only(bottom: 12),
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: AppColors.surface,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          debt['name'],
                                          style: const TextStyle(
                                            color: AppColors.textPrimary,
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        if (debt['creditor'] != null &&
                                            (debt['creditor'] as String)
                                                .isNotEmpty)
                                          Text(
                                            debt['creditor'],
                                            style: const TextStyle(
                                              color: AppColors.textSecondary,
                                              fontSize: 12,
                                            ),
                                          ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 4,
                                    ),
                                    decoration: BoxDecoration(
                                      color: debt['isActive']
                                          ? AppColors.error.withOpacity(0.1)
                                          : AppColors.success.withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Text(
                                      debt['isActive'] ? 'Active' : 'Paid',
                                      style: TextStyle(
                                        color: debt['isActive']
                                            ? AppColors.error
                                            : AppColors.success,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),
                              Row(
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const Text(
                                          'Remaining',
                                          style: TextStyle(
                                            color: AppColors.textSecondary,
                                            fontSize: 12,
                                          ),
                                        ),
                                        Text(
                                          'KSh ${debt['remainingAmount'].toStringAsFixed(0)}',
                                          style: const TextStyle(
                                            color: AppColors.textPrimary,
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const Text(
                                          'Total Paid',
                                          style: TextStyle(
                                            color: AppColors.textSecondary,
                                            fontSize: 12,
                                          ),
                                        ),
                                        Text(
                                          'KSh ${(debt['totalPaid'] ?? 0.0).toStringAsFixed(0)}',
                                          style: const TextStyle(
                                            color: AppColors.success,
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),
                              Row(
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const Text(
                                          'Total Expected',
                                          style: TextStyle(
                                            color: AppColors.textSecondary,
                                            fontSize: 12,
                                          ),
                                        ),
                                        Text(
                                          'KSh ${(((debt['originalAmount'] ?? debt['remainingAmount']) as double) + interest).toStringAsFixed(0)}',
                                          style: const TextStyle(
                                            color: AppColors.warning,
                                            fontSize: 14,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const Text(
                                          'Interest Rate',
                                          style: TextStyle(
                                            color: AppColors.textSecondary,
                                            fontSize: 12,
                                          ),
                                        ),
                                        Text(
                                          '${debt['interestRate']}% ${debt['interestPeriod'] ?? 'yearly'}',
                                          style: const TextStyle(
                                            color: AppColors.textSecondary,
                                            fontSize: 14,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  if (debt['isActive'])
                                    TextButton(
                                      onPressed: () => _recordPayment(index),
                                      child: const Text(
                                        'Record Payment',
                                        style: TextStyle(
                                          color: AppColors.success,
                                        ),
                                      ),
                                    ),
                                  if ((debt['payments'] as List?)?.isNotEmpty ??
                                      false)
                                    TextButton(
                                      onPressed: () =>
                                          _viewPaymentHistory(index),
                                      child: const Text(
                                        'History',
                                        style: TextStyle(
                                          color: AppColors.primary,
                                        ),
                                      ),
                                    ),
                                  TextButton(
                                    onPressed: () => _editDebt(index),
                                    child: const Text(
                                      'Edit',
                                      style: TextStyle(
                                        color: AppColors.primary,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  void _addDebt() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => DebtBottomSheet(
        onSave: (debt) async {
          setState(() => _debts.add(debt));
          _saveDebts();

          // Add as transaction
          final transaction = domain.Transaction(
            id: const Uuid().v4(),
            amount: debt['originalAmount'] as double,
            category: 'Loans',
            description:
                'Debt taken: ${debt['name']} from ${debt['creditor'] ?? 'Unknown'}',
            date: DateTime.now(),
            type: 'income',
          );
          if (context.mounted) {
            context.read<TransactionBloc>().add(
              TransactionEvent.addTransaction(transaction),
            );
          }
        },
      ),
    );
  }

  void _editDebt(int index) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => DebtBottomSheet(
        debt: _debts[index],
        onSave: (debt) {
          setState(() => _debts[index] = debt);
          _saveDebts();
        },
        onDelete: () {
          setState(() => _debts.removeAt(index));
          _saveDebts();
        },
      ),
    );
  }

  void _recordPayment(int index) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => PaymentBottomSheet(
        debt: _debts[index],
        onSave: (amount, channel) async {
          setState(() {
            final debt = _debts[index];
            final remaining = debt['remainingAmount'] as double;
            final totalPaid = (debt['totalPaid'] ?? 0.0) as double;
            final payments = List<Map<String, dynamic>>.from(
              debt['payments'] ?? [],
            );

            payments.add({
              'amount': amount,
              'date': DateTime.now().toIso8601String(),
              'channel': channel,
            });

            debt['payments'] = payments;
            debt['totalPaid'] = totalPaid + amount;
            debt['remainingAmount'] = remaining - amount;

            if (debt['remainingAmount'] <= 0) {
              debt['remainingAmount'] = 0.0;
              debt['isActive'] = false;
            }
          });
          _saveDebts();

          // Add as transaction
          final transaction = domain.Transaction(
            id: const Uuid().v4(),
            amount: amount,
            category: 'Loans',
            description: 'Debt payment: ${_debts[index]['name']} via $channel',
            date: DateTime.now(),
            type: 'expense',
          );
          if (context.mounted) {
            context.read<TransactionBloc>().add(
              TransactionEvent.addTransaction(transaction),
            );
          }
        },
      ),
    );
  }

  void _viewPaymentHistory(int index) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => PaymentHistoryBottomSheet(debt: _debts[index]),
    );
  }

  void _markAsPaid(int index) {
    setState(() {
      _debts[index]['isActive'] = !_debts[index]['isActive'];
    });
    _saveDebts();
  }
}

class DebtBottomSheet extends StatefulWidget {
  final Map<String, dynamic>? debt;
  final Function(Map<String, dynamic>) onSave;
  final VoidCallback? onDelete;

  const DebtBottomSheet({
    super.key,
    this.debt,
    required this.onSave,
    this.onDelete,
  });

  @override
  State<DebtBottomSheet> createState() => _DebtBottomSheetState();
}

class _DebtBottomSheetState extends State<DebtBottomSheet> {
  late final TextEditingController nameController;
  late final TextEditingController creditorController;
  late final TextEditingController amountController;
  late final TextEditingController interestController;
  late final TextEditingController monthsController;
  late String interestPeriod;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.debt?['name'] ?? '');
    creditorController = TextEditingController(
      text: widget.debt?['creditor'] ?? '',
    );
    amountController = TextEditingController(
      text: widget.debt?['remainingAmount']?.toString() ?? '',
    );
    interestController = TextEditingController(
      text: widget.debt?['interestRate']?.toString() ?? '',
    );
    monthsController = TextEditingController(
      text: widget.debt?['remainingMonths']?.toString() ?? '',
    );
    interestPeriod = widget.debt?['interestPeriod'] ?? 'yearly';
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        decoration: const BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom + 16,
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: AppColors.textSecondary.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  widget.debt == null ? 'Add Debt' : 'Edit Debt',
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 24),
                TextField(
                  controller: nameController,
                  style: const TextStyle(color: AppColors.textPrimary),
                  decoration: InputDecoration(
                    labelText: 'Debt Name',
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
                TextField(
                  controller: creditorController,
                  style: const TextStyle(color: AppColors.textPrimary),
                  decoration: InputDecoration(
                    labelText: 'Creditor (Person/Institution)',
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
                TextField(
                  controller: amountController,
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 18,
                  ),
                  decoration: InputDecoration(
                    labelText: 'Principal Amount',
                    labelStyle: const TextStyle(color: AppColors.textSecondary),
                    prefixText: 'KSh ',
                    prefixStyle: const TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 18,
                    ),
                    filled: true,
                    fillColor: AppColors.surfaceLight,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: interestController,
                  style: const TextStyle(color: AppColors.textPrimary),
                  decoration: InputDecoration(
                    labelText: 'Interest Rate (%)',
                    labelStyle: const TextStyle(color: AppColors.textSecondary),
                    suffixText: '%',
                    filled: true,
                    fillColor: AppColors.surfaceLight,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  value: interestPeriod,
                  dropdownColor: AppColors.surfaceLight,
                  style: const TextStyle(color: AppColors.textPrimary),
                  decoration: InputDecoration(
                    labelText: 'Interest Period',
                    labelStyle: const TextStyle(color: AppColors.textSecondary),
                    filled: true,
                    fillColor: AppColors.surfaceLight,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  items: [
                    const DropdownMenuItem(
                      value: 'principal',
                      child: Text('On Principal'),
                    ),
                    const DropdownMenuItem(
                      value: 'monthly',
                      child: Text('Monthly'),
                    ),
                    const DropdownMenuItem(
                      value: 'yearly',
                      child: Text('Yearly'),
                    ),
                  ],
                  onChanged: (v) => setState(() => interestPeriod = v!),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: monthsController,
                  style: const TextStyle(color: AppColors.textPrimary),
                  decoration: InputDecoration(
                    labelText: 'Payment Period (months)',
                    labelStyle: const TextStyle(color: AppColors.textSecondary),
                    suffixText: 'months',
                    filled: true,
                    fillColor: AppColors.surfaceLight,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 24),
                if (widget.onDelete != null)
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton(
                      onPressed: () {
                        widget.onDelete!();
                        Navigator.pop(context);
                      },
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.error,
                        side: const BorderSide(color: AppColors.error),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'Delete',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                if (widget.onDelete != null) const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      if (nameController.text.isEmpty ||
                          amountController.text.isEmpty)
                        return;
                      final debt = {
                        'id': widget.debt?['id'] ?? const Uuid().v4(),
                        'name': nameController.text,
                        'creditor': creditorController.text,
                        'originalAmount':
                            widget.debt?['originalAmount'] ??
                            double.parse(amountController.text),
                        'remainingAmount': double.parse(amountController.text),
                        'totalPaid': widget.debt?['totalPaid'] ?? 0.0,
                        'interestRate': double.parse(
                          interestController.text.isEmpty
                              ? '0'
                              : interestController.text,
                        ),
                        'interestPeriod': interestPeriod,
                        'remainingMonths': int.parse(
                          monthsController.text.isEmpty
                              ? '1'
                              : monthsController.text,
                        ),
                        'payments': widget.debt?['payments'] ?? [],
                        'isActive': widget.debt?['isActive'] ?? true,
                      };
                      widget.onSave(debt);
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'Save',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
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
}

class PaymentBottomSheet extends StatefulWidget {
  final Map<String, dynamic> debt;
  final Function(double, String) onSave;

  const PaymentBottomSheet({
    super.key,
    required this.debt,
    required this.onSave,
  });

  @override
  State<PaymentBottomSheet> createState() => _PaymentBottomSheetState();
}

class _PaymentBottomSheetState extends State<PaymentBottomSheet> {
  late final TextEditingController amountController;
  String channel = 'M-Pesa';

  @override
  void initState() {
    super.initState();
    amountController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    final remaining = widget.debt['remainingAmount'] as double;
    return SafeArea(
      child: Container(
        decoration: const BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom + 16,
        ),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppColors.textSecondary.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                'Record Payment',
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Remaining: KSh ${remaining.toStringAsFixed(2)}',
                style: const TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 24),
              TextField(
                controller: amountController,
                style: const TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 18,
                ),
                decoration: InputDecoration(
                  labelText: 'Payment Amount',
                  labelStyle: const TextStyle(color: AppColors.textSecondary),
                  prefixText: 'KSh ',
                  prefixStyle: const TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 18,
                  ),
                  filled: true,
                  fillColor: AppColors.surfaceLight,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: channel,
                dropdownColor: AppColors.surfaceLight,
                style: const TextStyle(color: AppColors.textPrimary),
                decoration: InputDecoration(
                  labelText: 'Payment Channel',
                  labelStyle: const TextStyle(color: AppColors.textSecondary),
                  filled: true,
                  fillColor: AppColors.surfaceLight,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
                items: const [
                  DropdownMenuItem(value: 'M-Pesa', child: Text('M-Pesa')),
                  DropdownMenuItem(
                    value: 'Bank Transfer',
                    child: Text('Bank Transfer'),
                  ),
                  DropdownMenuItem(value: 'Cash', child: Text('Cash')),
                  DropdownMenuItem(value: 'Other', child: Text('Other')),
                ],
                onChanged: (v) => setState(() => channel = v!),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        amountController.text = remaining.toStringAsFixed(2);
                      },
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.primary,
                        side: const BorderSide(color: AppColors.primary),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'Pay Full',
                        style: TextStyle(fontSize: 14),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    if (amountController.text.isEmpty) return;
                    final amount = double.parse(amountController.text);
                    if (amount <= 0 || amount > remaining) return;
                    widget.onSave(amount, channel);
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Record Payment',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
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

class PaymentHistoryBottomSheet extends StatelessWidget {
  final Map<String, dynamic> debt;

  const PaymentHistoryBottomSheet({super.key, required this.debt});

  @override
  Widget build(BuildContext context) {
    final payments = List<Map<String, dynamic>>.from(debt['payments'] ?? []);
    payments.sort(
      (a, b) => DateTime.parse(b['date']).compareTo(DateTime.parse(a['date'])),
    );

    return SafeArea(
      child: Container(
        decoration: const BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.7,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  Center(
                    child: Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: AppColors.textSecondary.withOpacity(0.3),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Payment History',
                        style: TextStyle(
                          color: AppColors.textPrimary,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '${payments.length} payments',
                        style: const TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Expanded(
              child: payments.isEmpty
                  ? const Center(
                      child: Text(
                        'No payments recorded',
                        style: TextStyle(color: AppColors.textSecondary),
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      itemCount: payments.length,
                      itemBuilder: (context, index) {
                        final payment = payments[index];
                        final date = DateTime.parse(payment['date']);
                        final dateStr =
                            '${date.day}/${date.month}/${date.year}';

                        return Container(
                          margin: const EdgeInsets.only(bottom: 12),
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: AppColors.surfaceLight,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: AppColors.success.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: const Icon(
                                  Icons.check_circle_rounded,
                                  color: AppColors.success,
                                  size: 20,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'KSh ${payment['amount'].toStringAsFixed(2)}',
                                      style: const TextStyle(
                                        color: AppColors.textPrimary,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      '$dateStr • ${payment['channel']}',
                                      style: const TextStyle(
                                        color: AppColors.textSecondary,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
