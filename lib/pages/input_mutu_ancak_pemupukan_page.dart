import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:convert';
import '../utils/constants.dart';
import 'menu_page.dart';
import 'input_mutu_ancak_pemupukan_summary.dart';
import 'package:qa_agronomy/database/input_mutu_ancak_database_pemupukan.dart';
import 'package:qa_agronomy/database/qa_database_pemupukan.dart';

class InputMutuAncakPemupukanPage extends StatefulWidget {
  final Map<String, dynamic> qa;

  const InputMutuAncakPemupukanPage({super.key, required this.qa});

  @override
  State<InputMutuAncakPemupukanPage> createState() => _InputMutuAncakPemupukanPageState();
}

class _InputMutuAncakPemupukanPageState extends State<InputMutuAncakPemupukanPage> {
  late Map<String, dynamic> qaData;
  final _tenagaTaburController = TextEditingController();
  final _barisController = TextEditingController();
  List<TextEditingController> _dosisSampleControllers =[];

  final String tanggalPemeriksaanMutuAncak = DateFormat('yyyy-MM-dd').format(DateTime.now());

  String? selectedPokokTerpupuk;
  String? selectedKondisiPiringan;
  String? selectedCaraAplikasi;

  String get _tenagaTaburKey => "${_tenagaTaburController.text.trim().toLowerCase()}|${qaData['blok'] ??''}|$tanggalPemeriksaanMutuAncak";

  final List<Map<String, dynamic>> _samples = [];
  final Map<String, Map<String, dynamic>> _tenagaTabur = {};
  bool get isTenagaTaburLocked => _tenagaTabur.containsKey(_tenagaTaburKey);
  int _pokokCounter = 1; // Counter otomatis untuk pokok

  final List<String> kebunOptions = ['Inti', 'Plasma'];
  final List<String> divisiOptions = ['1', '2', '3', '4', '5'];
  final List<String> jenisPupukOptions = [
    'NPK 13', 'NPK 15', 'NPK 12', 'Dolomite', 'Urea', 'MOP', 'HGFB',
    'CuSO4', 'Zincop Chelated', 'Kieserite', 'RP', 'TSP', 'Kaptan'
  ];

  final Map<String, List<String>> blokOptions = {
    "Inti-1": ["I-18", "I-19", "I-20", "I-21", "I-22", "I-23", "I-24", "I-25", "I-26", "I-27", "I-28", "I-29", "J-18", "J-19", "J-20", "J-21", "J-22", "J-23", "J-24", "J-25", "J-26", "J-27", "J-28", "J-29", "I-12", "I-13", "I-14", "I-14B", "I-15", "I-15B", "I-16", "I-16B", "I-17", "I-08", "I-09", "I-10", "I-11"],
    "Inti-2": ["H-18", "H-19", "H-20", "H-21", "H-22", "H-23", "H-24", "H-25", "H-26", "H-27", "H-28", "H-29", "H-30", "H-31", "G-18", "G-19", "G-20", "G-21", "G-22", "G-23", "G-24", "G-25", "G-26", "G-27"],
    "Inti-3": ["G-1", "G-10", "G-11", "G-12", "G-13", "G-14", "G-15", "G-16", "G-17", "G-2", "G-3", "G-4", "G-5", "G-6", "G-7", "G-8", "G-9", "H-10", "H-11", "H-12", "H-13", "H-14", "H-15", "H-16", "H-17", "H-6", "H-7", "H-8", "H-9", "G-04", "G-05", "H-06", "H-07"],
    "Inti-4": ["E-18", "E-10", "E-11", "E-12", "E-13", "E-14", "E-15", "E-16", "E-17", "E-19", "E-20", "E-21", "E-22", "E-23", "E-7", "E-8", "E-9", "E-24", "F-10", "F-11", "F-12", "F-13", "F-14", "F-15", "F-16", "F-17", "F-18", "F-19", "F-20", "F-21", "F-22", "F-23", "F-24", "F-7", "F-8", "F-9"],
    "Inti-5": ["C-16", "E-1", "E-2", "E-3", "E-4", "E-5", "E-6", "F-1", "F-2", "F-3", "F-4", "F-5", "F-6", "C-5", "C-6", "C-7", "C-8", "C-9", "D-10", "D-11", "D-3", "D-4", "D-5", "D-6", "D-7", "D-8", "D-9"],
    "Plasma-1": ["I-30", "I-31", "I-32", "J-30", "J-31", "J-32", "G-31", "H-31", "K-28", "K-29", "K-30", "L-26", "L-27", "L-28", "L-29", "L-30", "L-31", "L-32", "L-33", "L-34", "L-35", "L-37", "H-32", "L-36", "L-38", "L-39", "K-26", "K-27", "K-31", "K-22", "K-23", "K-24", "K-25", "H-33", "K-32", "K-33", "K-34", "K-35", "L-40", "L-41", "M-36", "M-38"],
    "Plasma-2": ["E-34", "E-35", "E-37", "E-38", "F-34", "F-35", "F-37", "F-38", "F-39", "F-40", "F-41", "D-34", "D-35", "D-49", "D-50", "D-51", "D-52", "D-53", "E-33", "E-36", "E-39", "F-36", "E-25", "E-26", "E-27", "F-24", "F-25", "F-26", "F-27", "F-28", "D-37", "D-38", "D-41", "D-42", "D-36", "D-39", "D-40", "D-43", "D-48", "E-28", "E-29"],
    "Plasma-3": ["D-35", "D-36", "D-30", "D-33", "D-34", "C-25", "C-26", "C-31", "C-32", "D-37", "D-38", "D-39", "D-40", "D-41", "D-42", "C-27", "C-28", "C-29", "C-30", "C-33", "C-34", "C-35", "C-36", "C-37", "C-38", "C-39", "C-40", "B-34", "B-35", "B-37", "B-40", "B-41", "B-43", "C-41", "C-42", "C-43", "C-44"],
    "Plasma-4": ["B-23", "B-17", "B-18", "B-27", "B-29", "A-20", "A-21", "A-22", "A-23", "B-19", "B-20", "B-21", "B-22", "B-24", "B-25", "B-26", "B-28", "A-28", "A-29", "A-30", "A-32", "A-25", "A-31", "B-30", "A-26"],
    "Plasma-5": ["B-15", "B-16", "C-23", "D-20", "D-28", "B-10", "B-13", "B-14", "C-15", "C-16", "C-8", "C-9", "D-11", "C-19", "C-20", "D-25", "D-26", "D-27", "B-12", "C-5", "B-11", "C-10", "C-11", "C-14", "D-19", "C-6", "C-7", "D-17", "D-1", "D-2", "D-3"]
  };
  
