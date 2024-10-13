import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class FileDatabaseHelper {
  static final FileDatabaseHelper _instance = FileDatabaseHelper._internal();
  factory FileDatabaseHelper() => _instance;
  static Database? _database;

  FileDatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'file_info.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) {
        return db.execute('''
          CREATE TABLE files(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            file_name TEXT NOT NULL,
            file_size INTEGER NOT NULL,
            download_date TEXT NOT NULL
          )
        ''');
      },
    );
  }

  Future<void> insertFile(String fileName, int fileSize, String downloadDate) async {
    final db = await database;
    await db.insert('files', {
      'file_name': fileName,
      'file_size': fileSize,
      'download_date': downloadDate,
    });
  }

  Future<Map<String, dynamic>?> getFile(String fileName) async {
    final db = await database;
    final result = await db.query(
      'files',
      where: 'file_name = ?',
      whereArgs: [fileName],
    );
    if (result.isNotEmpty) {
      return result.first;
    }
    return null;
  }
  Future<List<Map<String, dynamic>>> getAllFiles() async {
    final db = await database;
    return await db.query('files');
  }
  Future<void> deleteFile(int id) async {
    final db = await database;
    await db.delete('files', where: 'id = ?', whereArgs: [id]);
  }
}

