import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import '../models/note_model.dart';

class DatabaseProvider {
  static const _databaseName = "note_app.db";
  static const _databaseVersion = 1;

  static const table = 'notes';

  static const columnId = 'id';
  static const columnTitle = 'title';
  static const columnBody = 'body';
  static const columnColor = 'color';
  static const columnDate = 'creationDate';

  static DatabaseProvider? _instance;
  static Database? _database;

  factory DatabaseProvider() => _instance ??= DatabaseProvider._();

  DatabaseProvider._();

  Future<Database> get database async => _database ??= await initDB();

  Future<Database> initDB() async {
    final path = join(await getDatabasesPath(), _databaseName);

    return await openDatabase(path,
        version: _databaseVersion, onCreate: _onCreate);
  }

  // SQL code to create the database table
  Future _onCreate(Database db, int version) async {
    await db.execute('''
          CREATE TABLE $table (
            $columnId INTEGER PRIMARY KEY AUTOINCREMENT,
            $columnTitle TEXT,
            $columnBody TEXT,
            $columnColor TEXT,
            $columnDate DATE
          )
          ''');
  }

  Future<List<NoteModel>> getAllNotes() async {
    final db = await database;

    List<Map<String, dynamic>> maps = await db.query(table);

    return List.generate(maps.length, (i) {
      return NoteModel(
        id: maps[i]['id'],
        title: maps[i]['title'],
        body: maps[i]['body'],
        color: maps[i]['color'],
        creationDate: DateTime.parse(maps[i]['creationDate']),
      );
    });
  }

  Future<int> create(NoteModel note) async {
    final db = await database;

    return await db.insert(table, note.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<int> update(NoteModel note) async {
    final db = await database;

    return await db
        .update('notes', note.toMap(), where: 'id = ?', whereArgs: [note.id]);
  }

  Future<int> delete(int id) async {
    final db = await database;

    return await db.delete('notes', where: 'id = ?', whereArgs: [id]);
  }

  Future<void> deleteDatabase() async {
    final path = join(await getDatabasesPath(), _databaseName);

    databaseFactory.deleteDatabase(path);
  }
}