  final List<String> apdOptions = [
    'Lengkap', 'Kurang dari 1 item', 'Kurang dari 2 item',
    'Kurang dari 3 item', 'Tidak ada APD'
  ];
  final List<String> tenagaPemupukOptions = [
    'Organisasi tetap, training rutin',
    'Organisasi tetap, training tidak rutin',
    'Organisasi tidak tetap, training rutin',
    'Organisasi tidak tetap, training tidak rutin',
    'Organisasi tidak tetap, tidak ada training'
  ];
  final List<String> supervisiOptions = [
    'Lengkap',
    'Ada semua kecuali tidak ada Assistant / Mandor 1',
    'Ada semua kecuali tidak ada Assistant & Security',
    'Ada semua kecuali tidak ada Assistant & Mandor',
    'Tidak ada sama sekali supervisi'
  ];
  final List<String> fisikPupukOptions = [
    'Tekstur baik, kondisi kering',
    'Tekstur baik, sebagian menggumpal',
    'Tekstur kurang baik, sebagian menggumpal',
    'Tekstur tidak baik, sebagian menggumpal',
    'Tekstur tidak baik, semua menggumpal'
  ];
  final List<String> pokokOptions = ['Terpupuk', 'Tidak Terpupuk'];
  final List<String> piringanOptions = ['Baik', 'Ancak Semak atau Ada Gulma'];
  final List<String> caraAplikasiOptions = ['Standar', 'Tidak Standar'];
  final List<String> dosisUjiOptions = ['Sesuai', 'Tidak Sesuai'];

  void _saveSample() {
  if (_tenagaTaburController.text.isEmpty ||
      _barisController.text.isEmpty ||
      selectedPokokTerpupuk == null ||
      selectedKondisiPiringan == null ||
      selectedCaraAplikasi == null) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Lengkapi semua data pokok sample dengan benar.")));
        return;
  }

