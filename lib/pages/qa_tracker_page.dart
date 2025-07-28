import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:qa_agronomy/database/qa_database_produksi.dart';
import 'package:qa_agronomy/database/qa_database_perawatan.dart';
import 'package:qa_agronomy/database/input_mutu_ancak_database_pemupukan.dart';
import 'package:qa_agronomy/database/input_mutu_ancak_database_chemist.dart';
import 'package:qa_agronomy/gsheet_service.dart';
import 'package:sqflite/sqflite.dart';

class QATrackerPage extends StatefulWidget {
  const QATrackerPage({super.key});

  @override
  State<QATrackerPage> createState() => _QATrackerPageState();
}

class _QATrackerPageState extends State<QATrackerPage> {
  final String _today = DateFormat('yyyy-MM-dd').format(DateTime.now());
  List<Map<String, dynamic>> _qaListProduksi = [];
  List<Map<String, dynamic>> _qaListPerawatan = [];
  List<Map<String, dynamic>> _qaListPemupukan = [];
  List<Map<String, dynamic>> _qaListChemist = [];

  final List<String> SkippedDetails = [
    'Daftar Tenaga Tabur',
  ];

  @override
  void initState() {
    super.initState();
    _loadQAData();
  }

  Future<void> _loadQAData() async {
    final tanggal = DateFormat('yyyy-MM-dd').format(DateTime.now());
    final produksi = await QADatabase.instance.getAllQAHariIni(tanggal);
    final perawatan = await QADatabasePerawatan.instance.getAllQAHariIni(tanggal);
    final pupuk = await QADatabasePemupukanGulmaAncak.instance.getAllQABasedTanggalMutuAncak(tanggal);
    final chemist = await QADatabaseChemistGulmaAncak.instance.getAllQABasedTanggalMutuAncak(tanggal);

    setState(() {
      _qaListProduksi = produksi;
      _qaListPerawatan = perawatan;
      _qaListPemupukan = pupuk;
      _qaListChemist = chemist;
    });
  }

String _formatKey(String key) {
    List<String> parts = key.split('_');
    for (int i = 0; i < parts.length; i++) {
      parts[i] = parts[i].replaceRange(0, 1, parts[i][0].toUpperCase());
    }
    return parts.join(' ');
  }

  void _showDetailDialog(Map<String, dynamic> qa) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Detail QA"),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: qa.entries
            .where((e) => !SkippedDetails.contains(_formatKey(e.key)))
            .map((e) {
              String formattedKey = _formatKey(e.key);
              return Text("$formattedKey: ${e.value}");
            })
            .toList(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Tutup"),
          ),
        ],
      ),
    );
  }

  Future<void> _syncToGSheet(Map<String, dynamic> qa, {required String title}) async {
    try {
      final gsheet = await GSheetService.init();
      final nowFormatted = DateFormat('dd MMM yyyy HH:mm').format(DateTime.now());

      if (title == "Produksi") {
        await QADatabase.instance.updateSyncStatusWithTimestamp(qa['id'], true, nowFormatted);
        final db = await QADatabase.instance.database;

        final updatedQA = (await db.query(
          'qa_samples',
          where: 'id =?',
          whereArgs: [qa['id']],
        )).first;

        await gsheet.insertQAProduksi(updatedQA);

      } else if (title == "Perawatan") {
        await QADatabasePerawatan.instance.updateSyncStatusWithTimestamp(qa['id'], true, nowFormatted);
        final db = await QADatabasePerawatan.instance.database;

        final updatedQA = (await db.query(
          'qa_perawatan_samples',
          where: 'id =?',
          whereArgs: [qa['id']],
        )).first;

        await gsheet.insertQAPerawatan(updatedQA);

      } else if (title == "Pemupukan") {
        await QADatabasePemupukanGulmaAncak.instance.updateSyncStatusWithTimestamp(qa['id'], true, nowFormatted);
        final db = await QADatabasePemupukanGulmaAncak.instance.database;

        final updatedQA = (await db.query(
          'qa_pemupukan_mutu_ancak_samples',
          where: 'id =?',
          whereArgs: [qa['id']],
        )).first;

        await gsheet.insertQAPemupukan(updatedQA);

      } else if (title == "Chemist") {
        await QADatabaseChemistGulmaAncak.instance.updateSyncStatusWithTimestamp(qa['id'], true, nowFormatted);
        final db = await QADatabaseChemistGulmaAncak.instance.database;

        final updatedQA = (await db.query(
          'qa_chemist_mutu_ancak_samples',
          where: 'id =?',
          whereArgs: [qa['id']],
        )).first;

        await gsheet.insertQAChemist(updatedQA);

      }
      
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Berhasil Sinkronisasi Data ke Spreadsheet!")),
      );

      _loadQAData();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Gagal Sync: $e")),
      );
    }
  }

  Future<void> _deleteQA(Map<String, dynamic> qa, {required String tableName, required Database db}) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Hapus Data"),
        content: const Text("Yakin ingin menghapus data ini?"),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text("Batal")),
          TextButton(onPressed: () => Navigator.pop(context, true), child: const Text("Hapus")),
        ],
      ),
    );

    if (confirm == true) {
      await db.delete(tableName, where: 'id = ?', whereArgs: [qa['id']]);
      _loadQAData();
    }
  }

