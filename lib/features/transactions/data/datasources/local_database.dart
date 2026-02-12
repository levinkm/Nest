import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../../domain/entities/transaction.dart' as domain;
import '../models/transaction_model.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../budget/data/models/budget_model.dart';

class LocalDatabase {
  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB();
    return _database!;
  }

  Future<Database> _initDB() async {
    String path = join(await getDatabasesPath(), AppConstants.dbName);
    return await openDatabase(
      path,
      version: AppConstants.dbVersion,
      onCreate: _createDB,
      onUpgrade: _upgradeDB,
    );
  }

  Future<void> _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE accounts(
        id TEXT PRIMARY KEY,
        name TEXT,
        type TEXT,
        balance REAL,
        recordedBalance REAL,
        creditLimit REAL,
        lastSmsDate TEXT,
        createdAt TEXT,
        updatedAt TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE transactions(
        id TEXT PRIMARY KEY,
        amount REAL,
        category TEXT,
        description TEXT,
        date TEXT,
        type TEXT,
        transactionId TEXT UNIQUE,
        fee REAL DEFAULT 0,
        accountId TEXT,
        toAccountId TEXT,
        FOREIGN KEY (accountId) REFERENCES accounts(id),
        FOREIGN KEY (toAccountId) REFERENCES accounts(id)
      )
    ''');
    
    await db.execute('''
      CREATE TABLE budgets(
        id TEXT PRIMARY KEY,
        category TEXT,
        limit_amount REAL,
        spent REAL,
        period TEXT,
        startDate TEXT,
        endDate TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE debts(
        id TEXT PRIMARY KEY,
        name TEXT,
        principal REAL,
        creditLimit REAL,
        interestRate REAL,
        interestType TEXT,
        dueDate TEXT,
        createdAt TEXT,
        isActive INTEGER DEFAULT 1
      )
    ''');

    await db.execute('''
      CREATE TABLE sms_senders(
        id TEXT PRIMARY KEY,
        senderName TEXT,
        accountType TEXT,
        accountId TEXT,
        isActive INTEGER DEFAULT 1,
        createdAt TEXT
      )
    ''');

    // Create default M-Pesa account
    await db.insert('accounts', {
      'id': 'mpesa_default',
      'name': 'M-Pesa',
      'type': 'mpesa',
      'balance': 0.0,
      'recordedBalance': 0.0,
      'creditLimit': 0.0,
      'lastSmsDate': null,
      'createdAt': DateTime.now().toIso8601String(),
      'updatedAt': DateTime.now().toIso8601String(),
    });

    // Default SMS senders
    await db.insert('sms_senders', {
      'id': 'mpesa_sender',
      'senderName': 'M-PESA',
      'accountType': 'mpesa',
      'accountId': 'mpesa_default',
      'isActive': 1,
      'createdAt': DateTime.now().toIso8601String(),
    });
  }

  Future<void> _upgradeDB(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      await db.execute('''
        CREATE TABLE IF NOT EXISTS budgets(
          id TEXT PRIMARY KEY,
          category TEXT,
          limit_amount REAL,
          spent REAL,
          period TEXT,
          startDate TEXT,
          endDate TEXT
        )
      ''');
    }
    if (oldVersion < 3) {
      await db.execute('ALTER TABLE transactions ADD COLUMN transactionId TEXT');
    }
    if (oldVersion < 4) {
      // Create accounts table
      await db.execute('''
        CREATE TABLE IF NOT EXISTS accounts(
          id TEXT PRIMARY KEY,
          name TEXT,
          type TEXT,
          balance REAL,
          recordedBalance REAL,
          creditLimit REAL,
          lastSmsDate TEXT,
          createdAt TEXT,
          updatedAt TEXT
        )
      ''');
      
      // Add new columns to transactions
      await db.execute('ALTER TABLE transactions ADD COLUMN fee REAL DEFAULT 0');
      await db.execute('ALTER TABLE transactions ADD COLUMN accountId TEXT');
      await db.execute('ALTER TABLE transactions ADD COLUMN toAccountId TEXT');
      
      // Create debts table
      await db.execute('''
        CREATE TABLE IF NOT EXISTS debts(
          id TEXT PRIMARY KEY,
          name TEXT,
          principal REAL,
          creditLimit REAL,
          interestRate REAL,
          interestType TEXT,
          dueDate TEXT,
          createdAt TEXT,
          isActive INTEGER DEFAULT 1
        )
      ''');

      // Create sms_senders table
      await db.execute('''
        CREATE TABLE IF NOT EXISTS sms_senders(
          id TEXT PRIMARY KEY,
          senderName TEXT,
          accountType TEXT,
          accountId TEXT,
          isActive INTEGER DEFAULT 1,
          createdAt TEXT
        )
      ''');
      
      // Create default M-Pesa account
      await db.insert('accounts', {
        'id': 'mpesa_default',
        'name': 'M-Pesa',
        'type': 'mpesa',
        'balance': 0.0,
        'recordedBalance': 0.0,
        'creditLimit': 0.0,
        'lastSmsDate': null,
        'createdAt': DateTime.now().toIso8601String(),
        'updatedAt': DateTime.now().toIso8601String(),
      });
    }
  }

  Future<void> insertTransaction(domain.Transaction transaction) async {
    final db = await database;
    try {
      // Check if transaction with same transactionId already exists
      if (transaction.transactionId != null) {
        print('Inserting transaction with ID: ${transaction.transactionId}');
        final existing = await db.query(
          'transactions',
          where: 'transactionId = ?',
          whereArgs: [transaction.transactionId],
          limit: 1,
        );
        if (existing.isNotEmpty) {
          print('Duplicate found, skipping: ${transaction.transactionId}');
          return; // Skip duplicate
        }
      }
      
      await db.insert(
        'transactions',
        TransactionModel.toJson(transaction),
        conflictAlgorithm: ConflictAlgorithm.ignore,
      );
      print('Transaction inserted successfully: ${transaction.transactionId}');
    } catch (e) {
      print('Error inserting transaction: $e');
    }
  }

  Future<void> removeDuplicateTransactions() async {
    final db = await database;
    // Delete duplicates keeping only one occurrence based on description, amount, and date
    await db.execute('''
      DELETE FROM transactions 
      WHERE rowid NOT IN (
        SELECT MIN(rowid) 
        FROM transactions 
        GROUP BY description, amount, strftime('%Y-%m-%d %H:%M', date)
      )
    ''');
  }

  Future<List<domain.Transaction>> getTransactions() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('transactions', orderBy: 'date DESC');
    return List.generate(maps.length, (i) => TransactionModel.fromJson(maps[i]));
  }

  Future<void> deleteTransaction(String id) async {
    final db = await database;
    await db.delete('transactions', where: 'id = ?', whereArgs: [id]);
  }

  Future<void> insertBudget(Budget budget) async {
    final db = await database;
    await db.insert(
      'budgets',
      {
        'id': budget.id,
        'category': budget.category,
        'limit_amount': budget.limit,
        'spent': budget.spent,
        'period': budget.period,
        'startDate': budget.startDate.toIso8601String(),
        'endDate': budget.endDate.toIso8601String(),
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Budget>> getBudgets() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('budgets');
    return List.generate(maps.length, (i) => Budget(
      id: maps[i]['id'],
      category: maps[i]['category'],
      limit: maps[i]['limit_amount'],
      spent: maps[i]['spent'],
      period: maps[i]['period'],
      startDate: DateTime.parse(maps[i]['startDate']),
      endDate: DateTime.parse(maps[i]['endDate']),
    ));
  }

  Future<void> deleteBudget(String id) async {
    final db = await database;
    await db.delete('budgets', where: 'id = ?', whereArgs: [id]);
  }

  // Account methods
  Future<void> insertAccount(Map<String, dynamic> account) async {
    final db = await database;
    await db.insert('accounts', account, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<Map<String, dynamic>>> getAccounts() async {
    final db = await database;
    return await db.query('accounts', orderBy: 'name ASC');
  }

  Future<Map<String, dynamic>?> getAccount(String id) async {
    final db = await database;
    final results = await db.query('accounts', where: 'id = ?', whereArgs: [id]);
    return results.isNotEmpty ? results.first : null;
  }

  Future<void> updateAccountBalance(String accountId, double balance) async {
    final db = await database;
    await db.update(
      'accounts',
      {'balance': balance, 'updatedAt': DateTime.now().toIso8601String()},
      where: 'id = ?',
      whereArgs: [accountId],
    );
  }

  Future<void> updateRecordedBalance(String accountId, double recordedBalance, DateTime smsDate) async {
    final db = await database;
    await db.update(
      'accounts',
      {
        'recordedBalance': recordedBalance,
        'lastSmsDate': smsDate.toIso8601String(),
        'updatedAt': DateTime.now().toIso8601String()
      },
      where: 'id = ?',
      whereArgs: [accountId],
    );
  }

  Future<void> updateAccountOverdraft(String accountId, double overdraft) async {
    final db = await database;
    await db.update(
      'accounts',
      {'overdraft': overdraft, 'updatedAt': DateTime.now().toIso8601String()},
      where: 'id = ?',
      whereArgs: [accountId],
    );
  }

  // Debt methods
  Future<void> insertDebt(Map<String, dynamic> debt) async {
    final db = await database;
    await db.insert('debts', debt, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<Map<String, dynamic>>> getDebts() async {
    final db = await database;
    return await db.query('debts', where: 'isActive = ?', whereArgs: [1]);
  }

  Future<void> updateDebt(String id, Map<String, dynamic> updates) async {
    final db = await database;
    await db.update('debts', updates, where: 'id = ?', whereArgs: [id]);
  }

  Future<void> deleteDebt(String id) async {
    final db = await database;
    await db.update('debts', {'isActive': 0}, where: 'id = ?', whereArgs: [id]);
  }

  // SMS Sender methods
  Future<void> insertSmsSender(Map<String, dynamic> sender) async {
    final db = await database;
    await db.insert('sms_senders', sender, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<Map<String, dynamic>>> getSmsSenders() async {
    final db = await database;
    return await db.query('sms_senders', where: 'isActive = ?', whereArgs: [1]);
  }

  Future<void> deleteSmsSender(String id) async {
    final db = await database;
    await db.update('sms_senders', {'isActive': 0}, where: 'id = ?', whereArgs: [id]);
  }
}
