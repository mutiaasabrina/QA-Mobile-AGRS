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
      pkk_dipanen INTEGER,
      buah_dipanen INTEGER,
      buah_matang_tidak_dipanen INTEGER,
      buah_busuk_tidak_dipanen INTEGER,
      lf_tinggal INTEGER,
      lf_tinggal_tph INTEGER,
      buah_tinggal INTEGER,

      kondisi_circle_baik INTEGER,
      kondisi_circle_semak INTEGER,
      kondisi_circle_dominan_anak_sawit INTEGER,
      kondisi_circle_dominan_sampah INTEGER,

      kondisi_path_baik INTEGER,
      kondisi_path_tidak_baik INTEGER,

      kondisi_tph_baik INTEGER,
      kondisi_tph_tidak_baik INTEGER,

      lalang_ada INTEGER,
      lalang_tidak_ada INTEGER,

      anak_kayu_ada INTEGER,
      anak_kayu_tidak_ada INTEGER,

      perumpung_ada INTEGER,
      perumpung_tidak_ada INTEGER,

      purun_tikus_ada INTEGER,
      purun_tikus_tidak_ada INTEGER,

      pakis_udang_ada INTEGER,
      pakis_udang_tidak_ada INTEGER,

      titi_panen_kondisi_standar_permanen_baik INTEGER,
      titi_panen_kondisi_standar_semi_permanen_baik INTEGER,
      titi_panen_kondisi_kurang_standar_semi_permanen_baik INTEGER,
      titi_panen_kondisi_kurang_standar_semi_permanen_rusak INTEGER,
      titi_panen_kondisi_tidak_ada INTEGER,

      jalan_jembatan_rata_permanen INTEGER,
      jalan_jembatan_sedang_permanen INTEGER,
      jalan_jembatan_rusak_sebagian INTEGER,
      jalan_jembatan_dominan_rusak INTEGER,
      jalan_jembatan_parah INTEGER,

      pruning_baik INTEGER,
      pruning_over INTEGER,
      pruning_sengkleh INTEGER,
      pruning_under INTEGER,

      susunan_pelepah_rapi INTEGER,
      susunan_pelepah_tidak_rapi INTEGER,

      serangan_tikus_ada INTEGER,
      serangan_tikus_tidak_ada INTEGER,
      serangan_rayap_ada INTEGER,
      serangan_rayap_tidak_ada INTEGER,
      thirathaba_ada INTEGER,
      thirathaba_tidak_ada INTEGER,
      updpks_ada INTEGER,
      updpks_tidak_ada INTEGER,

      is_synced INTEGER,
      timestamp_sync TEXT
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

  // ✅ Versi baru: dengan timestamp custom (format cantik)
  Future<void> updateSyncStatusWithTimestamp(int id, bool synced, String timestamp) async {
    final db = await instance.database;
    await db.update(
      'qa_samples',
      {
        'is_synced': synced ? 1 : 0,
        'timestamp_sync': synced ? timestamp : null,
      },
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
