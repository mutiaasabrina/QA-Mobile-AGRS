import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../utils/constants.dart';
import 'menu_page.dart';
import 'input_mutu_ancak_chemist_summary.dart';
import 'package:qa_agronomy/database/qa_database_chemist.dart';
import 'package:qa_agronomy/database/input_mutu_ancak_database_chemist.dart';

class InputMutuAncakChemistPage extends StatefulWidget {
  final Map<String, dynamic> qa;

  const InputMutuAncakChemistPage({super.key, required this.qa});

  @override
  State<InputMutuAncakChemistPage> createState() => _InputMutuAncakChemistPageState();
}

class _InputMutuAncakChemistPageState extends State<InputMutuAncakChemistPage> {
  late Map<String, dynamic> qaData;
  final barisController = TextEditingController();
  final String tanggalPemeriksaanMutuAncak = DateFormat('yyyy-MM-dd').format(DateTime.now());

  String? selectedCircle;
  String? selectedPath;
  String? selectedTPH;
  String? selectedGawangan;

  final List<Map<String, dynamic>> pokokSamples = [];

  final List<String> mutuAncakOptions = ['Mati', 'Tidak Mati'];

  int pokokCounter = 1;

  @override
  void initState() {
    super.initState();
    qaData = widget.qa;
  }
  
  @override
  void dispose() {
    super.dispose();
  }

  void _saveSample() {
    setState(() {
      pokokSamples.add({
        'baris': barisController.text,
        'pokok': pokokCounter.toString(),
        'gulmaCircle': selectedCircle ?? "",
        'gulmaPath': selectedPath ?? "",
        'gulmaTPH': selectedTPH ?? "",
        'gulmaGawangan': selectedGawangan ?? "",
      });

      pokokCounter++;
      barisController.clear();
      selectedCircle = null;
      selectedPath = null;
      selectedTPH = null;
      selectedGawangan = null;
    });
  }
  
