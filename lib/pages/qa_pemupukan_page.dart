import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../utils/constants.dart';
import 'menu_page.dart';
import 'qa_pemupukan_summary.dart';
import 'package:qa_agronomy/database/qa_database_pemupukan.dart';



class QAPemupukanPage extends StatefulWidget {
  const QAPemupukanPage({super.key});

  @override
  State<QAPemupukanPage> createState() => _QAPemupukanPageState();
}

class _QAPemupukanPageState extends State<QAPemupukanPage> {
  final _namaPetugasController = TextEditingController();
  final _tenagaTaburController = TextEditingController();
  final _dosisController = TextEditingController();
  final _jumlahAlatTaburController = TextEditingController();
  final _jumlahSampleUjiPetikController = TextEditingController();
  final _barisController = TextEditingController();
  List<TextEditingController> _dosisSampleControllers =[];
  String dosisUjiPetikResult ="";


  final String _tanggalPeriksa = DateFormat('yyyy-MM-dd').format(DateTime.now());
  final String _tanggalPemupukan = DateFormat('yyyy-MM-dd').format(DateTime.now());

  final Map<String, Map<String, dynamic>> _alatTaburData = {};

  String? selectedKebun;
  String? selectedDivisi;
  String? selectedBlok;
  String? selectedJenisPupuk;
  String? selectedAPD;
  String? selectedKeseragaman;
  String? selectedTenagaPemupuk;
  String? selectedSupervisi;
  String? selectedFisikPupuk;

  String? selectedLubangPocket;
  String? selectedPokokTerpupuk;
  String? selectedKondisiPiringan;
  String? selectedCaraAplikasi;
 // String? selectedDosisUjiPetik;

  String get _tenagaTaburKey => "${_tenagaTaburController.text.trim()}|${selectedBlok ??''}|$_tanggalPemupukan";

  bool _ujiPetik = false;

  final List<Map<String, dynamic>> _samples = [];

  bool get isLocked => _samples.isNotEmpty;

  bool get isAlatTaburLocked => _alatTaburData.containsKey(_tenagaTaburKey);
  bool get isAPDLocked => isAlatTaburLocked;

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

  List<String> get availableBloks {
    if (selectedKebun != null && selectedDivisi != null) {
      return blokOptions['$selectedKebun-$selectedDivisi'] ?? [];
    }
    return [];
  }

  final List<String> apdOptions = [
    'Lengkap', 'Kurang dari 1 item', 'Kurang dari 2 item',
    'Kurang dari 3 item', 'Tidak ada APD'
  ];
  final List<String> keseragamanOptions = ['Seragam', 'Tidak Seragam'];
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
  final List<String> pocketOptions = ['Standar', 'Tidak Standar'];
  final List<String> pokokOptions = ['Terpupuk', 'Tidak Terpupuk'];
  final List<String> piringanOptions = ['Baik', 'Ancak Semak atau Ada Gulma'];
  final List<String> caraAplikasiOptions = ['Standar', 'Tidak Standar'];
  final List<String> dosisUjiOptions = ['Sesuai', 'Tidak Sesuai'];

  void _saveSample() {
  if (_barisController.text.isEmpty ||
      selectedLubangPocket == null ||
      selectedPokokTerpupuk == null ||
      selectedKondisiPiringan == null ||
      selectedCaraAplikasi == null ||
      (_ujiPetik && (_jumlahSampleUjiPetikController.text.isEmpty || _dosisSampleControllers.any((c)=> c.text.isEmpty)))) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Lengkapi semua data pokok sample.")));
    return;
  }

