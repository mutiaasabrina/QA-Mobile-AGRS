import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:qa_agronomy/database/qa_database.dart';


class QATrackerPage extends StatefulWidget {
  const QATrackerPage({super.key});

  @override
  State<QATrackerPage> createState() => _QATrackerPageState();
}

class _QATrackerPageState extends State<QATrackerPage> {
  List<Map<String, dynamic>> _qaList = [];
  final String _today = DateFormat('yyyy-MM-dd').format(DateTime.now());

  @override
  void initState() {
    super.initState();
    _loadQAData();
  }

  Future<void> _loadQAData() async {
    final data = await QADatabase.instance.getAllQAHariIni(_today);
    setState(() {
      _qaList = data;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Tracking QA Hari Ini")),
      body: _qaList.isEmpty
          ? const Center(child: Text("Belum ada data QA hari ini."))
          : ListView.builder(
              itemCount: _qaList.length,
              itemBuilder: (context, index) {
                final qa = _qaList[index];
                final isSynced = qa['is_synced'] == 1;

                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  child: ListTile(
                    title: Text("${qa['kebun']} - ${qa['divisi']} - ${qa['blok']}"),
                    subtitle: Text("Rotasi: ${qa['rotasi']} hari\nPokok: ${qa['jumlah_pokok']}"),
                    trailing: isSynced
    ? const Icon(Icons.check_circle, color: Colors.green)
    : Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          ElevatedButton(
            child: const Text("Sync"),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Fitur sync coming soon!"))
              );
            },
          ),
          const SizedBox(width: 8),
          IconButton(
            icon: const Icon(Icons.delete, color: Colors.red),
            onPressed: () async {
              final confirm = await showDialog<bool>(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text("Hapus Data"),
                  content: const Text("Yakin ingin menghapus data ini?"),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context, false),
                      child: const Text("Batal"),
                    ),
                    TextButton(
                      onPressed: () => Navigator.pop(context, true),
                      child: const Text("Hapus"),
                    ),
                  ],
                ),
              );

              if (confirm == true) {
                final db = await QADatabase.instance.database;
                await db.delete('qa_samples', where: 'id = ?', whereArgs: [qa['id']]);
                _loadQAData(); // Refresh list setelah hapus
              }
            },
          ),
        ],
      ),

                ),
                );
              },
            ),
    );
  }
}
