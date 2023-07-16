import 'package:taskmanager/models/task.dart';
import 'package:sqflite/sqflite.dart';

class DBHelper {
  static Database? _db;

  static const int _version = 1;
  static const String _tableName = "tasks";

  static Future<void> initDb() async {
    if (_db != null) {
      return;
    }
    final databasesPath = await getDatabasesPath();
    final path = '${databasesPath}todo.db';

    try {
      _db = await openDatabase(
        path,
        version: _version,
        onCreate: (db, version) async {
          await db.execute('''
          CREATE TABLE $_tableName(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            title TEXT,
            note TEXT,
            isCompleted INTEGER,
            selectedDate TEXT,
            startTime TEXT,
            endTime TEXT,
            selectedRemind INTEGER,
            selectedRepeat TEXT,
            selectedColor INTEGER
          )
        ''');
        },
      );
    } catch (e) {
      initDb();
    }
  }

  static Future<int> insert(TaskToDo? task) async {
    return await _db?.insert(_tableName, task!.toJson()) ?? 1;
  }

  static Future<List<Map<String, dynamic>>> query() async {
    print("Getting tasks from DB");
    return _db!.query(_tableName);
  }

  static delete(TaskToDo task) async {
    await _db!.delete(_tableName, where: "id=?", whereArgs: [task.id]);
  }

  static update(int id, int val) async {
    return await _db!.rawUpdate('''
UPDATE $_tableName
SET isCompleted = ?
WHERE id =?
''', [val, id]);
  }
}
