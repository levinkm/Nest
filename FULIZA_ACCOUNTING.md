# Fuliza Accounting Treatment

## Overview
Fuliza (M-Pesa overdraft) is now properly treated as DEBT using standard accounting principles, not as expenses.

## Accounting Rules

### 1. Fuliza Principal (Borrowed Amount)
**Transaction Type**: `debt`
**Treatment**: Liability (Debt)
**Effect on Balance**: Increases M-Pesa balance (money comes in)
**Effect on Debt**: Increases Fuliza debt

**Example SMS**:
```
You have used Fuliza M-PESA of Ksh500.00. 
Limit used Ksh500.00
```

**Ledger Entry**:
```
Date: 2024-01-15
Description: Fuliza borrowed Ksh500.00
Credit: 500.00 (money in)
Balance: 1500.00 (increased)
Debt: 500.00 (liability increased)
```

### 2. Fuliza Interest/Fees
**Transaction Type**: `expense`
**Category**: `Interest & Fees`
**Treatment**: Financial expense
**Effect on Balance**: Decreases M-Pesa balance
**Effect on Debt**: No effect (it's a cost, not principal)

**Example SMS**:
```
Fuliza interest charge of Ksh15.00 has been deducted
```

**Ledger Entry**:
```
Date: 2024-01-16
Description: Fuliza interest charge
Category: Interest & Fees
Debit: 15.00 (expense)
Balance: 1485.00 (decreased)
```

### 3. Fuliza Repayment
**Transaction Type**: `debt_payment`
**Treatment**: Debt reduction (not expense)
**Effect on Balance**: Decreases M-Pesa balance (money goes out)
**Effect on Debt**: Decreases Fuliza debt

**Example SMS**:
```
You have repaid Fuliza M-PESA of Ksh300.00
Available Fuliza limit is now Ksh800.00
```

**Ledger Entry**:
```
Date: 2024-01-17
Description: Fuliza repayment
Debit: 300.00 (money out)
Balance: 1185.00 (decreased)
Debt: 200.00 (liability decreased from 500 to 200)
```

## Complete Example

### Scenario
1. Start with Ksh1000 in M-Pesa
2. Borrow Ksh500 Fuliza
3. Charged Ksh15 interest
4. Repay Ksh300

### Ledger
```
Date       | Description           | Type         | Debit  | Credit | Balance | Debt
-----------|-----------------------|--------------|--------|--------|---------|------
2024-01-15 | Starting balance      | -            | -      | -      | 1000.00 | 0.00
2024-01-15 | Fuliza borrowed       | debt         | -      | 500.00 | 1500.00 | 500.00
2024-01-16 | Fuliza interest       | expense      | 15.00  | -      | 1485.00 | 500.00
2024-01-17 | Fuliza repayment      | debt_payment | 300.00 | -      | 1185.00 | 200.00
```

### Financial Summary
- **M-Pesa Balance**: Ksh1185.00
- **Fuliza Debt**: Ksh200.00
- **Net Worth**: Ksh985.00 (1185 - 200)
- **Total Expenses**: Ksh15.00 (only interest)

## Why This Matters

### Old (Incorrect) Way
```
Fuliza borrowed: Expense -500
Fuliza repaid: Expense -300
Total Expenses: -800 ❌ WRONG
```
This made it look like you spent Ksh800 when you only paid Ksh15 in interest.

### New (Correct) Way
```
Fuliza borrowed: Debt +500 (liability)
Fuliza interest: Expense -15
Fuliza repaid: Debt -300 (reduces liability)
Total Expenses: -15 ✅ CORRECT
Remaining Debt: 200 ✅ CORRECT
```

## Transaction Types

### Summary Table
| Transaction | Type | Category | Affects Balance | Affects Debt | Affects Expenses |
|-------------|------|----------|-----------------|--------------|------------------|
| Fuliza borrowed | `debt` | - | ✅ Increases | ✅ Increases | ❌ No |
| Fuliza interest | `expense` | Interest & Fees | ✅ Decreases | ❌ No | ✅ Increases |
| Fuliza repayment | `debt_payment` | - | ✅ Decreases | ✅ Decreases | ❌ No |

## SMS Detection Patterns

### Debt (Borrowed)
Keywords: `fuliza` + (`limit used` OR `borrowed`)
```
"You have used Fuliza M-PESA of Ksh500.00"
"Fuliza limit used Ksh500.00"
```

### Expense (Interest/Fees)
Keywords: `fuliza` + (`interest` OR `fee` OR `charge`)
```
"Fuliza interest charge of Ksh15.00"
"Fuliza fee Ksh10.00 deducted"
```

### Debt Payment (Repayment)
Keywords: `fuliza` + (`repay` OR `repaid` OR `available fuliza`)
```
"You have repaid Fuliza M-PESA of Ksh300.00"
"Fuliza repayment successful"
"Available Fuliza limit is now Ksh800.00"
```

## Dashboard Display

### Debt Card
Shows total debt including Fuliza:
```
┌─────────────────────┐
│  Total Debt         │
│  Ksh 200.00         │
│  (Fuliza)           │
└─────────────────────┘
```

### Fuliza Card
Shows current Fuliza debt:
```
┌─────────────────────┐
│  Fuliza Debt        │
│  Ksh 200.00         │
└─────────────────────┘
```

## Ledger Export

CSV export shows proper accounting:
```csv
Date,Description,Category,Debit,Credit,Balance,Type
2024-01-15,Fuliza borrowed Ksh500,,500.00,1500.00,debt
2024-01-16,Fuliza interest,Interest & Fees,15.00,,1485.00,expense
2024-01-17,Fuliza repayment,,300.00,,1185.00,debt_payment
```

## Benefits

### 1. Accurate Expense Tracking
Only actual costs (interest/fees) show as expenses, not the borrowed amount.

### 2. Proper Debt Management
Fuliza debt is tracked separately and can be monitored over time.

### 3. Correct Net Worth
Net worth = Assets (M-Pesa balance) - Liabilities (Fuliza debt)

### 4. Better Financial Insights
- See how much you're paying in Fuliza interest
- Track debt reduction progress
- Understand true spending vs borrowing

## Migration

Existing Fuliza transactions will be automatically reclassified:
- Old `expense` type Fuliza → New `debt` or `debt_payment` type
- Interest charges remain as `expense` with category `Interest & Fees`

## Code Changes

### Files Modified
1. `sms_parser_datasource.dart` - Detect debt vs expense
2. `account_balance_service.dart` - Calculate debt separately
3. `ledger_service.dart` - Handle debt types in ledger
4. `financial_stats_calculator.dart` - Exclude debt from expenses
5. `app_constants.dart` - Update categories

### New Transaction Types
- `debt` - Borrowed money (liability increase)
- `debt_payment` - Repayment (liability decrease)

### New Category
- `Interest & Fees` - Financial charges (replaces `Loans`)

## Testing

### Verify Correct Behavior
1. Sync SMS with Fuliza transactions
2. Check dashboard shows debt separately
3. Verify expenses don't include principal
4. Confirm ledger shows proper debit/credit
5. Export and verify CSV format

### Expected Results
- Fuliza borrowed: Shows as debt, not expense
- Fuliza interest: Shows as expense in Interest & Fees
- Fuliza repaid: Reduces debt, not counted as expense
- Balance calculation: Correct with debt tracking

## Future Enhancements

1. **Debt Analytics**: Track Fuliza usage patterns
2. **Interest Calculation**: Estimate future interest charges
3. **Debt Alerts**: Warn when Fuliza debt is high
4. **Repayment Plans**: Suggest optimal repayment strategy
5. **Cost Analysis**: Show total interest paid over time