  void _saveAll() {
    // Kelompokkan per sample 
    final Map<String, List<Map<String, dynamic>>> perSample = {};
    for (final sample in pokokSamples) {
      final key = sample['baris'];
      perSample.putIfAbsent(key, () => []).add(sample);
    }

    final List<SampleAncakSummary> sampleAncakList = perSample.entries.map((entry) {
      final baris = entry.key;
      final list = entry.value;
      int countSample = list.length;
      
      Map<String, int> countBy(String field) {
        final Map<String, int> count = {};
        for (final s in list) {
          final val = s[field] ?? '-';
          count[val] = (count[val] ?? 0) + 1;
        }
        return count;
      }
      
      return SampleAncakSummary(
        baris: baris,
        jumlahSample: countSample,
        gulmaCircle: countBy('gulmaCircle'),
        gulmaPath: countBy('gulmaPath'),
        gulmaTPH: countBy('gulmaTPH'),
        gulmaGawangan: countBy('gulmaGawangan'),
      );
    }).toList();
    
    final summary = AncakSummary(
      tanggalPeriksa: qaData['tanggal'],
      namaPetugas: qaData['nama_petugas'],
      kebun: qaData['kebun'],
      divisi: qaData['divisi'],
      blok: qaData['blok'],
      tanggalPenyemprotan: qaData['tanggal_semprot'],
      luasan: qaData['luas'],
      chemist: qaData['chemist'],
      jenisChemist: qaData['jenis_chemist'],
      dosis: qaData['dosis_knapsack'],
      tanggalPeriksaMutuAncak : tanggalPemeriksaanMutuAncak,
      sampleAncakList: sampleAncakList,
    );

    final ringkasan = generateRingkasanText(summary);

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Ringkasan Mutu Ancak"),
        content: SingleChildScrollView(child: Text(ringkasan)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Batal"),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(context);

              final totalSampleGulma = sampleAncakList.fold<int>(0, (sum, t) => sum + t.jumlahSample,);
              int totalGulmaCircleMati = pokokSamples.where((s) => s['gulmaCircle'] == 'Mati').length;
              int totalGulmaCircleTidakMati = pokokSamples.where((s) => s['gulmaCircle'] == 'Tidak Mati').length;
              int totalGulmaPathMati = pokokSamples.where((s) => s['gulmaPath'] == 'Mati').length;
              int totalGulmaPathTidakMati = pokokSamples.where((s) => s['gulmaPath'] == 'Tidak Mati').length;
              int totalGulmaTPHMati = pokokSamples.where((s) => s['gulmaTPH'] == 'Mati').length;
              int totalGulmaTPHTidakMati = pokokSamples.where((s) => s['gulmaTPH'] == 'Tidak Mati').length;
              int totalGulmaGawanganMati = pokokSamples.where((s) => s['gulmaGawangan'] == 'Mati').length;
              int totalGulmaGawanganTidakMati = pokokSamples.where((s) => s['gulmaGawangan'] == 'Tidak Mati').length;

              await QADatabaseChemistGulmaAncak.instance.insertQA({
                'tanggal': qaData['tanggal'],
                'nama_petugas': qaData['nama_petugas'],
                'kebun': qaData['kebun'],
                'divisi': qaData['divisi'],
                'blok': qaData['blok'],
                'tanggal_semprot': qaData['tanggal_semprot'],
                'luas': qaData['luas'],
                'chemist': qaData['chemist'],
                'jenis_chemist': qaData['jenis_chemist'],
                'dosis_knapsack': qaData['dosis_knapsack'],
                'bahan_herbisida': qaData['bahan_herbisida'],
                'program_pengendalian_gulma': qaData['program_pengendalian_gulma'],
                'kartu_pengambilan_pencampuran': qaData['kartu_pengambilan_pencampuran'],
                'kalibrasi_alat_nozel': qaData['kalibrasi_alat_nozel'],
                'gelas_ukur_perkakas': qaData['gelas_ukur_perkakas'],
                'peletakan_alat_semprot': qaData['peletakan_alat_semprot'],
                'jumlah_pokok': qaData['jumlah_pokok'],
                'total_tenaga_kerja': qaData['total_tenaga_kerja'],
                'total_uji_petik_aktif': qaData['total_uji_petik_aktif'],
                'total_uji_petik_nonaktif': qaData['total_uji_petik_nonaktif'],
                'total_uji_petik_sesuai': qaData['total_uji_petik_sesuai'],
                'total_uji_petik__tidak_sesuai': qaData['total_uji_petik__tidak_sesuai'],
                'total_pokok_tersemprot': qaData['total_pokok_tersemprot'],
                'total_pokok__tidak_tersemprot': qaData['total_pokok__tidak_tersemprot'],
                'total_alat_semprot_baik': qaData['total_alat_semprot_baik'],
                'total_alat_semprot__tidak_layak': qaData['total_alat_semprot__tidak_layak'],
                'total_nozel_seragam': qaData['total_nozel_seragam'],
                'total_nozel_tidak_seragam': qaData['total_nozel_tidak_seragam'],
                'apd_pekerja': qaData['apd_pekerja'],
                'tanggal_mutu_ancak': tanggalPemeriksaanMutuAncak,
                'jumlah_pokok_gulma': totalSampleGulma,
                'total_gulma_circle_mati': totalGulmaCircleMati,
                'total_gulma_path_mati': totalGulmaPathMati,
                'total_gulma_tph_mati': totalGulmaTPHMati,
                'total_gulma_gawangan_mati': totalGulmaGawanganMati,
                'ringkasan': ringkasan,
                'is_synced': 0,
                'timestamp_sync': null,
              });

              QADatabaseChemist.instance.updateSyncStatusQAData(qaData['tanggal'], qaData['kebun'], qaData['divisi'], qaData['blok'], 1);

              Navigator.of(context).popUntil((route) => route.isFirst);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const MenuPage()),
              );
            },
            child: const Text("Ok"),
          ),
        ],
      ),
    );
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Mutu Ancak - ${qaData['tanggal']} - ${qaData['kebun']} - ${qaData['divisi']} - ${qaData['blok']}")),
      body: ListView(
        padding: const EdgeInsets.all(10),
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ExpansionTile(
                title: Text("QA Details"),
                children: [
                  Text("Tanggal Pemeriksaan Terakhir: ${qaData['tanggal']}"),
                  Text("Nama Petugas: ${qaData['nama_petugas']}"),
                  Text("Kebun: ${qaData['kebun']}"),
                  Text("Divisi: ${qaData['divisi']}"),
                  Text("Blok: ${qaData['blok']}"),
                  Text("Tanggal Semprot: ${qaData['tanggal_semprot']}"),
                  Text("Luas: ${qaData['luas']}"),
                  Text("Chemist: ${qaData['chemist']}"),
                  Text("Jenis Chemist: ${qaData['jenis_chemist']}"),
                  Text("Dosis / Knapsack (liter/ha):: ${qaData['dosis_knapsack']}",),
                ],
              ),
              if (qaData['chemist'] == 'Chemist CPT') ...[
                TextField(
                  controller: barisController,
                  decoration: const InputDecoration(labelText: "Baris ke-"),
                  keyboardType: TextInputType.number,
                ),
                DropdownButtonFormField<String>(
                  decoration: const InputDecoration(labelText: "Kematian Gulma Circle",),
                  value: selectedCircle,
                  onChanged: (val) => setState(() => selectedCircle = val),
                  items: mutuAncakOptions.map((e) => DropdownMenuItem(value: e, child: Text(e)),).toList(),
                ),
                DropdownButtonFormField<String>(
                  decoration: const InputDecoration(labelText: "Kematian Gulma Path",),
                  value: selectedPath,
                  onChanged: (val) => setState(() => selectedPath = val),
                  items: mutuAncakOptions.map((e) => DropdownMenuItem(value: e, child: Text(e)),).toList(),
                ),
                DropdownButtonFormField<String>(
                  decoration: const InputDecoration(labelText: "Kematian Gulma TPH",),
                  value: selectedTPH,
                  onChanged: (val) => setState(() => selectedTPH = val),
                  items: mutuAncakOptions.map((e) => DropdownMenuItem(value: e, child: Text(e)),).toList(),
                ),
              ]
              else if (qaData['chemist'] == 'Chemist Gawangan') ...[
                TextField(
                  controller: barisController,
                  decoration: const InputDecoration(labelText: "Baris ke-"),
                  keyboardType: TextInputType.number,
                ),
                DropdownButtonFormField<String>(
                  decoration: const InputDecoration(labelText: "Kematian Gulma Gawangan",),
                  value: selectedGawangan,
                  onChanged: (val) => setState(() => selectedGawangan = val),
                  items: mutuAncakOptions.map((e) => DropdownMenuItem(value: e, child: Text(e)),).toList(),
                ),
              ]
              else if (qaData['chemist'] == 'Chemist CPT + Gawangan') ...[
                TextField(
                  controller: barisController,
                  decoration: const InputDecoration(labelText: "Baris ke-"),
                  keyboardType: TextInputType.number,
                ),
                DropdownButtonFormField<String>(
                  decoration: const InputDecoration(labelText: "Kematian Gulma Circle",),
                  value: selectedCircle,
                  onChanged: (val) => setState(() => selectedCircle = val),
                  items: mutuAncakOptions.map((e) => DropdownMenuItem(value: e, child: Text(e)),).toList(),
                ),
                DropdownButtonFormField<String>(
                  decoration: const InputDecoration(labelText: "Kematian Gulma Path",),
                  value: selectedPath,
                  onChanged: (val) => setState(() => selectedPath = val),
                  items: mutuAncakOptions.map((e) => DropdownMenuItem(value: e, child: Text(e)),).toList(),
                ),
                DropdownButtonFormField<String>(
                  decoration: const InputDecoration(labelText: "Kematian Gulma TPH",),
                  value: selectedTPH,
                  onChanged: (val) => setState(() => selectedTPH = val),
                  items: mutuAncakOptions.map((e) => DropdownMenuItem(value: e, child: Text(e)),).toList(),
                ),
                DropdownButtonFormField<String>(
                  decoration: const InputDecoration(labelText: "Kematian Gulma Gawangan",),
                  value: selectedGawangan,
                  onChanged: (val) => setState(() => selectedGawangan = val),
                  items: mutuAncakOptions.map((e) => DropdownMenuItem(value: e, child: Text(e)),).toList(),
                ),              ],
              const SizedBox(height: 8),
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: primaryColor, foregroundColor: Colors.white,),
                onPressed: _saveSample,
                child: const Text("Save & Tambah Pokok Sample"),
              ),
              if (pokokSamples.isNotEmpty) ...[
                const Divider(),
                const Text("Daftar Sample:",style: TextStyle(fontWeight: FontWeight.bold),),

                if(qaData['chemist'] == 'Chemist CPT') ...[
                  ...pokokSamples.map(
                    (s) => ListTile(
                      title: Text("Baris ke ${s['baris']} - Pokok ke ${s['pokok']}"),
                      subtitle: Text(
                        "Circle: ${s['gulmaCircle']}, Path: ${s['gulmaPath']}, TPH: ${s['gulmaTPH']}",
                      ),
                    ),
                  ),
                ]
                else if(qaData['chemist'] == 'Chemist Gawangan') ...[
                  ...pokokSamples.map(
                    (s) => ListTile(
                      title: Text("Baris ke ${s['baris']} - Pokok ke ${s['pokok']}"),
                      subtitle: Text(
                        "Gawangan: ${s['gulmaGawangan']}",
                      ),
                    ),
                  ),
                ]
                else if(qaData['chemist'] == 'Chemist CPT + Gawangan') ...[
                  ...pokokSamples.map(
                    (s) => ListTile(
                      title: Text("Baris ke ${s['baris']} - Pokok ke ${s['pokok']}"),
                      subtitle: Text(
                        "Circle: ${s['gulmaCircle']}, Path: ${s['gulmaPath']}, TPH: ${s['gulmaTPH']}, Gawangan: ${s['gulmaGawangan']}",
                      ),
                    ),
                  ),
                ]
              ],
              const SizedBox(height: 8),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor,
                  foregroundColor: Colors.white,
                ),
                onPressed: _saveAll,
                child: const Text("Save All"),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
