import 'package:sqflite/sqflite.dart' as sql;
import 'package:path/path.dart' as path;
import 'package:sqflite/sqlite_api.dart';
import './../constants/index.dart';

class DBHelper {
  static Future<Database> database() async {
    final dbPath = await sql.getDatabasesPath();
    return sql.openDatabase(path.join(dbPath, AppDatabase.name),
        onCreate: (db, version) async {
      final String notificationsTable = AppDatabase.deletedNotificationsTable;
      final String feedbackTable = AppDatabase.feedbackTable;
      await db.execute(
          'CREATE TABLE $notificationsTable (id INTEGER PRIMARY KEY AUTOINCREMENT, user_id TEXT, notification_id TEXT)');
      return await db.execute(
          'CREATE TABLE $feedbackTable (id INTEGER PRIMARY KEY AUTOINCREMENT, user_id TEXT, user_rating REAL)');
    }, version: 1);
  }

  static Future<void> insert(String table, Map<String, Object> data) async {
    final db = await DBHelper.database();
    db.insert(
      table,
      data,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  static Future<List<Map<String, dynamic>>> getData(String table) async {
    final db = await DBHelper.database();
    return db.query(table);
  }
}
