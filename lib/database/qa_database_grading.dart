import 'dart:async';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';


class QADatabaseGrading {
  static final QADatabaseGrading instance = QADatabaseGrading._init();
  static Database? _database;

  QADatabaseGrading._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('qa_grading.db');
    return _database!;
  }

  Future<Database> _initDB(String fileName) async {
    final documentsDirectory = await getApplicationDocumentsDirectory();
    final path = join(documentsDirectory.path, fileName);
    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE qa_grading_samples (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        tanggal TEXT,
        nama_petugas TEXT,
        kebun TEXT,
        divisi TEXT,
        blok TEXT,
        varietas TEXT,
        tahun_tanam TEXT,
        buah_a_mentah DOUBLE,
        Berat_buah_a_mentah DOUBLE,
        buah_b_mentah DOUBLE,
        Berat_buah_b_mentah DOUBLE,
        buah_c_mentah DOUBLE,
        Berat_buah_c_mentah DOUBLE,
        buah_d_mentah DOUBLE,
        Berat_buah_d_mentah DOUBLE,
        buah_a_matang DOUBLE,
        Berat_buah_a_matang DOUBLE,
        buah_b_matang DOUBLE,
        Berat_buah_b_matang DOUBLE,
        buah_c_matang DOUBLE,
        Berat_buah_c_matang DOUBLE,
        buah_d_matang DOUBLE,
        Berat_buah_d_matang DOUBLE,
        buah_kurang3kg_mentah INTEGER,
        buah_kurang3kg_matang INTEGER,
        total_buah_mentah INTEGER,
        total_buah_matang INTEGER,
        is_synced INTEGER,
        timestamp_sync TEXT
      )
    ''');
  }

  Future<int> insertQA(Map<String, dynamic> data) async {
    final db = await instance.database;
    return await db.insert('qa_grading_samples', data);
  }

  Future<int> updateSyncStatusQAData(String tanggalPeriksa, String kebun, String divisi, String blok, int newSyncStatus) async {
    final db = await instance.database;

    Map<String, dynamic> updateData = {
      'is_synced': newSyncStatus,
    };

    return await db.update(
      'qa_grading_samples',
      updateData,
      where: 'tanggal = ? AND kebun = ? AND divisi = ? AND blok = ?',
      whereArgs: [
        tanggalPeriksa,
        kebun, 
        divisi, 
        blok
      ],
    );
  }

  Future<List<Map<String, dynamic>>> getUnsyncedQAOrderedByDate() async {
    final db = await instance.database;

    return await db.query(
      'qa_grading_samples',
      where: 'is_synced = ?',
      whereArgs: [0],
      orderBy: 'tanggal DESC',
    );
  }

  Future<List<Map<String, dynamic>>> getAllQAOrderedByDate() async {
    final db = await instance.database;

    return await db.query(
      'qa_grading_samples',
      orderBy: 'tanggal DESC',
    );
  }

  Future<List<Map<String, dynamic>>> getAllQAHariIni(String tanggal) async {
    final db = await instance.database;
    return await db.query(
      'qa_grading_samples',
      where: 'tanggal = ?',
      whereArgs: [tanggal],
      orderBy: 'id DESC',
    );
  }

  Future<void> updateSyncStatusWithTimestamp(int id, bool synced, String timestamp) async {
    final db = await instance.database;
    await db.update(
      'qa_grading_samples',
      {
        'is_synced': synced ? 1 : 0,
        'timestamp_sync': synced ? timestamp : null,
      },
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<void> deleteQA(int id) async {
    final db = await instance.database;
    await db.delete('qa_grading_samples', where: 'id = ?', whereArgs: [id]);
  }

  Future<void> clearAll() async {
    final db = await instance.database;
    await db.delete('qa_grading_samples');
  }
}
