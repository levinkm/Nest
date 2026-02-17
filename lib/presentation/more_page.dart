import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/debug/debug_menu_page.dart';
import '../../features/financial_planning/presentation/pages/financial_planning_page.dart';
import '../../features/debt_management/presentation/pages/debt_management_page.dart';
import '../features/settings/presentation/pages/settings_page.dart';
import '../../features/ledger/presentation/pages/ledger_page.dart';
import '../../features/analytics/presentation/pages/analytics_dashboard_page.dart';
import '../../features/bills/presentation/pages/bills_page.dart';
import '../../features/bills/presentation/pages/financial_insights_page.dart';
import '../../features/transactions/presentation/pages/recurring_income_page.dart';
import '../../features/planning/presentation/pages/planning_page.dart';

class MorePage extends StatelessWidget {
  const MorePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: const Text(
          'More',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text(
            'Analytics',
            style: TextStyle(
              color: AppColors.textSecondary,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          _buildMenuItem(
            context,
            icon: Icons.analytics_rounded,
            title: 'Analytics Dashboard',
            subtitle: 'Insights & spending patterns',
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const AnalyticsDashboardPage()),
            ),
          ),
          const SizedBox(height: 12),
          _buildMenuItem(
            context,
            icon: Icons.account_balance_rounded,
            title: 'M-Pesa Ledger',
            subtitle: 'View & export account ledger',
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const LedgerPage()),
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            'Financial Planning',
            style: TextStyle(
              color: AppColors.textSecondary,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          _buildMenuItem(
            context,
            icon: Icons.savings_rounded,
            title: 'Financial Planning',
            subtitle: 'Goals, savings & projections',
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const FinancialPlanningPage()),
            ),
          ),
          const SizedBox(height: 12),
          _buildMenuItem(
            context,
            icon: Icons.checklist_rounded,
            title: 'Planning & Goals',
            subtitle: 'Track goals with estimated costs',
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const PlanningPage()),
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            'Income & Expenses',
            style: TextStyle(
              color: AppColors.textSecondary,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          _buildMenuItem(
            context,
            icon: Icons.attach_money_rounded,
            title: 'Recurring Income',
            subtitle: 'Track salary & regular income',
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const RecurringIncomePage()),
            ),
          ),
          const SizedBox(height: 12),
          _buildMenuItem(
            context,
            icon: Icons.receipt_long_rounded,
            title: 'Bill Tracker',
            subtitle: 'Manage bills & payments',
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const BillsPage()),
            ),
          ),
          const SizedBox(height: 12),
          _buildMenuItem(
            context,
            icon: Icons.credit_card_rounded,
            title: 'Debt Management',
            subtitle: 'Track and manage debts',
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const DebtManagementPage()),
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            'Insights',
            style: TextStyle(
              color: AppColors.textSecondary,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          _buildMenuItem(
            context,
            icon: Icons.lightbulb_rounded,
            title: 'Financial Insights',
            subtitle: 'Affordability & predictions',
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const FinancialInsightsPage()),
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            'Settings',
            style: TextStyle(
              color: AppColors.textSecondary,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          _buildMenuItem(
            context,
            icon: Icons.settings_rounded,
            title: 'Settings',
            subtitle: 'App preferences & configuration',
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const SettingsPage()),
            ),
          ),
          const SizedBox(height: 12),
          _buildMenuItem(
            context,
            icon: Icons.developer_mode_rounded,
            title: 'Debug Menu',
            subtitle: 'Developer tools & testing',
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const DebugMenuPage()),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(icon, color: AppColors.primary, size: 24),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          color: AppColors.textPrimary,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        subtitle,
                        style: const TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                const Icon(
                  Icons.chevron_right_rounded,
                  color: AppColors.textSecondary,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
