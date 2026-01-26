import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../../../../core/utils/currency_helper.dart';
import '../../../../core/theme/app_colors.dart';

class AutomatedSavingsRulesPage extends StatefulWidget {
  const AutomatedSavingsRulesPage({super.key});

  @override
  State<AutomatedSavingsRulesPage> createState() =>
      _AutomatedSavingsRulesPageState();
}

class _AutomatedSavingsRulesPageState extends State<AutomatedSavingsRulesPage> {
  List<Map<String, dynamic>> _rules = [];
  String _currency = 'KSh';

  @override
  void initState() {
    super.initState();
    _loadRules();
    _loadCurrency();
  }

  Future<void> _loadCurrency() async {
    final currency = await CurrencyHelper.getCurrency();
    setState(() => _currency = currency);
  }

  Future<void> _loadRules() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString('savings_rules') ?? '[]';
    setState(() {
      _rules = List<Map<String, dynamic>>.from(jsonDecode(data));
    });
  }

  Future<void> _saveRules() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('savings_rules', jsonEncode(_rules));
  }

  void _addRule() {
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
          child: _RuleBottomSheet(
            currency: _currency,
            onSave: (rule) {
              setState(() => _rules.add(rule));
              _saveRules();
            },
          ),
        ),
      ),
    );
  }

  void _toggleRule(int index) {
    setState(() {
      _rules[index]['isActive'] = !(_rules[index]['isActive'] ?? true);
    });
    _saveRules();
  }

  void _deleteRule(int index) {
    setState(() => _rules.removeAt(index));
    _saveRules();
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
          'Automated Savings Rules',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addRule,
        child: const Icon(Icons.add),
      ),
      body: _rules.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.auto_awesome,
                    size: 64,
                    color: Colors.grey.shade400,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No automated rules yet',
                    style: TextStyle(fontSize: 18, color: Colors.grey.shade600),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Create rules to save automatically',
                    style: TextStyle(fontSize: 14, color: Colors.grey.shade500),
                  ),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _rules.length,
              itemBuilder: (context, index) {
                final rule = _rules[index];
                final isActive = rule['isActive'] ?? true;

                return Card(
                  color: isActive
                      ? AppColors.cardGradientStart
                      : Colors.grey.shade50,
                  margin: const EdgeInsets.only(bottom: 12),
                  child: ListTile(
                    leading: Icon(
                      _getRuleIcon(rule['type']),
                      color: isActive ? AppColors.primary : Colors.grey,
                    ),
                    title: Text(
                      _getRuleTitle(rule),
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: isActive
                            ? AppColors.textPrimary
                            : AppColors.textSecondary,
                      ),
                    ),
                    subtitle: Text(
                      _getRuleDescription(rule, _currency),
                      style: TextStyle(
                        fontSize: 12,
                        color: isActive ? Colors.grey.shade700 : Colors.grey,
                      ),
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Switch(
                          value: isActive,
                          onChanged: (_) => _toggleRule(index),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () => _deleteRule(index),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }

  IconData _getRuleIcon(String type) {
    switch (type) {
      case 'percentage':
        return Icons.percent;
      case 'fixed':
        return Icons.attach_money;
      case 'roundup':
        return Icons.arrow_upward;
      case 'windfall':
        return Icons.celebration;
      default:
        return Icons.savings;
    }
  }

  String _getRuleTitle(Map<String, dynamic> rule) {
    switch (rule['type']) {
      case 'percentage':
        return 'Save ${rule['value']}% of Income';
      case 'fixed':
        return 'Save Fixed Amount';
      case 'roundup':
        return 'Round-Up Savings';
      case 'windfall':
        return 'Save Windfall Income';
      default:
        return 'Savings Rule';
    }
  }

  String _getRuleDescription(Map<String, dynamic> rule, String currency) {
    switch (rule['type']) {
      case 'percentage':
        return 'Automatically save ${rule['value']}% of every income transaction';
      case 'fixed':
        return 'Save $currency ${rule['value']} on ${rule['frequency']}';
      case 'roundup':
        return 'Round up transactions to nearest $currency ${rule['value']} and save difference';
      case 'windfall':
        return 'Save ${rule['value']}% of bonuses, refunds, and unexpected income';
      default:
        return 'Custom savings rule';
    }
  }
}

class _RuleBottomSheet extends StatefulWidget {
  final String currency;
  final Function(Map<String, dynamic>) onSave;

  const _RuleBottomSheet({required this.currency, required this.onSave});

  @override
  State<_RuleBottomSheet> createState() => _RuleBottomSheetState();
}

class _RuleBottomSheetState extends State<_RuleBottomSheet> {
  String _ruleType = 'percentage';
  final _valueController = TextEditingController();
  String _frequency = 'monthly';

  @override
  void dispose() {
    _valueController.dispose();
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
              const Text(
                'New Savings Rule',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
          const SizedBox(height: 20),
          DropdownButtonFormField<String>(
            value: _ruleType,
            decoration: const InputDecoration(
              labelText: 'Rule Type',
              border: OutlineInputBorder(),
            ),
            items: const [
              DropdownMenuItem(
                value: 'percentage',
                child: Text('Percentage of Income'),
              ),
              DropdownMenuItem(value: 'fixed', child: Text('Fixed Amount')),
              DropdownMenuItem(
                value: 'roundup',
                child: Text('Round-Up Savings'),
              ),
              DropdownMenuItem(
                value: 'windfall',
                child: Text('Windfall Income'),
              ),
            ],
            onChanged: (value) => setState(() => _ruleType = value!),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _valueController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              labelText: _ruleType == 'percentage' || _ruleType == 'windfall'
                  ? 'Percentage'
                  : 'Amount',
              suffixText: _ruleType == 'percentage' || _ruleType == 'windfall'
                  ? '%'
                  : widget.currency,
              border: const OutlineInputBorder(),
            ),
          ),
          if (_ruleType == 'fixed') ...[
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: _frequency,
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
                final valueText = _valueController.text
                    .replaceAll('%', '')
                    .trim();
                if (valueText.isNotEmpty) {
                  final value = double.tryParse(valueText);
                  if (value != null) {
                    widget.onSave({
                      'id': DateTime.now().toString(),
                      'type': _ruleType,
                      'value': value,
                      'frequency': _frequency,
                      'isActive': true,
                      'createdAt': DateTime.now().toIso8601String(),
                    });
                    Navigator.pop(context);
                  }
                }
              },
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: const Text('Create Rule'),
            ),
          ),
        ],
      ),
    );
  }
}
