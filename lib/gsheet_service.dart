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
    final values = data.values.map((v) => v?.toString() ?? '').toList();
    await _sheet!.values.appendRow(values);
  }
}