  setState(() {
    _samples.add({
      'baris': _barisController.text,
      'lubangPocket': selectedLubangPocket,
      'pokokTerpupuk': selectedPokokTerpupuk,
      'kondisiPiringan': selectedKondisiPiringan,
      'caraAplikasi': selectedCaraAplikasi,
      'ujiPetik': _ujiPetik,
      'jumlahSample': _ujiPetik ? _jumlahSampleUjiPetikController.text : '-',
      'dosisAlatTabur': _ujiPetik ? dosisUjiPetikResult : '-',
      'tenagaTabur': _tenagaTaburController.text,
    });

    _barisController.clear();
    selectedLubangPocket = null;
    selectedPokokTerpupuk = null;
    selectedKondisiPiringan = null;
    selectedCaraAplikasi = null;
    //selectedDosisUjiPetik = null;
    _jumlahSampleUjiPetikController.clear();
    _ujiPetik = false;
    dosisUjiPetikResult ="";

    // ✅ Simpan data alat tabur kalau belum pernah
    if (!_alatTaburData.containsKey(_tenagaTaburKey)) {
      _alatTaburData[_tenagaTaburKey] = {
        'jumlah': _jumlahAlatTaburController.text,
        'keseragaman': selectedKeseragaman,
        'apd': selectedAPD,
      };
    }

    // ✅ Auto isi jika data sudah ada (kalau kamu edit tenaga ke yang lama)
    final alatTabur = _alatTaburData[_tenagaTaburKey];
    if (alatTabur != null) {
      _jumlahAlatTaburController.text = alatTabur['jumlah'];
      selectedKeseragaman = alatTabur['keseragaman'];
      selectedAPD = alatTabur['apd'];
    }
  });
}

  void _saveAll() {
  // Kelompokkan sample per tenaga tabur
  final Map<String, List<Map<String, dynamic>>> perTenaga = {};
  for (final sample in _samples) {
    final key = sample['tenagaTabur'];
    perTenaga.putIfAbsent(key, () => []).add(sample);
  }

  final List<TenagaTaburSummary> tenagaList = perTenaga.entries.map((entry) {
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

    final alatTabur = _alatTaburData.entries.firstWhere((e) => e.key.startsWith(nama)).value;

    return TenagaTaburSummary(
      nama: nama,
      jumlahSample: countSample,
      jumlahAlatTabur: alatTabur['jumlah'],
      apd: alatTabur['apd'],
      keseragaman: alatTabur['keseragaman'],
      pocket: countBy('lubangPocket'),
      pokokTerpupuk: countBy('pokokTerpupuk'),
      piringan: countBy('kondisiPiringan'),
      caraAplikasi: countBy('caraAplikasi'),
      dosis: countBy('dosisAlatTabur'),
    );
  }).toList();

  final summary = QAPemupukanSummary(
    tanggalPeriksa: _tanggalPeriksa,
    namaPetugas: _namaPetugasController.text,
    kebun: selectedKebun ?? '',
    divisi: selectedDivisi ?? '',
    blok: selectedBlok ?? '',
    tanggalPemupukan: _tanggalPemupukan,
    jenisPupuk: selectedJenisPupuk ?? '',
    dosis: _dosisController.text,
    tenagaPemupuk: selectedTenagaPemupuk ?? '',
    supervisi: selectedSupervisi ?? '',
    fisikPupuk: selectedFisikPupuk ?? '',
    tenagaTaburList: tenagaList,
  );

  final ringkasan = generateRingkasanText(summary);

  showDialog(
    context: context,
    builder: (_) => AlertDialog(
      title: const Text("Ringkasan QA Pemupukan"),
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
          int totalAlatTabur = _alatTaburData.length;
          int totalTenagaKerja = perTenaga.length;
          int totalUjiPetikAktif = _samples.where((s) => s['ujiPetik'] == true).length;
          int totalUjiPetikNonAktif = _samples.where((s) => s['ujiPetik'] == false).length;
          int totalDosisSesuai = _samples.where((s) => s['dosisAlatTabur'] == 'Sesuai').length;
          int totalDosisTidakSesuai = _samples.where((s) => s['dosisAlatTabur'] == 'Tidak Sesuai').length;
          int totalPokokTerpupuk = _samples.where((s) => s['pokokTerpupuk'] == 'Terpupuk').length;
          int totalPokokTidakTerpupuk = _samples.where((s) => s['pokokTerpupuk'] == 'Tidak Terpupuk').length;
          int totalPocketStandar = _samples.where((s) => s['lubangPocket'] == 'Standar').length;
          int totalPocketTidakStandar = _samples.where((s) => s['lubangPocket'] == 'Tidak Standar').length;
          int totalGawanganBaik = _samples.where((s) => s['kondisiPiringan'] == 'Baik').length;
          int totalGawanganSemak = _samples.where((s) => s['kondisiPiringan'] == 'Ancak Semak atau Ada Gulma').length;
          int totalAplikasiStandar = _samples.where((s) => s['caraAplikasi'] == 'Standar').length;
          int totalAplikasiTidakStandar = _samples.where((s) => s['caraAplikasi'] == 'Tidak Standar').length;
          Map<String, int> apdCount = {};
          for (var tabur in _alatTaburData.values) {
            final apd = tabur['apd'];
            if (apd != null) apdCount[apd] = (apdCount[apd] ?? 0) + 1;
          }
          String mostCommonAPD = apdCount.entries.isEmpty ? '' : (apdCount.entries.toList()..sort((a, b) => b.value.compareTo(a.value))).first.key;

          String mostCommonFisikPupuk = selectedFisikPupuk ?? '';

          await QADatabasePemupukan.instance.insertQA({
            'tanggal': summary.tanggalPeriksa,
            'nama_petugas': summary.namaPetugas,
            'kebun': summary.kebun,
            'divisi': summary.divisi,
            'blok': summary.blok,
            'tanggal_pemupukan': summary.tanggalPemupukan,
            'jenis_pupuk': summary.jenisPupuk,
            'dosis': summary.dosis,
            'tenaga_pemupuk': summary.tenagaPemupuk,
            'supervisi': summary.supervisi,
            'fisik_pupuk': mostCommonFisikPupuk,
            'jumlah_pokok': totalSample,
            'total_alat_tabur': totalAlatTabur,
            'total_tenaga_kerja': totalTenagaKerja,
            'total_uji_petik_aktif': totalUjiPetikAktif,
            'total_uji_petik_nonaktif': totalUjiPetikNonAktif,
            'total_dosis_sesuai': totalDosisSesuai,
            'total_dosis_tidak_sesuai': totalDosisTidakSesuai,
            'pokok_terpupuk': totalPokokTerpupuk,
            'pokok_tidak_terpupuk': totalPokokTidakTerpupuk,
            'lubang_pocket_standar': totalPocketStandar,
            'lubang_pocket_tidak_standar': totalPocketTidakStandar,
            'gawangan_baik': totalGawanganBaik,
            'gawangan_semak': totalGawanganSemak,
            'cara_aplikasi_standar': totalAplikasiStandar,
            'cara_aplikasi_tidak_standar': totalAplikasiTidakStandar,
            'apd_pekerja': mostCommonAPD,
            'ringkasan': ringkasan,
            'is_synced': 0,
            'timestamp_sync': null,
          });

          // Pindah ke halaman tracker (coming soon)
          Navigator.of(context).popUntil((route) => route.isFirst);
          Navigator.push(context, MaterialPageRoute(builder: (context) => const MenuPage()));
        },
          child: const Text("Ok"),
        ),
      ],
),
);
}

  void _updateDosisSamples(){
    final int jumlah = int.tryParse(_jumlahSampleUjiPetikController.text)??0;
    _dosisSampleControllers = List.generate(jumlah, (_) => TextEditingController());
    dosisUjiPetikResult =""; //Reset
  }
  
  void _calculateDosisUjiPetik(){
    if (_dosisController.text.isEmpty) return;

    final double targetKg = double.tryParse(_dosisController.text)??0;
    final double targetGram = targetKg * 1000;
    final double total = _dosisSampleControllers.fold<double>(
      0,
      (sum, c) => sum + (double.tryParse(c.text)??0),
    );
    final selisih = (total - targetGram).abs();
    setState(() {
      dosisUjiPetikResult = selisih <= 50? "Sesuai": "Tidak Sesuai";
    });
  }

  @override
  void dispose() {
    for (var c in _dosisSampleControllers) {
      c.dispose();
    }
    _namaPetugasController.dispose();
    _tenagaTaburController.dispose();
    _dosisController.dispose();
    _jumlahAlatTaburController.dispose();
    _jumlahSampleUjiPetikController.dispose();
    _barisController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("QA Pemupukan")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Tanggal Pemeriksaan: $_tanggalPeriksa"),
            Text("Tanggal Pemupukan: $_tanggalPemupukan"),
            TextField(controller: _namaPetugasController, decoration: const InputDecoration(labelText: "Nama Petugas")),
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(labelText: "Kebun"),
              value: selectedKebun,
              onChanged: isLocked ? null : (val) => setState(() => selectedKebun = val),
              items: kebunOptions.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
            ),
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(labelText: "Divisi"),
              value: selectedDivisi,
              onChanged: isLocked ? null : (val) => setState(() => selectedDivisi = val),
              items: divisiOptions.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
            ),
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(labelText: "Kode Blok"),
              value: selectedBlok,
              onChanged: isLocked ? null : (val) => setState(() => selectedBlok = val),
              items: availableBloks.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
            ),
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(labelText: "Jenis Pupuk"),
              value: selectedJenisPupuk,
              onChanged: isLocked ? null : (val) => setState(() => selectedJenisPupuk = val),
              items: jenisPupukOptions.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
            ),
            TextField(controller: _dosisController, decoration: const InputDecoration(labelText: "Dosis/Pokok"), enabled: !isLocked),
            TextField(
                  controller: _tenagaTaburController,
                  decoration: const InputDecoration(labelText: "Nama Tenaga Tabur"),
                  onChanged: (_) {
                    final alatTabur = _alatTaburData[_tenagaTaburKey];
                    if (alatTabur != null) {
                      setState(() {
                        _jumlahAlatTaburController.text = alatTabur['jumlah'];
                        selectedKeseragaman = alatTabur['keseragaman'];
                        selectedAPD = alatTabur['apd'];
                      });
                    } else {
                      setState(() {
                        _jumlahAlatTaburController.clear();
                        selectedKeseragaman = null;
                      });
                    }
                  },
                ),
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(labelText: "APD Pekerja"),
              value: selectedAPD,
              onChanged: isAPDLocked ? null : (val) => setState(() => selectedAPD = val),
              items: apdOptions.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
            ),
            TextField(controller: _jumlahAlatTaburController, decoration: InputDecoration(labelText: "Jumlah Alat Tabur", hintText: isAlatTaburLocked ? "Data Ini Sudah Tersedia": null,), keyboardType: TextInputType.number, enabled: !isAlatTaburLocked,),
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(labelText: "Keseragaman Alat Tabur"),
              value: selectedKeseragaman,
              onChanged: isAlatTaburLocked ? null : (val) => setState(() => selectedKeseragaman = val),
              items: keseragamanOptions.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
            ),
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(labelText: "Tenaga Pemupuk"),
              value: selectedTenagaPemupuk,
              onChanged: isLocked ? null : (val) => setState(() => selectedTenagaPemupuk = val),
              items: tenagaPemupukOptions.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
            ),
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(labelText: "Supervisi"),
              value: selectedSupervisi,
              onChanged: isLocked ? null : (val) => setState(() => selectedSupervisi = val),
              items: supervisiOptions.map((e) => DropdownMenuItem(value: e, child: Text(e, softWrap: true, style: TextStyle(fontSize: 14),))).toList(),
            ),
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(labelText: "Fisik Pupuk"),
              value: selectedFisikPupuk,
              onChanged: isLocked ? null : (val) => setState(() => selectedFisikPupuk = val),
              items: fisikPupukOptions.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
            ),
            const Divider(),
            const Text("Input Sample Pokok", style: TextStyle(fontWeight: FontWeight.bold)),
            TextField(controller: _barisController, decoration: const InputDecoration(labelText: "Baris ke-")),
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(labelText: "Lubang Pocket"),
              value: selectedLubangPocket,
              onChanged: (val) => setState(() => selectedLubangPocket = val),
              items: pocketOptions.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
            ),
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
            SwitchListTile(
              title: const Text("Apakah melakukan uji petik?"),
              value: _ujiPetik,
              onChanged: (val) {
                setState(() {
                  _ujiPetik = val;

                  for (final c in _dosisSampleControllers){
                    c.dispose();
                  }
                  _dosisSampleControllers.clear();
                  dosisUjiPetikResult="";
                  if (val){
                    final jumlah = int.tryParse(_jumlahSampleUjiPetikController.text)??0;
                    _dosisSampleControllers = List.generate(jumlah, (_)=>TextEditingController());
                  }
                });
              },
            ),
            if (_ujiPetik) ...[
                TextField(
                  controller: _jumlahSampleUjiPetikController,
                  decoration: const InputDecoration(labelText: "Jumlah sample uji petik"),
                  keyboardType: TextInputType.number,
                  onChanged: (_) {
                    setState(() {
                      _updateDosisSamples();
                    });
                  },
                ),
                const SizedBox(height: 8),
                ..._dosisSampleControllers.asMap().entries.map((entry) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: TextField(
                    controller: entry.value,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: "Dosis Sample ${entry.key + 1} (gram)",
                    ),
                    onChanged: (_) => _calculateDosisUjiPetik(),
                  ),
                )),
                const SizedBox(height: 8),
                Text(
                  "Dosis Alat Tabur: $dosisUjiPetikResult",
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
              
            const SizedBox(height: 12),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: primaryColor, foregroundColor: Colors.white),onPressed: _saveSample, child: const Text("Save Pokok Sample")),
            const SizedBox(height: 16),
            ElevatedButton( style: ElevatedButton.styleFrom(backgroundColor: primaryColor, foregroundColor: Colors.white),onPressed: _saveAll, child: const Text("Save All")),
            const Divider(),
            const Text("Daftar Sample"),
            ..._samples.map((s) => ListTile(
              title: Text("Baris: ${s['baris']}, Pokok: ${s['pokokTerpupuk']}"),
              subtitle: Text("Uji Petik: ${s['ujiPetik'] ? 'Ya' : 'Tidak'}"),
            ))
          ],
        ),
),
);
}
}