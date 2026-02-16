import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/currency_helper.dart';
import '../../../bills/presentation/pages/bills_page.dart';
import '../../../bills/presentation/pages/financial_insights_page.dart';
import '../../../transactions/presentation/pages/recurring_income_page.dart';
import '../../../planning/presentation/pages/planning_page.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  String _currency = 'KSh';
  int _smsDaysBack = 30;
  String _themeMode = 'system';
  bool _autoSync = true;
  bool _budgetAlerts = true;
  bool _savingsAlerts = true;
  bool _debtReminders = true;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _currency = prefs.getString('currency') ?? 'KSh';
      _smsDaysBack = prefs.getInt('sms_days_back') ?? 30;
      _themeMode = prefs.getString('theme_mode') ?? 'system';
      _autoSync = prefs.getBool('auto_sync') ?? true;
      _budgetAlerts = prefs.getBool('budget_alerts') ?? true;
      _savingsAlerts = prefs.getBool('savings_alerts') ?? true;
      _debtReminders = prefs.getBool('debt_reminders') ?? true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        children: [
          _buildSection('Financial Settings', [
            _buildCurrencyTile(),
            _buildBudgetLimitsTile(),
          ]),
          _buildSection('SMS & Sync', [
            _buildSmsDaysBackTile(),
            _buildAutoSyncTile(),
          ]),
          _buildSection('Appearance', [
            _buildThemeModeTile(),
          ]),
          _buildSection('Notifications', [
            _buildSwitchTile('Budget Alerts', _budgetAlerts, (val) async {
              setState(() => _budgetAlerts = val);
              final prefs = await SharedPreferences.getInstance();
              await prefs.setBool('budget_alerts', val);
            }),
            _buildSwitchTile('Savings Milestones', _savingsAlerts, (val) async {
              setState(() => _savingsAlerts = val);
              final prefs = await SharedPreferences.getInstance();
              await prefs.setBool('savings_alerts', val);
            }),
            _buildSwitchTile('Debt Reminders', _debtReminders, (val) async {
              setState(() => _debtReminders = val);
              final prefs = await SharedPreferences.getInstance();
              await prefs.setBool('debt_reminders', val);
            }),
          ]),
          _buildSection('Category Management', [
            _buildTile('Manage Categories', Icons.category, () {
              Navigator.push(context, MaterialPageRoute(builder: (_) => const CategoryManagementPage()));
            }),
          ]),
          _buildSection('Bills & Payments', [
            _buildTile('Recurring Income', Icons.attach_money, () {
              Navigator.push(context, MaterialPageRoute(builder: (_) => const RecurringIncomePage()));
            }),
            _buildTile('Bill Tracker', Icons.receipt_long, () {
              Navigator.push(context, MaterialPageRoute(builder: (_) => const BillsPage()));
            }),
            _buildTile('Financial Insights', Icons.lightbulb, () {
              Navigator.push(context, MaterialPageRoute(builder: (_) => const FinancialInsightsPage()));
            }),
            _buildTile('Debt Manager', Icons.credit_card, () {
              Navigator.pushNamed(context, '/debt-manager');
            }),
            _buildTile('Planning & Goals', Icons.checklist, () {
              Navigator.push(context, MaterialPageRoute(builder: (_) => const PlanningPage()));
            }),
          ]),
          _buildSection('Data & Backup', [
            _buildTile('Export Data', Icons.download, () => _exportData()),
            _buildTile('Backup Data', Icons.backup, () => _backupData()),
            _buildTile('Restore Data', Icons.restore, () => _restoreData()),
          ]),
          _buildSection('Security', [
            _buildTile('Biometric Lock', Icons.fingerprint, () => _setupBiometric()),
          ]),
          _buildSection('About', [
            _buildInfoTile('Version', '1.0.0'),
          ]),
        ],
      ),
    );
  }

  Widget _buildSection(String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
          child: Text(title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.primary)),
        ),
        ...children,
        const Divider(height: 1),
      ],
    );
  }

  Widget _buildCurrencyTile() {
    return ListTile(
      leading: const Icon(Icons.attach_money),
      title: const Text('Default Currency'),
      subtitle: Text(_currency),
      trailing: const Icon(Icons.chevron_right),
      onTap: () => _showCurrencyPicker(),
    );
  }

  Widget _buildSmsDaysBackTile() {
    return ListTile(
      leading: const Icon(Icons.calendar_today),
      title: const Text('SMS Days Back'),
      subtitle: Text('$_smsDaysBack days'),
      trailing: const Icon(Icons.chevron_right),
      onTap: () => _showSmsDaysBackPicker(),
    );
  }

  Widget _buildThemeModeTile() {
    return ListTile(
      leading: const Icon(Icons.palette),
      title: const Text('Theme Mode'),
      subtitle: Text(_themeMode == 'light' ? 'Light' : _themeMode == 'dark' ? 'Dark' : 'System'),
      trailing: const Icon(Icons.chevron_right),
      onTap: () => _showThemeModePicker(),
    );
  }

  Widget _buildAutoSyncTile() {
    return SwitchListTile(
      secondary: const Icon(Icons.sync),
      title: const Text('Auto-sync on Launch'),
      subtitle: const Text('Sync SMS when app opens'),
      value: _autoSync,
      onChanged: (val) async {
        setState(() => _autoSync = val);
        final prefs = await SharedPreferences.getInstance();
        await prefs.setBool('auto_sync', val);
      },
    );
  }

  Widget _buildBudgetLimitsTile() {
    return ListTile(
      leading: const Icon(Icons.account_balance_wallet),
      title: const Text('Budget Limits'),
      subtitle: const Text('Set spending limits'),
      trailing: const Icon(Icons.chevron_right),
      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const BudgetLimitsPage())),
    );
  }

  Widget _buildSwitchTile(String title, bool value, Function(bool) onChanged) {
    return SwitchListTile(title: Text(title), value: value, onChanged: onChanged);
  }

  Widget _buildTile(String title, IconData icon, VoidCallback onTap) {
    return ListTile(leading: Icon(icon), title: Text(title), trailing: const Icon(Icons.chevron_right), onTap: onTap);
  }

  Widget _buildInfoTile(String title, String value) {
    return ListTile(leading: const Icon(Icons.info), title: Text(title), trailing: Text(value));
  }

  void _showCurrencyPicker() {
    final currencies = ['KSh', 'USD', 'EUR', 'GBP', 'TZS', 'UGX'];
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Select Currency'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: currencies.map((c) => RadioListTile<String>(
            title: Text(c),
            value: c,
            groupValue: _currency,
            onChanged: (val) async {
              setState(() => _currency = val!);
              final prefs = await SharedPreferences.getInstance();
              await prefs.setString('currency', val!);
              await CurrencyHelper.setCurrency(val);
              Navigator.pop(context);
            },
          )).toList(),
        ),
      ),
    );
  }

  void _showSmsDaysBackPicker() {
    final days = [7, 14, 30, 60, 90, 180];
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('SMS Days Back'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: days.map((d) => RadioListTile<int>(
            title: Text('$d days'),
            value: d,
            groupValue: _smsDaysBack,
            onChanged: (val) async {
              setState(() => _smsDaysBack = val!);
              final prefs = await SharedPreferences.getInstance();
              await prefs.setInt('sms_days_back', val!);
              Navigator.pop(context);
            },
          )).toList(),
        ),
      ),
    );
  }

  void _showThemeModePicker() {
    final modes = {'light': 'Light', 'dark': 'Dark', 'system': 'System'};
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Theme Mode'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: modes.entries.map((e) => RadioListTile<String>(
            title: Text(e.value),
            value: e.key,
            groupValue: _themeMode,
            onChanged: (val) async {
              setState(() => _themeMode = val!);
              final prefs = await SharedPreferences.getInstance();
              await prefs.setString('theme_mode', val!);
              Navigator.pop(context);
            },
          )).toList(),
        ),
      ),
    );
  }

  Future<void> _exportData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final data = {
        'transactions': prefs.getString('emergency_fund_transactions') ?? '[]',
        'goals': prefs.getString('savings_goals') ?? '[]',
        'incomes': prefs.getString('expected_incomes') ?? '[]',
        'rules': prefs.getString('savings_rules') ?? '[]',
      };
      
      final dir = await getApplicationDocumentsDirectory();
      final file = File('${dir.path}/nest_export_${DateTime.now().millisecondsSinceEpoch}.json');
      await file.writeAsString(jsonEncode(data));
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Exported to ${file.path}')));
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Export failed: $e')));
      }
    }
  }

  Future<void> _backupData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final backup = prefs.getKeys().fold<Map<String, dynamic>>({}, (map, key) {
        map[key] = prefs.get(key);
        return map;
      });
      
      final dir = await getApplicationDocumentsDirectory();
      final file = File('${dir.path}/nest_backup_${DateTime.now().millisecondsSinceEpoch}.json');
      await file.writeAsString(jsonEncode(backup));
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Backup saved to ${file.path}')));
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Backup failed: $e')));
      }
    }
  }

  Future<void> _restoreData() async {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Restore Data'),
        content: const Text('This will replace all current data. Continue?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Restore feature coming soon')));
            },
            child: const Text('Restore'),
          ),
        ],
      ),
    );
  }

  Future<void> _setupBiometric() async {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Biometric Lock'),
        content: const Text('Biometric authentication coming in next update.'),
        actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text('OK'))],
      ),
    );
  }
}