  setState(() {
    _samples.add({
      'tenagaTabur': _tenagaTaburController.text.toLowerCase(),
      'baris': _barisController.text,
      'pokok': _pokokCounter++,
      'pokokTerpupuk': selectedPokokTerpupuk,
      'kondisiPiringan': selectedKondisiPiringan,
      'caraAplikasi': selectedCaraAplikasi,
    });

    if (!_tenagaTabur.containsKey(_tenagaTaburKey)) {
      _tenagaTabur[_tenagaTaburKey] = {
        'baris': _barisController.text,
      };
    }
    
    selectedPokokTerpupuk = null;
    selectedKondisiPiringan = null;
    selectedCaraAplikasi = null;
  });
}

  void _saveAll() {
  if (_samples.isEmpty || 
      _tenagaTabur.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Lengkapi semua data.")));
        return;
  }

  // Kelompokkan sample per tenaga tabur
  final Map<String, List<Map<String, dynamic>>> perTenaga = {};
  for (final sample in _samples) {
    final key = sample['tenagaTabur'].toLowerCase();
    perTenaga.putIfAbsent(key, () => []).add(sample);
  }

  final List<SampleAncakPemupukanSummary> tenagaList = perTenaga.entries.map((entry) {
    final nama = entry.key;
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

    return SampleAncakPemupukanSummary(
      nama: nama.toLowerCase(),
      jumlahSample: countSample,
      pokokTerpupuk: countBy('pokokTerpupuk'),
      piringan: countBy('kondisiPiringan'),
      caraAplikasi: countBy('caraAplikasi'),
    );
  }).toList();

  final summary = PemupukanAncakSummary(
    tanggalPeriksa: qaData['tanggal'],
    namaPetugas: qaData['nama_petugas'],
    kebun: qaData['kebun'],
    divisi: qaData['divisi'],
    blok: qaData['blok'],
    tanggalPemupukan: qaData['tanggal_pemupukan'],
    jenisPupuk: qaData['jenis_pupuk'],
    dosis: qaData['dosis'],
    tenagaPemupuk: qaData['tenaga_pemupuk'],
    supervisi: qaData['supervisi'],
    fisikPupuk: qaData['fisik_pupuk'],
    totalUjiPetikAktif: qaData['total_uji_petik_aktif'],
    totalHasilUjiPetikSesuai: qaData['total_dosis_sesuai'],
    tanggalPeriksaMutuAncak: tanggalPemeriksaanMutuAncak,
    tenagaTaburList: tenagaList,
  );
  
  final ringkasan = generateRingkasanText(summary);

  showDialog(
    context: context,
    builder: (_) => AlertDialog(
      title: const Text("Ringkasan Mutu Ancak QA Pemupukan"),
      content: SingleChildScrollView(child: Text(ringkasan)),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text("Batal"),
        ),
        ElevatedButton(
          onPressed: () async {
          Navigator.pop(context);

          final totalSample = tenagaList.fold<int>(0, (sum, t) => sum + t.jumlahSample);
          int totalTenagaKerja = perTenaga.length;
          int totalPokokTerpupuk = _samples.where((s) => s['pokokTerpupuk'] == 'Terpupuk').length;
          int totalPokokTidakTerpupuk = _samples.where((s) => s['pokokTerpupuk'] == 'Tidak Terpupuk').length;
          int totalGawanganBaik = _samples.where((s) => s['kondisiPiringan'] == 'Baik').length;
          int totalGawanganSemak = _samples.where((s) => s['kondisiPiringan'] == 'Ancak Semak atau Ada Gulma').length;
          int totalAplikasiStandar = _samples.where((s) => s['caraAplikasi'] == 'Standar').length;
          int totalAplikasiTidakStandar = _samples.where((s) => s['caraAplikasi'] == 'Tidak Standar').length;
          
          String tenagaTaburString = json.encode(_tenagaTabur);

          await QADatabasePemupukanGulmaAncak.instance.insertQA({
            'tanggal': summary.tanggalPeriksa,
            'nama_petugas': summary.namaPetugas,
            'kebun': summary.kebun,
            'divisi': summary.divisi,
            'blok': summary.blok,
            'tanggal_pemupukan': summary.tanggalPemupukan,
            'jenis_pupuk': summary.jenisPupuk,
            'dosis': summary.dosis,
            'tenaga_pemupuk': qaData['tenaga_pemupuk'],
            'supervisi': qaData['supervisi'],
            'fisik_pupuk': qaData['fisik_pupuk'],
            'jumlah_pokok': totalSample,
            'total_alat_tabur': qaData['total_alat_tabur'],
            'alat_tabur_seragam': qaData['alat_tabur_seragam'],
            'alat_tabur_tidak_seragam': qaData['alat_tabur_tidak_seragam'],
            'total_tenaga_kerja': totalTenagaKerja,
            'total_uji_petik_aktif': qaData['total_uji_petik_aktif'],
            'total_uji_petik_nonaktif': qaData['total_uji_petik_nonaktif'],
            'total_dosis_sesuai': qaData['total_dosis_sesuai'],
            'total_dosis_tidak_sesuai': qaData['total_dosis_tidak_sesuai'],
            'tanggal_mutu_ancak': tanggalPemeriksaanMutuAncak,
            'pokok_terpupuk': totalPokokTerpupuk,
            'pokok_tidak_terpupuk': totalPokokTidakTerpupuk,
            'gawangan_baik': totalGawanganBaik,
            'gawangan_semak': totalGawanganSemak,
            'cara_aplikasi_standar': totalAplikasiStandar,
            'cara_aplikasi_tidak_standar': totalAplikasiTidakStandar,
            'apd_pekerja': qaData['apd_pekerja'],
            'daftar_tenaga_tabur': tenagaTaburString,
            'ringkasan': ringkasan,
            'is_synced': 0,
            'timestamp_sync': null,
          });

          QADatabasePemupukan.instance.updateSyncStatusQAData(qaData['tanggal'], qaData['kebun'], qaData['divisi'], qaData['blok'], 1);
          
          Navigator.of(context).popUntil((route) => route.isFirst);
          Navigator.push(context, MaterialPageRoute(builder: (context) => const MenuPage()));
        },
          child: const Text("Ok"),
        ),
      ],
),
);
}

  @override
  void initState() {
    super.initState();
    qaData = widget.qa;
  }

  @override
  void dispose() {
    for (var c in _dosisSampleControllers) {
      c.dispose();
    }
    _tenagaTaburController.dispose();
    _barisController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Mutu Ancak Pemupukan - ${qaData['tanggal']} - ${qaData['kebun']} - ${qaData['divisi']} - ${qaData['blok']}")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
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
                Text("Tanggal Pemupukan: ${qaData['tanggal_pemupukan']}"),
                Text("Jenis Pupuk: ${qaData['jenis_pupuk']}"),
                Text("Dosis/Pokok: ${qaData['dosis']}"),
                Text("Tenaga Pemupuk: ${qaData['tenaga_pemupuk']}",),
                Text("Supervisi: ${qaData['supervisi']}",),
                Text("Fisik Pupuk: ${qaData['fisik_pupuk']}",),
                Text("Total Uji Petik Aktif: ${qaData['total_uji_petik_aktif']}",),
                Text("Total Dosis Sesuai: ${qaData['total_dosis_sesuai']}",),
                const SizedBox(height: 12),
              ],
            ),
            const SizedBox(height: 12),
            const Text("Input Sample Pokok", style: TextStyle(fontWeight: FontWeight.bold)),
            TextField(
                  controller: _tenagaTaburController,
                  decoration: const InputDecoration(labelText: "Nama Tenaga Tabur"),
                  onChanged: (_) {
                    final tenagaTabur = _tenagaTabur[_tenagaTaburKey];
                    if (tenagaTabur != null) {
                      setState(() {
                        _barisController.text = tenagaTabur['baris'];
                      });
                    } else {
                      setState(() {
                        _barisController.clear();
                      });
                    }
                  },
                ),
            TextField(controller: _barisController, decoration: const InputDecoration(labelText: "Baris ke-"), enabled: !isTenagaTaburLocked,),
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(labelText: "Pokok Terpupuk"),
              value: selectedPokokTerpupuk,
              onChanged: (val) => setState(() => selectedPokokTerpupuk = val),
              items: pokokOptions.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
            ),
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(labelText: "Kondisi Piringan/Gawangan"),
              value: selectedKondisiPiringan,
              onChanged: (val) => setState(() => selectedKondisiPiringan = val),
              items: piringanOptions.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
            ),
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(labelText: "Cara Aplikasi"),
              value: selectedCaraAplikasi,
              onChanged: (val) => setState(() => selectedCaraAplikasi = val),
              items: caraAplikasiOptions.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: primaryColor, foregroundColor: Colors.white),onPressed: _saveSample, child: const Text("Save & Tambah Pokok Sample")),
            const SizedBox(height: 16),
            ElevatedButton( style: ElevatedButton.styleFrom(backgroundColor: primaryColor, foregroundColor: Colors.white),onPressed: _saveAll, child: const Text("Save All")),
            const Divider(),
            const Text("Daftar Sample"),
            ..._samples.map((s) => ListTile(
              title: Text("Baris: ${s['baris']}, Pokok Ke: ${s['pokok']}"),
              subtitle: Text("Tenaga Tabur: ${s['tenagaTabur']}\nStatus: ${s['pokokTerpupuk']}\nKondisi: ${s['kondisiPiringan']}\nAplikasi: ${s['caraAplikasi']}"),
            ))
          ],
        ),
),
);
}
}