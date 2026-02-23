import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:file_picker/file_picker.dart';
import '../../../transactions/presentation/pages/classification_rules_page.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/currency_helper.dart';
import '../../../../core/services/backup_service.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../notifications/presentation/pages/notification_settings_page.dart';

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

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _currency = prefs.getString('currency') ?? AppConstants.defaultCurrency;
      _smsDaysBack =
          prefs.getInt('sms_days_back') ?? AppConstants.defaultSmsDaysBack;
      _themeMode =
          prefs.getString('theme_mode') ?? AppConstants.defaultThemeMode;
      _autoSync = prefs.getBool('auto_sync') ?? AppConstants.defaultAutoSync;
    });
  }

  Widget _buildSection(String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: AppColors.primary,
            ),
          ),
        ),
        ...children,
        const Divider(height: 1),
      ],
    );
  }

  Widget _buildCurrencyTile() {
    return ListTile(
      leading: const Icon(Icons.attach_money, color: AppColors.textPrimary),
      title: const Text(
        'Default Currency',
        style: TextStyle(color: AppColors.textPrimary),
      ),
      subtitle: Text(
        _currency,
        style: const TextStyle(color: AppColors.textSecondary),
      ),
      trailing: const Icon(Icons.chevron_right, color: AppColors.textSecondary),
      onTap: () => _showCurrencyPicker(),
    );
  }

  Widget _buildSmsDaysBackTile() {
    return ListTile(
      leading: const Icon(Icons.calendar_today, color: AppColors.textPrimary),
      title: const Text(
        'SMS Days Back',
        style: TextStyle(color: AppColors.textPrimary),
      ),
      subtitle: Text(
        '$_smsDaysBack days',
        style: const TextStyle(color: AppColors.textSecondary),
      ),
      trailing: const Icon(Icons.chevron_right, color: AppColors.textSecondary),
      onTap: () => _showSmsDaysBackPicker(),
    );
  }

  Widget _buildThemeModeTile() {
    return ListTile(
      leading: const Icon(Icons.palette, color: AppColors.textPrimary),
      title: const Text(
        'Theme Mode',
        style: TextStyle(color: AppColors.textPrimary),
      ),
      subtitle: Text(
        _themeMode == 'light'
            ? 'Light'
            : _themeMode == 'dark'
            ? 'Dark'
            : 'System',
        style: const TextStyle(color: AppColors.textSecondary),
      ),
      trailing: const Icon(Icons.chevron_right, color: AppColors.textSecondary),
      onTap: () => _showThemeModePicker(),
    );
  }

  Widget _buildAutoSyncTile() {
    return SwitchListTile(
      secondary: const Icon(Icons.sync, color: AppColors.textPrimary),
      title: const Text(
        'Auto-sync on Launch',
        style: TextStyle(color: AppColors.textPrimary),
      ),
      subtitle: const Text(
        'Sync SMS when app opens',
        style: TextStyle(color: AppColors.textSecondary),
      ),
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
      leading: const Icon(
        Icons.account_balance_wallet,
        color: AppColors.textPrimary,
      ),
      title: const Text(
        'Budget Limits',
        style: TextStyle(color: AppColors.textPrimary),
      ),
      subtitle: const Text(
        'Set spending limits',
        style: TextStyle(color: AppColors.textSecondary),
      ),
      trailing: const Icon(Icons.chevron_right, color: AppColors.textSecondary),
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const BudgetLimitsPage()),
      ),
    );
  }

  Widget _buildTile(String title, IconData icon, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon, color: AppColors.textPrimary),
      title: Text(title, style: const TextStyle(color: AppColors.textPrimary)),
      trailing: const Icon(Icons.chevron_right, color: AppColors.textSecondary),
      onTap: onTap,
    );
  }

  Widget _buildInfoTile(String title, String value) {
    return ListTile(
      leading: const Icon(Icons.info, color: AppColors.textPrimary),
      title: Text(title, style: const TextStyle(color: AppColors.textPrimary)),
      trailing: Text(
        value,
        style: const TextStyle(color: AppColors.textSecondary),
      ),
    );
  }

  void _showCurrencyPicker() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Select Currency'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: AppConstants.supportedCurrencies
              .map(
                (c) => RadioListTile<String>(
                  title: Text(c),
                  value: c,
                  groupValue: _currency,
                  onChanged: (val) async {
                    setState(() => _currency = val!);
                    final prefs = await SharedPreferences.getInstance();
                    await prefs.setString('currency', val!);
                    await CurrencyHelper.setCurrency(val);
                    if (context.mounted) {
                      Navigator.pop(context);
                    }
                  },
                ),
              )
              .toList(),
        ),
      ),
    );
  }

  void _showSmsDaysBackPicker() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('SMS Days Back'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: AppConstants.smsDaysBackOptions
              .map(
                (d) => RadioListTile<int>(
                  title: Text('$d days'),
                  value: d,
                  groupValue: _smsDaysBack,
                  onChanged: (val) async {
                    setState(() => _smsDaysBack = val!);
                    final prefs = await SharedPreferences.getInstance();
                    await prefs.setInt('sms_days_back', val!);
                    if (context.mounted) {
                      Navigator.pop(context);
                    }
                  },
                ),
              )
              .toList(),
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
          children: modes.entries
              .map(
                (e) => RadioListTile<String>(
                  title: Text(e.value),
                  value: e.key,
                  groupValue: _themeMode,
                  onChanged: (val) async {
                    setState(() => _themeMode = val!);
                    final prefs = await SharedPreferences.getInstance();
                    await prefs.setString('theme_mode', val!);
                    if (context.mounted) {
                      Navigator.pop(context);
                    }
                  },
                ),
              )
              .toList(),
        ),
      ),
    );
  }

  Future<void> _backupData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final backup = prefs.getKeys().fold<Map<String, dynamic>>({}, (map, key) {
        map[key] = prefs.get(key);
        return map;
      });

      final dir = await getApplicationDocumentsDirectory();
      final file = File(
        '${dir.path}/nest_backup_${DateTime.now().millisecondsSinceEpoch}.json',
      );
      await file.writeAsString(jsonEncode(backup));

      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Backup saved to ${file.path}')));
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Backup failed: $e')));
      }
    }
  }

  Future<void> _cloudBackup() async {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Cloud Backup'),
        content: const Text('Choose backup format'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              final navigator = Navigator.of(context);
              final messenger = ScaffoldMessenger.of(context);
              navigator.pop();
              try {
                await BackupService.shareBackup('csv');
                if (mounted) {
                  messenger.showSnackBar(
                    const SnackBar(content: Text('CSV backup shared')),
                  );
                }
              } catch (e) {
                if (mounted) {
                  messenger.showSnackBar(SnackBar(content: Text('Failed: $e')));
                }
              }
            },
            child: const Text('CSV'),
          ),
          TextButton(
            onPressed: () async {
              final navigator = Navigator.of(context);
              final messenger = ScaffoldMessenger.of(context);
              navigator.pop();
              try {
                await BackupService.shareBackup('json');
                if (mounted) {
                  messenger.showSnackBar(
                    const SnackBar(content: Text('JSON backup shared')),
                  );
                }
              } catch (e) {
                if (mounted) {
                  messenger.showSnackBar(SnackBar(content: Text('Failed: $e')));
                }
              }
            },
            child: const Text('JSON'),
          ),
        ],
      ),
    );
  }

  Future<void> _restoreData() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['json', 'csv'],
    );

    if (result == null || result.files.single.path == null) return;

    if (!mounted) return;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Restore Data'),
        content: const Text('This will replace all current data. Continue?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              final navigator = Navigator.of(context);
              final messenger = ScaffoldMessenger.of(context);
              navigator.pop();
              final success = await BackupService.restoreFromFile(
                result.files.single.path!,
              );
              if (mounted) {
                messenger.showSnackBar(
                  SnackBar(
                    content: Text(
                      success ? 'Data restored successfully' : 'Restore failed',
                    ),
                  ),
                );
                if (success) _loadSettings();
              }
            },
            child: const Text('Restore'),
          ),
        ],
      ),
    );
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
          'Settings',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SafeArea(
        child: ListView(
          children: [
            _buildSection('Financial Settings', [
              _buildCurrencyTile(),
              _buildBudgetLimitsTile(),
            ]),
            _buildSection('SMS & Sync', [
              _buildSmsDaysBackTile(),
              _buildAutoSyncTile(),
            ]),
            _buildSection('Appearance', [_buildThemeModeTile()]),
            _buildSection('Notifications', [
              _buildTile('Notification Settings', Icons.notifications, () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const NotificationSettingsPage(),
                  ),
                );
              }),
            ]),
            _buildSection('Category Management', [
              _buildTile('Manage Categories', Icons.category, () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const CategoryManagementPage(),
                  ),
                );
              }),
            ]),
            _buildSection('Classification', [
              _buildTile('Classification Rules', Icons.rule, () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const ClassificationRulesPage(),
                  ),
                );
              }),
            ]),
            _buildSection('Data & Backup', [
              _buildTile(
                'Cloud Backup (Share)',
                Icons.cloud_upload,
                () => _cloudBackup(),
              ),
              _buildTile(
                'Restore from File',
                Icons.restore,
                () => _restoreData(),
              ),
              _buildTile('Local Backup', Icons.backup, () => _backupData()),
            ]),
            _buildSection('About', [_buildInfoTile('Version', '1.0.0')]),
          ],
        ),
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
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Budget Limits',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addBudget,
        backgroundColor: AppColors.primary,
        child: const Icon(Icons.add),
      ),
      body: _budgets.isEmpty
          ? const Center(
              child: Text(
                'No budget limits set',
                style: TextStyle(color: AppColors.textSecondary),
              ),
            )
          : ListView.builder(
              itemCount: _budgets.length,
              itemBuilder: (context, index) {
                final entry = _budgets.entries.elementAt(index);
                return ListTile(
                  title: Text(
                    entry.key,
                    style: const TextStyle(color: AppColors.textPrimary),
                  ),
                  subtitle: Text(
                    '$_currency ${entry.value.toStringAsFixed(0)}',
                    style: const TextStyle(color: AppColors.textSecondary),
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete, color: AppColors.error),
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
            TextField(
              controller: categoryController,
              decoration: const InputDecoration(labelText: 'Category'),
            ),
            TextField(
              controller: amountController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: 'Limit ($_currency)'),
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
              if (categoryController.text.isNotEmpty &&
                  amountController.text.isNotEmpty) {
                setState(
                  () => _budgets[categoryController.text] = double.parse(
                    amountController.text,
                  ),
                );
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
        content: TextField(
          controller: amountController,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(labelText: 'Limit ($_currency)'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              if (amountController.text.isNotEmpty) {
                setState(
                  () =>
                      _budgets[category] = double.parse(amountController.text),
                );
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
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Manage Categories',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addCategory,
        backgroundColor: AppColors.primary,
        child: const Icon(Icons.add),
      ),
      body: _categories.isEmpty
          ? const Center(
              child: Text(
                'No custom categories',
                style: TextStyle(color: AppColors.textSecondary),
              ),
            )
          : ListView.builder(
              itemCount: _categories.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(
                    _categories[index],
                    style: const TextStyle(color: AppColors.textPrimary),
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete, color: AppColors.error),
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
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(labelText: 'Category Name'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
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