Widget _buildListSection(
  String title,
  List<Map<String, dynamic>> list, {
  required String tableName,
  required Future<Database> Function() getDb,
}) {
  if (list.isEmpty) return const SizedBox.shrink();

  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const SizedBox(height: 16),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
      ),
      const SizedBox(height: 8),
      ...list.map((qa) {
        final isSynced = qa['is_synced'] == 1;
        final timestamp = qa['timestamp_sync'] ?? '-';

        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          child: ListTile(
              title: Text("${qa['kebun']} - ${qa['divisi']} - ${qa['blok']}"),
              subtitle: Text(() {
                if (title == 'Produksi') {
                  return "Rotasi: ${qa['rotasi']} hari\nPokok: ${qa['jumlah_pokok']}\nSync: $timestamp";
                } else if (title == 'Perawatan') {
                  return "Tanggal QA: ${qa['tanggal']}\nPokok: ${qa['jumlah_pokok']}\nSync: $timestamp";
                } else if (title == 'Pemupukan') {
                  return "Jenis Pupuk: ${qa['jenis_pupuk']}\nPokok: ${qa['jumlah_pokok']}\nSync: $timestamp";
                } else if (title == 'Chemist') {
                  return "Jenis Chemist: ${qa['jenis_chemist']}\nPokok: ${qa['jumlah_pokok']}\nSync: $timestamp";;
                } else {
                  return "";
                }
              }()),
            trailing: isSynced
                ? const Icon(Icons.check_circle, color: Colors.green)
                : Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ElevatedButton(
                        child: const Text("Sync"),
                        onPressed: () => _syncToGSheet(qa, title: title),
                      ),
                      const SizedBox(width: 8),
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () async {
                          final db = await getDb();
                          _deleteQA(qa, tableName: tableName, db: db);
                        },
                      ),
                    ],
                  ),
            onTap: () => _showDetailDialog(qa),
          ),
        );
      }),
    ],
  );
}

  @override
  Widget build(BuildContext context) {
    final isAllEmpty = _qaListProduksi.isEmpty && _qaListPerawatan.isEmpty && _qaListPemupukan.isEmpty && _qaListChemist.isEmpty;

    return Scaffold(
      appBar: AppBar(title: const Text("Tracking QA Hari Ini")),
      body: isAllEmpty
          ? const Center(child: Text("Belum ada data QA hari ini."))
          : SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildListSection(
                    "Produksi",
                    _qaListProduksi,
                    tableName: 'qa_samples',
                    getDb: () => QADatabase.instance.database,
                  ),
                  _buildListSection(
                    "Perawatan",
                    _qaListPerawatan,
                    tableName: 'qa_perawatan_samples',
                    getDb: () => QADatabasePerawatan.instance.database,
                  ),
                  _buildListSection(
                    "Pemupukan",
                    _qaListPemupukan,
                    tableName: 'qa_pemupukan_mutu_ancak_samples',
                    getDb: () => QADatabasePemupukanGulmaAncak.instance.database,
                  ),
                  _buildListSection(
                    "Chemist",
                    _qaListChemist,
                    tableName: 'qa_chemist_mutu_ancak_samples',
                    getDb: () => QADatabaseChemistGulmaAncak.instance.database,
                  ),
                  const SizedBox(height: 24),
                ],
              ),
           ),
);
}
}