import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../utils/constants.dart';
import 'menu_page.dart';
import 'qa_chemist_summary.dart';
import 'package:qa_agronomy/database/qa_database_chemist.dart';

class QAChemistPage extends StatefulWidget {
  const QAChemistPage({super.key});

  @override
  State<QAChemistPage> createState() => _QAChemistPageState();
}

class _QAChemistPageState extends State<QAChemistPage> {  
  final String _tanggalPemeriksaan = DateFormat('yyyy-MM-dd').format(DateTime.now());
  final String _tanggalSemprot = DateFormat('yyyy-MM-dd').format(DateTime.now());
  final _namaPetugasController = TextEditingController();
  final _luasanController = TextEditingController();
  final _barisController = TextEditingController();
  final _jenisChemist = TextEditingController();
  final _jumlahSampleUjiPetikController = TextEditingController();
  List<TextEditingController> _volumeSampleControllers = [];
  final _namaPetugasSemprotController = TextEditingController();

  String? selectedEstate;
  String? selectedDivisi;
  String? selectedBlok;
  String? selectedChemist;
  String? selectedBahanHerbisida;
  String? selectedProgramGulma;
  String? selectedKartu;
  String? selectedKalibrasi;
  String? selectedPerkakas;
  String? selectedPeletakan;
  String? selectedAPD;
  String? selectedAlatSemprot;
  String? selectedKeseragamanNozel;
  String? selectedPokokTersemprot;

  final Map<String, Map<String, dynamic>> _alatSemprotData = {};
  String get _tenagaSemprotKey => "${_namaPetugasSemprotController.text.trim().toLowerCase()}|${selectedBlok ??''}|$_tanggalSemprot";
  bool get isAlatSemprotLocked => _alatSemprotData.containsKey(_tenagaSemprotKey);

  final List<Map<String, dynamic>> _pokokSamples = [];
  bool get isLocked => _pokokSamples.isNotEmpty;

  bool _ujiPetik = false;
  int totalUjiPetik = 0;
  String dosisKnapsack = "";
  final _dosisController = TextEditingController();

  final List<String> estateOptions = ['Inti', 'Plasma'];
  final List<String> divisiOptions = ['1', '2', '3', '4', '5'];
  final List<String> chemistType = ['Chemist CPT', 'Chemist Gawangan', 'Chemist CPT + Gawangan'];
  final List<String> apdOptions = [
    'Lengkap', 'Kurang dari 1 item', 'Kurang dari 2 item', 'Kurang dari 3 item', 'Tidak ada APD'
  ];
  final List<String> bahanHerbisidaOptions = ['Sesuai sasaran, sesuai kebutuhan', 'Kurang sesuai sasaran, Sesuai kebutuhan', 'Sesuai gulma sasaran, tidak sesuai kebutuhan', 'Kurang sesuai gulma sasaran, tidak sesuai kebutuhan', 'Tidak Sesuai Gulma sasaran, Jumlah tidak sesuai'];
  final List<String> programGulmaOptions = ['Terdapat RKB/RKH, Sesuai program Rotasi', 'Terdapat RKB/RKH,  kurang Sesuai program Rotasi', 'Terdapat RKB/RKH,  Tidak sesuai program Rotasi', 'Tidak terdapat RKB/RKH, Sesuai program Rotasi', 'Tidak terdapat RKB/RKH, Tidak Sesuai program Rotasi'];
  final List<String> kartuOptions = ['Kartu lengkap dan Update', 'Kartu lengkap, Terlambat 1 Hari', 'Kartu lengkap, Terlambat > 2 Hari', 'Kartu tidak lengkap, terlambat 1 hari', 'Kartu dan Monitoring tidak ada'];
  final List<String> kalibrasiOptions = ['Rutin dan Tercatat', 'Rutin dan tidak tercatat', 'Kurang rutin, tercatat', 'Tidak Rutin, tercatat', 'Tidak Pernah'];
  final List<String> perkakasOptions = ['Gelas ukur terkalibrasi, Toolkit lengkap', 'Gelas ukur terkalibrasi, Toolkit tidak lengkap', 'Gelas ukur tidak terkalibrasi, Toolkit  lengkap', 'Gelas ukur tidak terkalibrasi, Toolkit  tidak lengkap', 'Tidak membawa keduanya'];
  final List<String> peletakanOptions = ['Semua alat, tercatat', 'Semua alat, tidak tercatat', 'Sebagian alat saja dan tercatat', 'Sebagian alat saja, tidak tercatat', 'Tidak ada gudang dan pencatatan'];
  final List<String> keseragamanNozel = ['Seragam', 'Tidak Seragam'];
  final List<String> alatSemprot = ['Baik dan Lancar', 'Tidak Baik'];

