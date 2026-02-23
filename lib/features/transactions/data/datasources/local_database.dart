import 'package:flutter/foundation.dart';
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
      version: 15,
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
        name TEXT,
        type TEXT DEFAULT 'category',
        category TEXT,
        amount REAL,
        spent REAL DEFAULT 0,
        period TEXT,
        startDate TEXT,
        endDate TEXT,
        autoAllocate INTEGER DEFAULT 0,
        percentageOfIncome REAL,
        rolloverEnabled INTEGER DEFAULT 0,
        rolloverAmount REAL DEFAULT 0,
        isProject INTEGER DEFAULT 0,
        projectGoal TEXT,
        linkedTransactionIds TEXT,
        alertAt REAL DEFAULT 80,
        notificationsEnabled INTEGER DEFAULT 1,
        averageSpending REAL DEFAULT 0,
        predictedSpending REAL DEFAULT 0,
        createdAt TEXT,
        updatedAt TEXT,
        isActive INTEGER DEFAULT 1
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

    await db.execute('''
      CREATE TABLE bills(
        id TEXT PRIMARY KEY,
        name TEXT,
        amount REAL,
        dueDate TEXT,
        frequency TEXT,
        category TEXT,
        paymentMethod TEXT,
        merchant TEXT,
        isVariable INTEGER DEFAULT 0,
        averageAmount REAL,
        status TEXT DEFAULT 'upcoming',
        paidDate TEXT,
        paidTransactionId TEXT,
        isActive INTEGER DEFAULT 1,
        autoDetected INTEGER DEFAULT 0,
        createdAt TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE categorization_rules(
        id TEXT PRIMARY KEY,
        name TEXT,
        category TEXT,
        matchType TEXT,
        matchValue TEXT,
        isActive INTEGER DEFAULT 1,
        priority INTEGER DEFAULT 0,
        createdAt TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE recurring_incomes(
        id TEXT PRIMARY KEY,
        name TEXT,
        source TEXT,
        amount REAL,
        minAmount REAL,
        maxAmount REAL,
        frequency TEXT,
        dayOfMonth INTEGER DEFAULT 1,
        dayOfWeek INTEGER DEFAULT 1,
        merchantName TEXT,
        autoMark INTEGER DEFAULT 1,
        lastReceived TEXT,
        nextExpected TEXT,
        isActive INTEGER DEFAULT 1,
        createdAt TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE planning_items(
        id TEXT PRIMARY KEY,
        name TEXT NOT NULL,
        estimated_cost REAL NOT NULL,
        actual_cost REAL DEFAULT 0,
        notes TEXT,
        is_completed INTEGER DEFAULT 0,
        parent_id TEXT,
        sort_order INTEGER NOT NULL,
        tag TEXT,
        quantity INTEGER DEFAULT 1
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

    // Create indexes for performance
    await db.execute(
      'CREATE INDEX idx_transactions_date ON transactions(date DESC)',
    );
    await db.execute(
      'CREATE INDEX idx_transactions_category ON transactions(category)',
    );
    await db.execute(
      'CREATE INDEX idx_transactions_type ON transactions(type)',
    );
    await db.execute(
      'CREATE INDEX idx_transactions_accountId ON transactions(accountId)',
    );
    await db.execute('CREATE INDEX idx_budgets_category ON budgets(category)');
    await db.execute('CREATE INDEX idx_bills_dueDate ON bills(dueDate)');
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
      await db.execute(
        'ALTER TABLE transactions ADD COLUMN transactionId TEXT',
      );
    }
    if (oldVersion < 4) {
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

      await db.execute(
        'ALTER TABLE transactions ADD COLUMN fee REAL DEFAULT 0',
      );
      await db.execute('ALTER TABLE transactions ADD COLUMN accountId TEXT');
      await db.execute('ALTER TABLE transactions ADD COLUMN toAccountId TEXT');

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
    if (oldVersion < 5) {
      await db.execute('''
        CREATE TABLE IF NOT EXISTS bills(
          id TEXT PRIMARY KEY,
          name TEXT,
          amount REAL,
          dueDate TEXT,
          frequency TEXT,
          category TEXT,
          paymentMethod TEXT,
          merchant TEXT,
          isVariable INTEGER DEFAULT 0,
          averageAmount REAL,
          status TEXT DEFAULT 'upcoming',
          paidDate TEXT,
          paidTransactionId TEXT,
          isActive INTEGER DEFAULT 1,
          autoDetected INTEGER DEFAULT 0,
          createdAt TEXT
        )
      ''');
    }
    if (oldVersion < 6) {
      try {
        await db.execute('ALTER TABLE budgets ADD COLUMN name TEXT');
        await db.execute(
          'ALTER TABLE budgets ADD COLUMN type TEXT DEFAULT "category"',
        );
        await db.execute('ALTER TABLE budgets ADD COLUMN amount REAL');
        await db.execute(
          'ALTER TABLE budgets ADD COLUMN autoAllocate INTEGER DEFAULT 0',
        );
        await db.execute(
          'ALTER TABLE budgets ADD COLUMN percentageOfIncome REAL',
        );
        await db.execute(
          'ALTER TABLE budgets ADD COLUMN rolloverEnabled INTEGER DEFAULT 0',
        );
        await db.execute(
          'ALTER TABLE budgets ADD COLUMN rolloverAmount REAL DEFAULT 0',
        );
        await db.execute(
          'ALTER TABLE budgets ADD COLUMN isProject INTEGER DEFAULT 0',
        );
        await db.execute('ALTER TABLE budgets ADD COLUMN projectGoal TEXT');
        await db.execute(
          'ALTER TABLE budgets ADD COLUMN linkedTransactionIds TEXT',
        );
        await db.execute(
          'ALTER TABLE budgets ADD COLUMN alertAt REAL DEFAULT 80',
        );
        await db.execute(
          'ALTER TABLE budgets ADD COLUMN notificationsEnabled INTEGER DEFAULT 1',
        );
        await db.execute(
          'ALTER TABLE budgets ADD COLUMN averageSpending REAL DEFAULT 0',
        );
        await db.execute(
          'ALTER TABLE budgets ADD COLUMN predictedSpending REAL DEFAULT 0',
        );
        await db.execute('ALTER TABLE budgets ADD COLUMN createdAt TEXT');
        await db.execute('ALTER TABLE budgets ADD COLUMN updatedAt TEXT');
        await db.execute(
          'ALTER TABLE budgets ADD COLUMN isActive INTEGER DEFAULT 1',
        );

        await db.execute('''
          UPDATE budgets SET 
            name = category,
            amount = limit_amount,
            createdAt = startDate,
            updatedAt = startDate
          WHERE name IS NULL
        ''');
      } catch (e) {
        if (kDebugMode) print('Budget migration: $e');
      }
    }
    if (oldVersion < 7) {
      await db.execute('''
        CREATE TABLE IF NOT EXISTS categorization_rules(
          id TEXT PRIMARY KEY,
          name TEXT,
          category TEXT,
          matchType TEXT,
          matchValue TEXT,
          isActive INTEGER DEFAULT 1,
          priority INTEGER DEFAULT 0,
          createdAt TEXT
        )
      ''');

      await db.execute('''
        CREATE TABLE IF NOT EXISTS recurring_incomes(
          id TEXT PRIMARY KEY,
          name TEXT,
          source TEXT,
          amount REAL,
          minAmount REAL,
          maxAmount REAL,
          frequency TEXT,
          dayOfMonth INTEGER DEFAULT 1,
          dayOfWeek INTEGER DEFAULT 1,
          merchantName TEXT,
          autoMark INTEGER DEFAULT 1,
          lastReceived TEXT,
          nextExpected TEXT,
          isActive INTEGER DEFAULT 1,
          createdAt TEXT
        )
      ''');
    }
    if (oldVersion < 8) {
      await db.execute('''
        CREATE TABLE IF NOT EXISTS planning_items(
          id TEXT PRIMARY KEY,
          name TEXT NOT NULL,
          estimated_cost REAL NOT NULL,
          actual_cost REAL DEFAULT 0,
          notes TEXT,
          is_completed INTEGER DEFAULT 0,
          parent_id TEXT,
          sort_order INTEGER NOT NULL
        )
      ''');
    }
    if (oldVersion < 9) {
      try {
        await db.execute(
          'ALTER TABLE planning_items ADD COLUMN quantity INTEGER DEFAULT 1',
        );
      } catch (e) {
        if (kDebugMode) print('Quantity column migration: $e');
      }
    }
    if (oldVersion < 10) {
      try {
        await db.execute('ALTER TABLE planning_items ADD COLUMN tag TEXT');
      } catch (e) {
        if (kDebugMode) print('Tag column migration: $e');
      }
    }
    if (oldVersion < 11) {
      // Ensure both columns exist
      try {
        await db.execute(
          'ALTER TABLE planning_items ADD COLUMN quantity INTEGER DEFAULT 1',
        );
      } catch (_) {
        // Column may already exist
      }
      try {
        await db.execute('ALTER TABLE planning_items ADD COLUMN tag TEXT');
      } catch (_) {
        // Column may already exist
      }
    }
    if (oldVersion < 12) {
      // Add indexes for performance
      try {
        await db.execute(
          'CREATE INDEX IF NOT EXISTS idx_transactions_date ON transactions(date DESC)',
        );
        await db.execute(
          'CREATE INDEX IF NOT EXISTS idx_transactions_category ON transactions(category)',
        );
        await db.execute(
          'CREATE INDEX IF NOT EXISTS idx_transactions_type ON transactions(type)',
        );
        await db.execute(
          'CREATE INDEX IF NOT EXISTS idx_transactions_accountId ON transactions(accountId)',
        );
        await db.execute(
          'CREATE INDEX IF NOT EXISTS idx_budgets_category ON budgets(category)',
        );
        await db.execute(
          'CREATE INDEX IF NOT EXISTS idx_bills_dueDate ON bills(dueDate)',
        );
      } catch (e) {
        if (kDebugMode) print('Index creation error: $e');
      }
    }
    if (oldVersion < 13) {
      // Add notes and tags columns to transactions
      try {
        await db.execute('ALTER TABLE transactions ADD COLUMN notes TEXT');
        await db.execute('ALTER TABLE transactions ADD COLUMN tags TEXT');
      } catch (e) {
        if (kDebugMode) print('Notes/Tags column migration: $e');
      }
    }
    if (oldVersion < 14) {
      // Add counterparty column to transactions
      try {
        await db.execute(
          'ALTER TABLE transactions ADD COLUMN counterparty TEXT',
        );
      } catch (e) {
        if (kDebugMode) print('Counterparty column migration: $e');
      }
    }
    if (oldVersion < 15) {
      // Add accountBalance column to transactions
      try {
        await db.execute(
          'ALTER TABLE transactions ADD COLUMN accountBalance REAL',
        );
      } catch (e) {
        if (kDebugMode) print('AccountBalance column migration: $e');
      }
    }
  }

  Future<void> _ensureColumnsExist(Database db) async {
    try {
      // Check and add counterparty column if missing
      final tableInfo = await db.rawQuery('PRAGMA table_info(transactions)');
      final hasCounterparty = tableInfo.any(
        (col) => col['name'] == 'counterparty',
      );
      final hasAccountBalance = tableInfo.any(
        (col) => col['name'] == 'accountBalance',
      );

      if (!hasCounterparty) {
        await db.execute(
          'ALTER TABLE transactions ADD COLUMN counterparty TEXT',
        );
        if (kDebugMode) print('Added missing counterparty column');
      }

      if (!hasAccountBalance) {
        await db.execute(
          'ALTER TABLE transactions ADD COLUMN accountBalance REAL',
        );
        if (kDebugMode) print('Added missing accountBalance column');
      }
    } catch (e) {
      if (kDebugMode) print('Error ensuring columns exist: $e');
    }
  }

  Future<void> insertTransaction(domain.Transaction transaction) async {
    final db = await database;
    try {
      // Check if transaction with same transactionId already exists
      if (transaction.transactionId != null) {
        if (kDebugMode) {
          print('Inserting transaction with ID: ${transaction.transactionId}');
        }
        final existing = await db.query(
          'transactions',
          where: 'transactionId = ?',
          whereArgs: [transaction.transactionId],
          limit: 1,
        );
        if (existing.isNotEmpty) {
          if (kDebugMode) {
            print('Duplicate found, skipping: ${transaction.transactionId}');
          }
          return; // Skip duplicate
        }
      }

      // Ensure columns exist before inserting
      await _ensureColumnsExist(db);

      await db.insert(
        'transactions',
        TransactionModel.toJson(transaction),
        conflictAlgorithm: ConflictAlgorithm.ignore,
      );
      if (kDebugMode) {
        print(
          'Transaction inserted successfully: ${transaction.transactionId}',
        );
      }
    } catch (e) {
      if (kDebugMode) print('Error inserting transaction: $e');
    }
  }

  Future<void> removeDuplicateTransactions() async {
    final db = await database;

    // Remove duplicates with same transactionId (M-Pesa reference code)
    // Keep only the M-Pesa SMS (not bank confirmation)
    await db.execute('''
      DELETE FROM transactions 
      WHERE rowid NOT IN (
        SELECT MIN(rowid) 
        FROM transactions 
        WHERE transactionId IS NOT NULL
        GROUP BY transactionId
      ) AND transactionId IS NOT NULL
    ''');
  }

  Future<List<domain.Transaction>> getTransactions() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'transactions',
      orderBy: 'date DESC',
    );
    return List.generate(
      maps.length,
      (i) => TransactionModel.fromJson(maps[i]),
    );
  }

  Future<void> deleteTransaction(String id) async {
    final db = await database;
    await db.delete('transactions', where: 'id = ?', whereArgs: [id]);
  }

  Future<void> updateTransaction(
    String id,
    Map<String, dynamic> updates,
  ) async {
    final db = await database;
    await db.update('transactions', updates, where: 'id = ?', whereArgs: [id]);
  }

  Future<void> bulkDeleteTransactions(List<String> ids) async {
    final db = await database;
    final batch = db.batch();
    for (final id in ids) {
      batch.delete('transactions', where: 'id = ?', whereArgs: [id]);
    }
    await batch.commit(noResult: true);
  }

  Future<void> bulkUpdateCategory(List<String> ids, String category) async {
    final db = await database;
    final batch = db.batch();
    for (final id in ids) {
      batch.update(
        'transactions',
        {'category': category},
        where: 'id = ?',
        whereArgs: [id],
      );
    }
    await batch.commit(noResult: true);
  }

  Future<void> insertBudget(Budget budget) async {
    final db = await database;
    await db.insert(
      'budgets',
      budget.toJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Budget>> getBudgets({bool activeOnly = true}) async {
    final db = await database;
    final maps = activeOnly
        ? await db.query('budgets', where: 'isActive = ?', whereArgs: [1])
        : await db.query('budgets');
    return maps.map((m) => Budget.fromJson(m)).toList();
  }

  Future<Budget?> getBudget(String id) async {
    final db = await database;
    final results = await db.query('budgets', where: 'id = ?', whereArgs: [id]);
    return results.isNotEmpty ? Budget.fromJson(results.first) : null;
  }

  Future<void> updateBudget(String id, Map<String, dynamic> updates) async {
    final db = await database;
    updates['updatedAt'] = DateTime.now().toIso8601String();
    await db.update('budgets', updates, where: 'id = ?', whereArgs: [id]);
  }

  Future<void> deleteBudget(String id) async {
    final db = await database;
    await db.delete('budgets', where: 'id = ?', whereArgs: [id]);
  }

  // Account methods
  Future<void> insertAccount(Map<String, dynamic> account) async {
    final db = await database;
    await db.insert(
      'accounts',
      account,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Map<String, dynamic>>> getAccounts() async {
    final db = await database;
    return await db.query('accounts', orderBy: 'name ASC');
  }

  Future<Map<String, dynamic>?> getAccount(String id) async {
    final db = await database;
    final results = await db.query(
      'accounts',
      where: 'id = ?',
      whereArgs: [id],
    );
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

  Future<void> updateRecordedBalance(
    String accountId,
    double recordedBalance,
    DateTime smsDate,
  ) async {
    final db = await database;
    await db.update(
      'accounts',
      {
        'recordedBalance': recordedBalance,
        'lastSmsDate': smsDate.toIso8601String(),
        'updatedAt': DateTime.now().toIso8601String(),
      },
      where: 'id = ?',
      whereArgs: [accountId],
    );
  }

  Future<void> updateAccountOverdraft(
    String accountId,
    double overdraft,
  ) async {
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
    await db.insert(
      'debts',
      debt,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
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
    await db.insert(
      'sms_senders',
      sender,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Map<String, dynamic>>> getSmsSenders() async {
    final db = await database;
    return await db.query('sms_senders', where: 'isActive = ?', whereArgs: [1]);
  }

  Future<void> deleteSmsSender(String id) async {
    final db = await database;
    await db.update(
      'sms_senders',
      {'isActive': 0},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // Bill methods
  Future<void> insertBill(Map<String, dynamic> bill) async {
    final db = await database;
    await db.insert(
      'bills',
      bill,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Map<String, dynamic>>> getBills({bool activeOnly = true}) async {
    final db = await database;
    if (activeOnly) {
      return await db.query(
        'bills',
        where: 'isActive = ?',
        whereArgs: [1],
        orderBy: 'dueDate ASC',
      );
    }
    return await db.query('bills', orderBy: 'dueDate ASC');
  }

  Future<void> updateBill(String id, Map<String, dynamic> updates) async {
    final db = await database;
    await db.update('bills', updates, where: 'id = ?', whereArgs: [id]);
  }

  Future<void> deleteBill(String id) async {
    final db = await database;
    await db.update('bills', {'isActive': 0}, where: 'id = ?', whereArgs: [id]);
  }

  Future<void> markBillAsPaid(
    String billId,
    String transactionId,
    DateTime paidDate,
  ) async {
    final db = await database;
    await db.update(
      'bills',
      {
        'status': 'paid',
        'paidDate': paidDate.toIso8601String(),
        'paidTransactionId': transactionId,
      },
      where: 'id = ?',
      whereArgs: [billId],
    );
  }

  // Categorization Rules methods
  Future<void> insertCategorizationRule(Map<String, dynamic> rule) async {
    final db = await database;
    await db.insert(
      'categorization_rules',
      rule,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Map<String, dynamic>>> getCategorizationRules({
    bool activeOnly = true,
  }) async {
    final db = await database;
    return activeOnly
        ? await db.query(
            'categorization_rules',
            where: 'isActive = ?',
            whereArgs: [1],
            orderBy: 'priority DESC',
          )
        : await db.query('categorization_rules', orderBy: 'priority DESC');
  }

  Future<void> updateCategorizationRule(
    String id,
    Map<String, dynamic> updates,
  ) async {
    final db = await database;
    await db.update(
      'categorization_rules',
      updates,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<void> deleteCategorizationRule(String id) async {
    final db = await database;
    await db.update(
      'categorization_rules',
      {'isActive': 0},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // Recurring Income methods
  Future<void> insertRecurringIncome(Map<String, dynamic> income) async {
    final db = await database;
    await db.insert(
      'recurring_incomes',
      income,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Map<String, dynamic>>> getRecurringIncomes({
    bool activeOnly = true,
  }) async {
    final db = await database;
    return activeOnly
        ? await db.query(
            'recurring_incomes',
            where: 'isActive = ?',
            whereArgs: [1],
          )
        : await db.query('recurring_incomes');
  }

  Future<void> updateRecurringIncome(
    String id,
    Map<String, dynamic> updates,
  ) async {
    final db = await database;
    await db.update(
      'recurring_incomes',
      updates,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<void> deleteRecurringIncome(String id) async {
    final db = await database;
    await db.update(
      'recurring_incomes',
      {'isActive': 0},
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
