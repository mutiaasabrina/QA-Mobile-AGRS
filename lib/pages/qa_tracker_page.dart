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
            children: [
              Text("Tanggal: ${qa['tanggal']}"),
              Text("Petugas: ${qa['nama_petugas']}"),
              Text("Kebun: ${qa['kebun']}"),
              Text("Divisi: ${qa['divisi']}"),
              Text("Blok: ${qa['blok']}"),
              Text("Rotasi: ${qa['rotasi']} hari"),
              const SizedBox(height: 10),
              const Text("Produksi", style: TextStyle(fontWeight: FontWeight.bold)),
              Text("Jumlah Pokok: ${qa['jumlah_pokok']}"),
              Text("Pkk Dipanen: ${qa['pkk_dipanen']}"),
              Text("Buah Dipanen: ${qa['buah_dipanen']}"),
              Text("Buah Matang Tidak Dipanen: ${qa['buah_matang_tidak_dipanen']}"),
              Text("Buah Busuk Tidak Dipanen: ${qa['buah_busuk_tidak_dipanen']}"),
              Text("LF Tinggal: ${qa['lf_tinggal']}"),
              Text("LF TPH Tinggal: ${qa['lf_tinggal_tph']}"),
              Text("Buah Tinggal: ${qa['buah_tinggal']}"),
              const SizedBox(height: 10),
              const Text("Perawatan", style: TextStyle(fontWeight: FontWeight.bold)),
              Text("Circle Baik: ${qa['kondisi_circle_baik']}"),
              Text("Circle Semak: ${qa['kondisi_circle_semak']}"),
              Text("Circle Dominan Anak Sawit: ${qa['kondisi_circle_dominan_anak_sawit']}"),
              Text("Circle Dominan Sampah: ${qa['kondisi_circle_dominan_sampah']}"),
              Text("Path Baik: ${qa['kondisi_path_baik']}"),
              Text("Path Tidak Baik: ${qa['kondisi_path_tidak_baik']}"),
              Text("TPH Baik: ${qa['kondisi_tph_baik']}"),
              Text("TPH Tidak Baik: ${qa['kondisi_tph_tidak_baik']}"),
              Text("Lalang Ada: ${qa['lalang_ada']}"),
              Text("Lalang Tidak Ada: ${qa['lalang_tidak_ada']}"),
              Text("Anak Kayu Ada: ${qa['anak_kayu_ada']}"),
              Text("Anak Kayu Tidak Ada: ${qa['anak_kayu_tidak_ada']}"),
              Text("Perumpung Ada: ${qa['perumpung_ada']}"),
              Text("Perumpung Tidak Ada: ${qa['perumpung_tidak_ada']}"),
              Text("Purun Tikus Ada: ${qa['purun_tikus_ada']}"),
              Text("Purun Tikus Tidak Ada: ${qa['purun_tikus_tidak_ada']}"),
              Text("Pakis Udang Ada: ${qa['pakis_udang_ada']}"),
              Text("Pakis Udang Tidak Ada: ${qa['pakis_udang_tidak_ada']}"),
              Text("Titi Panen Ada: ${qa['titi_panen_ada']}"),
              Text("Titi Panen Tidak Ada: ${qa['titi_panen_tidak_ada']}"),
              Text("Jalan dan Jembatan Baik: ${qa['jalan_dan_jembatan_baik']}"),
              Text("Jalan dan Jembatan Sedang: ${qa['jalan_dan_jembatan_sedang']}"),
              Text("Jalan dan Jembatan Jelek: ${qa['jalan_dan_jembatan_jelek']}"),
              Text("Pruning Baik: ${qa['pruning_baik']}"),
              Text("Pruning Over: ${qa['pruning_over']}"),
              Text("Pruning Sengkleh: ${qa['pruning_sengkleh']}"),
              Text("Pruning Under: ${qa['pruning_under']}"),
              Text("Susunah Pelepah Rapi: ${qa['susunan_pelepah_rapi']}"),
              Text("Susunan Pelepah Tidak Rapi: ${qa['susunan_pelepah_tidak_rapi']}"),
              Text("Serangan Tikus Ada: ${qa['serangan_tikus_ada']}"),
              Text("Serangan Tikus Tidak Ada: ${qa['serangan_tikus_tidak_ada']}"),
              Text("Rayap Ada: ${qa['serangan_rayap_ada']}"),
              Text("Rayap Tidak Ada: ${qa['serangan_rayap_tidak_ada']}"),
              Text("Thirathaba Ada: ${qa['thirathaba_ada']}"),
              Text("Thirathaba Tidak Ada: ${qa['thirathaba_tidak_ada']}"),
              Text("UPDPKS Ada: ${qa['updpks_ada']}"),
              Text("UPDPKS Tidak Ada: ${qa['updpks_tidak_ada']}"),
            
            ],
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
                                onPressed: () async {
                                  final gsheet = await GSheetService.init();
                                  await gsheet.insertQA(qa);
                                  await QADatabase.instance.updateSyncStatus(qa['id'], true);

                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text("Berhasil Sinkronisasi Data ke Spreadsheet!")),
                                  );
                                  _loadQAData(); // Refresh
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
                    onTap: () => _showDetailDialog(qa), // Ringkasan detail
                  ),
                );
              },
            ),
    );
  }
}
