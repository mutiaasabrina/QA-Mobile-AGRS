import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:qa_agronomy/database/qa_database_produksi_perawatan.dart';
import 'package:qa_agronomy/database/qa_database_pemupukan.dart';
import 'package:qa_agronomy/gsheet_service.dart';

class QATrackerPage extends StatefulWidget {
  const QATrackerPage({super.key});

  @override
  State<QATrackerPage> createState() => _QATrackerPageState();
}

class _QATrackerPageState extends State<QATrackerPage> {
  final String _today = DateFormat('yyyy-MM-dd').format(DateTime.now());
  List<Map<String, dynamic>> _qaListProduksiPerawatan = [];
  List<Map<String, dynamic>> _qaListPemupukan = [];

  @override
  void initState() {
    super.initState();
    _loadQAData();
  }

  Future<void> _loadQAData() async {
    final tanggal = DateFormat('yyyy-MM-dd').format(DateTime.now());
    final produksi = await QADatabase.instance.getAllQAHariIni(tanggal);
    final pupuk = await QADatabasePemupukan.instance.getAllQAHariIni(tanggal);

    setState(() {
      _qaListProduksiPerawatan = produksi;
      _qaListPemupukan = pupuk;
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

  Future<void> _syncToGSheet(Map<String, dynamic> qa, {required bool isProduksi}) async {
    try {
      final gsheet = await GSheetService.init();
      final nowFormatted = DateFormat('dd MMM yyyy HH:mm').format(DateTime.now());

      if (isProduksi) {
        await QADatabase.instance.updateSyncStatusWithTimestamp(qa['id'], true, nowFormatted);
      } else {
        await QADatabasePemupukan.instance.updateSyncStatusWithTimestamp(qa['id'], true, nowFormatted);
      }

      final db = isProduksi
          ? await QADatabase.instance.database
          : await QADatabasePemupukan.instance.database;

      final updatedQA = (await db.query(
        'qa_samples',
        where: 'id = ?',
        whereArgs: [qa['id']],
      )).first;

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

  Future<void> _deleteQA(Map<String, dynamic> qa, {required bool isProduksi}) async {
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
      final db = isProduksi
          ? await QADatabase.instance.database
          : await QADatabasePemupukan.instance.database;

      await db.delete('qa_samples', where: 'id = ?', whereArgs: [qa['id']]);
      _loadQAData();
    }
  }

  Widget _buildListSection(String title, List<Map<String, dynamic>> list, {required bool isProduksi}) {
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
                isProduksi
                    ? "Rotasi: ${qa['rotasi']} hari\nPokok: ${qa['jumlah_pokok']}\nSync: $timestamp"
                    : "Jenis Pupuk: ${qa['jenis_pupuk']}\nPokok: ${qa['jumlah_pokok']}\nSync: $timestamp",
              ),
              trailing: isSynced
                  ? const Icon(Icons.check_circle, color: Colors.green)
                  : Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ElevatedButton(
                          child: const Text("Sync"),
                          onPressed: () => _syncToGSheet(qa, isProduksi: isProduksi),
                        ),
                        const SizedBox(width: 8),
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () => _deleteQA(qa, isProduksi: isProduksi),
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
    final isAllEmpty = _qaListProduksiPerawatan.isEmpty && _qaListPemupukan.isEmpty;

    return Scaffold(
      appBar: AppBar(title: const Text("Tracking QA Hari Ini")),
      body: isAllEmpty
          ? const Center(child: Text("Belum ada data QA hari ini."))
          : SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildListSection("Produksi & Perawatan", _qaListProduksiPerawatan, isProduksi: true),
                  _buildListSection("Pemupukan", _qaListPemupukan, isProduksi: false),
                  const SizedBox(height: 24),
                ],
              ),
           ),
);
}
}