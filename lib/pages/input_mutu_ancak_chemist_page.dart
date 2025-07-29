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
  final kematianGulmaCircleController = TextEditingController();
  final kematianGulmaPathontroller = TextEditingController();
  final kematianGulmaTPHController = TextEditingController();
  final kematianGulmaGawanganController = TextEditingController();
  final String tanggalPemeriksaanMutuAncak = DateFormat('yyyy-MM-dd').format(DateTime.now());

  String? selectedPokokTersemprot;
  String? selectedCircle;
  String? selectedPath;
  String? selectedTPH;
  String? selectedGawangan;

  final List<Map<String, dynamic>> pokokSamples = [];

  int pokokCounter = 1;
  bool isGawanganUsed = false;

  final List<String> pokokOptions = ['Tersemprot', 'Tidak Tersemprot'];

  @override
  void initState() {
    super.initState();
    qaData = widget.qa;
    isGawanganUsed = qaData['chemist'] == 'Chemist CPT + Gawangan' || qaData['chemist'] == 'Chemist Gawangan';
  }
  
  @override
  void dispose() {
    super.dispose();
  }
  
  void _saveSample() {
    if (barisController.text.isEmpty ||
        kematianGulmaCircleController.text.isEmpty ||
        kematianGulmaPathontroller.text.isEmpty ||
        kematianGulmaTPHController.text.isEmpty ||
        (isGawanganUsed && kematianGulmaGawanganController.text.isEmpty)) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Lengkapi semua data pokok sample dengan benar.")));
          return;
    }

    setState(() {
      pokokSamples.add({
        'baris': barisController.text,
        'pokok': pokokCounter.toString(),
        'tersemprot': selectedPokokTersemprot,
        'gulmaCircle': kematianGulmaCircleController.text,
        'gulmaPath': kematianGulmaPathontroller.text,
        'gulmaTPH': kematianGulmaTPHController.text,
        'gulmaGawangan': kematianGulmaGawanganController.text,
      });

      barisController.clear();
      pokokCounter++;
      selectedPokokTersemprot = null;
      kematianGulmaCircleController.clear();
      kematianGulmaPathontroller.clear();
      kematianGulmaTPHController.clear();
      kematianGulmaGawanganController.clear();
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

    final List<SampleAncakChemistSummary> sampleAncakList = perSample.entries.map((entry) {
      final baris = entry.key;
      final list = entry.value;
      int countSample = list.length;
      
      int count(String field) {
        int count = 0;
        for (final s in list) {
          final val = int.tryParse(s[field]) ?? 0;
          count = count + val;
        }
        return count;
      }

      Map<String, int> countBy(String field) {
        final Map<String, int> count = {};
        for (final s in list) {
          final val = s[field] ?? '-';
          count[val] = (count[val] ?? 0) + 1;
        }
        return count;
      }
      
      return SampleAncakChemistSummary(
        baris: baris,
        jumlahSample: countSample,
        pokokTersemprot: countBy('tersemprot'),
        gulmaCircle: count('gulmaCircle'),
        gulmaPath: count('gulmaPath'),
        gulmaTPH: count('gulmaTPH'),
        gulmaGawangan: count('gulmaGawangan'),
      );
    }).toList();
    
    final summary = ChemistAncakSummary(
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
              int totalPokokTersemprot = sampleAncakList.map((s) => s.pokokTersemprot['Tersemprot'] ?? 0).reduce((a, b) => a + b);
              int totalPokokTidakTersemprot = sampleAncakList.map((s) => s.pokokTersemprot['Tidak Tersemprot'] ?? 0).reduce((a, b) => a + b);
              
              double averageGulmaCircleMati =
                  pokokSamples
                      .where(
                        (s) => double.tryParse(s['gulmaCircle'].toString()) != null,)
                      .map((s) => double.parse(s['gulmaCircle'].toString()),) 
                      .fold(0.0, (a, b) => a + b) /
                    pokokSamples
                        .where((s) => double.tryParse(s['gulmaCircle'].toString()) != null,)
                        .length;

              double averageGulmaPathMati =
                  pokokSamples
                      .where(
                        (s) => double.tryParse(s['gulmaPath'].toString()) != null,)
                      .map((s) => double.parse(s['gulmaPath'].toString()),) 
                      .fold(0.0, (a, b) => a + b) /
                    pokokSamples
                        .where((s) => double.tryParse(s['gulmaPath'].toString()) != null,)
                        .length;

              double averageGulmaTPHMati =
                  pokokSamples
                      .where(
                        (s) => double.tryParse(s['gulmaTPH'].toString()) != null,)
                      .map((s) => double.parse(s['gulmaTPH'].toString()),) 
                      .fold(0.0, (a, b) => a + b) /
                    pokokSamples
                        .where((s) => double.tryParse(s['gulmaTPH'].toString()) != null,)
                        .length;

              double averageGawanganTPHMati =
                  pokokSamples
                      .where(
                        (s) => double.tryParse(s['gulmaGawangan'].toString()) != null,)
                      .map((s) => double.parse(s['gulmaGawangan'].toString()),) 
                      .fold(0.0, (a, b) => a + b) /
                    pokokSamples
                        .where((s) => double.tryParse(s['gulmaGawangan'].toString()) != null,)
                        .length;

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
                'total_pokok_tersemprot': totalPokokTersemprot,
                'total_pokok__tidak_tersemprot': totalPokokTidakTersemprot,
                'total_alat_semprot_baik': qaData['total_alat_semprot_baik'],
                'total_alat_semprot__tidak_layak': qaData['total_alat_semprot__tidak_layak'],
                'total_nozel_seragam': qaData['total_nozel_seragam'],
                'total_nozel_tidak_seragam': qaData['total_nozel_tidak_seragam'],
                'apd_pekerja': qaData['apd_pekerja'],
                'daftar_tenaga_semprot': qaData['daftar_tenaga_semprot'],
                'tanggal_mutu_ancak': tanggalPemeriksaanMutuAncak,
                'jumlah_pokok_gulma': totalSampleGulma,
                'total_gulma_circle_mati': averageGulmaCircleMati,
                'total_gulma_path_mati': averageGulmaPathMati,
                'total_gulma_tph_mati': averageGulmaTPHMati,
                'total_gulma_gawangan_mati': averageGawanganTPHMati,
                'ringkasan_chemist': qaData['ringkasan_chemist'],
                'ringkasan_mutu_ancak': ringkasan,
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
      appBar: AppBar(title: Text("Mutu Ancak Chemist - ${qaData['tanggal']} - ${qaData['kebun']} - ${qaData['divisi']} - ${qaData['blok']}")),
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
                  const SizedBox(height: 12),
                ],
              ),
              const SizedBox(height: 12),
              TextField(
                controller: barisController,
                decoration: const InputDecoration(labelText: "Baris ke-"),
                keyboardType: TextInputType.number,
              ),
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(labelText: "Pokok Tersemprot"),
                value: selectedPokokTersemprot,
                onChanged: (val) => setState(() => selectedPokokTersemprot = val),
                items: pokokOptions.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
              ),
              if (qaData['chemist'] == 'Chemist CPT') ...[
                TextField(
                  controller: kematianGulmaCircleController,
                  decoration: const InputDecoration(labelText: "Kematian Gulma Circle"),
                  keyboardType: TextInputType.number,
                ),
                TextField(
                  controller: kematianGulmaPathontroller,
                  decoration: const InputDecoration(labelText: "Kematian Gulma Path"),
                  keyboardType: TextInputType.number,
                ),
                TextField(
                  controller: kematianGulmaTPHController,
                  decoration: const InputDecoration(labelText: "Kematian Gulma TPH"),
                  keyboardType: TextInputType.number,
                ),
              ]
              else if (qaData['chemist'] == 'Chemist Gawangan') ...[
                TextField(
                  controller: kematianGulmaGawanganController,
                  decoration: const InputDecoration(labelText: "Kematian Gulma Gawangan"),
                  keyboardType: TextInputType.number,
                ),
              ]
              else if (qaData['chemist'] == 'Chemist CPT + Gawangan') ...[
                TextField(
                  controller: kematianGulmaCircleController,
                  decoration: const InputDecoration(labelText: "Kematian Gulma Circle-"),
                  keyboardType: TextInputType.number,
                ),
                TextField(
                  controller: kematianGulmaPathontroller,
                  decoration: const InputDecoration(labelText: "Kematian Gulma Path"),
                  keyboardType: TextInputType.number,
                ),
                TextField(
                  controller: kematianGulmaTPHController,
                  decoration: const InputDecoration(labelText: "Kematian Gulma TPH"),
                  keyboardType: TextInputType.number,
                ),
                TextField(
                  controller: kematianGulmaGawanganController,
                  decoration: const InputDecoration(labelText: "Kematian Gulma Gawangan"),
                  keyboardType: TextInputType.number,
                ),
              ],
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
                        "Tersemprot: ${s['tersemprot']}, Circle: ${s['gulmaCircle']}, Path: ${s['gulmaPath']}, TPH: ${s['gulmaTPH']}",
                      ),
                    ),
                  ),
                ]
                else if(qaData['chemist'] == 'Chemist Gawangan') ...[
                  ...pokokSamples.map(
                    (s) => ListTile(
                      title: Text("Baris ke ${s['baris']} - Pokok ke ${s['pokok']}"),
                      subtitle: Text(
                        "Tersemprot: ${s['tersemprot']}, Gawangan: ${s['gulmaGawangan']}",
                      ),
                    ),
                  ),
                ]
                else if(qaData['chemist'] == 'Chemist CPT + Gawangan') ...[
                  ...pokokSamples.map(
                    (s) => ListTile(
                      title: Text("Baris ke ${s['baris']} - Pokok ke ${s['pokok']}"),
                      subtitle: Text(
                        "Tersemprot: ${s['tersemprot']}, Circle: ${s['gulmaCircle']}, Path: ${s['gulmaPath']}, TPH: ${s['gulmaTPH']}, Gawangan: ${s['gulmaGawangan']}",
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
