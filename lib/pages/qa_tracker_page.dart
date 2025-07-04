import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:qa_agronomy/database/qa_database.dart';
import 'package:qa_agronomy/gsheet_service.dart';

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

  void _showDetailDialog(Map<String, dynamic> qa) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Detail QA"),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: qa.entries.map((e) => Text("${e.key}: ${e.value}"))
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

  Future<void> _syncToGSheet(Map<String, dynamic> qa) async {
    try {
      final gsheet = await GSheetService.init();

      // Format timestamp
      final nowFormatted = DateFormat('dd MMM yyyy HH:mm').format(DateTime.now());

      // Update status ke database
      await QADatabase.instance.updateSyncStatusWithTimestamp(
        qa['id'], true, nowFormatted,
      );

      // Ambil ulang data QA yg baru diupdate
      final db = await QADatabase.instance.database;
      final updatedQA = (await db.query(
        'qa_samples',
        where: 'id = ?',
        whereArgs: [qa['id']],
      )).first;

      // Kirim ke Google Spreadsheet
      await gsheet.insertQA(updatedQA);

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
                final timestamp = qa['timestamp_sync'] ?? '-';

                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  child: ListTile(
                    title: Text("${qa['kebun']} - ${qa['divisi']} - ${qa['blok']}"),
                    subtitle: Text("Rotasi: ${qa['rotasi']} hari\nPokok: ${qa['jumlah_pokok']}\nSync: $timestamp"),
                    trailing: isSynced
                        ? const Icon(Icons.check_circle, color: Colors.green)
                        : Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              ElevatedButton(
                                child: const Text("Sync"),
                                onPressed: () => _syncToGSheet(qa),
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
                                    _loadQAData();
                                  }
                                },
                              ),
                            ],
                          ),
                    onTap: () => _showDetailDialog(qa),
                  ),
                );
              },
            ),
    );
  }
}
