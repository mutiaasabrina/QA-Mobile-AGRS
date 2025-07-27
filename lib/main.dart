import 'package:flutter/material.dart';
import 'pages/landing_page.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

Future<void> deleteLocalDatabase() async {
  final dbPath = join((await getApplicationDocumentsDirectory()).path, 'qa_pemupukan.db');
  await deleteDatabase(dbPath);
  print("✅ Local DB deleted.");
}
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await deleteLocalDatabase(); // ⬅ Tambahin ini
  runApp(const MaterialApp(home: LandingPage()));
}