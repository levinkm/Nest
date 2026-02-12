# Architecture Overview: Account-Based Ledger System

## System Architecture

```
┌─────────────────────────────────────────────────────────────┐
│                         USER INTERFACE                       │
├─────────────────────────────────────────────────────────────┤
│                                                              │
│  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐     │
│  │  Dashboard   │  │ Transactions │  │  More Page   │     │
│  │    Page      │  │     Page     │  │              │     │
│  └──────┬───────┘  └──────┬───────┘  └──────┬───────┘     │
│         │                  │                  │              │
│         │                  │         ┌────────▼────────┐    │
│         │                  │         │  Ledger Page    │    │
│         │                  │         │  - Summary      │    │
│         │                  │         │  - Entry List   │    │
│         │                  │         │  - Export       │    │
│         │                  │         └────────┬────────┘    │
└─────────┼──────────────────┼──────────────────┼─────────────┘
          │                  │                  │
          │                  │                  │
┌─────────▼──────────────────▼──────────────────▼─────────────┐
│                      BUSINESS LOGIC                          │
├─────────────────────────────────────────────────────────────┤
│                                                              │
│  ┌──────────────────┐  ┌──────────────────┐                │
│  │ Transaction Bloc │  │  SMS Sync Bloc   │                │
│  └────────┬─────────┘  └────────┬─────────┘                │
│           │                     │                            │
│  ┌────────▼─────────────────────▼─────────┐                │
│  │      Transaction Repository            │                │
│  └────────┬───────────────────────────────┘                │
│           │                                                  │
│  ┌────────▼─────────┐  ┌──────────────────┐               │
│  │ Ledger Service   │  │ Account Balance  │               │
│  │ - Generate       │  │    Service       │               │
│  │ - Calculate      │  │ - Update Balance │               │
│  │ - Summary        │  │ - Track Fuliza   │               │
│  └────────┬─────────┘  └──────────────────┘               │
│           │                                                  │
│  ┌────────▼─────────┐                                       │
│  │ Excel Export     │                                       │
│  │    Service       │                                       │
│  │ - Generate CSV   │                                       │
│  │ - Format Data    │                                       │
│  └──────────────────┘                                       │
└─────────────────────────────────────────────────────────────┘
          │
          │
┌─────────▼─────────────────────────────────────────────────┐
│                      DATA LAYER                            │
├───────────────────────────────────────────────────────────┤
│                                                            │
│  ┌──────────────────────────────────────────────────┐    │
│  │           Local Database (SQLite)                 │    │
│  ├──────────────────────────────────────────────────┤    │
│  │                                                    │    │
│  │  ┌─────────────────┐  ┌─────────────────┐       │    │
│  │  │   Accounts      │  │  Transactions   │       │    │
│  │  ├─────────────────┤  ├─────────────────┤       │    │
│  │  │ id              │  │ id              │       │    │
│  │  │ name            │  │ amount          │       │    │
│  │  │ type            │  │ category        │       │    │
│  │  │ balance         │  │ description     │       │    │
│  │  │ overdraft       │  │ date            │       │    │
│  │  │ createdAt       │  │ type            │       │    │
│  │  │ updatedAt       │  │ transactionId   │       │    │
│  │  └─────────────────┘  │ fee         ◄───┼───NEW │    │
│  │                       │ accountId   ◄───┼───NEW │    │
│  │                       │ toAccountId ◄───┼───NEW │    │
│  │                       └─────────────────┘       │    │
│  └──────────────────────────────────────────────────┘    │
└───────────────────────────────────────────────────────────┘
          │
          │
┌─────────▼─────────────────────────────────────────────────┐
│                    EXTERNAL SOURCES                        │
├───────────────────────────────────────────────────────────┤
│                                                            │
│  ┌──────────────────┐                                     │
│  │   SMS Messages   │                                     │
│  │  - M-Pesa        │                                     │
│  │  - Banks         │                                     │
│  │  - Fuliza        │                                     │
│  └────────┬─────────┘                                     │
│           │                                                │
│  ┌────────▼─────────┐                                     │
│  │  SMS Parser      │                                     │
│  │  - Extract $     │                                     │
│  │  - Extract Fee   │                                     │
│  │  - Categorize    │                                     │
│  │  - Assign Acct   │                                     │
│  └──────────────────┘                                     │
└───────────────────────────────────────────────────────────┘
```

