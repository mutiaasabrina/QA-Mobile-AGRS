import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:qa_agronomy/database/qa_database_produksi.dart';
import '../utils/constants.dart';
import 'menu_page.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image/image.dart' as img;
import 'package:permission_handler/permission_handler.dart';
import 'dart:io';


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
  final _lfTinggalTPHController = TextEditingController();
  final _buahTinggalController = TextEditingController();
  final _buahTinggalTPHController = TextEditingController();
  final _komentarController = TextEditingController();


  String? selectedDivisi;
  String? selectedKebun;
  String? selectedBlok;

  String? selectedBeneficialPlant;
  String? selectedPeilscale;

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
  int _lfTinggalTPHCounter = 1; // Counter otomatis LF tinggal TPH
  int _buahTinggalTPHCounter = 1; // Counter otomatis buah tinggal TPH

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
          "QA Produksi\nEstate: $estate\nDivisi: $divisi\nBlok: $blok\nBaris: $barisKe\nPetugas: $petugas\nWaktu: $dateStr\nKeterangan: $komentar";

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

      final filename = 'foto_QA_Produksi_${DateTime.now().millisecondsSinceEpoch}.png';
      final imagePath = '$path/$filename';

      final file = File(imagePath);
      await file.writeAsBytes(img.encodePng(original));

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Foto disimpan di galeri: $imagePath")),
      );

      _komentarController.clear();
    }
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
        "buahDipanen": _buahDipanenController.text.isEmpty ? '0' : _buahDipanenController.text,
        "buahMatangTidakDipanen": _buahMatangTidakDipanenController.text.isEmpty ? '0' : _buahMatangTidakDipanenController.text,
        "buahBusukTidakDipanen": _buahBusukTidakDipanenController.text.isEmpty ? '0' : _buahBusukTidakDipanenController.text,
        "lfTinggal": _lfTinggalController.text.isEmpty ? '0' : _lfTinggalController.text,
        "tphTinggal": _lfTinggalTPHController.text.isEmpty ? '0' : _lfTinggalTPHController.text,
        "buahTinggal": _buahTinggalController.text.isEmpty ? '0' : _buahTinggalController.text,
        "buahTinggalTPH": _buahTinggalTPHController.text.isEmpty ? '0' : _buahTinggalTPHController.text,
        "dropdowns": Map<String, String?>.from(dropdownSelections),
      });

      _pokokCounter++;

      if(_lfTinggalTPHController.text.isNotEmpty && _lfTinggalTPHController.text != '0')
      {
        _lfTinggalTPHCounter++;
      }

      if(_buahTinggalTPHController.text.isNotEmpty && _buahTinggalTPHController.text != '0')
      {
        _buahTinggalTPHCounter++;
      }
      
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
    _lfTinggalTPHController.clear();
    _buahTinggalController.clear();
    _buahTinggalTPHController.clear();
  }

  void _saveAll() async {
    if (_samples.isEmpty ||
        selectedKebun == null ||
        selectedDivisi == null ||
        selectedBlok == null ||
        _namaPetugasController.text.isEmpty ||
        _rotasiController.text.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Lengkapi semua data.")));
      return;
    }
    
    dropdownCounters.clear();

    for (var s in _samples) {
      final drop = s['dropdowns'] as Map<String, String?>?;
      drop?.forEach((key, val) {
        if (val != null) {
          dropdownCounters.update('$key: $val', (v) => v + 1, ifAbsent: () => 1);
        }
      });
    }

    int totalDipanen = _samples.where((s) => s['dipanen'] == true).length;
    int totalBuahDipanen = _samples.fold(0, (sum, s) {int value = int.tryParse(s['buahDipanen'] ?? '0') ?? 0; return sum + value;});
    int totalBuahMatangTidakDipanen = _samples.fold(0, (sum, s) {int value = int.tryParse(s['buahMatangTidakDipanen'] ?? '0') ?? 0; return sum + value;});
    int totalBuahBusukTidakDipanen = _samples.fold(0, (sum, s) {int value = int.tryParse(s['buahBusukTidakDipanen'] ?? '0') ?? 0; return sum + value;});
    int totalLfTinggal = _samples.fold(0, (sum, s) {int value = int.tryParse(s['lfTinggal'] ?? '0') ?? 0; return sum + value;});
    int totalTphTinggal = _samples.fold(0, (sum, s) {int value = int.tryParse(s['tphTinggal'] ?? '0') ?? 0; return sum + value;});
    int totalBuahTinggal = _samples.fold(0, (sum, s) {int value = int.tryParse(s['buahTinggal'] ?? '0') ?? 0; return sum + value;});
    int totalBuahTinggalTPH = _samples.fold(0, (sum, s) {int value = int.tryParse(s['buahTinggalTPH'] ?? '0') ?? 0; return sum + value;});

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
    result.writeln("LF Tinggal (Pr): $totalLfTinggal");
    result.writeln("LF Tinggal (TPH): $totalTphTinggal");
    result.writeln("Buah Tinggal (Pr,PP,Pk,Lp): $totalBuahTinggal\n");
    result.writeln("Buah Tinggal TPH: $totalBuahTinggalTPH\n");
    
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
      'lf_tinggal_tph_counter': _lfTinggalTPHCounter,
      'buah_tinggal': totalBuahTinggal,
      'buah_tinggal_tph': totalBuahTinggalTPH,
      'buah_tinggal_tph_counter': _buahTinggalTPHCounter,
      'is_synced': 0,
      'timestamp_sync': null,
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
      appBar: AppBar(title: const Text("QA Produksi")),
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
            TextField(controller: _lfTinggalController, decoration: const InputDecoration(labelText: "LF Tinggal (Pr,PP,Pk,Lp)")),
            TextField(controller: _lfTinggalTPHController, decoration: const InputDecoration(labelText: "LF Tinggal (TPH)")),
            TextField(controller: _buahTinggalController, decoration: const InputDecoration(labelText: "Buah Tinggal (Pr,PP,Pk,Lp)")),
            TextField(controller: _buahTinggalTPHController, decoration: const InputDecoration(labelText: "Buah Tinggal (TPH)")),
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
                  estate: selectedKebun.toString(),
                  divisi: selectedDivisi.toString(),
                  blok: selectedBlok.toString(),
                  barisKe: _barisController.text,
                  petugas: _namaPetugasController.text,
                  context: context,
                );
              },
            ),
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
                      subtitle: Text("Dipanen: ${p['dipanen'] ? '√' : '✗'}, Buah Panen: ${(int.tryParse(p['buahDipanen'] ?? '0') ?? 0)}, Tidak Panen: ${(int.tryParse(p['buahMatangTidakDipanen'] ?? '0') ?? 0) + (int.tryParse(p['buahBusukTidakDipanen'] ?? '0') ?? 0) + (int.tryParse(p['buahTinggal'] ?? '0') ?? 0)}"),
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