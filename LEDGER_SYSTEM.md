# Account-Based Ledger System

## Overview
The app now treats M-Pesa as a proper financial account with double-entry bookkeeping principles. This provides accurate ledger tracking with running balances, transaction fees, and Fuliza (overdraft) management.

## Key Features

### 1. Account System
- **M-Pesa Account**: Default account for all M-Pesa transactions
- **Balance Tracking**: Real-time balance calculation based on all transactions
- **Fuliza (Overdraft)**: Automatic tracking of M-Pesa Fuliza loans
- **Transaction Fees**: Separate tracking of M-Pesa transaction fees

### 2. Enhanced Transaction Model
Transactions now include:
- `fee`: Transaction fee amount (extracted from SMS)
- `accountId`: Source account for the transaction
- `toAccountId`: Destination account (for transfers)

### 3. Ledger Generation
- **Double-Entry Format**: Proper debit/credit entries
- **Running Balance**: Accurate balance after each transaction
- **Fee Entries**: Separate ledger entries for transaction fees
- **Chronological Order**: Transactions sorted by date

### 4. Excel/CSV Export
Generate accurate ledger reports in CSV format:
- Transaction details with debit/credit columns
- Running balance after each entry
- Summary statistics (total credits, debits, fees, net balance)
- Ready for import into Excel or accounting software

## Database Schema

### Accounts Table
```sql
CREATE TABLE accounts(
  id TEXT PRIMARY KEY,
  name TEXT,
  type TEXT,              -- 'mpesa', 'bank', 'cash'
  balance REAL,
  overdraft REAL,         -- Fuliza amount
  createdAt TEXT,
  updatedAt TEXT
)
```

### Updated Transactions Table
```sql
CREATE TABLE transactions(
  id TEXT PRIMARY KEY,
  amount REAL,
  category TEXT,
  description TEXT,
  date TEXT,
  type TEXT,
  transactionId TEXT UNIQUE,
  fee REAL DEFAULT 0,     -- NEW
  accountId TEXT,         -- NEW
  toAccountId TEXT,       -- NEW
  FOREIGN KEY (accountId) REFERENCES accounts(id),
  FOREIGN KEY (toAccountId) REFERENCES accounts(id)
)
```

## Usage

### Viewing Ledger
Navigate to the Ledger page to view:
- All M-Pesa transactions in ledger format
- Running balance after each transaction
- Summary statistics

### Exporting Ledger
1. Open Ledger page
2. Tap the download icon in the app bar
3. Choose where to share/save the CSV file
4. Open in Excel or any spreadsheet application

### CSV Format
```csv
Date,Reference,Description,Category,Debit,Credit,Fee,Balance
2024-01-15 10:30,ABC123XYZ,Sent to John Doe,Transfer,1000.00,,11.00,5489.00
2024-01-15 10:30,ABC123XYZ,Transaction Fee - Sent to John Doe,Fees,11.00,,,5478.00
```

## How It Works

### 1. SMS Parsing
When SMS messages are synced:
- Transaction amount is extracted
- Transaction fee is extracted (if present)
- Transaction is assigned to M-Pesa account
- Fee is stored separately

### 2. Balance Calculation
The `AccountBalanceService` calculates:
- Running balance from all transactions
- Fuliza (overdraft) amount from Fuliza-related transactions
- Updates account record in database

### 3. Ledger Generation
The `LedgerService` creates ledger entries:
- Each transaction becomes a debit or credit entry
- Fees create separate debit entries
- Running balance is calculated chronologically
- All entries are linked to the source transaction

### 4. Export
The `ExcelExportService`:
- Formats ledger entries as CSV
- Includes summary statistics
- Creates shareable file

## Migration

The database automatically migrates to version 4:
1. Creates `accounts` table
2. Adds `fee`, `accountId`, `toAccountId` columns to transactions
3. Creates default M-Pesa account
4. Existing transactions are preserved

## Future Enhancements

### Planned Features
- Multiple account support (bank accounts, cash)
- Account-to-account transfers
- Bank statement import
- Reconciliation tools
- Advanced filtering and date ranges
- PDF export with formatting
- Actual XLSX export (requires additional package)

### Adding New Accounts
```dart
final db = LocalDatabase();
await db.insertAccount({
  'id': 'bank_kcb',
  'name': 'KCB Bank',
  'type': 'bank',
  'balance': 0.0,
  'overdraft': 0.0,
  'createdAt': DateTime.now().toIso8601String(),
  'updatedAt': DateTime.now().toIso8601String(),
});
```

## Technical Details

### Key Files
- `lib/features/accounts/domain/entities/account.dart` - Account entity
- `lib/features/ledger/domain/entities/ledger_entry.dart` - Ledger entry entity
- `lib/features/ledger/data/services/ledger_service.dart` - Ledger generation logic
- `lib/features/ledger/data/services/excel_export_service.dart` - CSV export
- `lib/features/ledger/presentation/pages/ledger_page.dart` - Ledger UI
- `lib/features/accounts/data/services/account_balance_service.dart` - Balance calculation

### Dependencies Used
- `intl` - Date and number formatting
- `path_provider` - File system access
- `share_plus` - File sharing
- `sqflite` - Database operations

## Testing

To test the ledger system:
1. Sync SMS messages to import transactions
2. Navigate to Ledger page
3. Verify running balances are correct
4. Export ledger and open in Excel
5. Verify all transactions and fees are present
6. Check summary totals match

## Troubleshooting

### Balance Incorrect
Run balance recalculation:
```dart
final db = LocalDatabase();
final transactions = await db.getTransactions();
await AccountBalanceService.updateMpesaBalance(transactions);
```

### Missing Fees
Fees are extracted from SMS messages. If missing:
- Check SMS message contains fee information
- Update fee extraction regex in `sms_parser_datasource.dart`
- Re-sync SMS messages

### Export Fails
- Ensure storage permissions are granted
- Check available disk space
- Verify `path_provider` is working correctly
