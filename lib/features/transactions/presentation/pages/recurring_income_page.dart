import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '../../data/models/categorization_models.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/currency_helper.dart';
import '../../data/datasources/local_database.dart';
import 'package:intl/intl.dart';

class RecurringIncomePage extends StatefulWidget {
  const RecurringIncomePage({super.key});

  @override
  State<RecurringIncomePage> createState() => _RecurringIncomePageState();
}

class _RecurringIncomePageState extends State<RecurringIncomePage> {
  List<RecurringIncome> _incomes = [];
  String _currency = 'KSh';

  @override
  void initState() {
    super.initState();
    _loadIncomes();
  }

  Future<void> _loadIncomes() async {
    _currency = await CurrencyHelper.getCurrency();
    final db = LocalDatabase();
    final data = await db.getRecurringIncomes();
    setState(() {
      _incomes = data.map((m) => RecurringIncome.fromJson(m)).toList();
    });
  }

  void _addIncome() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _IncomeSheet(
        currency: _currency,
        onSave: (income) async {
          final db = LocalDatabase();
          await db.insertRecurringIncome(income.toJson());
          _loadIncomes();
        },
      ),
    );
  }

  void _editIncome(RecurringIncome income) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _IncomeSheet(
        currency: _currency,
        income: income,
        onSave: (updated) async {
          final db = LocalDatabase();
          await db.insertRecurringIncome(updated.toJson());
          _loadIncomes();
        },
      ),
    );
  }

  void _deleteIncome(RecurringIncome income) async {
    final db = LocalDatabase();
    await db.deleteRecurringIncome(income.id);
    _loadIncomes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        title: const Text(
          'Recurring Income',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _addIncome,
        backgroundColor: AppColors.primary,
        icon: const Icon(Icons.add),
        label: const Text('Add Income'),
      ),
      body: _incomes.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.account_balance_wallet,
                    size: 80,
                    color: AppColors.textSecondary.withValues(alpha: .5),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'No recurring income yet',
                    style: TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 18,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Add your salary or other regular income',
                    style: TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _incomes.length,
              itemBuilder: (context, index) =>
                  _buildIncomeCard(_incomes[index]),
            ),
    );
  }

  Widget _buildIncomeCard(RecurringIncome income) {
    final nextExpected = income.nextExpected ?? income.calculateNextExpected();
    final daysUntil = nextExpected.difference(DateTime.now()).inDays;

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
          onTap: () => _editIncome(income),
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
                            income.name,
                            style: const TextStyle(
                              color: AppColors.textPrimary,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '${income.frequency.toUpperCase()} • ${income.source}',
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
                            () => _editIncome(income),
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
                                'Edit',
                                style: TextStyle(color: AppColors.textPrimary),
                              ),
                            ],
                          ),
                        ),
                        PopupMenuItem(
                          onTap: () => _deleteIncome(income),
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Amount',
                          style: const TextStyle(
                            color: AppColors.textSecondary,
                            fontSize: 12,
                          ),
                        ),
                        Text(
                          income.isVariableAmount
                              ? '$_currency ${income.minAmount!.toStringAsFixed(0)}-${income.maxAmount!.toStringAsFixed(0)}'
                              : '$_currency ${income.amount.toStringAsFixed(0)}',
                          style: const TextStyle(
                            color: AppColors.income,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          'Next Expected',
                          style: const TextStyle(
                            color: AppColors.textSecondary,
                            fontSize: 12,
                          ),
                        ),
                        Text(
                          daysUntil > 0
                              ? 'In $daysUntil days'
                              : daysUntil == 0
                              ? 'Today'
                              : '${daysUntil.abs()} days ago',
                          style: TextStyle(
                            color: daysUntil < 0
                                ? AppColors.error
                                : AppColors.textPrimary,
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          DateFormat('MMM d').format(nextExpected),
                          style: const TextStyle(
                            color: AppColors.textSecondary,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                if (income.merchantName != null) ...[
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: .1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.store,
                          color: AppColors.primary,
                          size: 14,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          'Auto-detect: ${income.merchantName}',
                          style: const TextStyle(
                            color: AppColors.primary,
                            fontSize: 12,
                          ),
                        ),
                      ],
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
}

class _IncomeSheet extends StatefulWidget {
  final String currency;
  final RecurringIncome? income;
  final Function(RecurringIncome) onSave;

  const _IncomeSheet({
    required this.currency,
    this.income,
    required this.onSave,
  });

  @override
  State<_IncomeSheet> createState() => _IncomeSheetState();
}

class _IncomeSheetState extends State<_IncomeSheet> {
  late TextEditingController _nameController;
  late TextEditingController _amountController;
  late TextEditingController _minAmountController;
  late TextEditingController _maxAmountController;
  late TextEditingController _merchantController;
  late String _source;
  late String _frequency;
  late int _dayOfMonth;
  // ignore: unused_field
  late int _dayOfWeek;
  late bool _autoMark;
  late bool _isVariableAmount;

  @override
  void initState() {
    super.initState();
    final income = widget.income;
    _nameController = TextEditingController(text: income?.name ?? '');
    _source = income?.source ?? 'business';
    _frequency = income?.frequency ?? 'daily';
    _dayOfMonth = income?.dayOfMonth ?? DateTime.now().day;
    _dayOfWeek = income?.dayOfWeek ?? DateTime.now().weekday;
    _autoMark = income?.autoMark ?? true;
    _isVariableAmount = income?.isVariableAmount ?? false;
    _amountController = TextEditingController(
      text: income != null && !income.isVariableAmount
          ? income.amount.toString()
          : '',
    );
    _minAmountController = TextEditingController(
      text: income?.minAmount?.toString() ?? '',
    );
    _maxAmountController = TextEditingController(
      text: income?.maxAmount?.toString() ?? '',
    );
    _merchantController = TextEditingController(
      text: income?.merchantName ?? '',
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
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
                    Text(
                      widget.income == null
                          ? 'Add Recurring Income'
                          : 'Edit Recurring Income',
                      style: const TextStyle(
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
                TextField(
                  controller: _nameController,
                  style: const TextStyle(color: AppColors.textPrimary),
                  decoration: InputDecoration(
                    labelText: 'Name',
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
                Row(
                  children: [
                    Checkbox(
                      value: _isVariableAmount,
                      activeColor: AppColors.primary,
                      onChanged: (val) =>
                          setState(() => _isVariableAmount = val!),
                    ),
                    const Text(
                      'Variable amount (range)',
                      style: TextStyle(color: AppColors.textPrimary),
                    ),
                  ],
                ),
                if (_isVariableAmount) ...[
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _minAmountController,
                          keyboardType: TextInputType.number,
                          style: const TextStyle(color: AppColors.textPrimary),
                          decoration: InputDecoration(
                            labelText: 'Min',
                            prefixText: '${widget.currency} ',
                            filled: true,
                            fillColor: AppColors.surfaceLight,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide.none,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: TextField(
                          controller: _maxAmountController,
                          keyboardType: TextInputType.number,
                          style: const TextStyle(color: AppColors.textPrimary),
                          decoration: InputDecoration(
                            labelText: 'Max',
                            prefixText: '${widget.currency} ',
                            filled: true,
                            fillColor: AppColors.surfaceLight,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide.none,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ] else
                  TextField(
                    controller: _amountController,
                    keyboardType: TextInputType.number,
                    style: const TextStyle(color: AppColors.textPrimary),
                    decoration: InputDecoration(
                      labelText: 'Amount',
                      prefixText: '${widget.currency} ',
                      filled: true,
                      fillColor: AppColors.surfaceLight,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                const SizedBox(height: 16),
                Wrap(
                  spacing: 8,
                  children: ['salary', 'business', 'investment', 'other'].map((
                    s,
                  ) {
                    final isSelected = _source == s;
                    return GestureDetector(
                      onTap: () => setState(() => _source = s),
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
                          s.toUpperCase(),
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
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  initialValue: _frequency,
                  dropdownColor: AppColors.surfaceLight,
                  style: const TextStyle(color: AppColors.textPrimary),
                  decoration: InputDecoration(
                    labelText: 'Frequency',
                    labelStyle: const TextStyle(color: AppColors.textSecondary),
                    filled: true,
                    fillColor: AppColors.surfaceLight,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  items: ['daily', 'weekly', 'biweekly', 'monthly']
                      .map(
                        (f) => DropdownMenuItem(
                          value: f,
                          child: Text(f.toUpperCase()),
                        ),
                      )
                      .toList(),
                  onChanged: (val) => setState(() => _frequency = val!),
                ),
                if (_frequency == 'weekly' || _frequency == 'biweekly') ...[
                  const SizedBox(height: 16),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children:
                        [
                          {'day': 1, 'name': 'Mon'},
                          {'day': 2, 'name': 'Tue'},
                          {'day': 3, 'name': 'Wed'},
                          {'day': 4, 'name': 'Thu'},
                          {'day': 5, 'name': 'Fri'},
                          {'day': 6, 'name': 'Sat'},
                          {'day': 7, 'name': 'Sun'},
                        ].map((item) {
                          final day = item['day'] as int;
                          final name = item['name'] as String;
                          final isSelected = _dayOfMonth == day;
                          return GestureDetector(
                            onTap: () => setState(() => _dayOfMonth = day),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 12,
                              ),
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? AppColors.primary
                                    : AppColors.surfaceLight,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                name,
                                style: TextStyle(
                                  color: isSelected
                                      ? Colors.white
                                      : AppColors.textPrimary,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                  ),
                ],
                if (_frequency == 'monthly') ...[
                  const SizedBox(height: 16),
                  GestureDetector(
                    onTap: () => _showDayPicker(context),
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppColors.surfaceLight,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Day of Month: $_dayOfMonth',
                            style: const TextStyle(
                              color: AppColors.textPrimary,
                              fontSize: 16,
                            ),
                          ),
                          const Icon(
                            Icons.calendar_today,
                            color: AppColors.primary,
                            size: 20,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
                const SizedBox(height: 16),
                TextField(
                  controller: _merchantController,
                  style: const TextStyle(color: AppColors.textPrimary),
                  decoration: InputDecoration(
                    labelText: 'Merchant Name (optional)',
                    hintText: 'For auto-detection',
                    filled: true,
                    fillColor: AppColors.surfaceLight,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                SwitchListTile(
                  contentPadding: EdgeInsets.zero,
                  title: const Text(
                    'Auto-mark transactions',
                    style: TextStyle(color: AppColors.textPrimary),
                  ),
                  value: _autoMark,
                  activeThumbColor: AppColors.primary,
                  onChanged: (val) => setState(() => _autoMark = val),
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      if (_nameController.text.isNotEmpty &&
                          (_isVariableAmount
                              ? (_minAmountController.text.isNotEmpty &&
                                    _maxAmountController.text.isNotEmpty)
                              : _amountController.text.isNotEmpty)) {
                        widget.onSave(
                          RecurringIncome(
                            id: widget.income?.id ?? const Uuid().v4(),
                            name: _nameController.text,
                            source: _source,
                            amount: _isVariableAmount
                                ? 0
                                : double.parse(_amountController.text),
                            minAmount: _isVariableAmount
                                ? double.parse(_minAmountController.text)
                                : null,
                            maxAmount: _isVariableAmount
                                ? double.parse(_maxAmountController.text)
                                : null,
                            frequency: _frequency,
                            dayOfMonth: _frequency == 'monthly'
                                ? _dayOfMonth
                                : 1,
                            dayOfWeek:
                                (_frequency == 'weekly' ||
                                    _frequency == 'biweekly')
                                ? _dayOfMonth
                                : 1,
                            merchantName: _merchantController.text.isEmpty
                                ? null
                                : _merchantController.text,
                            autoMark: _autoMark,
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
                    child: Text(
                      widget.income == null ? 'Add Income' : 'Save Changes',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
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

  void _showDayPicker(BuildContext context) async {
    final now = DateTime.now();
    final selected = DateTime(now.year, now.month, _dayOfMonth);

    final picked = await showDatePicker(
      context: context,
      initialDate: selected,
      firstDate: DateTime(now.year, now.month, 1),
      lastDate: DateTime(now.year, now.month + 1, 0),
      builder: (context, child) {
        return Theme(
          data: ThemeData.dark().copyWith(
            colorScheme: const ColorScheme.dark(
              primary: AppColors.primary,
              surface: AppColors.surface,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() => _dayOfMonth = picked.day);
    }
  }
}
