import 'dart:async';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

class QADatabaseTBSProduksi {
  static final QADatabaseTBSProduksi instance = QADatabaseTBSProduksi._init();
  static Database? _database;

  QADatabaseTBSProduksi._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('qa_tbs_produksi.db');
    return _database!;
  }

  Future<Database> _initDB(String fileName) async {
    final documentsDirectory = await getApplicationDocumentsDirectory();
    final path = join(documentsDirectory.path, fileName);
    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

 Future _createDB(Database db, int version) async {
  await db.execute('''
    CREATE TABLE qa_tbs (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      tanggal TEXT,
      nama_petugas TEXT,
      kebun TEXT,
      divisi TEXT,
      blok TEXT,
      mentah INTEGER,
      masak INTEGER,
      overripe INTEGER,
      busuk_kosong INTEGER,
      abnormal INTEGER,
      total_buah INTEGER,
      tph_counter INTEGER,

      is_synced INTEGER,
      timestamp_sync TEXT
    )
  ''');
}


 Future<int> insertQA(Map<String, dynamic> data) async {
    final db = await instance.database;
    return await db.insert('qa_tbs', data);
  }

  Future<List<Map<String, dynamic>>> getAllQAHariIni(String tanggal) async {
    final db = await instance.database;
    return await db.query(
      'qa_tbs',
      where: 'tanggal = ?',
      whereArgs: [tanggal],
      orderBy: 'id DESC',
    );
  }

  Future<List<Map<String, dynamic>>> getAllQA() async {
    final db = await instance.database;
    return await db.query('qa_tbs', orderBy: 'tanggal DESC, id DESC');
  }

  Future<List<Map<String, dynamic>>> getUnsyncedQA() async {
    final db = await instance.database;
    return await db.query(
      'qa_tbs',
      where: 'is_synced = 0',
      orderBy: 'tanggal DESC',
    );
  }

  // ✅ Versi baru: dengan timestamp custom (format cantik)
  Future<void> updateSyncStatusWithTimestamp(int id, bool synced, String timestamp) async {
    final db = await instance.database;
    await db.update(
      'qa_tbs',
      {
        'is_synced': synced ? 1 : 0,
        'timestamp_sync': synced ? timestamp : null,
      },
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<void> deleteQA(String blok, String kebun, String divisi, String tanggal) async {
    final db = await instance.database;
    await db.delete(
      'qa_tbs',
      where: 'blok = ? AND kebun = ? AND divisi = ? AND tanggal = ?',
      whereArgs: [blok, kebun, divisi, tanggal],
      );
  }

  Future<void> deleteSyncedQA() async {
    final db = await instance.database;
    await db.delete('qa_tbs', where: 'is_synced = ?', whereArgs: [1]);
  }

  Future<void> clearAllQA() async {
    final db = await instance.database;
    await db.delete('qa_tbs');
  }
}