  final List<String> pokokOptions = ['Tersemprot', 'Tidak Tersemprot'];

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
    if (selectedEstate != null && selectedDivisi != null) {
      return blokOptions['$selectedEstate-$selectedDivisi'] ?? [];
    }
    return [];
  }

  void _updateVolumeSampleControllers() {
    final int jumlah = int.tryParse(_jumlahSampleUjiPetikController.text) ?? 0;
    _volumeSampleControllers = List.generate(jumlah, (_) => TextEditingController());
    dosisKnapsack = "";
  }

  void _calculateDosisUjiPetik() {
    if (_dosisController.text.isEmpty) return;
    final double targetLiter = double.tryParse(_dosisController.text) ?? 0;
    final double targetMililiter = targetLiter*1000;
    final double total = _volumeSampleControllers.fold(0.0, (sum, c) => sum + (double.tryParse(c.text) ?? 0));
    final selisih = (total - targetMililiter).abs();
    setState(() {
      dosisKnapsack = selisih <= 5 ? 'Sesuai' : 'Tidak Sesuai';
    });
  }

    @override
  void dispose() {
    _namaPetugasController.dispose();
    _luasanController.dispose();
    _dosisController.dispose();
    _jumlahSampleUjiPetikController.dispose();
    _barisController.dispose();
    for (var c in _volumeSampleControllers) {
      c.dispose();
    }
    super.dispose();
  }

  void _saveSample() {
    if (_barisController.text.isNotEmpty &&
        _namaPetugasSemprotController.text.isNotEmpty &&
        selectedPokokTersemprot != null &&
        selectedAPD != null) {
      setState(() {
        _pokokSamples.add({
          'baris': _barisController.text,
          'nama_petugas': _namaPetugasSemprotController.text.toLowerCase(),
          'tersemprot': selectedPokokTersemprot,
          'kondisiAlat': selectedAlatSemprot,
          'keseragamanNozel': selectedKeseragamanNozel,
          'apd': selectedAPD,
          'ujiPetik': _ujiPetik,
          'hasilUjiPetik': _ujiPetik ? dosisKnapsack : '-',

        });

        if (!_alatSemprotData.containsKey(_tenagaSemprotKey)) {
          _alatSemprotData[_tenagaSemprotKey] = {
            'apd': selectedAPD,
            'kondisiAlat': selectedAlatSemprot,
            'keseragamanNozel': selectedKeseragamanNozel,
          };
        }

        // ✅ Auto isi jika data sudah ada (kalau kamu edit tenaga ke yang lama)
        final alatchemist = _alatSemprotData[_tenagaSemprotKey];
        if (alatchemist != null) {
          selectedAPD = alatchemist['apd'];
          selectedAlatSemprot = alatchemist['kondisiAlat'];
          selectedKeseragamanNozel = alatchemist['keseragamanNozel'];
        }

        _barisController.clear();
        _namaPetugasSemprotController.clear();
        selectedPokokTersemprot = null;
        selectedAlatSemprot = null;
        selectedKeseragamanNozel = null;
        selectedAPD = null;
        _ujiPetik = false;
        dosisKnapsack = "";
        _jumlahSampleUjiPetikController.clear();
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Sample berhasil ditambahkan")),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Lengkapi semua data sample")),
      );
    }
  }
  
  void _saveAll() {
    // Kelompokkan sample per tenaga semprot
    final Map<String, List<Map<String, dynamic>>> perTenaga = {};
    for (final sample in _pokokSamples) {
      final key = sample['nama_petugas'].toString().toLowerCase();
      perTenaga.putIfAbsent(key, () => []).add(sample);
    }

    final List<TenagaSemprotSummary> tenagaList = perTenaga.entries.map((entry) {
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

      final _alatSemprot = _alatSemprotData.entries
          .firstWhere((e) => e.key.startsWith(nama.toLowerCase()))
          .value;

      return TenagaSemprotSummary(
        nama: nama.toLowerCase(),
        jumlahSample: countSample,
        pokokTersemprot: countBy('tersemprot'),
        kondisiAlat: _alatSemprot['kondisiAlat'],
        keseragamanNozel: _alatSemprot['keseragamanNozel'],
        apd: _alatSemprot['apd'],
        ujiPetik: countBy('hasilUjiPetik')
      );
    }).toList();
    
    final totalUjiPetik = _pokokSamples.where((s) => s['ujiPetik'] == true).length;

    final summary = QAChemistSummary(
      tanggalPeriksa: _tanggalPemeriksaan,
      namaPetugas: _namaPetugasController.text,
      kebun: selectedEstate ?? '',
      divisi: selectedDivisi ?? '',
      blok: selectedBlok ?? '',
      tanggalPenyemprotan: _tanggalSemprot,
      luasan: _luasanController.text,
      chemist: selectedChemist ?? '',
      jenisChemist: _jenisChemist.text,
      dosis: _dosisController.text,
      bahanHerbisida: selectedBahanHerbisida ?? '',
      programPengendalianGulma: selectedProgramGulma ?? '',
      kartuPengambilanPencampuran: selectedKartu ?? '',
      kalibrasiAlatNozel: selectedKalibrasi ?? '',
      gelasUkurPerkakas: selectedPerkakas ?? '',
      peletakanAlatSemprot: selectedPeletakan ?? '',
      totalUjiPetik: totalUjiPetik,
      tenagaSemprotList: tenagaList,
    );

    final ringkasan = generateRingkasanText(summary);

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Ringkasan QA Chemist"),
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
              int totalUjiPetikAktif = _pokokSamples.where((s) => s['ujiPetik'] == true).length;
              int totalUjiPetikNonAktif = _pokokSamples.where((s) => s['ujiPetik'] == false).length;
              int totalHasilUjiPetikSesuai = _pokokSamples.where((s) => s['hasilUjiPetik'] == 'Sesuai').length;
              int totalHasilUjiPetikTidakSesuai = _pokokSamples.where((s) => s['hasilUjiPetik'] == 'Tidak Sesuai').length;
              int totalPokokTersemprot = _pokokSamples.where((s) => s['tersemprot'] == 'Tersemprot').length;
              int totalPokokTidakTersemprot = _pokokSamples.where((s) => s['tersemprot'] == 'Tidak Tersemprot').length;
              int totalAlatSemprotBaik = _alatSemprotData.values.where((s) => s['kondisiAlat'] == 'Baik dan Lancar').length;
              int totalAlatSemprotTidakLayak = _alatSemprotData.values.where((s) => s['kondisiAlat'] == 'Tidak Baik').length;
              int totalNozelSeragam = _alatSemprotData.values.where((s) => s['keseragamanNozel'] == 'Seragam').length;
              int totalNozelTidakSeragam = _alatSemprotData.values.where((s) => s['keseragamanNozel'] == 'Tidak Seragam').length;

              const List<String> apdRank = [
                'Lengkap',
                'Kurang dari 1 item',
                'Kurang dari 2 item',
                'Kurang dari 3 item',
                'Tidak ada APD',
              ];
              String worstApd = '';
              int worstIndex = -1;

              for (var tabur in _alatSemprotData.values) {
                final apd = tabur['apd'];
                if (apd == null) continue;

                final idx = apdRank.indexOf(apd);
                if (idx > worstIndex) {
                  worstIndex = idx;
                  worstApd = apd;
                }
              }

              await QADatabaseChemist.instance.insertQA({
                'tanggal': summary.tanggalPeriksa,
                'nama_petugas': summary.namaPetugas,
                'kebun': summary.kebun,
                'divisi': summary.divisi,
                'blok': summary.blok,
                'tanggal_semprot': summary.tanggalPenyemprotan,
                'luas': summary.luasan,
                'chemist': summary.chemist,
                'jenis_chemist': summary.jenisChemist,
                'dosis_knapsack': summary.dosis,
                'bahan_herbisida': summary.bahanHerbisida,
                'program_pengendalian_gulma': summary.programPengendalianGulma,
                'kartu_pengambilan_pencampuran': summary.kartuPengambilanPencampuran,
                'kalibrasi_alat_nozel': summary.kalibrasiAlatNozel,
                'gelas_ukur_perkakas': summary.gelasUkurPerkakas,
                'peletakan_alat_semprot': summary.peletakanAlatSemprot,
                'jumlah_pokok': totalSample,
                'total_tenaga_kerja': totalTenagaKerja,
                'total_uji_petik_aktif': totalUjiPetikAktif,
                'total_uji_petik_nonaktif': totalUjiPetikNonAktif,
                'total_uji_petik_sesuai': totalHasilUjiPetikSesuai,
                'total_uji_petik__tidak_sesuai': totalHasilUjiPetikTidakSesuai,
                'total_pokok_tersemprot': totalPokokTersemprot,
                'total_pokok__tidak_tersemprot': totalPokokTidakTersemprot,
                'total_alat_semprot_baik': totalAlatSemprotBaik,
                'total_alat_semprot__tidak_layak': totalAlatSemprotTidakLayak,
                'total_nozel_seragam': totalNozelSeragam,
                'total_nozel_tidak_seragam': totalNozelTidakSeragam,
                'apd_pekerja': worstApd,
                'ringkasan': ringkasan,
                'is_synced': 0,
                'timestamp_sync': null,
              });

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
      appBar: AppBar(title: const Text("QA Chemist")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text("Tanggal Pemeriksaan: $_tanggalPemeriksaan"),
          Text("Tanggal Semprot: $_tanggalSemprot"),
          TextField(controller: _namaPetugasController, decoration: const InputDecoration(labelText: "Nama Petugas")),
          DropdownButtonFormField<String>(
            decoration: const InputDecoration(labelText: "Estate"),
            value: selectedEstate,
            onChanged: isLocked ? null : (val) => setState(() => selectedEstate = val),
            items: estateOptions.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
          ),
          DropdownButtonFormField<String>(
            decoration: const InputDecoration(labelText: "Divisi"),
            value: selectedDivisi,
            onChanged: isLocked ? null : (val) => setState(() => selectedDivisi = val),
            items: divisiOptions.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
          ),
          DropdownButtonFormField<String>(
            decoration: const InputDecoration(labelText: "Blok"),
            value: selectedBlok,
            onChanged: isLocked ? null : (val) => setState(() => selectedBlok = val),
            items: availableBloks.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
          ),
          TextField(controller: _luasanController, decoration: const InputDecoration(labelText: "Luasan (Ha)"), enabled: !isLocked,),
          DropdownButtonFormField<String>(
            decoration: const InputDecoration(labelText: "Chemist"),
            value: selectedChemist,
            onChanged: isLocked ? null : (val) => setState(() => selectedChemist = val),
            items: chemistType.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
          ),
          TextField(controller: _jenisChemist, decoration: const InputDecoration(labelText: "Jenis Chemist yang digunakan"), enabled: !isLocked,),
          TextField(controller: _dosisController, decoration: const InputDecoration(labelText: "Dosis / Knapsack (liter/ha)"), keyboardType: TextInputType.number, enabled: !isLocked,),
          DropdownButtonFormField<String>(
            decoration: const InputDecoration(labelText: "Bahan Herbisida"),
            value: selectedBahanHerbisida,
            onChanged: isLocked ? null : (val) => setState(() => selectedBahanHerbisida = val),
            items: bahanHerbisidaOptions.map((e) => DropdownMenuItem(value: e, child: Text(e, softWrap: true, style: TextStyle(fontSize: 12),))).toList(),
          ),
          DropdownButtonFormField<String>(
            decoration: const InputDecoration(labelText: "Program Pengendalian Gulma"),
            value: selectedProgramGulma,
            onChanged: isLocked ? null : (val) => setState(() => selectedProgramGulma = val),
            items: programGulmaOptions.map((e) => DropdownMenuItem(value: e, child: Text(e, softWrap: true, style: TextStyle(fontSize: 12),))).toList(),
          ),
          DropdownButtonFormField<String>(
            decoration: const InputDecoration(labelText: "Kartu Pengambilan dan Pencampuran"),
            value: selectedKartu,
            onChanged: isLocked ? null : (val) => setState(() => selectedKartu = val),
            items: kartuOptions.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
          ),
          DropdownButtonFormField<String>(
            decoration: const InputDecoration(labelText: "Kalibrasi Alat & Nozel"),
            value: selectedKalibrasi,
            onChanged: isLocked ? null : (val) => setState(() => selectedKalibrasi = val),
            items: kalibrasiOptions.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
          ),
          DropdownButtonFormField<String>(
            decoration: const InputDecoration(labelText: "Gelas Ukur & Perkakas"),
            value: selectedPerkakas,
            onChanged: isLocked ? null : (val) => setState(() => selectedPerkakas = val),
            items: perkakasOptions.map((e) => DropdownMenuItem(value: e, child: Text(e, softWrap: true, style: TextStyle(fontSize: 14),))).toList(),
          ),
          DropdownButtonFormField<String>(
            decoration: const InputDecoration(labelText: "Peletakan Alat Semprot"),
            value: selectedPeletakan,
            onChanged: isLocked ? null : (val) => setState(() => selectedPeletakan = val),
            items: peletakanOptions.map((e) => DropdownMenuItem(value: e, child: Text(e, softWrap: true, style: TextStyle(fontSize: 14),))).toList(),
          ),

          const Divider(),
          const Text("Input Pokok Sample", style: TextStyle(fontWeight: FontWeight.bold)),
          TextField(
            controller: _barisController,
            decoration: const InputDecoration(labelText: "Baris ke-"),
            keyboardType: TextInputType.number,
          ),
          TextField(
                  controller: _namaPetugasSemprotController,
                  decoration: const InputDecoration(labelText: "Nama Tenaga Semprot"),
                  onChanged: (_) {
                    final alatchemist = _alatSemprotData[_tenagaSemprotKey];
                    if (alatchemist != null) {
                      setState(() {
                         selectedAPD = alatchemist['apd'];
                         selectedAlatSemprot = alatchemist['kondisiAlat'];
                         selectedKeseragamanNozel = alatchemist['keseragamanNozel'];
                      });
                    } else {
                      setState(() {
                        
                      });
                    }
                  },
                ),
          DropdownButtonFormField<String>(
            decoration: const InputDecoration(labelText: "Pokok Tersemprot"),
            value: selectedPokokTersemprot,
            onChanged: (val) => setState(() => selectedPokokTersemprot = val),
            items: pokokOptions.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
          ),
          DropdownButtonFormField<String>(
            decoration: const InputDecoration(labelText: "Kondisi Alat Semprot"),
            value: selectedAlatSemprot,
            onChanged: isAlatSemprotLocked ? null : (val) => setState(() => selectedAlatSemprot = val),
            items: alatSemprot.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
          ),
          DropdownButtonFormField<String>(
            decoration: const InputDecoration(labelText: "Keseragaman Nozel"),
            value: selectedKeseragamanNozel,
            onChanged: isAlatSemprotLocked ? null : (val) => setState(() => selectedKeseragamanNozel = val),
            items: keseragamanNozel.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
          ),
          DropdownButtonFormField<String>(
            decoration: const InputDecoration(labelText: "APD Pekerja"),
            value: selectedAPD,
            onChanged: isAlatSemprotLocked ? null : (val) => setState(() => selectedAPD = val),
            items: apdOptions.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
          ),
           const Divider(),
          const Text("Input Sample Uji Petik", style: TextStyle(fontWeight: FontWeight.bold)),
          SwitchListTile(
            title: const Text("Apakah melakukan uji petik?"),
            value: _ujiPetik,
            onChanged: (val) {
              setState(() {
                _ujiPetik = val;
                for (final c in _volumeSampleControllers) {
                  c.dispose();
                }
                _volumeSampleControllers.clear();
                dosisKnapsack = "";
              });
            },
          ),
          if (_ujiPetik) ...[
            TextField(
              controller: _jumlahSampleUjiPetikController,
              decoration: const InputDecoration(labelText: "Jumlah Sample"),
              keyboardType: TextInputType.number,
              onChanged: (_) => setState(() => _updateVolumeSampleControllers()),
            ),
            const SizedBox(height: 8),
            ..._volumeSampleControllers.asMap().entries.map((entry) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: TextField(
                controller: entry.value,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(labelText: "Volume Sample ${entry.key + 1} (ml)"),
                onChanged: (_) => _calculateDosisUjiPetik(),
              ),
            )),
            const SizedBox(height: 8),
            Text("Hasil Uji Petik: $dosisKnapsack", style: const TextStyle(fontWeight: FontWeight.bold)),
          ],
          const SizedBox(height: 8),
          ElevatedButton(
            onPressed: _saveSample,
            style: ElevatedButton.styleFrom(backgroundColor: primaryColor, foregroundColor: Colors.white),
            child: const Text("Save Sample"),
          ),
          if (_pokokSamples.isNotEmpty) ...[
            const Divider(),
            const Text("Daftar Sample:", style: TextStyle(fontWeight: FontWeight.bold)),
            ..._pokokSamples.map((s) => ListTile(
              title: Text("Baris ${s['baris']} - ${s['nama_petugas']}"),
              subtitle: Text("Tersemprot: ${s['tersemprot']}, APD: ${s['apd']}, Alat: ${s['kondisiAlat']}, Nozel: ${s['keseragamanNozel']}"),
          )),
          ],
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {

              _saveAll();

              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Data disimpan")));
            },
            style: ElevatedButton.styleFrom(backgroundColor: primaryColor, foregroundColor: Colors.white),
            child: const Text("Save All"),
          ),
        ]),
     ),
    );
  }
}
