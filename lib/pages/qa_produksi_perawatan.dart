import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:qa_agronomy/database/qa_database.dart';
import '../utils/constants.dart';
import 'menu_page.dart';

class QAProduksiPage extends StatefulWidget {
  const QAProduksiPage({super.key});

  @override
  State<QAProduksiPage> createState() => _QAProduksiPageState();
}

class _QAProduksiPageState extends State<QAProduksiPage> {
  final _namaPetugasController = TextEditingController();
  final _rotasiController = TextEditingController();

  final List<Map<String, dynamic>> _samples = [];
  bool get isLocked => _samples.isNotEmpty;
  final String _tanggalPeriksa = DateFormat('yyyy-MM-dd').format(DateTime.now());

  final _barisController = TextEditingController();
  int pokokCounter = 1;
  bool _dipanen = false;
  final _buahDipanenController = TextEditingController();
  final _buahMatangTidakDipanenController = TextEditingController();
  final _buahBusukTidakDipanenController = TextEditingController();
  final _lfTinggalController = TextEditingController();
  final _tphTinggalController = TextEditingController();
  final _buahTinggalController = TextEditingController();

  String? selectedDivisi;
  String? selectedKebun;
  String? selectedBlok;

  final Map<String, String?> dropdownSelections = {};
  final Map<String, int> dropdownCounters = {};

