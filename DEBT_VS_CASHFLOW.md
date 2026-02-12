# Debt vs Cash Flow Separation

## Core Concept

```
┌─────────────────────────────────────┐
│   INCOME/EXPENSE (Cash Flow)       │
│   - Salary, business, gifts         │
│   - Food, rent, entertainment       │
│   - Interest & fees (cost of debt)  │
└─────────────────────────────────────┘
         ↕ Affects Net Income

┌─────────────────────────────────────┐
│   DEBT (Liabilities)                │
│   - Loans, overdrafts, credit       │
│   - Principal amounts owed          │
│   - Tracked separately              │
└─────────────────────────────────────┘
         ↕ Affects Net Worth
```

## M-Pesa Fuliza Model

### Account Structure
```dart
Account {
  balance: 1500.00          // Current M-Pesa balance
  creditLimit: 5000.00      // Maximum Fuliza you can borrow
  
  // Calculated properties:
  debtBalance: 0.00         // If balance < 0, abs(balance)
  availableCredit: 5000.00  // creditLimit - debtBalance
  utilizationPercentage: 0% // (debtBalance / creditLimit) * 100
  isOverdrawn: false        // balance < 0
}
```

### When You Borrow Fuliza
```
Before:
  Balance: 1000.00
  Debt: 0.00

Borrow 500:
  Balance: 1500.00 (+500)
  Debt: 0.00 (still positive balance)

Borrow another 2000:
  Balance: -500.00 (overdrawn)
  Debt: 500.00 (negative balance = debt)
  Available Credit: 4500.00 (5000 - 500)
```

### Display in UI
```
┌─────────────────────────────────┐
│  M-Pesa Fuliza                  │
│                                 │
│  Balance: KES -500.00           │
│  Owed: KES 500.00               │
│  Limit: KES 5,000               │
│  Available: KES 4,500           │
│                                 │
│  Utilization: 10% ██░░░░░░░░    │
│                                 │
│  Due Date: Jan 30, 2024         │
└─────────────────────────────────┘
```

## Transaction Types

### 1. Income (Cash Flow)
```dart
type: 'income'
category: 'Salary', 'Business', etc.
effect: balance += amount
```

### 2. Expense (Cash Flow)
```dart
type: 'expense'
category: 'Food', 'Rent', 'Interest & Fees', etc.
effect: balance -= amount
```

### 3. Debt Borrowed (Liability)
```dart
type: 'debt'
effect: balance += amount (money comes in)
note: If balance goes negative, debt is tracked
```

### 4. Debt Repayment (Liability Reduction)
```dart
type: 'debt_payment'
effect: balance -= amount (money goes out)
note: Reduces negative balance (debt)
```

## Fuliza Transaction Handling

### Scenario 1: Borrow Fuliza
**SMS**: "You have used Fuliza M-PESA of Ksh500.00"

```dart
Transaction {
  type: 'debt'
  amount: 500.00
  accountId: 'mpesa_default'
}

Account Update:
  balance: 1000 + 500 = 1500
  // If balance goes negative, that's debt
```

### Scenario 2: Fuliza Interest
**SMS**: "Fuliza interest charge of Ksh15.00"

```dart
Transaction {
  type: 'expense'
  category: 'Interest & Fees'
  amount: 15.00
  accountId: 'mpesa_default'
}

Account Update:
  balance: 1500 - 15 = 1485
```

### Scenario 3: Repay Fuliza
**SMS**: "You have repaid Fuliza M-PESA of Ksh300.00"

```dart
Transaction {
  type: 'debt_payment'
  amount: 300.00
  accountId: 'mpesa_default'
}

Account Update:
  balance: 1485 - 300 = 1185
  // If balance was negative, debt reduces
```

## Complete Example

### Starting Point
```
M-Pesa Balance: 1000.00
Fuliza Limit: 5000.00
Debt: 0.00
```

### Day 1: Borrow 2000
```
Transaction: debt, 2000.00
Balance: 1000 + 2000 = 3000.00
Debt: 0.00 (still positive)
```

### Day 2: Spend 3500
```
Transaction: expense, 3500.00
Balance: 3000 - 3500 = -500.00
Debt: 500.00 (negative balance)
Available Credit: 5000 - 500 = 4500.00
```

### Day 3: Interest Charged
```
Transaction: expense (Interest & Fees), 15.00
Balance: -500 - 15 = -515.00
Debt: 515.00
```

### Day 4: Repay 300
```
Transaction: debt_payment, 300.00
Balance: -515 + 300 = -215.00
Debt: 215.00
```

### Day 5: Receive Salary
```
Transaction: income, 5000.00
Balance: -215 + 5000 = 4785.00
Debt: 0.00 (back to positive)
```

## Financial Summary

### Cash Flow (Income/Expense)
```
Income:     5000.00
Expenses:   3515.00 (3500 + 15 interest)
Net:        1485.00 ✅
```

