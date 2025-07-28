import 'dart:convert';
import 'dart:io';
import 'package:gsheets/gsheets.dart';
import 'package:flutter/services.dart' show rootBundle;

class GSheetService {
  static const _spreadsheetId = '1I0dkJq30JSM-sUaGUhd0eZiAdeuVjI7Ls4rNLWd6bbE';
  static const _sheetNameProduksi = 'Testing';
  static const _sheetNamePerawatan = 'Testing Perawatan';
  static const _sheetNamePemupukan = 'Testing Pemupukan';
  static const _sheetNameChemist = 'Testing Chemist';

  Worksheet? _sheet;

  GSheetService._();

  static Future<GSheetService> init() async {
    final jsonString = await rootBundle.loadString('assets/credentials/enginewaktuaplikasipemupukan-03e33861bae9.json',);
    final jsonCredentials = json.decode(jsonString);
    final gsheets = GSheets(jsonCredentials);
    final spreadsheet = await gsheets.spreadsheet(_spreadsheetId);
    final sheet = await spreadsheet.worksheetByTitle(_sheetNameProduksi,);

    final service = GSheetService._();
    service._sheet = sheet;
    return service;
  }

  Future<void> insertQAProduksi(Map<String, dynamic> data) async {
    final spreadsheet = await GSheets(json.decode(await rootBundle.loadString('assets/credentials/enginewaktuaplikasipemupukan-03e33861bae9.json',),),).spreadsheet(_spreadsheetId);
    final sheet = await spreadsheet.worksheetByTitle(_sheetNameProduksi);
    if (sheet == null) return;

    final orderedKeys = [
      'id',
      'tanggal',
      'nama_petugas',
      'kebun',
      'divisi',
      'blok',
      'rotasi',
      'jumlah_pokok',
      'pkk_dipanen',
      'buah_dipanen',
      'buah_matang_tidak_dipanen',
      'buah_busuk_tidak_dipanen',
      'lf_tinggal',
      'lf_tinggal_tph',
      'buah_tinggal',
      'buah_tinggal_tph',

      'is_synced',
      'timestamp_sync',
    ];

    final values = orderedKeys
        .map((key) => data[key]?.toString() ?? '')
        .toList();
    await _sheet!.values.appendRow(values);
  }

  Future<void> insertQAPerawatan(Map<String, dynamic> data) async {
    final spreadsheet = await GSheets(json.decode(await rootBundle.loadString('assets/credentials/enginewaktuaplikasipemupukan-03e33861bae9.json',),),).spreadsheet(_spreadsheetId);
    final sheet = await spreadsheet.worksheetByTitle(_sheetNamePerawatan);
    if (sheet == null) return;

    final orderedKeys = [
      'id',
      'tanggal',
      'nama_petugas',
      'kebun',
      'divisi',
      'blok',
      'jumlah_pokok',

      'beneficial_plant',
      'peilscale',

      'kondisi_circle_baik',
      'kondisi_circle_semak',
      'kondisi_circle_dominan_anak_sawit',
      'kondisi_circle_dominan_sampah',

      'kondisi_path_baik',
      'kondisi_path_tidak_baik',

      'kondisi_tph',

      'lalang_ada',
      'lalang_tidak_ada',

      'anak_kayu_ada',
      'anak_kayu_tidak_ada',

      'perumpung_ada',
      'perumpung_tidak_ada',

      'purun_tikus_ada',
      'purun_tikus_tidak_ada',

      'pakis_udang_ada',
      'pakis_udang_tidak_ada',

      'titi_panen',

      'jalan_jembatan',

      'pruning_baik',
      'pruning_over',
      'pruning_sengkleh',
      'pruning_under',

      'susunan_pelepah_rapi',
      'susunan_pelepah_tidak_rapi',

      'serangan_tikus_ada',
      'serangan_tikus_tidak_ada',
      'serangan_rayap_ada',
      'serangan_rayap_tidak_ada',
      'thirathaba_ada',
      'thirathaba_tidak_ada',
      'updpks_ada',
      'updpks_tidak_ada',

      'is_synced',
      'timestamp_sync',
    ];

    final values = orderedKeys.map((k) => data[k]?.toString() ?? '').toList();
    await sheet.values.appendRow(values);
  }