## Data Flow

### 1. SMS to Transaction
```
SMS Arrives
    ↓
SMS Parser
    ↓
Extract: Amount, Fee, Type, Category
    ↓
Create Transaction
    ↓
Assign to M-Pesa Account (accountId = 'mpesa_default')
    ↓
Save to Database
    ↓
Update Account Balance
```

### 2. Transaction to Ledger
```
Load Transactions
    ↓
Filter by Account
    ↓
Sort by Date
    ↓
For Each Transaction:
    ├─ Create Main Entry (Debit or Credit)
    └─ Create Fee Entry (if fee > 0)
    ↓
Calculate Running Balance
    ↓
Generate Ledger Entries
```

### 3. Ledger to Export
```
Ledger Entries
    ↓
Calculate Summary
    ↓
Format as CSV
    ├─ Header Section
    ├─ Summary Section
    └─ Data Section
    ↓
Save to File
    ↓
Share with User
```

## Entity Relationships

```
┌─────────────────┐
│    Account      │
│  (M-Pesa)       │
└────────┬────────┘
         │ 1
         │
         │ has many
         │
         │ *
┌────────▼────────┐
│  Transaction    │
│  - amount       │
│  - fee          │
│  - accountId ───┼──┐
│  - toAccountId  │  │
└────────┬────────┘  │
         │ 1         │
         │           │
         │ generates │
         │           │
         │ *         │
┌────────▼────────┐  │
│ Ledger Entry    │  │
│  - debit        │  │
│  - credit       │  │
│  - balance      │  │
│  - fee          │  │
│  - accountId ───┼──┘
└─────────────────┘
```

## Component Breakdown

### Frontend (Presentation Layer)
```
lib/features/ledger/presentation/pages/
└── ledger_page.dart
    ├── Summary Card Widget
    │   ├── Total Credits
    │   ├── Total Debits
    │   ├── Total Fees
    │   └── Net Balance
    │
    └── Ledger List Widget
        └── Entry Card Widget
            ├── Date & Time
            ├── Description
            ├── Debit/Credit
            ├── Fee
            ├── Balance
            └── Category
```

### Business Logic (Domain Layer)
```
lib/features/ledger/data/services/
├── ledger_service.dart
│   ├── generateLedger()
│   │   ├── Sort transactions
│   │   ├── Create entries
│   │   └── Calculate balance
│   │
│   └── getLedgerSummary()
│       ├── Sum debits
│       ├── Sum credits
│       ├── Sum fees
│       └── Calculate net
│
└── excel_export_service.dart
    ├── exportLedgerToCSV()
    │   ├── Format header
    │   ├── Format summary
    │   ├── Format data
    │   └── Save file
    │
    └── exportAllAccountsToCSV()
        └── (Future: multiple accounts)
```

### Data Layer
```
lib/features/transactions/data/datasources/
└── local_database.dart
    ├── Account Methods
    │   ├── insertAccount()
    │   ├── getAccounts()
    │   ├── getAccount()
    │   ├── updateAccountBalance()
    │   └── updateAccountOverdraft()
    │
    └── Transaction Methods
        ├── insertTransaction()
        ├── getTransactions()
        └── deleteTransaction()
```

## Key Algorithms

### Balance Calculation
```
balance = 0
for each transaction (sorted by date):
    if type == 'income':
        balance += amount
    else if type == 'expense':
        balance -= amount
    
    balance -= fee
    
    if is_fuliza_loan:
        overdraft += amount
    else if is_fuliza_repay:
        overdraft -= amount
```

