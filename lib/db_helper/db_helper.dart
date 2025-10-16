import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../models/tasks_model.dart';


class DbHelper {
  static Database? db;
  Future onCreateDatabase(Database db, int version) async {
    await db.execute(
      'CREATE TABLE tasks(id INTEGER PRIMARY KEY, task TEXT, dueDate TEXT, isChecked INTEGER)',
    );
  }

  Future<Database?> initDatabase() async {
    if (db != null) {
      return db;
    }

    String path = join(await getDatabasesPath(), 'tasks.db');
    db = await openDatabase(
      path,
      version: 1,
      onCreate: onCreateDatabase,
    );
    return db;
  }

// GET DATA

  Future getDataFromDatabase() async {
    Database? db = await initDatabase();
    return db!.query('tasks');
  }

// INSERT DATA

  Future insertDataIntoDatabase(TasksModel tasksModel) async {
    Database? db = await initDatabase();
    return db!.insert(
      'tasks',
      tasksModel.toMap(),
    );
  }

// DELETA DATA

  Future deletetDataIntoDatabase(int id) async {
    Database? db = await initDatabase();
    await db!.delete('tasks', where: 'id=?', whereArgs: [id]);
  }
}
