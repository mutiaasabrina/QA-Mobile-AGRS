import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:convert';
import '../utils/constants.dart';
import 'menu_page.dart';
import 'input_mutu_ancak_chemist_summary.dart';
import 'package:qa_agronomy/database/qa_database_chemist.dart';
import 'package:qa_agronomy/database/input_mutu_ancak_database_chemist.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image/image.dart' as img;
import 'package:permission_handler/permission_handler.dart';
import 'dart:io';

class InputMutuAncakChemistPage extends StatefulWidget {
  final Map<String, dynamic> qa;

  const InputMutuAncakChemistPage({super.key, required this.qa});

  @override
  State<InputMutuAncakChemistPage> createState() => _InputMutuAncakChemistPageState();
}

class _InputMutuAncakChemistPageState extends State<InputMutuAncakChemistPage> {
  late Map<String, dynamic> qaData;
  final _tenagaSemprotController = TextEditingController();
  final barisController = TextEditingController();
  final kematianGulmaCircleController = TextEditingController();
  final kematianGulmaPathontroller = TextEditingController();
  final kematianGulmaTPHController = TextEditingController();
  final kematianGulmaGawanganController = TextEditingController();
  final _komentarController = TextEditingController();
  final String tanggalPemeriksaanMutuAncak = DateFormat('yyyy-MM-dd').format(DateTime.now());

  String? selectedPokokTersemprot;

  String get _tenagaSemprotKey => "${_tenagaSemprotController.text.trim().toLowerCase()}|${qaData['blok'] ??''}|$tanggalPemeriksaanMutuAncak";

  final List<Map<String, dynamic>> _samples = [];
  final Map<String, Map<String, dynamic>> _tenagaSemprot = {};
  bool get isTenagaSemprotLocked => _tenagaSemprot.containsKey(_tenagaSemprotKey);
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

  Future<void> ambilFotoDenganWatermark({
    required String estate,
    required String divisi,
    required String blok,
    required String barisKe,
    required String petugas,
    required BuildContext context,
  }) async {
    if (_komentarController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Keterangan foto harus diisi")),
      );
      return;
    }

    final picker = ImagePicker();

    // Minta izin akses kamera dan storage
    await Permission.camera.request();
    await Permission.storage.request();

    final pickedFile = await picker.pickImage(source: ImageSource.camera);

    if (pickedFile != null) {
      final rawImage = File(pickedFile.path);
      final img.Image? original = img.decodeImage(await rawImage.readAsBytes());

      if (original == null) return;

      // Tanggal & waktu sekarang
      final String dateStr = DateFormat(
        'dd/MM/yyyy HH:mm:ss',
      ).format(DateTime.now());

      // Teks watermark
      final komentar = _komentarController.text;
      final watermarkText =
          "QA Chemist Mutu Ancak\nEstate: $estate\nDivisi: $divisi\nBlok: $blok\nBaris: $barisKe\nPetugas: $petugas\nWaktu: $dateStr\nKeterangan: $komentar";

      final font = img.arial48;
      final avgCharWidth = 30;
      final textWidth =
          watermarkText.length * avgCharWidth ~/ 4; // karena banyak baris
      final textHeight = font.lineHeight * 6;

      final margin = 30;
      final x = original.width - textWidth - margin;
      final y = original.height - textHeight - margin;

      img.fillRect(
        original,
        x1: x - 10,
        y1: y - 10,
        x2: x + textWidth + 10,
        y2: y + textHeight + 10,
        color: img.ColorRgba8(0, 0, 0, 150),
      );

      img.drawString(
        original,
        font: font,
        x: x,
        y: y,
        watermarkText,
        color: img.ColorRgb8(255, 255, 255),
      );
      // Simpan di local
      final path = '/storage/emulated/0/DCIM/QA_Agronomy';
      final directory = Directory(path);

      if (!await directory.exists()) {
        await directory.create(recursive: true);
      }

      final filename = 'foto_QA_Chemist_Mutu_Ancak_${DateTime.now().millisecondsSinceEpoch}.png';
      final imagePath = '$path/$filename';

      final file = File(imagePath);
      await file.writeAsBytes(img.encodePng(original));

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Foto disimpan di galeri: $imagePath")),
      );

