import 'package:flutter/material.dart';
import 'package:qa_agronomy/database/qa_database_pemupukan.dart';
import 'input_mutu_ancak_pemupukan_page.dart';
import 'package:sqflite/sqflite.dart';

class MutuAncakPemupukanPage extends StatefulWidget {
  const MutuAncakPemupukanPage({super.key});

  @override
  State<MutuAncakPemupukanPage> createState() => _MutuAncakPemupukanPageState();
}

class _MutuAncakPemupukanPageState extends State<MutuAncakPemupukanPage> {
  List<Map<String, dynamic>> _qaListPemupukan = [];

  @override
  void initState() {
    super.initState();
    _loadQAData();
  }

  Future<void> _loadQAData() async {
    final pemupukan = await QADatabasePemupukan.instance.getUnsyncedQAOrderedByDate();

    setState(() { 
      _qaListPemupukan = pemupukan;
    });
  }

  void _showDetailDialog(Map<String, dynamic> qa) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => InputMutuAncakPemupukanPage(qa: qa),
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
              "Jenis Pupuk: ${qa['jenis_pupuk']}\nDosis/Pokok: ${qa['dosis']}\nTanggal Periksa: ${qa['tanggal']}"
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
    final isAllEmpty = _qaListPemupukan.isEmpty;

    return Scaffold(
      appBar: AppBar(title: const Text("Mutu Ancak Pemupukan")),
      body: isAllEmpty
          ? const Center(child: Text("Belum ada data QA Pemupukan hari ini."))
          : SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildListSection(
                    "Pemupukan",
                    _qaListPemupukan,
                    tableName: 'qa_pemupukan_samples',
                    getDb: () => QADatabasePemupukan.instance.database,
                  ),
                  const SizedBox(height: 24),
                ],
              ),
           ),
);
}
}