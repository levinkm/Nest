# Recurring Income - Auto-Mark & History Implementation Guide

## Requirements

1. **Auto-mark transactions**: When SMS matches recurring income, tag/create transaction
2. **Transaction history**: Show all transactions linked to each recurring income
3. **Monthly totals**: Calculate monthly value for daily/weekly incomes

## Implementation Steps

### 1. Update Database Schema

Add `recurringIncomeId` to transactions table:

```sql
ALTER TABLE transactions ADD COLUMN recurringIncomeId TEXT;
```

### 2. SMS Parser Integration

When parsing SMS, check for recurring income matches:

```dart
// In SMS parser after creating transaction
final db = LocalDatabase();
final incomes = await db.getRecurringIncomes();
final service = SmartCategorizationService();

final matched = service.matchRecurringIncome(transaction, incomes);
if (matched != null && matched.autoMark) {
  // Tag transaction with recurring income ID
  transaction = transaction.copyWith(
    recurringIncomeId: matched.id,
    category: matched.source == 'salary' ? 'Salary' : 'Income',
  );
  
  // Update last received date
  await db.updateRecurringIncome(matched.id, {
    'lastReceived': transaction.date.toIso8601String(),
    'nextExpected': matched.calculateNextExpected().toIso8601String(),
  });
}

await db.insertTransaction(transaction);
```

### 3. Get Transactions for Recurring Income

```dart
Future<List<Transaction>> getTransactionsForIncome(String incomeId) async {
  final db = await database;
  final maps = await db.query(
    'transactions',
    where: 'recurringIncomeId = ?',
    whereArgs: [incomeId],
    orderBy: 'date DESC',
  );
  return maps.map((m) => Transaction.fromJson(m)).toList();
}
```

### 4. Calculate Monthly Total

```dart
double calculateMonthlyTotal(RecurringIncome income, List<Transaction> transactions) {
  final now = DateTime.now();
  final monthStart = DateTime(now.year, now.month, 1);
  final monthEnd = DateTime(now.year, now.month + 1, 0);
  
  final monthTransactions = transactions.where((t) =>
    t.date.isAfter(monthStart) && t.date.isBefore(monthEnd)
  ).toList();
  
  return monthTransactions.fold(0.0, (sum, t) => sum + t.amount);
}

double calculateProjectedMonthly(RecurringIncome income, List<Transaction> transactions) {
  if (income.frequency == 'monthly') {
    return income.isVariableAmount 
        ? (income.minAmount! + income.maxAmount!) / 2 
        : income.amount;
  }
  
  // Calculate average from last 30 days
  final thirtyDaysAgo = DateTime.now().subtract(Duration(days: 30));
  final recentTxns = transactions.where((t) => t.date.isAfter(thirtyDaysAgo)).toList();
  
  if (recentTxns.isEmpty) {
    // Estimate based on frequency
    if (income.frequency == 'daily') {
      return income.isVariableAmount 
          ? ((income.minAmount! + income.maxAmount!) / 2) * 30 
          : income.amount * 30;
    } else if (income.frequency == 'weekly') {
      return income.isVariableAmount 
          ? ((income.minAmount! + income.maxAmount!) / 2) * 4 
          : income.amount * 4;
    } else if (income.frequency == 'biweekly') {
      return income.isVariableAmount 
          ? ((income.minAmount! + income.maxAmount!) / 2) * 2 
          : income.amount * 2;
    }
  }
  
  // Use actual average
  final total = recentTxns.fold(0.0, (sum, t) => sum + t.amount);
  final daysWithIncome = recentTxns.length;
  final avgPerOccurrence = total / daysWithIncome;
  
  // Project to monthly
  if (income.frequency == 'daily') return avgPerOccurrence * 30;
  if (income.frequency == 'weekly') return avgPerOccurrence * 4;
  if (income.frequency == 'biweekly') return avgPerOccurrence * 2;
  
  return total;
}
```

### 5. Enhanced Recurring Income Card

