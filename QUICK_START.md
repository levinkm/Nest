# Quick Start Guide: Account-Based Ledger System

## ✅ What's Been Done

Your Nest app now has a complete account-based ledger system that treats M-Pesa as a proper financial account with accurate bookkeeping.

## 🚀 How to Use

### 1. Run the App
```bash
flutter run
```

The database will automatically migrate to version 4 and create the M-Pesa account.

### 2. Access the Ledger
- Open the app
- Navigate to **More** tab (bottom navigation)
- Tap **M-Pesa Ledger**

### 3. View Your Ledger
You'll see:
- **Summary Card**: Total credits, debits, fees, and net balance
- **Ledger Entries**: All transactions in chronological order with running balance
- Each entry shows:
  - Date and time
  - Description
  - Debit (DR) or Credit (CR) amount
  - Transaction fee (if any)
  - Running balance
  - Category

### 4. Export to Excel
- Tap the **download icon** in the app bar
- Choose where to share/save the file
- Open the CSV file in Excel or Google Sheets

## 📊 CSV Format

The exported file includes:
```
M-Pesa Ledger Report
Generated: 2024-01-15 14:30

Summary
Total Credits,50000.00
Total Debits,25000.00
Total Fees,150.00
Net Balance,24850.00
Total Entries,45

Date,Reference,Description,Category,Debit,Credit,Fee,Balance
2024-01-15 10:30,ABC123XYZ,Sent to John Doe,Transfer,1000.00,,11.00,5489.00
2024-01-15 10:30,ABC123XYZ,Transaction Fee - Sent to John Doe,Fees,11.00,,,5478.00
```

## 🔍 What Gets Tracked

### Incoming (Credits)
- Money received from others
- Deposits
- Refunds
- Salary payments

### Outgoing (Debits)
- Payments sent
- Buy goods
- Paybill payments
- Withdrawals
- Airtime purchases

### Transaction Fees
- Automatically extracted from SMS
- Shown as separate ledger entries
- Deducted from balance

### Fuliza (Overdraft)
- Automatically tracked when you use Fuliza
- Updated when you repay
- Shown in account details

## 🎯 Key Features

### 1. Accurate Balance
The ledger calculates your M-Pesa balance by:
- Starting from zero
- Adding all credits (money in)
- Subtracting all debits (money out)
- Subtracting all transaction fees
- Showing running balance after each transaction

### 2. Double-Entry Format
Professional accounting format:
- **Debit (DR)**: Money leaving your account
- **Credit (CR)**: Money entering your account
- **Balance**: Your current M-Pesa balance

### 3. Fee Tracking
Transaction fees are:
- Extracted from SMS messages
- Shown as separate entries
- Included in balance calculations
- Categorized as "Fees"

### 4. Fuliza Management
Fuliza loans are:
- Detected from SMS keywords
- Tracked as overdraft amount
- Updated when repaid
- Separate from main balance

## 📱 User Flow

```
1. SMS arrives → Parsed automatically
2. Transaction created → Assigned to M-Pesa account
3. Fee extracted → Stored separately
4. Balance updated → Calculated from all transactions
5. Ledger generated → Double-entry format
6. Export available → CSV for Excel
```

## 🔧 Technical Details

### Database Changes
- **Version**: 3 → 4
- **New Table**: `accounts`
- **New Columns**: `fee`, `accountId`, `toAccountId`
- **Migration**: Automatic on app launch

### Account Structure
```dart
Account {
  id: 'mpesa_default',
  name: 'M-Pesa',
  type: 'mpesa',
  balance: 24850.00,
  overdraft: 500.00,  // Fuliza used
  createdAt: DateTime,
  updatedAt: DateTime,
}
```

### Transaction Structure
```dart
Transaction {
  id: UUID,
  amount: 1000.00,
  category: 'Transfer',
  description: 'Sent to John Doe',
  date: DateTime,
  type: 'expense',
  transactionId: 'ABC123XYZ',
  fee: 11.00,           // NEW
  accountId: 'mpesa_default',  // NEW
  toAccountId: null,    // NEW
}
```

## 🧪 Testing

### Test the Ledger
1. Sync SMS messages (pull to refresh on dashboard)
2. Navigate to M-Pesa Ledger
3. Verify transactions appear
4. Check running balance is correct
5. Export and open in Excel
6. Verify all data is present

### Verify Fees
1. Look for transactions with fees
2. Check fee is shown separately
3. Verify balance deducts fee
4. Confirm fee appears in export

### Check Fuliza
1. Find Fuliza transactions
2. Verify overdraft amount updates
3. Check repayments reduce overdraft

## 🐛 Troubleshooting

### Balance Seems Wrong
The ledger calculates from transaction history. If balance is incorrect:
- Check all transactions are synced
- Verify no duplicate transactions
- Ensure fees are extracted correctly

### Fees Not Showing
Fees are extracted from SMS. If missing:
- Check SMS contains fee information
- Pattern: "transaction cost Ksh 11.00" or "fee 11.00"
- Re-sync SMS if needed

### Export Fails
- Ensure storage permissions granted
- Check available disk space
- Try sharing to different app

## 🎨 UI Components

### Ledger Page
- **App Bar**: Title + Export button
- **Summary Card**: Statistics overview
- **Entry List**: Scrollable transaction list
- **Entry Card**: Individual transaction details

### Colors
- **Credits**: Green (income)
- **Debits**: Red (expense)
- **Fees**: Orange (warning)
- **Balance**: Blue (primary)

## 📈 Future Enhancements

Ready to add:
1. **Multiple Accounts**: Bank accounts, cash
2. **Account Transfers**: Move money between accounts
3. **Date Filtering**: View specific date ranges
4. **PDF Export**: Formatted reports
5. **Reconciliation**: Match with statements
6. **Charts**: Visual balance trends

## 💡 Tips

1. **Regular Sync**: Pull to refresh dashboard to sync SMS
2. **Export Monthly**: Create monthly ledger exports
3. **Check Fees**: Monitor transaction fees
4. **Track Fuliza**: Keep eye on overdraft usage
5. **Backup Data**: Export ledger as backup

## 📞 Support

If you encounter issues:
1. Check `LEDGER_SYSTEM.md` for detailed docs
2. Review `IMPLEMENTATION_SUMMARY.md` for technical details
3. Verify database migration completed
4. Check console logs for errors

## ✨ Success!

You now have:
- ✅ M-Pesa as a proper account
- ✅ Accurate ledger with running balance
- ✅ Transaction fee tracking
- ✅ Fuliza overdraft management
- ✅ Excel-compatible export
- ✅ Professional double-entry format

Enjoy your new account-based ledger system! 🎉
