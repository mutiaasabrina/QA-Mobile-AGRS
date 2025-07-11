import 'dart:convert';
import 'dart:io';
import 'package:gsheets/gsheets.dart';
import 'package:flutter/services.dart' show rootBundle;

class GSheetService {
  static const _spreadsheetId = '1I0dkJq30JSM-sUaGUhd0eZiAdeuVjI7Ls4rNLWd6bbE';
  static const _sheetNameProduksiPerawatan = 'Testing';
  static const _sheetNamePemupukan = 'Testing Pemupukan';

  Worksheet? _sheet;

  GSheetService._();

  static Future<GSheetService> init() async {
    final jsonString = await rootBundle.loadString(
      'assets/credentials/enginewaktuaplikasipemupukan-03e33861bae9.json'
    );
    final jsonCredentials = json.decode(jsonString);
    final gsheets = GSheets(jsonCredentials);
    final spreadsheet = await gsheets.spreadsheet(_spreadsheetId);
    final sheet = await spreadsheet.worksheetByTitle(_sheetNameProduksiPerawatan);

    final service = GSheetService._();
    service._sheet = sheet;
    return service;
  }

  Future<void> insertQA(Map<String, dynamic> data) async {
  if (_sheet == null) return;

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

    'beneficial_plant',
    'peilscale',

    'kondisi_circle_baik',
    'kondisi_circle_semak',
    'kondisi_circle_dominan_anak_sawit',
    'kondisi_circle_dominan_sampah',

    'kondisi_path_baik',
    'kondisi_path_tidak_baik',

    'kondisi_tph_baik',
    'kondisi_tph_tidak_baik',

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

    'titi_panen_kondisi_standar_permanen_baik',
    'titi_panen_kondisi_standar_semi_permanen_baik',
    'titi_panen_kondisi_kurang_standar_semi_permanen_baik',
    'titi_panen_kondisi_kurang_standar_semi_permanen_rusak',
    'titi_panen_kondisi_tidak_ada',

    'jalan_jembatan_rata_permanen',
    'jalan_jembatan_sedang_permanen',
    'jalan_jembatan_rusak_sebagian',
    'jalan_jembatan_dominan_rusak',
    'jalan_jembatan_parah',

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

  final values = orderedKeys.map((key) => data[key]?.toString() ?? '').toList();
  await _sheet!.values.appendRow(values);
}
Future<void> insertQAPemupukan(Map<String, dynamic> data) async {
  final spreadsheet = await GSheets(json.decode(await rootBundle.loadString(
    'assets/credentials/enginewaktuaplikasipemupukan-03e33861bae9.json'))).spreadsheet(_spreadsheetId);
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
    'lubang_pocket_standar',
    'lubang_pocket_tidak_standar',
    'gawangan_baik',
    'gawangan_semak',
    'cara_aplikasi_standar',
    'cara_aplikasi_tidak_standar',
    'apd_pekerja',
    'ringkasan',
    'is_synced',
    'timestamp_sync',
  ];

  final values = orderedKeys.map((k) => data[k]?.toString() ?? '').toList();
  await sheet.values.appendRow(values);
}
}

