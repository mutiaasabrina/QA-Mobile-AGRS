import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../utils/constants.dart';

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

   String get _tenagaSemprotKey => "${_namaPetugasSemprotController.text.trim()}|${selectedBlok ??''}|$_tanggalSemprot";

  final List<Map<String, dynamic>> _pokokSamples = [];
  bool get isLocked => _pokokSamples.isNotEmpty;

  bool _ujiPetik = false;
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
    _volumeSampleControllers = List.generate(jumlah, (index) => TextEditingController());
    dosisKnapsack = "";
  }

  void _calculateDosisUjiPetik() {
    if (_dosisController.text.isEmpty) return;
    final double target = double.tryParse(_dosisController.text) ?? 0;
    final double total = _volumeSampleControllers.fold(0.0, (sum, c) => sum + (double.tryParse(c.text) ?? 0));
    final double rata2 = total / (_volumeSampleControllers.length == 0 ? 1 : _volumeSampleControllers.length);
    final selisih = (rata2 - target).abs();
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
          TextField(controller: _dosisController, decoration: const InputDecoration(labelText: "Dosis / Knapsack (liter/ha)"), keyboardType: TextInputType.number),
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
            controller: _namaPetugasSemprotController, decoration: const InputDecoration(labelText: "Nama Petugas Semprot"),
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
            onChanged: (val) => setState(() => selectedAlatSemprot = val),
            items: alatSemprot.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
          ),
          DropdownButtonFormField<String>(
            decoration: const InputDecoration(labelText: "Keseragaman Nozel"),
            value: selectedKeseragamanNozel,
            onChanged: (val) => setState(() => selectedKeseragamanNozel = val),
            items: keseragamanNozel.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
          ),
          DropdownButtonFormField<String>(
            decoration: const InputDecoration(labelText: "APD Pekerja"),
            value: selectedAPD,
            onChanged: (val) => setState(() => selectedAPD = val),
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
            onPressed: () {
              if (_barisController.text.isNotEmpty && _namaPetugasSemprotController.text.isNotEmpty && selectedPokokTersemprot != null && selectedAPD != null) {
                setState(() {
                  _pokokSamples.add({
                    'baris': _barisController.text,
                    'nama_petugas': _namaPetugasSemprotController.text,
                    'tersemprot': selectedPokokTersemprot,
                    'apd': selectedAPD,
                  });
                  _barisController.clear();
                  _namaPetugasSemprotController.clear();
                  selectedPokokTersemprot = null;
                  selectedAPD = null;
                });
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Sample berhasil ditambahkan")));
              } else {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Lengkapi semua data sample")));
              }
            },
            child: const Text("Save Sample"),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              // TODO: simpan semua data form + sample ke DB
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
