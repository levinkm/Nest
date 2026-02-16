import 'package:sqflite/sqflite.dart';
import '../models/planning_item.dart';
import '../../../transactions/data/datasources/local_database.dart';

class PlanningDatabase {
  static Future<void> createTable(Database db) async {
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
        tag TEXT
      )
    ''');
  }

  Future<List<PlanningItem>> getAllItems() async {
    final db = await LocalDatabase().database;
    final maps = await db.query('planning_items', orderBy: 'sort_order ASC');
    return maps.map((map) => PlanningItem.fromMap(map)).toList();
  }

  Future<void> insertItem(PlanningItem item) async {
    final db = await LocalDatabase().database;
    await db.insert('planning_items', item.toMap());
  }

  Future<void> updateItem(PlanningItem item) async {
    final db = await LocalDatabase().database;
    await db.update(
      'planning_items',
      item.toMap(),
      where: 'id = ?',
      whereArgs: [item.id],
    );
  }

  Future<void> deleteItem(String id) async {
    final db = await LocalDatabase().database;
    await db.delete('planning_items', where: 'id = ?', whereArgs: [id]);
    await db.delete('planning_items', where: 'parent_id = ?', whereArgs: [id]);
  }
}
