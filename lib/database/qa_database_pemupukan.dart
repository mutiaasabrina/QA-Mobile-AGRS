import 'dart:async';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';


class QADatabasePemupukan {
  static final QADatabasePemupukan instance = QADatabasePemupukan._init();
  static Database? _database;

  QADatabasePemupukan._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('qa_pemupukan.db');
    return _database!;
  }

  Future<Database> _initDB(String fileName) async {
    final documentsDirectory = await getApplicationDocumentsDirectory();
    final path = join(documentsDirectory.path, fileName);
    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE qa_pemupukan_samples (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        tanggal TEXT,
        nama_petugas TEXT,
        kebun TEXT,
        divisi TEXT,
        blok TEXT,
        tanggal_pemupukan TEXT,
        jenis_pupuk TEXT,
        dosis TEXT,
        tenaga_pemupuk TEXT,
        supervisi TEXT,
        fisik_pupuk TEXT,
        jumlah_pokok INTEGER,
        total_alat_tabur INTEGER,
        total_tenaga_kerja INTEGER,
        total_uji_petik_aktif INTEGER,
        total_uji_petik_nonaktif INTEGER,
        total_dosis_sesuai INTEGER,
        total_dosis_tidak_sesuai INTEGER,
        pokok_terpupuk INTEGER,
        pokok_tidak_terpupuk INTEGER,
        lubang_pocket_standar INTEGER,
        lubang_pocket_tidak_standar INTEGER,
        gawangan_baik INTEGER,
        gawangan_semak INTEGER,
        cara_aplikasi_standar INTEGER,
        cara_aplikasi_tidak_standar INTEGER,
        apd_pekerja TEXT,
        ringkasan TEXT,
        is_synced INTEGER,
        timestamp_sync TEXT
      )
    ''');
  }

  Future<int> insertQA(Map<String, dynamic> data) async {
    final db = await instance.database;
    return await db.insert('qa_pemupukan_samples', data);
  }

  Future<List<Map<String, dynamic>>> getAllQAHariIni(String tanggal) async {
    final db = await instance.database;
    return await db.query(
      'qa_pemupukan_samples',
      where: 'tanggal = ?',
      whereArgs: [tanggal],
      orderBy: 'id DESC',
    );
  }

  Future<void> updateSyncStatusWithTimestamp(int id, bool synced, String timestamp) async {
    final db = await instance.database;
    await db.update(
      'qa_pemupukan_samples',
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
    await db.delete('qa_pemupukan_samples', where: 'id = ?', whereArgs: [id]);
  }

  Future<void> clearAll() async {
    final db = await instance.database;
    await db.delete('qa_pemupukan_samples');
  }
}