```dart
Widget _buildIncomeCard(RecurringIncome income) {
  return FutureBuilder<List<Transaction>>(
    future: _getTransactionsForIncome(income.id),
    builder: (context, snapshot) {
      final transactions = snapshot.data ?? [];
      final monthlyTotal = calculateMonthlyTotal(income, transactions);
      final projectedMonthly = calculateProjectedMonthly(income, transactions);
      
      return Container(
        // ... existing card UI
        child: Column(
          children: [
            // Existing amount display
            
            // Add monthly total
            if (income.frequency != 'monthly') ...[
              Divider(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('This Month', style: TextStyle(color: AppColors.textSecondary)),
                  Text('$_currency ${monthlyTotal.toStringAsFixed(0)}', 
                    style: TextStyle(color: AppColors.income, fontWeight: FontWeight.bold)),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Projected Monthly', style: TextStyle(color: AppColors.textSecondary, fontSize: 12)),
                  Text('$_currency ${projectedMonthly.toStringAsFixed(0)}', 
                    style: TextStyle(color: AppColors.textSecondary, fontSize: 12)),
                ],
              ),
            ],
            
            // Transaction count
            if (transactions.isNotEmpty) ...[
              SizedBox(height: 8),
              Text('${transactions.length} transactions', 
                style: TextStyle(color: AppColors.textSecondary, fontSize: 12)),
            ],
          ],
        ),
      );
    },
  );
}
```

### 6. Transaction History Screen

```dart
class IncomeHistoryScreen extends StatelessWidget {
  final RecurringIncome income;
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('${income.name} History')),
      body: FutureBuilder<List<Transaction>>(
        future: _getTransactions(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return CircularProgressIndicator();
          
          final transactions = snapshot.data!;
          final monthlyTotal = calculateMonthlyTotal(income, transactions);
          
          return Column(
            children: [
              // Summary card
              Container(
                padding: EdgeInsets.all(16),
                child: Column(
                  children: [
                    Text('This Month Total'),
                    Text('$_currency ${monthlyTotal.toStringAsFixed(0)}',
                      style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold)),
                    Text('${transactions.where((t) => isThisMonth(t.date)).length} transactions'),
                  ],
                ),
              ),
              
              // Transaction list
              Expanded(
                child: ListView.builder(
                  itemCount: transactions.length,
                  itemBuilder: (context, index) {
                    final txn = transactions[index];
                    return ListTile(
                      title: Text(txn.description),
                      subtitle: Text(DateFormat('MMM d, yyyy').format(txn.date)),
                      trailing: Text('$_currency ${txn.amount.toStringAsFixed(0)}',
                        style: TextStyle(color: AppColors.income, fontWeight: FontWeight.bold)),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
```

### 7. Update Transaction Model

Add `recurringIncomeId` field:

```dart
class Transaction {
  final String? recurringIncomeId;
  
  // ... other fields
}
```

## Usage Flow

### For User Adding Salary:
1. User adds "Monthly Salary" with merchant "ACME Corp"
2. When SMS arrives: "You received KSh 50,000 from ACME Corp"
3. System automatically:
   - Creates transaction with `recurringIncomeId`
   - Sets category to "Salary"
   - Updates `lastReceived` date
   - Calculates `nextExpected` date

### For Pool Business (Daily):
1. User adds "Pool Business" with range 100-300, merchant "Jusper Kipchirchir"
2. Daily SMS: "You received KSh 250 from Jusper Kipchirchir"
3. System:
   - Tags transaction with recurring income ID
   - Tracks all daily transactions
   - Calculates monthly total (e.g., 25 days × avg 200 = KSh 5,000)
   - Shows projected monthly based on actual pattern

### Viewing History:
1. Tap on recurring income card
2. See all linked transactions
3. View monthly totals
4. See projected monthly income

## Database Migration

```dart
if (oldVersion < 8) {
  await db.execute('ALTER TABLE transactions ADD COLUMN recurringIncomeId TEXT');
}
```

Update `AppConstants.dbVersion = 8`

## Next Steps

1. Update database schema (add column)
2. Modify SMS parser to check recurring incomes
3. Add transaction history screen
4. Update recurring income card with monthly totals
5. Test with real SMS data

## Benefits

✅ Automatic transaction tagging
✅ No manual categorization needed
✅ Accurate monthly income tracking
✅ Historical data for budgeting
✅ Projected income for planning
✅ Works for variable daily income (Pool Business)
✅ Works for fixed monthly income (Salary)
