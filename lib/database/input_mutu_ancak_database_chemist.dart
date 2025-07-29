import 'package:intl/intl.dart';
import 'dart:async';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';


class QADatabaseChemistGulmaAncak {
  static final QADatabaseChemistGulmaAncak instance = QADatabaseChemistGulmaAncak._init();
  static Database? _database;

  QADatabaseChemistGulmaAncak._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('qa_chemist_mutu_ancak.db');
    return _database!;
  }

  Future<Database> _initDB(String fileName) async {
    final documentsDirectory = await getApplicationDocumentsDirectory();
    final path = join(documentsDirectory.path, fileName);
    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE qa_chemist_mutu_ancak_samples (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        tanggal TEXT,
        nama_petugas TEXT,
        kebun TEXT,
        divisi TEXT,
        blok TEXT,
        tanggal_semprot TEXT,
        luas TEXT,
        jumlah_tenaga_kerja TEXT,
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
        total_uji_petik_tidak_sesuai INTEGER,
        total_pokok_tersemprot INTEGER,
        total_pokok_tidak_tersemprot INTEGER,
        total_alat_semprot_baik INTEGER,
        total_alat_semprot_tidak_layak INTEGER,
        total_nozel_seragam INTEGER,
        total_nozel_tidak_seragam INTEGER,
        apd_pekerja TEXT,
        daftar_tenaga_semprot TEXT,
        tanggal_mutu_ancak TEXT,
        jumlah_pokok_gulma INTEGER,
        total_gulma_circle_mati INTEGER,
        total_gulma_path_mati INTEGER,
        total_gulma_tph_mati INTEGER,
        total_gulma_gawangan_mati INTEGER,
        ringkasan_chemist TEXT,
        ringkasan_mutu_ancak TEXT,
        is_synced INTEGER,
        timestamp_sync TEXT
      )
    ''');
  }

  Future<int> insertQA(Map<String, dynamic> data) async {
    final db = await instance.database;
    return await db.insert('qa_chemist_mutu_ancak_samples', data);
  }

  Future<List<Map<String, dynamic>>> getQAOnDaysAgo(int jumlahHari) async {
    final db = await instance.database;

    final waktuSekarang = DateTime.now();
    final tanggalXHariLalu = waktuSekarang.subtract(Duration(days: jumlahHari));
    final tanggalXHariLaluFormatted = DateFormat('yyyy-MM-dd').format(tanggalXHariLalu);

    return await db.query(
      'qa_chemist_mutu_ancak_samples',
      where: 'tanggal = ?',
      whereArgs: [tanggalXHariLaluFormatted],
      orderBy: 'id DESC',
    );
  }

  Future<List<Map<String, dynamic>>> getAllQAOrderedByDate() async {
    final db = await instance.database;

    return await db.query(
      'qa_chemist_mutu_ancak_samples',
      orderBy: 'tanggal DESC',
    );
  }

  Future<List<Map<String, dynamic>>> getAllQAHariIni(String tanggal) async {
    final db = await instance.database;
    return await db.query(
      'qa_chemist_mutu_ancak_samples',
      where: 'tanggal = ?',
      whereArgs: [tanggal],
      orderBy: 'id DESC',
    );
  }

  Future<List<Map<String, dynamic>>> getAllQABasedTanggalMutuAncak(String tanggal) async {
    final db = await instance.database;
    return await db.query(
      'qa_chemist_mutu_ancak_samples',
      where: 'tanggal_mutu_ancak = ?',
      whereArgs: [tanggal],
      orderBy: 'id DESC',
    );
  }

  Future<void> updateSyncStatusWithTimestamp(int id, bool synced, String timestamp) async {
    final db = await instance.database;
    await db.update(
      'qa_chemist_mutu_ancak_samples',
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
    await db.delete('qa_chemist_mutu_ancak_samples', where: 'id = ?', whereArgs: [id]);
  }

  Future<void> clearAll() async {
    final db = await instance.database;
    await db.delete('qa_chemist_mutu_ancak_samples');
  }
}