class BudgetLimitsPage extends StatefulWidget {
  const BudgetLimitsPage({super.key});

  @override
  State<BudgetLimitsPage> createState() => _BudgetLimitsPageState();
}

class _BudgetLimitsPageState extends State<BudgetLimitsPage> {
  Map<String, double> _budgets = {};
  String _currency = 'KSh';

  @override
  void initState() {
    super.initState();
    _loadBudgets();
  }

  Future<void> _loadBudgets() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString('budget_limits') ?? '{}';
    _currency = await CurrencyHelper.getCurrency();
    setState(() => _budgets = Map<String, double>.from(jsonDecode(data)));
  }

  Future<void> _saveBudgets() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('budget_limits', jsonEncode(_budgets));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Budget Limits')),
      floatingActionButton: FloatingActionButton(onPressed: _addBudget, child: const Icon(Icons.add)),
      body: _budgets.isEmpty
          ? const Center(child: Text('No budget limits set'))
          : ListView.builder(
              itemCount: _budgets.length,
              itemBuilder: (context, index) {
                final entry = _budgets.entries.elementAt(index);
                return ListTile(
                  title: Text(entry.key),
                  subtitle: Text('$_currency ${entry.value.toStringAsFixed(0)}'),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () {
                      setState(() => _budgets.remove(entry.key));
                      _saveBudgets();
                    },
                  ),
                  onTap: () => _editBudget(entry.key, entry.value),
                );
              },
            ),
    );
  }

  void _addBudget() {
    final categoryController = TextEditingController();
    final amountController = TextEditingController();
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Budget Limit'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: categoryController, decoration: const InputDecoration(labelText: 'Category')),
            TextField(controller: amountController, keyboardType: TextInputType.number, decoration: InputDecoration(labelText: 'Limit ($_currency)')),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          TextButton(
            onPressed: () {
              if (categoryController.text.isNotEmpty && amountController.text.isNotEmpty) {
                setState(() => _budgets[categoryController.text] = double.parse(amountController.text));
                _saveBudgets();
                Navigator.pop(context);
              }
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  void _editBudget(String category, double amount) {
    final amountController = TextEditingController(text: amount.toString());
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Edit $category Budget'),
        content: TextField(controller: amountController, keyboardType: TextInputType.number, decoration: InputDecoration(labelText: 'Limit ($_currency)')),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          TextButton(
            onPressed: () {
              if (amountController.text.isNotEmpty) {
                setState(() => _budgets[category] = double.parse(amountController.text));
                _saveBudgets();
                Navigator.pop(context);
              }
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }
}

class CategoryManagementPage extends StatefulWidget {
  const CategoryManagementPage({super.key});

  @override
  State<CategoryManagementPage> createState() => _CategoryManagementPageState();
}

class _CategoryManagementPageState extends State<CategoryManagementPage> {
  List<String> _categories = [];

  @override
  void initState() {
    super.initState();
    _loadCategories();
  }

  Future<void> _loadCategories() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getStringList('custom_categories') ?? [];
    setState(() => _categories = data);
  }

  Future<void> _saveCategories() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('custom_categories', _categories);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Manage Categories')),
      floatingActionButton: FloatingActionButton(onPressed: _addCategory, child: const Icon(Icons.add)),
      body: _categories.isEmpty
          ? const Center(child: Text('No custom categories'))
          : ListView.builder(
              itemCount: _categories.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(_categories[index]),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () {
                      setState(() => _categories.removeAt(index));
                      _saveCategories();
                    },
                  ),
                );
              },
            ),
    );
  }

  void _addCategory() {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Category'),
        content: TextField(controller: controller, decoration: const InputDecoration(labelText: 'Category Name')),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          TextButton(
            onPressed: () {
              if (controller.text.isNotEmpty) {
                setState(() => _categories.add(controller.text));
                _saveCategories();
                Navigator.pop(context);
              }
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }
}
