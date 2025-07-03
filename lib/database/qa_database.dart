import 'dart:async';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
// import 'dart:io';

class QADatabase {
  static final QADatabase instance = QADatabase._init();
  static Database? _database;

  QADatabase._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('qa_local.db');
    return _database!;
  }

  Future<Database> _initDB(String fileName) async {
    final documentsDirectory = await getApplicationDocumentsDirectory();
    final path = join(documentsDirectory.path, fileName);
    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE qa_samples (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        tanggal TEXT,
        nama_petugas TEXT,
        kebun TEXT,
        divisi TEXT,
        blok TEXT,
        rotasi INTEGER,
        jumlah_pokok INTEGER,
        summary TEXT,
        is_synced INTEGER
      )
    ''');
  }

  Future<int> insertQA(Map<String, dynamic> data) async {
    final db = await instance.database;
    return await db.insert('qa_samples', data);
  }

  Future<List<Map<String, dynamic>>> getAllQAHariIni(String tanggal) async {
    final db = await instance.database;
    return await db.query(
      'qa_samples',
      where: 'tanggal = ?',
      whereArgs: [tanggal],
      orderBy: 'id DESC',
    );
  }

  Future<List<Map<String, dynamic>>> getAllQA() async {
    final db = await instance.database;
    return await db.query('qa_samples', orderBy: 'tanggal DESC, id DESC');
  }

  Future<List<Map<String, dynamic>>> getUnsyncedQA() async {
    final db = await instance.database;
    return await db.query(
      'qa_samples',
      where: 'is_synced = 0',
      orderBy: 'tanggal DESC',
    );
  }

  Future<void> updateSyncStatus(int id, bool synced) async {
    final db = await instance.database;
    await db.update(
      'qa_samples',
      {'is_synced': synced ? 1 : 0},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<void> deleteSyncedQA() async {
    final db = await instance.database;
    await db.delete('qa_samples', where: 'is_synced = ?', whereArgs: [1]);
  }

  Future<void> clearAllQA() async {
    final db = await instance.database;
    await db.delete('qa_samples');
  }
}