  final List<String> divisiOptions = ['1', '2', '3', '4', '5'];
  final List<String> kebunOptions = ['Inti', 'Plasma'];

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
      return blokOptions['${selectedKebun}-${selectedDivisi}'] ?? [];
    }
    return [];
  }

  int _pokokCounter = 1; // Counter otomatis untuk pokok

   Widget _buildDropdown(String label, List<String> options, String key) {
    return DropdownButtonFormField<String>(
      decoration: InputDecoration(labelText: label),
      value: dropdownSelections[key],
      onChanged: (val) => setState(() {
        dropdownSelections[key] = val;
      }),
      items: options.map((opt) => DropdownMenuItem(value: opt, child: Text(opt))).toList(),
    );
  }

  void _savePokokSample() {
    if (_barisController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Baris harus diisi.")));
      return;
    }

    setState(() {
      _samples.add({
        "baris": _barisController.text,
        "pokok": _pokokCounter.toString(),
        "dipanen": _dipanen,
        "buahDipanen": _buahDipanenController.text,
        "buahMatangTidakDipanen": _buahMatangTidakDipanenController.text,
        "buahBusukTidakDipanen": _buahBusukTidakDipanenController.text,
        "lfTinggal": _lfTinggalController.text,
        "tphTinggal": _tphTinggalController.text,
        "buahTinggal": _buahTinggalController.text,
        "dropdowns": Map<String, String?>.from(dropdownSelections),
      });
      _pokokCounter++;
      _clearPokokForm();
      dropdownSelections.clear();
    });
  }

  void _clearPokokForm() {
    _barisController.clear();
    _dipanen = false;
    _buahDipanenController.clear();
    _buahMatangTidakDipanenController.clear();
    _buahBusukTidakDipanenController.clear();
    _lfTinggalController.clear();
    _tphTinggalController.clear();
    _buahTinggalController.clear();
  }

  void _saveAll() async {
    if (_samples.isEmpty || selectedKebun == null || selectedDivisi == null || selectedBlok == null || _namaPetugasController.text.isEmpty || _rotasiController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Lengkapi semua data.")));
      return;
    }

    dropdownCounters.clear();
    Map<String, Set<String>> dropdownOptions = {
      "Kondisi Circle": {"Baik", "Semak", "Dominan Anak Sawit", "Dominan Sampah (Berondolan Busuk)"},
      "Kondisi Path": {"Baik", "Tidak Baik"},
      "Kondisi TPH": {"Baik", "Tidak Baik"},
      "Lalang": {"Ada", "Tidak Ada"},
      "Anak Kayu": {"Ada", "Tidak Ada"},
      "Perumpung": {"Ada", "Tidak Ada"},
      "Purun Tikus": {"Ada", "Tidak Ada"},
      "Pakis Udang": {"Ada", "Tidak Ada"},
      "Titi Panen": {"Ada", "Tidak Ada"},
      "Jalan dan Jembatan": {"Baik", "Sedang", "Jelek"},
      "Pruning": {"Baik", "Over", "Sengkleh", "Under"},
      "Susunan Pelepah": {"Rapi", "Tidak Rapi"},
      "Serangan Tikus": {"Ada", "Tidak Ada"},
      "Serangan Rayap": {"Ada", "Tidak Ada"},
      "Thirathaba": {"Ada", "Tidak Ada"},
      "UPDPKS": {"Ada", "Tidak Ada"},
    };

    for (var s in _samples) {
      final drop = s['dropdowns'] as Map<String, String?>?;
      drop?.forEach((key, val) {
        if (val != null) {
          dropdownCounters.update('$key: $val', (v) => v + 1, ifAbsent: () => 1);
        }
      });
    }

    int totalDipanen = _samples.where((s) => s['dipanen'] == true).length;
    int totalBuahDipanen = _samples.fold(0, (sum, s) => sum + int.tryParse(s['buahDipanen'] ?? '0')!);
    int totalBuahMatangTidakDipanen = _samples.fold(0, (sum, s) => sum + int.tryParse(s['buahMatangTidakDipanen'] ?? '0')!);
    int totalBuahBusukTidakDipanen = _samples.fold(0, (sum, s) => sum + int.tryParse(s['buahBusukTidakDipanen'] ?? '0')!);
    int totalLfTinggal = _samples.fold(0, (sum, s) => sum + int.tryParse(s['lfTinggal'] ?? '0')!);
    int totalTphTinggal = _samples.fold(0, (sum, s) => sum + int.tryParse(s['tphTinggal'] ?? '0')!);
    int totalBuahTinggal = _samples.fold(0, (sum, s) => sum + int.tryParse(s['buahTinggal'] ?? '0')!);

    StringBuffer result = StringBuffer();
    result.writeln("Tanggal Periksa: $_tanggalPeriksa");
    result.writeln("Nama Petugas: ${_namaPetugasController.text}");
    result.writeln("Kebun: $selectedKebun");
    result.writeln("Divisi: $selectedDivisi");
    result.writeln("Kode Blok: $selectedBlok");
    result.writeln("Rotasi: ${_rotasiController.text} hari\n");
    result.writeln("Jumlah Pokok Sample: ${_samples.length}");
    result.writeln("Pkk dipanen: $totalDipanen");
    result.writeln("Buah di Panen: $totalBuahDipanen Jjg");
    result.writeln("Buah Matang Tdk di Panen: $totalBuahMatangTidakDipanen Jjg");
    result.writeln("Buah Busuk Tdk di Panen: $totalBuahBusukTidakDipanen Jjg");
    result.writeln("LF Tinggal: $totalLfTinggal");
    result.writeln("LF Tinggal (Pr,PP,TPH): $totalTphTinggal");
    result.writeln("Buah Tinggal (Pr,PP,TPH): $totalBuahTinggal\n");
    result.writeln("== Ringkasan Kondisi ==");

    dropdownOptions.forEach((label, options) {
      result.writeln("$label:");
      for (var opt in options) {
        final key = "$label: $opt";
        final count = dropdownCounters[key] ?? 0;
        result.writeln("  - $opt: $count");
      }
    });
    // Hitung semua kolom dropdown
    Map<String, dynamic> dropdownCounts = {};
    dropdownCounters.forEach((key, value){
      dropdownCounts[key.replaceAll(': ', '_')] = value;
    });

    // Gabung data jadi satu Map
    final qaData = {
      'tanggal': _tanggalPeriksa,
      'nama_petugas': _namaPetugasController.text,
      'kebun': selectedKebun,
      'divisi': selectedDivisi,
      'blok': selectedBlok,
      'rotasi': int.tryParse(_rotasiController.text) ?? 0,
      'jumlah_pokok': _samples.length,
      'pkk_dipanen': totalDipanen,
      'buah_dipanen': totalBuahDipanen,
      'buah_matang_tidak_dipanen': totalBuahMatangTidakDipanen,
      'buah_busuk_tidak_dipanen': totalBuahBusukTidakDipanen,
      'lf_tinggal': totalLfTinggal,
      'lf_tinggal_tph': totalTphTinggal,
      'buah_tinggal': totalBuahTinggal,
      'is_synced': 0,
      'timestamp_sync': null,

      // Ini bagian dropdown counter
      'kondisi_circle_baik': dropdownCounters['Kondisi Circle: Baik'] ?? 0,
      'kondisi_circle_semak': dropdownCounters['Kondisi Circle: Semak'] ?? 0,
      'kondisi_circle_dominan_anak_sawit': dropdownCounters['Kondisi Circle: Dominan Anak Sawit'] ?? 0,
      'kondisi_circle_dominan_sampah': dropdownCounters['Kondisi Circle: Dominan Sampah (Berondolan Busuk)'] ?? 0,
      'kondisi_path_baik': dropdownCounters['Kondisi Path: Baik'] ?? 0,
      'kondisi_path_tidak_baik': dropdownCounters['Kondisi Path: Tidak Baik'] ?? 0,
      'kondisi_tph_baik': dropdownCounters['Kondisi TPH: Baik'] ?? 0,
      'kondisi_tph_tidak_baik': dropdownCounters['Kondisi TPH: Tidak Baik'] ?? 0,
      'lalang_ada': dropdownCounters['Lalang: Ada'] ?? 0,
      'lalang_tidak_ada': dropdownCounters['Lalang: Tidak Ada'] ?? 0,
      'anak_kayu_ada': dropdownCounters['Anak Kayu: Ada'] ?? 0,
      'anak_kayu_tidak_ada': dropdownCounters['Anak Kayu: Tidak Ada'] ?? 0,
      'perumpung_ada': dropdownCounters['Perumpung: Ada'] ?? 0,
      'perumpung_tidak_ada': dropdownCounters['Perumpung: Tidak Ada'] ?? 0,
      'purun_tikus_ada': dropdownCounters['Purun Tikus: Ada'] ?? 0,
      'purun_tikus_tidak_ada': dropdownCounters['Purun Tikus: Tidak Ada'] ?? 0,
      'pakis_udang_ada': dropdownCounters['Pakis Udang: Ada'] ?? 0,
      'pakis_udang_tidak_ada': dropdownCounters['Pakis Udang: Tidak Ada'] ?? 0,
      'titi_panen_ada': dropdownCounters['Titi Panen: Ada'] ?? 0,
      'titi_panen_tidak_ada': dropdownCounters['Titi Panen: Tidak Ada'] ?? 0,
      'jalan_dan_jembatan_baik': dropdownCounters['Jalan dan Jembatan: Baik'] ?? 0,
      'jalan_dan_jembatan_sedang': dropdownCounters['Jalan dan Jembatan: Sedang'] ?? 0,
      'jalan_dan_jembatan_jelek': dropdownCounters['Jalan dan Jembatan: Jelek'] ?? 0,
      'pruning_baik': dropdownCounters['Pruning: Baik'] ?? 0,
      'pruning_over': dropdownCounters['Pruning: Over'] ?? 0,
      'pruning_sengkleh': dropdownCounters['Pruning: Sengkleh'] ?? 0,
      'pruning_under': dropdownCounters['Pruning: Under'] ?? 0,
      'susunan_pelepah_rapi': dropdownCounters['Susunan Pelepah: Rapi'] ?? 0,
      'susunan_pelepah_tidak_rapi': dropdownCounters['Susunan Pelepah: Tidak Rapi'] ?? 0,
      'serangan_tikus_ada': dropdownCounters['Serangan Tikus: Ada'] ?? 0,
      'serangan_tikus_tidak_ada': dropdownCounters['Serangan Tikus: Tidak Ada'] ?? 0,
      'serangan_rayap_ada': dropdownCounters['Serangan Rayap: Ada'] ?? 0,
      'serangan_rayap_tidak_ada': dropdownCounters['Serangan Rayap: Tidak Ada'] ?? 0,
      'thirathaba_ada': dropdownCounters['Thirathaba: Ada'] ?? 0,
      'thirathaba_tidak_ada': dropdownCounters['Thirathaba: Tidak Ada'] ?? 0,
      'updpks_ada': dropdownCounters['UPDPKS: Ada'] ?? 0,
      'updpks_tidak_ada': dropdownCounters['UPDPKS: Tidak Ada'] ?? 0,
    };
    await QADatabase.instance.insertQA(qaData);

     showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Data Overview"),
        content: SingleChildScrollView(child: Text(result.toString())),
        actions: [
          TextButton(
            onPressed: () {
              setState(() {
                _samples.clear();
                _pokokCounter = 1;
                dropdownSelections.clear();
              });
              Navigator.of(context).popUntil((route) => route.isFirst);
              Navigator.push(context, MaterialPageRoute(builder: (context) => const MenuPage()));
            },
            child: const Text("OK"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("QA Produksi & Perawatan")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Tanggal Periksa: $_tanggalPeriksa", style: const TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            TextField(controller: _namaPetugasController, decoration: const InputDecoration(labelText: "Nama Petugas")),
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(labelText: "Kebun"),
              value: selectedKebun,
              onChanged: isLocked ? null : (val) => setState(() {
                setState(() {
                  selectedKebun = val;
                  selectedDivisi = null;
                  selectedBlok = null;
                });
                
              }),              
              items: kebunOptions.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
            ),
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(labelText: "Divisi"),
              value: selectedDivisi,
              onChanged: isLocked ? null : (val) => setState(() {
                setState(() {
                  selectedDivisi = val;
                selectedBlok = null;
                });
    
              }),
              items: divisiOptions.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
            ),
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(labelText: "Kode Blok"),
              value: selectedBlok,
              onChanged: isLocked ? null : (val) => setState(() => selectedBlok = val),
              items: availableBloks.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
            ),
            TextField(
              controller: _rotasiController,
              decoration: const InputDecoration(labelText: "Rotasi (hari)"),
              enabled: !isLocked,
            ),
            const Divider(),
            const Text("Masukkan Pokok Sample", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            TextField(controller: _barisController, decoration: const InputDecoration(labelText: "Baris ke-")),
            Row(
              children: [
                Checkbox(value: _dipanen, onChanged: (val) => setState(() => _dipanen = val ?? false)),
                const Text("Pkk di Panen")
              ],
            ),
            TextField(controller: _buahDipanenController, decoration: const InputDecoration(labelText: "Buah di Panen (Mtg/Bsk)")),
            TextField(controller: _buahMatangTidakDipanenController, decoration: const InputDecoration(labelText: "Buah Matang Tidak di Panen (Jjg)")),
            TextField(controller: _buahBusukTidakDipanenController, decoration: const InputDecoration(labelText: "Buah Busuk Tidak di Panen (Jjg)")),
            TextField(controller: _lfTinggalController, decoration: const InputDecoration(labelText: "LF Tinggal (pr,pk,lp,pp)")),
            TextField(controller: _tphTinggalController, decoration: const InputDecoration(labelText: "LF Tinggal (TPH)")),
            TextField(controller: _buahTinggalController, decoration: const InputDecoration(labelText: "Buah Tinggal (pr,pk,lp,pp)")),
            const Divider(),
            _buildDropdown("Kondisi Circle", ["Baik", "Semak", "Dominan Anak Sawit", "Dominan Sampah (Berondolan Busuk)"], "Kondisi Circle"),
            _buildDropdown("Kondisi Path", ["Baik", "Tidak Baik"], "Kondisi Path"),
            _buildDropdown("Kondisi TPH", ["Baik", "Tidak Baik"], "Kondisi TPH"),
            _buildDropdown("Lalang", ["Ada", "Tidak Ada"], "Lalang"),
            _buildDropdown("Anak Kayu", ["Ada", "Tidak Ada"], "Anak Kayu"),
            _buildDropdown("Perumpung", ["Ada", "Tidak Ada"], "Perumpung"),
            _buildDropdown("Purun Tikus", ["Ada", "Tidak Ada"], "Purun Tikus"),
            _buildDropdown("Pakis Udang", ["Ada", "Tidak Ada"], "Pakis Udang"),
            _buildDropdown("Titi Panen", ["Ada", "Tidak Ada"], "Titi Panen"),
            _buildDropdown("Jalan dan Jembatan", ["Baik", "Sedang", "Jelek"], "Jalan dan Jembatan"),
            _buildDropdown("Pruning", ["Baik", "Over", "Sengkleh", "Under"], "Pruning"),
            _buildDropdown("Susunan Pelepah", ["Rapi", "Tidak Rapi"], "Susunan Pelepah"),
            _buildDropdown("Serangan Tikus", ["Ada", "Tidak Ada"], "Serangan Tikus"),
            _buildDropdown("Serangan Rayap", ["Ada", "Tidak Ada"], "Serangan Rayap"),
            _buildDropdown("Thirathaba", ["Ada", "Tidak Ada"], "Thirathaba"),
            _buildDropdown("UPDPKS", ["Ada", "Tidak Ada"], "UPDPKS"),
             const SizedBox(height: 16),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: primaryColor, foregroundColor: Colors.white),
              onPressed: _savePokokSample,
              child: const Text("Save Pokok Sample"),
            ),
            const SizedBox(height: 16),
            const Divider(),
            const Text("Daftar Sample Yang Sudah Diinput", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            if (_samples.isEmpty)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 8.0),
                child: Text("Belum ada sample yang diinput."),
              )
            else
              Column(
                children: _samples.map((p) => ListTile(
                      title: Text("Baris: ${p['baris']} - Pokok: ${p['pokok']}"),
                      subtitle: Text("Dipanen: ${p['dipanen'] ? '√' : '✗'}, Buah Panen: ${p['buahDipanen']}, Tidak Panen: ${int.tryParse(p['buahMatangTidakDipanen'] ?? '0')! + int.tryParse(p['buahBusukTidakDipanen'] ?? '0')!}"),
                    )).toList(),
              ),
            const SizedBox(height: 16),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: primaryColor, foregroundColor: Colors.white),
              onPressed: _saveAll,
              child: const Text("Save All"),
            ),
          ],
        ),
      ),
    );
  }
}