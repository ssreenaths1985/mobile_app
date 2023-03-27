import 'package:sqflite/sqflite.dart' as sql;
import 'package:path/path.dart' as path;
import 'package:sqflite/sqlite_api.dart';
import './constants.dart';

class FeedbackDbHelper {
  static Future<Database> database() async {
    final dbPath = await sql.getDatabasesPath();
    return sql.openDatabase(path.join(dbPath, FeedbackDatabase.name),
        onCreate: (db, version) async {
      final String table = FeedbackDatabase.userFeedbackTable;
      return await db.execute(
          'CREATE TABLE $table (id INTEGER PRIMARY KEY AUTOINCREMENT, user_id TEXT, user_rating REAL)');
    }, version: 1);
  }

  static Future<void> insert(String table, Map<String, Object> data) async {
    final db = await FeedbackDbHelper.database();
    db.insert(
      table,
      data,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  static Future<List<Map<String, dynamic>>> getData(String table) async {
    final db = await FeedbackDbHelper.database();
    return db.query(table);
  }
}
