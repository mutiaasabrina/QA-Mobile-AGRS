import 'dart:async';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';


class QADatabaseChemist {
  static final QADatabaseChemist instance = QADatabaseChemist._init();
  static Database? _database;

  QADatabaseChemist._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('qa_chemist.db');
    return _database!;
  }

  Future<Database> _initDB(String fileName) async {
    final documentsDirectory = await getApplicationDocumentsDirectory();
    final path = join(documentsDirectory.path, fileName);
    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE qa_chemist_samples (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        tanggal TEXT,
        nama_petugas TEXT,
        kebun TEXT,
        divisi TEXT,
        blok TEXT,
        tanggal_semprot TEXT,
        luas TEXT,
        chemist TEXT,
        jenis_chemist TEXT,
        dosis_knapsack TEXT,
        bahan_herbisida TEXT,
        program_pengendalian_gulma TEXT,
        kartu_pengambilan_pencampuran TEXT,
        kalibrasi_alat_nozel TEXT,
        gelas_ukur_perkakas TEXT,
        peletakan_alat_semprot TEXT,
        jumlah_pokok INTEGER,
        total_tenaga_kerja INTEGER,
        total_uji_petik_aktif INTEGER,
        total_uji_petik_nonaktif INTEGER,
        total_uji_petik_sesuai INTEGER,
        total_uji_petik__tidak_sesuai INTEGER,
        total_pokok_tersemprot INTEGER,
        total_pokok__tidak_tersemprot INTEGER,
        total_alat_semprot_baik INTEGER,
        total_alat_semprot__tidak_layak INTEGER,
        total_nozel_seragam INTEGER,
        total_nozel_tidak_seragam INTEGER,
        apd_pekerja TEXT,
        ringkasan TEXT,
        is_synced INTEGER,
        timestamp_sync TEXT
      )
    ''');
  }

  Future<int> insertQA(Map<String, dynamic> data) async {
    final db = await instance.database;
    return await db.insert('qa_chemist_samples', data);
  }

  Future<List<Map<String, dynamic>>> getAllQAHariIni(String tanggal) async {
    final db = await instance.database;
    return await db.query(
      'qa_chemist_samples',
      where: 'tanggal = ?',
      whereArgs: [tanggal],
      orderBy: 'id DESC',
    );
  }

  Future<void> updateSyncStatusWithTimestamp(int id, bool synced, String timestamp) async {
    final db = await instance.database;
    await db.update(
      'qa_chemist_samples',
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
    await db.delete('qa_chemist_samples', where: 'id = ?', whereArgs: [id]);
  }

  Future<void> clearAll() async {
    final db = await instance.database;
    await db.delete('qa_chemist_samples');
  }
}