### Debt Tracking
```
Borrowed:   2000.00
Repaid:     300.00
Outstanding: 0.00 (paid off with salary)
```

### M-Pesa Account
```
Final Balance: 4785.00
Fuliza Limit: 5000.00
Debt: 0.00
Available Credit: 5000.00
```

## Database Schema

### Accounts Table
```sql
CREATE TABLE accounts(
  id TEXT PRIMARY KEY,
  name TEXT,
  type TEXT,
  balance REAL,              -- Can be negative (debt)
  creditLimit REAL,          -- Fuliza limit
  createdAt TEXT,
  updatedAt TEXT
)
```

### Debts Table (for other loans)
```sql
CREATE TABLE debts(
  id TEXT PRIMARY KEY,
  name TEXT,
  principal REAL,            -- Amount owed
  creditLimit REAL,          -- Maximum borrowing
  interestRate REAL,
  interestType TEXT,
  dueDate TEXT,              -- When payment is due
  createdAt TEXT,
  isActive INTEGER DEFAULT 1
)
```

## Key Differences

### Fuliza (M-Pesa Overdraft)
- Tracked in **account balance** (negative balance = debt)
- Credit limit stored in account
- No separate debt record
- Flexible repayment

### Other Debts (Loans, Credit Cards)
- Tracked in **debts table**
- Separate from account balance
- Fixed principal amount
- Structured repayment with due dates

## Calculations

### Total Debt
```dart
totalDebt = 0.0

// Add Fuliza debt (negative M-Pesa balance)
if (mpesaBalance < 0) {
  totalDebt += abs(mpesaBalance)
}

// Add other debts
for (debt in debts) {
  totalDebt += debt.principal
}
```

### Net Worth
```dart
netWorth = totalAssets - totalDebt

totalAssets = mpesaBalance (if positive) + bankBalance + cash
totalDebt = fulizaDebt + otherDebts
```

### Available Credit
```dart
// For Fuliza
availableCredit = creditLimit - abs(negativeBalance)

// For other debts
availableCredit = creditLimit - principal
```

## UI Components

### Dashboard Card
```
┌─────────────────────────────────┐
│  Financial Summary              │
│                                 │
│  Income:      KES 5,000.00      │
│  Expenses:    KES 3,515.00      │
│  Net:         KES 1,485.00      │
│                                 │
│  Total Debt:  KES 215.00        │
│  Net Worth:   KES 4,570.00      │
└─────────────────────────────────┘
```

### Fuliza Card
```
┌─────────────────────────────────┐
│  M-Pesa Fuliza                  │
│                                 │
│  Current Balance: -215.00       │
│  Owed: KES 215.00               │
│  Limit: KES 5,000               │
│  Available: KES 4,785           │
│                                 │
│  Utilization: 4.3% █░░░░░░░░░   │
│  Due: Jan 30, 2024              │
└─────────────────────────────────┘
```

### Other Debts Card
```
┌─────────────────────────────────┐
│  Personal Loan                  │
│                                 │
│  Owed: KES 50,000               │
│  Limit: KES 100,000             │
│  Available: KES 50,000          │
│                                 │
│  Interest: 12% p.a.             │
│  Due: Feb 15, 2024              │
└─────────────────────────────────┘
```

## Benefits

### 1. Clear Separation
- Cash flow (income/expense) separate from debt
- Easy to see spending vs borrowing
- Interest is an expense, principal is not

### 2. Accurate Metrics
- Net income = income - expenses (excludes debt principal)
- Net worth = assets - liabilities
- Debt utilization = debt / credit limit

### 3. Better Insights
- See true spending patterns
- Track debt separately
- Monitor credit utilization
- Plan debt repayment

### 4. Flexible Tracking
- Fuliza: Negative balance (flexible)
- Other debts: Structured records (fixed)
- Both contribute to total debt

## Summary Table

| Concept | What It Is | Track As | Affects |
|---------|-----------|----------|---------|
| Overdraft Limit | Max borrowing | Credit facility | Context only |
| Overdraft Balance | Amount borrowed | Debt (liability) | Net worth |
| Available Credit | Limit - Balance | Calculated | Borrowing capacity |
| Overdraft Interest | Cost of borrowing | Expense | Net income |
| Overdraft Repayment | Paying back | Debt reduction | Net worth |
| Due Date | Payment deadline | Debt property | Payment planning |

## Implementation Status

✅ Account balance can be negative (debt)
✅ Credit limit tracked in account
✅ Debt calculated from negative balance
✅ Available credit calculated
✅ Utilization percentage calculated
✅ Debt separate from income/expense
✅ Interest tracked as expense
✅ Debts table for other loans
✅ Due date support for debts

This provides a complete, accurate financial tracking system that properly separates cash flow from debt management!
