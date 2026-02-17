import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/theme/app_colors.dart';
import '../../data/services/fcm_service.dart';

class NotificationSettingsPage extends StatefulWidget {
  const NotificationSettingsPage({super.key});

  @override
  State<NotificationSettingsPage> createState() =>
      _NotificationSettingsPageState();
}

class _NotificationSettingsPageState extends State<NotificationSettingsPage> {
  bool _budgetAlerts = true;
  bool _billReminders = true;
  bool _savingsMilestones = true;
  bool _debtReminders = true;
  bool _transactionAlerts = true;
  String? _fcmToken;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    final token = await FCMService().getToken();

    setState(() {
      _budgetAlerts = prefs.getBool('notif_budget') ?? true;
      _billReminders = prefs.getBool('notif_bills') ?? true;
      _savingsMilestones = prefs.getBool('notif_savings') ?? true;
      _debtReminders = prefs.getBool('notif_debt') ?? true;
      _transactionAlerts = prefs.getBool('notif_transactions') ?? true;
      _fcmToken = token;
    });

    await _updateTopicSubscriptions();
  }

  Future<void> _updateTopicSubscriptions() async {
    final fcm = FCMService();

    if (_budgetAlerts) {
      await fcm.subscribeToTopic('budget_alerts');
    } else {
      await fcm.unsubscribeFromTopic('budget_alerts');
    }

    if (_billReminders) {
      await fcm.subscribeToTopic('bill_reminders');
    } else {
      await fcm.unsubscribeFromTopic('bill_reminders');
    }

    if (_savingsMilestones) {
      await fcm.subscribeToTopic('savings_milestones');
    } else {
      await fcm.unsubscribeFromTopic('savings_milestones');
    }
  }

  Future<void> _saveSetting(String key, bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(key, value);
    await _updateTopicSubscriptions();
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
          'Notifications',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildSection('Financial Alerts', [
            _buildSwitch(
              'Budget Alerts',
              'Get notified when approaching budget limits',
              _budgetAlerts,
              (val) {
                setState(() => _budgetAlerts = val);
                _saveSetting('notif_budget', val);
              },
            ),
            _buildSwitch(
              'Bill Reminders',
              'Reminders for upcoming bill payments',
              _billReminders,
              (val) {
                setState(() => _billReminders = val);
                _saveSetting('notif_bills', val);
              },
            ),
            _buildSwitch(
              'Transaction Alerts',
              'Real-time alerts for new transactions',
              _transactionAlerts,
              (val) {
                setState(() => _transactionAlerts = val);
                _saveSetting('notif_transactions', val);
              },
            ),
          ]),
          const SizedBox(height: 16),
          _buildSection('Goals & Savings', [
            _buildSwitch(
              'Savings Milestones',
              'Celebrate when you reach savings goals',
              _savingsMilestones,
              (val) {
                setState(() => _savingsMilestones = val);
                _saveSetting('notif_savings', val);
              },
            ),
            _buildSwitch(
              'Debt Reminders',
              'Reminders for debt payments',
              _debtReminders,
              (val) {
                setState(() => _debtReminders = val);
                _saveSetting('notif_debt', val);
              },
            ),
          ]),
          if (_fcmToken != null) ...[
            const SizedBox(height: 24),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Device Token',
                    style: TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _fcmToken!,
                    style: const TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 10,
                      fontFamily: 'monospace',
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildSection(String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 8),
          child: Text(
            title,
            style: const TextStyle(
              color: AppColors.textSecondary,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(children: children),
        ),
      ],
    );
  }

  Widget _buildSwitch(
    String title,
    String subtitle,
    bool value,
    Function(bool) onChanged,
  ) {
    return SwitchListTile(
      title: Text(title, style: const TextStyle(color: AppColors.textPrimary)),
      subtitle: Text(
        subtitle,
        style: const TextStyle(color: AppColors.textSecondary, fontSize: 12),
      ),
      value: value,
      onChanged: onChanged,
      activeColor: AppColors.primary,
    );
  }
}
