import 'package:intl/intl.dart';
import 'dart:async';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:qa_agronomy/database/input_mutu_ancak_database_chemist.dart';



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
        total_uji_petik__tidak_sesuai INTEGER,
        total_alat_semprot_baik INTEGER,
        total_alat_semprot__tidak_layak INTEGER,
        total_nozel_seragam INTEGER,
        total_nozel_tidak_seragam INTEGER,
        apd_pekerja TEXT,
        daftar_tenaga_semprot TEXT,
        ringkasan_chemist TEXT,
        is_synced INTEGER,
        timestamp_sync TEXT
      )
    ''');
  }

  Future<int> insertQA(Map<String, dynamic> data) async {
    final db = await instance.database;
    return await db.insert('qa_chemist_samples', data);
  }

  Future<List<Map<String, dynamic>>> getQAOnDaysAgo(int jumlahHari) async {
    final db = await instance.database;

    final waktuSekarang = DateTime.now();
    final tanggalXHariLalu = waktuSekarang.subtract(Duration(days: jumlahHari));
    final tanggalXHariLaluFormatted = DateFormat('yyyy-MM-dd').format(tanggalXHariLalu);

    return await db.query(
      'qa_chemist_samples',
      where: 'tanggal = ?',
      whereArgs: [tanggalXHariLaluFormatted],
      orderBy: 'id DESC',
    );
  }

  Future<int> updateSyncStatusQAData(String tanggalPeriksa, String kebun, String divisi, String blok, int newSyncStatus) async {
    final db = await instance.database;

    Map<String, dynamic> updateData = {
      'is_synced': newSyncStatus,
    };

    return await db.update(
      'qa_chemist_samples',
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
      'qa_chemist_samples',
      where: 'is_synced = ?',
      whereArgs: [0],
      orderBy: 'tanggal DESC',
    );
  }

  Future<List<Map<String, dynamic>>> getAllQAOrderedByDate() async {
    final db = await instance.database;

    return await db.query(
      'qa_chemist_samples',
      orderBy: 'tanggal DESC',
    );
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

  Future<List<Map<String, dynamic>>> getChemistSamplesNeedingAncak() async {
  final chemistDB = await instance.database;

  // Buka juga koneksi ke database QA Mutu Ancak
  final ancakDB = await QADatabaseChemistGulmaAncak.instance.database;

  final now = DateTime.now();
  final limitDate = now.subtract(Duration(days: 14));
  final formattedLimitDate = DateFormat('yyyy-MM-dd').format(limitDate);

  // Ambil semua data Chemist yg lebih dari 14 hari
  final chemistData = await chemistDB.query(
    'qa_chemist_samples',
    where: 'tanggal < ?',
    whereArgs: [formattedLimitDate],
  );

  // Filter yang belum ada pasangan di qa_chemist_mutu_ancak_samples
  List<Map<String, dynamic>> needAncak = [];

  for (final chemist in chemistData) {
    final exist = await ancakDB.query(
      'qa_chemist_mutu_ancak_samples',
      where: 'tanggal = ? AND kebun = ? AND divisi = ? AND blok = ?',
      whereArgs: [
        chemist['tanggal'],
        chemist['kebun'],
        chemist['divisi'],
        chemist['blok'],
      ],
    );

    if (exist.isEmpty) {
      needAncak.add(chemist);
    }
  }

  return needAncak;
}

}
