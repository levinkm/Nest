import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';
import 'dart:convert';
import '../../../../core/theme/app_colors.dart';

class ExpectedIncomePage extends StatefulWidget {
  const ExpectedIncomePage({super.key});

  @override
  State<ExpectedIncomePage> createState() => _ExpectedIncomePageState();
}

class _ExpectedIncomePageState extends State<ExpectedIncomePage> {
  List<Map<String, dynamic>> _expectedIncomes = [];

  @override
  void initState() {
    super.initState();
    _loadExpectedIncomes();
  }

  Future<void> _loadExpectedIncomes() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString('expected_incomes') ?? '[]';
    setState(() {
      _expectedIncomes = List<Map<String, dynamic>>.from(jsonDecode(data));
    });
  }

  Future<void> _saveExpectedIncomes() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('expected_incomes', jsonEncode(_expectedIncomes));
  }

  double get totalMonthlyExpected {
    return _expectedIncomes.where((i) => i['isActive'] == true).fold(0.0, (
      sum,
      i,
    ) {
      final amount = i['amount'] as double;
      final frequency = i['frequency'] as String;
      if (frequency == 'monthly') return sum + amount;
      if (frequency == 'weekly') return sum + (amount * 4);
      if (frequency == 'daily') return sum + (amount * 30);
      return sum;
    });
  }

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
          'Expected Income',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Column(
        children: [
          Card(
            margin: const EdgeInsets.all(16),
            color: AppColors.cardGradientStart,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Total Monthly Expected',
                    style: TextStyle(fontSize: 16),
                  ),
                  Text(
                    'Ksh ${totalMonthlyExpected.toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: _expectedIncomes.isEmpty
                ? const Center(child: Text('No expected income added'))
                : ListView.builder(
                    itemCount: _expectedIncomes.length,
                    itemBuilder: (context, index) {
                      final income = _expectedIncomes[index];
                      return ListTile(
                        leading: Icon(
                          _getCategoryIcon(income['category']),
                          color: income['isActive']
                              ? Colors.green
                              : Colors.grey,
                        ),
                        title: Text(income['name']),
                        subtitle: Text(
                          '${income['frequency']} • ${income['category']}',
                        ),
                        trailing: Text(
                          '₹${income['amount']}',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        onTap: () => _editIncome(index),
                      );
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addIncome,
        child: const Icon(Icons.add),
      ),
    );
  }

  IconData _getCategoryIcon(String category) {
    switch (category) {
      case 'Salary':
        return Icons.work;
      case 'Investment':
        return Icons.trending_up;
      case 'Business':
        return Icons.business;
      default:
        return Icons.attach_money;
    }
  }

  void _addIncome() {
    _showIncomeDialog();
  }

  void _editIncome(int index) {
    _showIncomeDialog(income: _expectedIncomes[index], index: index);
  }

  void _showIncomeDialog({Map<String, dynamic>? income, int? index}) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => ExpectedIncomeBottomSheet(
        income: income,
        onSave: (newIncome) {
          setState(() {
            if (index != null) {
              _expectedIncomes[index] = newIncome;
            } else {
              _expectedIncomes.add(newIncome);
            }
          });
          _saveExpectedIncomes();
        },
        onDelete: index != null
            ? () {
                setState(() => _expectedIncomes.removeAt(index));
                _saveExpectedIncomes();
              }
            : null,
      ),
    );
  }
}

class ExpectedIncomeBottomSheet extends StatefulWidget {
  final Map<String, dynamic>? income;
  final Function(Map<String, dynamic>) onSave;
  final VoidCallback? onDelete;

  const ExpectedIncomeBottomSheet({
    super.key,
    this.income,
    required this.onSave,
    this.onDelete,
  });

  @override
  State<ExpectedIncomeBottomSheet> createState() =>
      _ExpectedIncomeBottomSheetState();
}

class _ExpectedIncomeBottomSheetState extends State<ExpectedIncomeBottomSheet> {
  late final TextEditingController nameController;
  late final TextEditingController amountController;
  late final TextEditingController customCategoryController;
  late String frequency;
  late String category;
  bool showCustomCategory = false;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.income?['name'] ?? '');
    amountController = TextEditingController(
      text: widget.income?['amount']?.toString() ?? '',
    );
    customCategoryController = TextEditingController();
    frequency = widget.income?['frequency'] ?? 'monthly';
    category = widget.income?['category'] ?? 'Salary';
    if (!['Salary', 'Investment', 'Business', 'Other'].contains(category)) {
      customCategoryController.text = category;
      category = 'Other';
      showCustomCategory = true;
    }
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
                  widget.income == null
                      ? 'Add Expected Income'
                      : 'Edit Expected Income',
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
                TextField(
                  controller: amountController,
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 18,
                  ),
                  decoration: InputDecoration(
                    labelText: 'Amount',
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
                  initialValue: frequency,
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
                  items: ['daily', 'weekly', 'monthly']
                      .map((f) => DropdownMenuItem(value: f, child: Text(f)))
                      .toList(),
                  onChanged: (v) => setState(() => frequency = v!),
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  initialValue: category,
                  dropdownColor: AppColors.surfaceLight,
                  style: const TextStyle(color: AppColors.textPrimary),
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
                  items: ['Salary', 'Investment', 'Business', 'Other']
                      .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                      .toList(),
                  onChanged: (v) {
                    setState(() {
                      category = v!;
                      showCustomCategory = v == 'Other';
                    });
                  },
                ),
                if (showCustomCategory) ...[
                  const SizedBox(height: 16),
                  TextField(
                    controller: customCategoryController,
                    style: const TextStyle(color: AppColors.textPrimary),
                    decoration: InputDecoration(
                      labelText: 'Specify Category',
                      labelStyle: const TextStyle(
                        color: AppColors.textSecondary,
                      ),
                      filled: true,
                      fillColor: AppColors.surfaceLight,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ],
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
                          amountController.text.isEmpty) {
                        return;
                      }
                      final newIncome = {
                        'id': widget.income?['id'] ?? const Uuid().v4(),
                        'name': nameController.text,
                        'amount': double.parse(amountController.text),
                        'frequency': frequency,
                        'category':
                            showCustomCategory &&
                                customCategoryController.text.isNotEmpty
                            ? customCategoryController.text
                            : category,
                        'isActive': true,
                      };
                      widget.onSave(newIncome);
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
