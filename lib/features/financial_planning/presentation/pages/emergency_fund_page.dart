import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/currency_helper.dart';
import '../../../../core/utils/milestone_celebration.dart';

class EmergencyFundPage extends StatefulWidget {
  final double targetAmount;

  const EmergencyFundPage({super.key, required this.targetAmount});

  @override
  State<EmergencyFundPage> createState() => _EmergencyFundPageState();
}

class _EmergencyFundPageState extends State<EmergencyFundPage> {
  List<Map<String, dynamic>> _transactions = [];
  double _currentBalance = 0.0;
  String _currency = 'KSh';

  @override
  void initState() {
    super.initState();
    _loadData();
    _loadCurrency();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkMilestones();
    });
  }

  Future<void> _checkMilestones() async {
    await MilestoneCelebration.checkAndCelebrate(context, _currency);
  }

  Future<void> _loadCurrency() async {
    final currency = await CurrencyHelper.getCurrency();
    setState(() => _currency = currency);
  }

  Future<void> _loadData() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString('emergency_fund_transactions') ?? '[]';
    final transactions = List<Map<String, dynamic>>.from(jsonDecode(data));

    double balance = 0.0;
    for (var t in transactions) {
      balance += t['amount'] as double;
    }

    setState(() {
      _transactions = transactions;
      _currentBalance = balance;
    });
  }

  Future<void> _saveData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      'emergency_fund_transactions',
      jsonEncode(_transactions),
    );
  }

  void _addTransaction(bool isDeposit) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: SafeArea(
          child: _TransactionBottomSheet(
            currency: _currency,
            isDeposit: isDeposit,
            onSave: (amount, note, account) {
              setState(() {
                _transactions.insert(0, {
                  'amount': isDeposit ? amount : -amount,
                  'note': note,
                  'account': account,
                  'date': DateTime.now().toIso8601String(),
                  'type': isDeposit ? 'deposit' : 'withdrawal',
                });
                _currentBalance += isDeposit ? amount : -amount;
              });
              _saveData();
              _checkMilestones();
            },
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final progress = (_currentBalance / widget.targetAmount).clamp(0.0, 1.0);
    final remaining = widget.targetAmount - _currentBalance;

    return Scaffold(
      appBar: AppBar(title: const Text('Emergency Fund')),
      body: Column(
        children: [
          Container(
            width: MediaQuery.of(context).size.width * 0.9,
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(16)),
              gradient: LinearGradient(
                colors: [
                  AppColors.primary,
                  AppColors.primary.withValues(alpha: 0.7),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Column(
              children: [
                const Text(
                  'Current Balance',
                  style: TextStyle(fontSize: 16, color: Colors.white70),
                ),
                const SizedBox(height: 8),
                Text(
                  '$_currency ${_currentBalance.toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 16),
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: LinearProgressIndicator(
                    value: progress,
                    minHeight: 12,
                    backgroundColor: Colors.white30,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${(progress * 100).toStringAsFixed(0)}% of goal',
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.white70,
                      ),
                    ),
                    Text(
                      'Target: $_currency ${widget.targetAmount.toStringAsFixed(0)}',
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.white70,
                      ),
                    ),
                  ],
                ),
                if (remaining > 0) ...[
                  const SizedBox(height: 8),
                  Text(
                    '$_currency ${remaining.toStringAsFixed(0)} remaining',
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => _addTransaction(true),
                    icon: const Icon(Icons.add),
                    label: const Text('Deposit'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => _addTransaction(false),
                    icon: const Icon(Icons.remove),
                    label: const Text('Withdraw'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Transaction History',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: _transactions.isEmpty
                ? Center(
                    child: Text(
                      'No transactions yet',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: _transactions.length,
                    itemBuilder: (context, index) {
                      final transaction = _transactions[index];
                      final amount = transaction['amount'] as double;
                      final isDeposit = amount > 0;
                      final date = DateTime.parse(transaction['date']);

                      return Card(
                        margin: const EdgeInsets.only(bottom: 8),
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundColor: isDeposit
                                ? Colors.green.shade100
                                : Colors.red.shade100,
                            child: Icon(
                              isDeposit ? Icons.add : Icons.remove,
                              color: isDeposit ? Colors.green : Colors.red,
                            ),
                          ),
                          title: Text(
                            '$_currency ${amount.abs().toStringAsFixed(2)}',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: isDeposit ? Colors.green : Colors.red,
                            ),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (transaction['account']?.isNotEmpty ?? false)
                                Text(
                                  transaction['account'],
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 13,
                                  ),
                                ),
                              if (transaction['note']?.isNotEmpty ?? false)
                                Text(transaction['note']),
                              Text(
                                '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')} ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey.shade600,
                                ),
                              ),
                            ],
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
}

class _TransactionBottomSheet extends StatefulWidget {
  final String currency;
  final bool isDeposit;
  final Function(double, String, String) onSave;

  const _TransactionBottomSheet({
    required this.currency,
    required this.isDeposit,
    required this.onSave,
  });

  @override
  State<_TransactionBottomSheet> createState() =>
      _TransactionBottomSheetState();
}

class _TransactionBottomSheetState extends State<_TransactionBottomSheet> {
  final _amountController = TextEditingController();
  final _noteController = TextEditingController();
  final _accountController = TextEditingController();

  @override
  void dispose() {
    _amountController.dispose();
    _noteController.dispose();
    _accountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                widget.isDeposit ? 'Add Deposit' : 'Add Withdrawal',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
          const SizedBox(height: 20),
          TextField(
            controller: _amountController,
            keyboardType: TextInputType.number,
            autofocus: true,
            decoration: InputDecoration(
              labelText: 'Amount',
              prefixText: '${widget.currency} ',
              border: const OutlineInputBorder(),
              hintText: '0.00',
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _accountController,
            decoration: const InputDecoration(
              labelText: 'Account/Location',
              border: OutlineInputBorder(),
              hintText: 'e.g., KCB Bank, Etica MMF',
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _noteController,
            decoration: const InputDecoration(
              labelText: 'Note (optional)',
              border: OutlineInputBorder(),
              hintText: 'Add a note about this transaction',
            ),
            maxLines: 2,
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                final amount = double.tryParse(_amountController.text) ?? 0;
                if (amount > 0) {
                  widget.onSave(
                    amount,
                    _noteController.text,
                    _accountController.text,
                  );
                  Navigator.pop(context);
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: widget.isDeposit ? Colors.green : Colors.red,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: Text(widget.isDeposit ? 'Add Deposit' : 'Add Withdrawal'),
            ),
          ),
        ],
      ),
    );
  }
}