  Future<void> insertQAPemupukan(Map<String, dynamic> data) async {
    final spreadsheet = await GSheets(json.decode(await rootBundle.loadString('assets/credentials/enginewaktuaplikasipemupukan-03e33861bae9.json',),),).spreadsheet(_spreadsheetId);
    final sheet = await spreadsheet.worksheetByTitle(_sheetNamePemupukan);
    if (sheet == null) return;

    final orderedKeys = [
      'id',
      'tanggal',
      'nama_petugas',
      'kebun',
      'divisi',
      'blok',
      'tanggal_pemupukan',
      'jenis_pupuk',
      'dosis',
      'tenaga_pemupuk',
      'supervisi',
      'fisik_pupuk',
      'jumlah_pokok',
      'total_alat_tabur',
      'alat_tabur_seragam',
      'alat_tabur_tidak_seragam',
      'total_tenaga_kerja',
      'total_uji_petik_aktif',
      'total_uji_petik_nonaktif',
      'total_dosis_sesuai',
      'total_dosis_tidak_sesuai',
      'pokok_terpupuk',
      'pokok_tidak_terpupuk',
      'gawangan_baik',
      'gawangan_semak',
      'cara_aplikasi_standar',
      'cara_aplikasi_tidak_standar',
      'apd_pekerja',
      'daftar_tenaga_tabur',
      'ringkasan',
      'is_synced',
      'timestamp_sync',
    ];

    final values = orderedKeys.map((k) => data[k]?.toString() ?? '').toList();
    await sheet.values.appendRow(values);
  }

  Future<void> insertQAChemist(Map<String, dynamic> data) async {
    final spreadsheet = await GSheets(json.decode(await rootBundle.loadString('assets/credentials/enginewaktuaplikasipemupukan-03e33861bae9.json',),),).spreadsheet(_spreadsheetId);
    final sheet = await spreadsheet.worksheetByTitle(_sheetNameChemist);
    if (sheet == null) return;

    final orderedKeys = [
      'id',
      'tanggal',
      'nama_petugas',
      'kebun',
      'divisi',
      'blok',
      'tanggal_semprot',
      'luas',
      'chemist',
      'jenis_chemist',
      'dosis_knapsack',
      'bahan_herbisida',
      'program_pengendalian_gulma',
      'kartu_pengambilan_pencampuran',
      'kalibrasi_alat_nozel',
      'gelas_ukur_perkakas',
      'peletakan_alat_semprot',
      'jumlah_pokok',
      'total_tenaga_kerja',
      'total_uji_petik_aktif',
      'total_uji_petik_nonaktif',
      'total_uji_petik_sesuai',
      'total_uji_petik__tidak_sesuai',
      'total_pokok_tersemprot',
      'total_pokok__tidak_tersemprot',
      'total_alat_semprot_baik',
      'total_alat_semprot__tidak_layak',
      'total_nozel_seragam',
      'total_nozel_tidak_seragam',
      'apd_pekerja',
      'daftar_tenaga_semprot',
      'tanggal_mutu_ancak',
      'jumlah_pokok_gulma',
      'total_gulma_circle_mati',
      'total_gulma_path_mati',
      'total_gulma_tph_mati',
      'total_gulma_gawangan_mati',
      'ringkasan_chemist',
      'ringkasan_mutu_ancak',
      'is_synced',
      'timestamp_sync',
    ];

    final values = orderedKeys.map((k) => data[k]?.toString() ?? '').toList();
    await sheet.values.appendRow(values);
  }
}
