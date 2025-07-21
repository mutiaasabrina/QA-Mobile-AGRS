import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:qa_agronomy/database/qa_database_chemist.dart';
import 'package:sqflite/sqflite.dart';

class MutuAncakChemistPage extends StatefulWidget {
  const MutuAncakChemistPage({super.key});

  @override
  State<MutuAncakChemistPage> createState() => _MutuAncakChemistPageState();
}

class _MutuAncakChemistPageState extends State<MutuAncakChemistPage> {
  final String _today = DateFormat('yyyy-MM-dd').format(DateTime.now());
  List<Map<String, dynamic>> _qaListChemist = [];

  @override
  void initState() {
    super.initState();
    _loadQAData();
  }

  Future<void> _loadQAData() async {
    final waktuSekarang = DateTime.now();
    final tambah10Menit = waktuSekarang.add(Duration(minutes: 10));
    final tambah14Hari = waktuSekarang.add(Duration(days: 14));

    final tanggalSekarang = DateFormat('yyyy-MM-dd').format(waktuSekarang);
    final tanggalTambah10Menit = DateFormat('yyyy-MM-dd').format(tambah10Menit);
    final tanggalTambah14Hari = DateFormat('yyyy-MM-dd').format(tambah14Hari);

    final chemist = await QADatabaseChemist.instance.getAllQAHariIni(tanggalTambah10Menit);

    setState(() {
      _qaListChemist = chemist;
    });
  }

  void _showDetailDialog(Map<String, dynamic> qa) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Detail QA"),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: qa.entries.map((e) => Text("${e.key}: ${e.value}")).toList(),
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
            subtitle: Text(
              "Chemist: ${qa['chemist']}\nJenis Chemist: ${qa['jenis_chemist']}\nSync to tracker: $timestamp"
            ),
            trailing: isSynced
                ? const Icon(Icons.check_circle, color: Colors.green)
                : Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // TODO: Implement sync button to tracker if needed
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
    final isAllEmpty = _qaListChemist.isEmpty;

    return Scaffold(
      appBar: AppBar(title: const Text("Mutu Ancak Chemist")),
      body: isAllEmpty
          ? const Center(child: Text("Belum ada data QA hari ini."))
          : SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildListSection(
                    "Chemist",
                    _qaListChemist,
                    tableName: 'qa_samples',
                    getDb: () => QADatabaseChemist.instance.database,
                  ),
                  const SizedBox(height: 24),
                ],
              ),
           ),
);
}
}