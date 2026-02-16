import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../transactions/data/datasources/local_database.dart';
import '../../data/services/bill_detection_service.dart';
import '../../data/services/bill_reminder_service.dart';
import 'package:uuid/uuid.dart';

class BillsPage extends StatefulWidget {
  const BillsPage({super.key});

  @override
  State<BillsPage> createState() => _BillsPageState();
}

class _BillsPageState extends State<BillsPage> {
  bool _loading = true;
  List<Map<String, dynamic>> _bills = [];
  Map<String, dynamic> _forecast = {};
  List<Map<String, dynamic>> _reminders = [];

  @override
  void initState() {
    super.initState();
    _loadBills();
  }

  Future<void> _loadBills() async {
    setState(() => _loading = true);

    final db = LocalDatabase();
    await BillDetectionService.autoMatchBillPayments();

    final bills = await db.getBills();
    final forecast = await BillDetectionService.getBillForecast();
    final reminders = await BillReminderService.getUpcomingReminders();

    setState(() {
      _bills = bills;
      _forecast = forecast;
      _reminders = reminders;
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        title: const Text(
          'Bills',
          style: TextStyle(color: AppColors.textPrimary),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.add, color: AppColors.primary),
            onPressed: () => _showAddBillDialog(),
          ),
        ],
      ),
      body: _loading
          ? const Center(
              child: CircularProgressIndicator(color: AppColors.primary),
            )
          : RefreshIndicator(
              onRefresh: _loadBills,
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  if (_reminders.isNotEmpty) _buildRemindersCard(),
                  if (_reminders.isNotEmpty) const SizedBox(height: 16),
                  _buildForecastCard(),
                  const SizedBox(height: 16),
                  _buildBillsList(),
                ],
              ),
            ),
    );
  }

  Widget _buildRemindersCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.error.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.error.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(
                Icons.notifications_active,
                color: AppColors.error,
                size: 20,
              ),
              SizedBox(width: 8),
              Text(
                'Reminders',
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ..._reminders.map(
            (r) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Text(
                r['message'],
                style: const TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 14,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildForecastCard() {
    final fmt = NumberFormat('#,##0');
    final totalUpcoming = _forecast['totalUpcoming'] ?? 0.0;
    final totalOverdue = _forecast['totalOverdue'] ?? 0.0;
    final upcomingCount = _forecast['upcomingCount'] ?? 0;
    final overdueCount = _forecast['overdueCount'] ?? 0;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Bills This Month',
            style: TextStyle(
              color: AppColors.textPrimary,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          if (overdueCount > 0)
            _buildRow(
              '⚠ Overdue ($overdueCount)',
              totalOverdue,
              AppColors.error,
              fmt,
            ),
          _buildRow(
            '📅 Upcoming ($upcomingCount)',
            totalUpcoming,
            AppColors.warning,
            fmt,
          ),
          const Divider(color: AppColors.border, height: 24),
          _buildRow(
            'Total',
            totalUpcoming + totalOverdue,
            AppColors.textPrimary,
            fmt,
            bold: true,
          ),
        ],
      ),
    );
  }

  Widget _buildRow(
    String label,
    double value,
    Color color,
    NumberFormat fmt, {
    bool bold = false,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              color: AppColors.textSecondary,
              fontWeight: bold ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          Text(
            'KSh ${fmt.format(value)}',
            style: TextStyle(
              color: color,
              fontWeight: bold ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBillsList() {
    if (_bills.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(32),
        child: const Center(
          child: Text(
            'No bills yet. Tap + to add one.',
            style: TextStyle(color: AppColors.textSecondary),
          ),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'All Bills',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        ..._bills.map((bill) => _buildBillCard(bill)),
      ],
    );
  }

  Widget _buildBillCard(Map<String, dynamic> bill) {
    final dueDate = DateTime.parse(bill['dueDate']);
    final status = bill['status'];
    final amount = bill['amount'];
    final name = bill['name'];
    final frequency = bill['frequency'];

    final now = DateTime.now();
    final daysUntil = dueDate.difference(now).inDays;
    final isOverdue = status == 'upcoming' && daysUntil < 0;

    Color statusColor;
    String statusText;

    if (status == 'paid') {
      statusColor = AppColors.income;
      statusText = '✓ Paid';
    } else if (isOverdue) {
      statusColor = AppColors.error;
      statusText = '⚠ ${daysUntil.abs()} days overdue';
    } else if (daysUntil <= 3) {
      statusColor = AppColors.warning;
      statusText = '⏰ Due in $daysUntil days';
    } else {
      statusColor = AppColors.textSecondary;
      statusText = 'Due ${DateFormat('MMM d').format(dueDate)}';
    }

    return GestureDetector(
      onTap: () => _showEditBillDialog(bill),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: const TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    frequency,
                    style: const TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    statusText,
                    style: TextStyle(color: statusColor, fontSize: 12),
                  ),
                ],
              ),
            ),
            Text(
              'KSh ${NumberFormat('#,##0').format(amount)}',
              style: const TextStyle(
                color: AppColors.textPrimary,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showAddBillDialog() {
    final nameController = TextEditingController();
    final amountController = TextEditingController();
    String frequency = 'monthly';
    DateTime dueDate = DateTime.now().add(const Duration(days: 7));
    String category = 'Bills & Utilities';
    final merchantController = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => Container(
          height: MediaQuery.of(context).size.height * 0.9,
          decoration: const BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: const BoxDecoration(
                  border: Border(bottom: BorderSide(color: AppColors.border)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Cancel'),
                    ),
                    const Text(
                      'Add Bill',
                      style: TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextButton(
                      onPressed: () async {
                        final name = nameController.text.trim();
                        final amount = double.tryParse(amountController.text);

                        if (name.isNotEmpty && amount != null) {
                          final db = LocalDatabase();
                          await db.insertBill({
                            'id': const Uuid().v4(),
                            'name': name,
                            'amount': amount,
                            'dueDate': dueDate.toIso8601String(),
                            'frequency': frequency,
                            'category': category,
                            'merchant': merchantController.text.trim().isEmpty
                                ? null
                                : merchantController.text.trim(),
                            'status': 'upcoming',
                            'isActive': 1,
                            'autoDetected': 0,
                            'createdAt': DateTime.now().toIso8601String(),
                          });

                          Navigator.pop(context);
                          _loadBills();
                        }
                      },
                      child: const Text('Add'),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      TextField(
                        controller: nameController,
                        style: const TextStyle(color: AppColors.textPrimary),
                        decoration: const InputDecoration(
                          labelText: 'Bill Name *',
                          labelStyle: TextStyle(color: AppColors.textSecondary),
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextField(
                        controller: amountController,
                        keyboardType: TextInputType.number,
                        style: const TextStyle(color: AppColors.textPrimary),
                        decoration: const InputDecoration(
                          labelText: 'Amount (KSh) *',
                          labelStyle: TextStyle(color: AppColors.textSecondary),
                        ),
                      ),
                      const SizedBox(height: 16),
                      DropdownButtonFormField<String>(
                        value: frequency,
                        dropdownColor: AppColors.surface,
                        style: const TextStyle(color: AppColors.textPrimary),
                        decoration: const InputDecoration(
                          labelText: 'Frequency',
                          labelStyle: TextStyle(color: AppColors.textSecondary),
                        ),
                        items: ['one-time', 'weekly', 'monthly', 'quarterly']
                            .map(
                              (f) => DropdownMenuItem(value: f, child: Text(f)),
                            )
                            .toList(),
                        onChanged: (val) => setState(() => frequency = val!),
                      ),
                      const SizedBox(height: 16),
                      ListTile(
                        contentPadding: EdgeInsets.zero,
                        title: const Text(
                          'Due Date',
                          style: TextStyle(
                            color: AppColors.textSecondary,
                            fontSize: 14,
                          ),
                        ),
                        subtitle: Text(
                          DateFormat('MMM d, yyyy').format(dueDate),
                          style: const TextStyle(color: AppColors.textPrimary),
                        ),
                        trailing: const Icon(
                          Icons.calendar_today,
                          color: AppColors.primary,
                        ),
                        onTap: () async {
                          final picked = await showDatePicker(
                            context: context,
                            initialDate: dueDate,
                            firstDate: DateTime.now(),
                            lastDate: DateTime.now().add(
                              const Duration(days: 365),
                            ),
                          );
                          if (picked != null) setState(() => dueDate = picked);
                        },
                      ),
                      const SizedBox(height: 16),
                      DropdownButtonFormField<String>(
                        value: category,
                        dropdownColor: AppColors.surface,
                        style: const TextStyle(color: AppColors.textPrimary),
                        decoration: const InputDecoration(
                          labelText: 'Category',
                          labelStyle: TextStyle(color: AppColors.textSecondary),
                        ),
                        items:
                            [
                                  'Bills & Utilities',
                                  'Rent',
                                  'Subscriptions',
                                  'Loan Payment',
                                  'Insurance',
                                  'Other',
                                ]
                                .map(
                                  (c) => DropdownMenuItem(
                                    value: c,
                                    child: Text(c),
                                  ),
                                )
                                .toList(),
                        onChanged: (val) => setState(() => category = val!),
                      ),
                      const SizedBox(height: 16),
                      TextField(
                        controller: merchantController,
                        style: const TextStyle(color: AppColors.textPrimary),
                        decoration: const InputDecoration(
                          labelText: 'Merchant (optional)',
                          labelStyle: TextStyle(color: AppColors.textSecondary),
                          hintText: 'For auto-matching payments',
                          hintStyle: TextStyle(
                            color: AppColors.textSecondary,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showEditBillDialog(Map<String, dynamic> bill) {
    final nameController = TextEditingController(text: bill['name']);
    final amountController = TextEditingController(
      text: bill['amount'].toString(),
    );
    String frequency = bill['frequency'];
    DateTime dueDate = DateTime.parse(bill['dueDate']);
    String category = bill['category'] ?? 'Bills & Utilities';
    final merchantController = TextEditingController(
      text: bill['merchant'] ?? '',
    );

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => Container(
          height: MediaQuery.of(context).size.height * 0.9,
          decoration: const BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: const BoxDecoration(
                  border: Border(bottom: BorderSide(color: AppColors.border)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Cancel'),
                    ),
                    const Text(
                      'Edit Bill',
                      style: TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Row(
                      children: [
                        IconButton(
                          icon: const Icon(
                            Icons.delete,
                            color: AppColors.error,
                          ),
                          onPressed: () async {
                            final db = LocalDatabase();
                            await db.deleteBill(bill['id']);
                            Navigator.pop(context);
                            _loadBills();
                          },
                        ),
                        TextButton(
                          onPressed: () async {
                            final name = nameController.text.trim();
                            final amount = double.tryParse(
                              amountController.text,
                            );

                            if (name.isNotEmpty && amount != null) {
                              final db = LocalDatabase();
                              await db.updateBill(bill['id'], {
                                'name': name,
                                'amount': amount,
                                'dueDate': dueDate.toIso8601String(),
                                'frequency': frequency,
                                'category': category,
                                'merchant':
                                    merchantController.text.trim().isEmpty
                                    ? null
                                    : merchantController.text.trim(),
                              });

                              Navigator.pop(context);
                              _loadBills();
                            }
                          },
                          child: const Text('Save'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      TextField(
                        controller: nameController,
                        style: const TextStyle(color: AppColors.textPrimary),
                        decoration: const InputDecoration(
                          labelText: 'Bill Name *',
                          labelStyle: TextStyle(color: AppColors.textSecondary),
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextField(
                        controller: amountController,
                        keyboardType: TextInputType.number,
                        style: const TextStyle(color: AppColors.textPrimary),
                        decoration: const InputDecoration(
                          labelText: 'Amount (KSh) *',
                          labelStyle: TextStyle(color: AppColors.textSecondary),
                        ),
                      ),
                      const SizedBox(height: 16),
                      DropdownButtonFormField<String>(
                        value: frequency,
                        dropdownColor: AppColors.surface,
                        style: const TextStyle(color: AppColors.textPrimary),
                        decoration: const InputDecoration(
                          labelText: 'Frequency',
                          labelStyle: TextStyle(color: AppColors.textSecondary),
                        ),
                        items: ['one-time', 'weekly', 'monthly', 'quarterly']
                            .map(
                              (f) => DropdownMenuItem(value: f, child: Text(f)),
                            )
                            .toList(),
                        onChanged: (val) => setState(() => frequency = val!),
                      ),
                      const SizedBox(height: 16),
                      ListTile(
                        contentPadding: EdgeInsets.zero,
                        title: const Text(
                          'Due Date',
                          style: TextStyle(
                            color: AppColors.textSecondary,
                            fontSize: 14,
                          ),
                        ),
                        subtitle: Text(
                          DateFormat('MMM d, yyyy').format(dueDate),
                          style: const TextStyle(color: AppColors.textPrimary),
                        ),
                        trailing: const Icon(
                          Icons.calendar_today,
                          color: AppColors.primary,
                        ),
                        onTap: () async {
                          final picked = await showDatePicker(
                            context: context,
                            initialDate: dueDate,
                            firstDate: DateTime.now().subtract(
                              const Duration(days: 365),
                            ),
                            lastDate: DateTime.now().add(
                              const Duration(days: 365),
                            ),
                          );
                          if (picked != null) setState(() => dueDate = picked);
                        },
                      ),
                      const SizedBox(height: 16),
                      DropdownButtonFormField<String>(
                        value: category,
                        dropdownColor: AppColors.surface,
                        style: const TextStyle(color: AppColors.textPrimary),
                        decoration: const InputDecoration(
                          labelText: 'Category',
                          labelStyle: TextStyle(color: AppColors.textSecondary),
                        ),
                        items:
                            [
                                  'Bills & Utilities',
                                  'Rent',
                                  'Subscriptions',
                                  'Loan Payment',
                                  'Insurance',
                                  'Other',
                                ]
                                .map(
                                  (c) => DropdownMenuItem(
                                    value: c,
                                    child: Text(c),
                                  ),
                                )
                                .toList(),
                        onChanged: (val) => setState(() => category = val!),
                      ),
                      const SizedBox(height: 16),
                      TextField(
                        controller: merchantController,
                        style: const TextStyle(color: AppColors.textPrimary),
                        decoration: const InputDecoration(
                          labelText: 'Merchant (optional)',
                          labelStyle: TextStyle(color: AppColors.textSecondary),
                          hintText: 'For auto-matching payments',
                          hintStyle: TextStyle(
                            color: AppColors.textSecondary,
                            fontSize: 12,
                          ),
                        ),
                      ),
                      if (bill['status'] == 'paid') ...[
                        const SizedBox(height: 16),
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: AppColors.income.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            children: [
                              const Icon(
                                Icons.check_circle,
                                color: AppColors.income,
                                size: 20,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                'Paid on ${DateFormat('MMM d').format(DateTime.parse(bill['paidDate']))}',
                                style: const TextStyle(
                                  color: AppColors.income,
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
            ],
          ),
        ),
      ),
    );
  }
}
