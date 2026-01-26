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
      CREATE TABLE transactions(
        id TEXT PRIMARY KEY,
        amount REAL,
        category TEXT,
        description TEXT,
        date TEXT,
        type TEXT
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
  }

  Future<void> insertTransaction(domain.Transaction transaction) async {
    final db = await database;
    await db.insert('transactions', TransactionModel.toJson(transaction));
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
}
