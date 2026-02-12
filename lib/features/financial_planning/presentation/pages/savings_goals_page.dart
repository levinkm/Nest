import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/currency_helper.dart';
import '../../../../core/utils/milestone_celebration.dart';

class SavingsGoalsPage extends StatefulWidget {
  const SavingsGoalsPage({super.key});

  @override
  State<SavingsGoalsPage> createState() => _SavingsGoalsPageState();
}

class _SavingsGoalsPageState extends State<SavingsGoalsPage> {
  List<Map<String, dynamic>> _goals = [];
  String _currency = 'KSh';

  @override
  void initState() {
    super.initState();
    _loadGoals();
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

  Future<void> _loadGoals() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString('savings_goals') ?? '[]';
    setState(() {
      _goals = List<Map<String, dynamic>>.from(jsonDecode(data));
    });
  }

  Future<void> _saveGoals() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('savings_goals', jsonEncode(_goals));
  }

  void _addGoal() {
    _showGoalBottomSheet(context);
  }

  void _editGoal(int index) {
    _showGoalBottomSheet(context, goal: _goals[index], index: index);
  }

  void _showGoalBottomSheet(
    BuildContext context, {
    Map<String, dynamic>? goal,
    int? index,
  }) {
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
        child: _GoalBottomSheet(
          currency: _currency,
          goal: goal,
          onSave: (newGoal) {
            setState(() {
              if (index != null) {
                _goals[index] = newGoal;
              } else {
                _goals.add(newGoal);
              }
            });
            _saveGoals();
          },
        ),
      ),
    );
  }

  void _addContribution(int index) {
    final controller = TextEditingController();
    final accountController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Contribution'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: controller,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Amount',
                prefixText: '$_currency ',
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: accountController,
              decoration: const InputDecoration(
                labelText: 'Account/Location',
                hintText: 'e.g., KCB Bank, Etica MMF',
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
            onPressed: () {
              final amount = double.tryParse(controller.text) ?? 0;
              if (amount > 0) {
                setState(() {
                  _goals[index]['currentAmount'] =
                      (_goals[index]['currentAmount'] ?? 0.0) + amount;
                  _goals[index]['lastAccount'] = accountController.text;
                });
                _saveGoals();
                _checkMilestones();
                Navigator.pop(context);
              }
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  void _deleteGoal(int index) {
    setState(() => _goals.removeAt(index));
    _saveGoals();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Savings Goals')),
      floatingActionButton: FloatingActionButton(
        onPressed: _addGoal,
        child: const Icon(Icons.add),
      ),
      body: _goals.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.savings, size: 64, color: Colors.grey.shade400),
                  const SizedBox(height: 16),
                  Text(
                    'No savings goals yet',
                    style: TextStyle(fontSize: 18, color: Colors.grey.shade600),
                  ),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _goals.length,
              itemBuilder: (context, index) {
                final goal = _goals[index];
                final current = goal['currentAmount'] ?? 0.0;
                final target = goal['targetAmount'] ?? 1.0;
                final progress = (current / target).clamp(0.0, 1.0);
                final daysLeft = DateTime.parse(
                  goal['targetDate'],
                ).difference(DateTime.now()).inDays;

                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                goal['name'],
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            PopupMenuButton(
                              itemBuilder: (context) => [
                                const PopupMenuItem(
                                  value: 'edit',
                                  child: Text('Edit'),
                                ),
                                const PopupMenuItem(
                                  value: 'delete',
                                  child: Text('Delete'),
                                ),
                              ],
                              onSelected: (value) {
                                if (value == 'edit') {
                                  _editGoal(index);
                                } else if (value == 'delete') {
                                  _deleteGoal(index);
                                }
                              },
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '$_currency ${current.toStringAsFixed(0)}',
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: AppColors.primary,
                              ),
                            ),
                            Text(
                              'of $_currency ${target.toStringAsFixed(0)}',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.grey.shade600,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: LinearProgressIndicator(
                            value: progress,
                            minHeight: 12,
                            backgroundColor: Colors.grey.shade200,
                            color: progress >= 1.0
                                ? Colors.green
                                : AppColors.primary,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '${(progress * 100).toStringAsFixed(0)}% complete',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey.shade600,
                              ),
                            ),
                            Text(
                              daysLeft > 0
                                  ? '$daysLeft days left'
                                  : 'Target date passed',
                              style: TextStyle(
                                fontSize: 14,
                                color: daysLeft > 0
                                    ? Colors.grey.shade600
                                    : Colors.red,
                              ),
                            ),
                          ],
                        ),
                        if (goal['lastAccount']?.isNotEmpty ?? false) ...[
                          const SizedBox(height: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.grey.shade100,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.account_balance,
                                  size: 14,
                                  color: Colors.grey.shade700,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  goal['lastAccount'],
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey.shade700,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                        if (goal['isRecurring'] == true) ...[
                          const SizedBox(height: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.blue.shade50,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.repeat,
                                  size: 14,
                                  color: Colors.blue.shade700,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  '$_currency ${goal['recurringAmount']?.toStringAsFixed(0)} ${goal['frequency']}',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.blue.shade700,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                        const SizedBox(height: 12),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            onPressed: () => _addContribution(index),
                            icon: const Icon(Icons.add),
                            label: const Text('Add Contribution'),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}

class _GoalBottomSheet extends StatefulWidget {
  final String currency;
  final Map<String, dynamic>? goal;
  final Function(Map<String, dynamic>) onSave;

  const _GoalBottomSheet({
    required this.currency,
    this.goal,
    required this.onSave,
  });

  @override
  State<_GoalBottomSheet> createState() => _GoalBottomSheetState();
}

class _GoalBottomSheetState extends State<_GoalBottomSheet> {
  late TextEditingController _nameController;
  late TextEditingController _targetController;
  late TextEditingController _recurringController;
  DateTime _targetDate = DateTime.now().add(const Duration(days: 365));
  bool _isRecurring = false;
  String _frequency = 'monthly';

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.goal?['name'] ?? '');
    _targetController = TextEditingController(
      text: widget.goal?['targetAmount']?.toString() ?? '',
    );
    _recurringController = TextEditingController(
      text: widget.goal?['recurringAmount']?.toString() ?? '',
    );
    if (widget.goal?['targetDate'] != null) {
      _targetDate = DateTime.parse(widget.goal!['targetDate']);
    }
    _isRecurring = widget.goal?['isRecurring'] ?? false;
    _frequency = widget.goal?['frequency'] ?? 'monthly';
  }

  @override
  void dispose() {
    _nameController.dispose();
    _targetController.dispose();
    _recurringController.dispose();
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
                widget.goal == null ? 'New Savings Goal' : 'Edit Goal',
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
            controller: _nameController,
            decoration: const InputDecoration(
              labelText: 'Goal Name',
              hintText: 'e.g., Vacation, New Car',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _targetController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              labelText: 'Target Amount',
              prefixText: '${widget.currency} ',
              border: const OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 16),
          InkWell(
            onTap: () async {
              final date = await showDatePicker(
                context: context,
                initialDate: _targetDate,
                firstDate: DateTime.now(),
                lastDate: DateTime.now().add(const Duration(days: 3650)),
              );
              if (date != null) {
                setState(() => _targetDate = date);
              }
            },
            child: InputDecorator(
              decoration: const InputDecoration(
                labelText: 'Target Date',
                border: OutlineInputBorder(),
                suffixIcon: Icon(Icons.calendar_today),
              ),
              child: Text(
                '${_targetDate.year}-${_targetDate.month.toString().padLeft(2, '0')}-${_targetDate.day.toString().padLeft(2, '0')}',
              ),
            ),
          ),
          const SizedBox(height: 16),
          SwitchListTile(
            title: const Text('Recurring Savings'),
            subtitle: const Text('Automatically save a fixed amount'),
            value: _isRecurring,
            onChanged: (value) => setState(() => _isRecurring = value),
            contentPadding: EdgeInsets.zero,
          ),
          if (_isRecurring) ...[
            const SizedBox(height: 8),
            TextField(
              controller: _recurringController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Recurring Amount',
                prefixText: '${widget.currency} ',
                border: const OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              initialValue: _frequency,
              decoration: const InputDecoration(
                labelText: 'Frequency',
                border: OutlineInputBorder(),
              ),
              items: const [
                DropdownMenuItem(value: 'daily', child: Text('Daily')),
                DropdownMenuItem(value: 'weekly', child: Text('Weekly')),
                DropdownMenuItem(value: 'monthly', child: Text('Monthly')),
              ],
              onChanged: (value) => setState(() => _frequency = value!),
            ),
          ],
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                if (_nameController.text.isNotEmpty &&
                    _targetController.text.isNotEmpty) {
                  widget.onSave({
                    'id': widget.goal?['id'] ?? DateTime.now().toString(),
                    'name': _nameController.text,
                    'targetAmount': double.parse(_targetController.text),
                    'currentAmount': widget.goal?['currentAmount'] ?? 0.0,
                    'targetDate': _targetDate.toIso8601String(),
                    'createdAt':
                        widget.goal?['createdAt'] ??
                        DateTime.now().toIso8601String(),
                    'isActive': true,
                    'isRecurring': _isRecurring,
                    'recurringAmount': _isRecurring
                        ? double.tryParse(_recurringController.text) ?? 0.0
                        : 0.0,
                    'frequency': _frequency,
                  });
                  Navigator.pop(context);
                }
              },
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: const Text('Save Goal'),
            ),
          ),
        ],
      ),
    );
  }
}
