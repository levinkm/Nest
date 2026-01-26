# Budget Module Documentation

## Overview
Comprehensive budgeting module for personal finance tracking with expense monitoring, analytics, and goal setting.

## Features

### 1. Budget Creation & Customization
- **Periods**: Weekly, Monthly, Custom
- **Templates**: 50/30/20 rule (Needs/Wants/Savings)
- **Categories**: Custom categories with icons and sub-categories
- **Rollover**: Unused budget carries to next period

### 2. Income Integration
- Multiple income sources
- Recurring income tracking
- Automatic allocation to budget categories

### 3. Expense Tracking
- Real-time expense syncing
- Automatic categorization using keyword matching
- Progress indicators (Green < 80%, Orange 80-100%, Red > 100%)
- Push notifications at 80% and 100% thresholds

### 4. Analytics & Reporting
- Pie charts for category spending
- Bar charts for budget vs actual
- Historical comparisons
- AI-powered insights and recommendations
- Export to CSV/PDF

### 5. Goals & Savings
- Savings goal tracking
- Progress monitoring
- Budget linking

### 6. Recurring Bills
- Bill reminders
- Due date tracking
- Auto-deduction from budget

## Architecture

```
lib/features/budget/
├── models/          # Data models (Freezed)
├── repositories/    # SQLite database layer
├── blocs/          # State management (BLoC)
├── screens/        # UI screens
├── widgets/        # Reusable components
└── services/       # Business logic
```

## Key Files

- `models/budget.dart` - Core data models
- `repositories/budget_repository.dart` - Database operations
- `blocs/budget_bloc.dart` - State management
- `screens/budget_screen.dart` - Main budget list
- `screens/create_budget_screen.dart` - Budget creation
- `screens/analytics_screen.dart` - Charts and insights
- `services/categorization_service.dart` - AI categorization
- `services/notification_service.dart` - Alerts
- `services/export_service.dart` - Report generation

## Usage

```dart
// Create budget
final budget = Budget(
  id: uuid.v4(),
  name: 'Monthly Budget',
  period: BudgetPeriod.monthly,
  startDate: DateTime.now(),
  endDate: DateTime.now().add(Duration(days: 30)),
  totalAmount: 3000,
  categories: [
    BudgetCategory(id: '1', name: 'Groceries', icon: '🏠', allocatedAmount: 500),
  ],
);

// Add to database
context.read<BudgetBloc>().add(BudgetEvent.createBudget(budget));

// Track expense
final expense = Expense(
  id: uuid.v4(),
  categoryId: '1',
  amount: 50,
  date: DateTime.now(),
  description: 'Walmart',
  budgetId: budget.id,
);

context.read<BudgetBloc>().add(BudgetEvent.addExpense(expense));
```

## Security
- Local SQLite database with encryption support
- No sensitive data in logs
- Secure file exports

## Dependencies
- `flutter_bloc` - State management
- `freezed` - Immutable models
- `sqflite` - Local database
- `fl_chart` - Visualizations
- `string_similarity` - AI categorization
- `share_plus` - Export functionality

## Future Enhancements
- Bank API integration
- Machine learning categorization
- Multi-currency support
- Cloud sync
- Collaborative budgets