      _komentarController.clear();
    }
  }
  
  void _saveSample() {
    if (_tenagaSemprotController.text.isEmpty ||
        barisController.text.isEmpty ||
        kematianGulmaCircleController.text.isEmpty ||
        kematianGulmaPathontroller.text.isEmpty ||
        kematianGulmaTPHController.text.isEmpty ||
        (isGawanganUsed && kematianGulmaGawanganController.text.isEmpty)) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Lengkapi semua data pokok sample dengan benar.")));
          return;
    }
    
  setState(() {
    _samples.add({
      'tenagaSemprot': _tenagaSemprotController.text.toLowerCase(),
      'baris': barisController.text,
      'pokok': pokokCounter++,
      'tersemprot': selectedPokokTersemprot,
      'gulmaCircle': kematianGulmaCircleController.text,
      'gulmaPath': kematianGulmaPathontroller.text,
      'gulmaTPH': kematianGulmaTPHController.text,
      'gulmaGawangan': kematianGulmaGawanganController.text,
    });

    if (!_tenagaSemprot.containsKey(_tenagaSemprotKey)) {
      _tenagaSemprot[_tenagaSemprotKey] = {
        'baris': barisController.text,
      };
    }

    selectedPokokTersemprot = null;
    kematianGulmaCircleController.clear();
    kematianGulmaPathontroller.clear();
    kematianGulmaTPHController.clear();
    kematianGulmaGawanganController.clear();
  });
}
  
  void _saveAll() {
    if (_samples.isEmpty || 
        _tenagaSemprot.isEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Lengkapi semua data.")));
          return;
    }

    // Kelompokkan sample per tenaga semprot
    final Map<String, List<Map<String, dynamic>>> perTenaga = {};
    for (final sample in _samples) {
      final key = sample['tenagaSemprot'].toLowerCase();
      perTenaga.putIfAbsent(key, () => []).add(sample);
    }

    final List<SampleAncakChemistSummary> tenagaList = perTenaga.entries.map((entry) {
      final nama = entry.key;
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
        nama: nama.toLowerCase(),
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
      kondisiAlatSemprot : qaData['kondisi_alat_semprot'],
      keseragamanNozel : qaData['keseragaman_nozel'],
      apdPekerja : qaData['apd_pekerja'],
      tanggalPeriksaMutuAncak : tanggalPemeriksaanMutuAncak,
      sampleAncakList: tenagaList,
    );

    final ringkasan = generateRingkasanText(summary);

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
      title: const Text("Ringkasan Mutu Ancak QA Chemist"),
        content: SingleChildScrollView(child: Text(ringkasan)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Batal"),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(context);

              final totalSample = tenagaList.fold<int>(0, (sum, t) => sum + t.jumlahSample,);
              int totalTenagaKerja = perTenaga.length;
              int totalPokokTersemprot = tenagaList.map((s) => s.pokokTersemprot['Tersemprot'] ?? 0).reduce((a, b) => a + b);
              int totalPokokTidakTersemprot = tenagaList.map((s) => s.pokokTersemprot['Tidak Tersemprot'] ?? 0).reduce((a, b) => a + b);
              double averageGulmaCircleMati =
                  _samples
                      .where(
                        (s) => double.tryParse(s['gulmaCircle'].toString()) != null,)
                      .map((s) => double.parse(s['gulmaCircle'].toString()),) 
                      .fold(0.0, (a, b) => a + b) /
                    _samples
                        .where((s) => double.tryParse(s['gulmaCircle'].toString()) != null,)
                        .length;

              double averageGulmaPathMati =
                  _samples
                      .where(
                        (s) => double.tryParse(s['gulmaPath'].toString()) != null,)
                      .map((s) => double.parse(s['gulmaPath'].toString()),) 
                      .fold(0.0, (a, b) => a + b) /
                    _samples
                        .where((s) => double.tryParse(s['gulmaPath'].toString()) != null,)
                        .length;

              double averageGulmaTPHMati =
                  _samples
                      .where(
                        (s) => double.tryParse(s['gulmaTPH'].toString()) != null,)
                      .map((s) => double.parse(s['gulmaTPH'].toString()),) 
                      .fold(0.0, (a, b) => a + b) /
                    _samples
                        .where((s) => double.tryParse(s['gulmaTPH'].toString()) != null,)
                        .length;

              double averageGawanganTPHMati =
                  _samples
                      .where(
                        (s) => double.tryParse(s['gulmaGawangan'].toString()) != null,)
                      .map((s) => double.parse(s['gulmaGawangan'].toString()),) 
                      .fold(0.0, (a, b) => a + b) /
                    _samples
                        .where((s) => double.tryParse(s['gulmaGawangan'].toString()) != null,)
                        .length;

              String tenagaSemprotString = json.encode(_tenagaSemprot);

              await QADatabaseChemistGulmaAncak.instance.insertQA({
                'tanggal': qaData['tanggal'],
                'nama_petugas': qaData['nama_petugas'],
                'kebun': qaData['kebun'],
                'divisi': qaData['divisi'],
                'blok': qaData['blok'],
                'tanggal_semprot': qaData['tanggal_semprot'],
                'luas': qaData['luas'],
                'jumlah_tenaga_kerja': qaData['jumlah_tenaga_kerja'],
                'chemist': qaData['chemist'],
                'jenis_chemist': qaData['jenis_chemist'],
                'dosis_knapsack': qaData['dosis_knapsack'],
                'bahan_herbisida': qaData['bahan_herbisida'],
                'program_pengendalian_gulma': qaData['program_pengendalian_gulma'],
                'kartu_pengambilan_pencampuran': qaData['kartu_pengambilan_pencampuran'],
                'kalibrasi_alat_nozel': qaData['kalibrasi_alat_nozel'],
                'gelas_ukur_perkakas': qaData['gelas_ukur_perkakas'],
                'peletakan_alat_semprot': qaData['peletakan_alat_semprot'],
                'total_tenaga_kerja_semprot': totalTenagaKerja,
                'total_pokok_tersemprot': totalPokokTersemprot,
                'total_pokok_tidak_tersemprot': totalPokokTidakTersemprot,
                'kondisi_alat_semprot': qaData['kondisi_alat_semprot'],
                'keseragaman_nozel': qaData['keseragaman_nozel'],
                'apd_pekerja': qaData['apd_pekerja'],
                'kesesuaian_kalibrasi_dosis': qaData['kesesuaian_kalibrasi_dosis'],
                'daftar_tenaga_semprot': tenagaSemprotString,
                'tanggal_mutu_ancak': tanggalPemeriksaanMutuAncak,
                'jumlah_pokok_gulma': totalSample,
                'total_gulma_circle_mati': averageGulmaCircleMati.isNaN ? 0 : averageGulmaCircleMati,
                'total_gulma_path_mati': averageGulmaPathMati.isNaN ? 0 : averageGulmaPathMati,
                'total_gulma_tph_mati': averageGulmaTPHMati.isNaN ? 0 : averageGulmaTPHMati,
                'total_gulma_gawangan_mati': averageGawanganTPHMati.isNaN ? 0 : averageGawanganTPHMati,
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
                    controller: _tenagaSemprotController,
                    decoration: const InputDecoration(labelText: "Nama Tenaga Semprot"),
                    onChanged: (_) {
                      final tenagaSemprot = _tenagaSemprot[_tenagaSemprotKey];
                      if (tenagaSemprot != null) {
                        setState(() {
                          barisController.text = tenagaSemprot['baris'];
                        });
                      } else {
                        setState(() {
                          barisController.clear();
                        });
                      }
                    },
                  ),
              TextField(controller: barisController, decoration: const InputDecoration(labelText: "Baris ke-"), enabled: !isTenagaSemprotLocked,),
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
              if (_samples.isNotEmpty) ...[
                const Divider(),
                const Text("Daftar Sample:",style: TextStyle(fontWeight: FontWeight.bold),),

                if(qaData['chemist'] == 'Chemist CPT') ...[
                  ..._samples.map(
                    (s) => ListTile(
                      title: Text("Baris ke ${s['baris']} - Pokok ke ${s['pokok']}"),
                      subtitle: Text(
                        "Tersemprot: ${s['tersemprot']}, Circle: ${s['gulmaCircle']}, Path: ${s['gulmaPath']}, TPH: ${s['gulmaTPH']}",
                      ),
                    ),
                  ),
                ]
                else if(qaData['chemist'] == 'Chemist Gawangan') ...[
                  ..._samples.map(
                    (s) => ListTile(
                      title: Text("Baris ke ${s['baris']} - Pokok ke ${s['pokok']}"),
                      subtitle: Text(
                        "Tersemprot: ${s['tersemprot']}, Gawangan: ${s['gulmaGawangan']}",
                      ),
                    ),
                  ),
                ]
                else if(qaData['chemist'] == 'Chemist CPT + Gawangan') ...[
                  ..._samples.map(
                    (s) => ListTile(
                      title: Text("Baris ke ${s['baris']} - Pokok ke ${s['pokok']}"),
                      subtitle: Text(
                        "Tersemprot: ${s['tersemprot']}, Circle: ${s['gulmaCircle']}, Path: ${s['gulmaPath']}, TPH: ${s['gulmaTPH']}, Gawangan: ${s['gulmaGawangan']}",
                      ),
                    ),
                  ),
                ]
              ],
              const Divider(),
              TextField(
                controller: _komentarController,
                decoration: InputDecoration(
                  labelText: 'Keterangan Foto',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
              ),
              const SizedBox(height: 8),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(backgroundColor: primaryColor, foregroundColor: Colors.white),
                icon: Icon(Icons.camera_alt),
                label: Text("Ambil Foto"),
                onPressed: () {
                  ambilFotoDenganWatermark(
                    estate: qaData['kebun'],
                    divisi: qaData['divisi'],
                    blok: qaData['blok'],
                    barisKe: barisController.text,
                    petugas: qaData['nama_petugas'],
                    context: context,
                  );
                },
              ),
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