### Ledger Generation
```
entries = []
balance = 0

for each transaction:
    if income or transfer_in:
        credit = amount
        debit = 0
        balance += amount
    else:
        debit = amount
        credit = 0
        balance -= amount
    
    entries.add(LedgerEntry(
        debit, credit, balance
    ))
    
    if fee > 0:
        balance -= fee
        entries.add(LedgerEntry(
            fee, 0, balance
        ))

return entries
```

### Fee Extraction
```
regex = /(?:transaction cost|fee|charge)\s*(?:Ksh\.?|KES)?\s*(\d+(?:\.\d{2})?)/i

match = regex.match(sms_body)
if match:
    fee = parse_float(match.group(1))
else:
    fee = 0.0
```

## File Structure

```
lib/
├── features/
│   ├── accounts/
│   │   ├── domain/
│   │   │   └── entities/
│   │   │       └── account.dart
│   │   └── data/
│   │       └── services/
│   │           └── account_balance_service.dart
│   │
│   ├── ledger/
│   │   ├── domain/
│   │   │   └── entities/
│   │   │       └── ledger_entry.dart
│   │   ├── data/
│   │   │   └── services/
│   │   │       ├── ledger_service.dart
│   │   │       └── excel_export_service.dart
│   │   └── presentation/
│   │       └── pages/
│   │           └── ledger_page.dart
│   │
│   └── transactions/
│       ├── domain/
│       │   └── entities/
│       │       └── transaction.dart (UPDATED)
│       └── data/
│           ├── models/
│           │   └── transaction_model.dart (UPDATED)
│           └── datasources/
│               └── local_database.dart (UPDATED)
│
└── core/
    └── constants/
        └── app_constants.dart (UPDATED: dbVersion 4)
```

## Technology Stack

```
┌─────────────────────────────────────┐
│         Flutter Framework           │
├─────────────────────────────────────┤
│ UI: Material Design                 │
│ State: BLoC Pattern                 │
│ Navigation: Named Routes            │
└─────────────────────────────────────┘
          ↓
┌─────────────────────────────────────┐
│         Core Packages               │
├─────────────────────────────────────┤
│ freezed: Immutable models           │
│ sqflite: Local database             │
│ intl: Formatting                    │
│ share_plus: File sharing            │
│ path_provider: File system          │
└─────────────────────────────────────┘
          ↓
┌─────────────────────────────────────┐
│         Platform                    │
├─────────────────────────────────────┤
│ Android: API 23+                    │
│ iOS: 12.0+                          │
│ Storage: SQLite                     │
│ Permissions: SMS, Storage           │
└─────────────────────────────────────┘
```

## Performance Characteristics

```
Operation              Time Complexity    Space Complexity
─────────────────────  ─────────────────  ─────────────────
Load Transactions      O(n)               O(n)
Generate Ledger        O(n log n)         O(n)
Calculate Balance      O(n)               O(1)
Export CSV             O(n)               O(n)
Database Query         O(log n)           O(n)

where n = number of transactions
```

## Security Model

```
┌─────────────────────────────────────┐
│         User Data                   │
├─────────────────────────────────────┤
│ SMS Messages → Transactions         │
│ Transactions → Ledger               │
│ Ledger → CSV Export                 │
└─────────────────────────────────────┘
          ↓
┌─────────────────────────────────────┐
│         Storage                     │
├─────────────────────────────────────┤
│ Local SQLite Database               │
│ App Documents Directory             │
│ No Cloud Sync                       │
│ No External Transmission            │
└─────────────────────────────────────┘
          ↓
┌─────────────────────────────────────┐
│         Access Control              │
├─────────────────────────────────────┤
│ PIN Authentication                  │
│ Biometric Lock (Optional)           │
│ App Sandbox                         │
└─────────────────────────────────────┘
```

This architecture provides a solid foundation for accurate financial tracking with room for future enhancements like multiple accounts, bank integration, and advanced reporting.
