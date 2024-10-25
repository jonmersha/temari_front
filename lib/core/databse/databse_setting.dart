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
    String path = join(await getDatabasesPath(), 'book_info.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) {
        return db.execute('''
          CREATE TABLE files(
            textbook_id INTEGER PRIMARY KEY,
            textbook_title TEXT NOT NULL,
            book_name TEXT NOT NULL,
            category TEXT NOT NULL,
            provider_logo TEXT NOT NULL,
            textbook_subject TEXT NOT NULL,
            textbook_grade INTEGER,
            textbook_description TEXT NOT NULL,
            textbook_isbn TEXT NOT NULL,
            textbook_image_url TEXT NOT NULL,
            textbook_url TEXT NOT NULL,
            provider_id INTEGER,
            provider_name TEXT NOT NULL,
            region_id INTEGER,
            region_name TEXT NOT NULL,
            textbook_created_at TEXT NOT NULL,
            textbook_updated_at TEXT NOT NULL
          )
        ''');
      },
    );
  }
  Future<void> insertBook(dynamic book) async {
    final db = await database;
    await db.insert('files', book);
  }

  Future<Map<String, dynamic>?> getBook(String bookName) async {
    final db = await database;
    final result = await db.query(
      'files',
      where: 'book_name = ?',
      whereArgs: [bookName],
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
  Future<void> deleteBook(int id) async {
    final db = await database;
    await db.delete('files', where: 'textbook_id = ?', whereArgs: [id]);
  }
}

