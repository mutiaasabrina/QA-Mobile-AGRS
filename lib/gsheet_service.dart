import 'dart:convert';
import 'dart:io';
import 'package:gsheets/gsheets.dart';
import 'package:flutter/services.dart' show rootBundle;

class GSheetService {
  static const _spreadsheetId = '1I0dkJq30JSM-sUaGUhd0eZiAdeuVjI7Ls4rNLWd6bbE';
  static const _sheetName = 'Testing';

  Worksheet? _sheet;

  GSheetService._();

  static Future<GSheetService> init() async {
    final jsonString = await rootBundle.loadString(
      'assets/credentials/enginewaktuaplikasipemupukan-03e33861bae9.json'
    );
    final jsonCredentials = json.decode(jsonString);
    final gsheets = GSheets(jsonCredentials);
    final spreadsheet = await gsheets.spreadsheet(_spreadsheetId);
    final sheet = await spreadsheet.worksheetByTitle(_sheetName);

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

    'titi_panen_ada',
    'titi_panen_tidak_ada',

    'jalan_dan_jembatan_baik',
    'jalan_dan_jembatan_sedang',
    'jalan_dan_jembatan_jelek',

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
}
