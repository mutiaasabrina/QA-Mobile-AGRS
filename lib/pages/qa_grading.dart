import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:qa_agronomy/database/qa_database_grading.dart';
import '../utils/constants.dart';
import 'menu_page.dart';
import 'qa_grading_summary.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image/image.dart' as img;
import 'package:permission_handler/permission_handler.dart';
import 'dart:io';


class QAGradingPage extends StatefulWidget {
  const QAGradingPage({super.key});

  @override
  State<QAGradingPage> createState() => _QAGradingPageState();
}

class _QAGradingPageState extends State<QAGradingPage> {
  final _namaPetugasController = TextEditingController();

  final _varietasController = TextEditingController();
  final _tahunTanamController = TextEditingController();

  final _buahAMController = TextEditingController();
  final _bjrAMController = TextEditingController();
  final _buahBMController = TextEditingController();
  final _bjrBMController = TextEditingController();
  final _buahCMController = TextEditingController();
  final _bjrCMController = TextEditingController();
  final _buahDMController = TextEditingController();
  final _bjrDMController = TextEditingController();

  final _buahAMatController = TextEditingController();
  final _bjrAMatController = TextEditingController();
  final _buahBMatController = TextEditingController();
  final _bjrBMatController = TextEditingController();
  final _buahCMatController = TextEditingController();
  final _bjrCMatController = TextEditingController();
  final _buahDMatController = TextEditingController();
  final _bjrDMatController = TextEditingController();

  final _buahMentahKecilController = TextEditingController();
  final _buahMatangKecilController = TextEditingController();

  final List<Map<String, dynamic>> _samples = [];
  bool get isLocked => _samples.isNotEmpty;
  final String _tanggalPeriksa = DateFormat('yyyy-MM-dd').format(DateTime.now());

  int TPHCounter = 1;
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
      return blokOptions['${selectedKebun!}-${selectedDivisi!}'] ?? [];
    }
    return [];
  }

  // Helper for watermark text wrapping
  List<String> wrapText(String text, int maxCharsPerLine) {
    final words = text.split(' ');
    List<String> lines = [];
    String current = '';
    for (var w in words) {
      if ((current + ' ' + w).trim().length <= maxCharsPerLine) {
        current += ' $w';
      } else {
        lines.add(current.trim());
        current = w;
      }
    }
    if (current.isNotEmpty) lines.add(current.trim());
    return lines;
  }

  int getMaxLineWidth(List<String> lines, int avgCharWidth) =>
      lines.map((l) => l.length * avgCharWidth).reduce((a, b) => a > b ? a : b);

  // Camera + watermark method (only includes the fields you need)
  Future<void> ambilFotoDenganWatermark(BuildContext context) async {
    if (_komentarController.text.isEmpty) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("Keterangan foto harus diisi")));
      return;
    }

    final picker = ImagePicker();
    await Permission.camera.request();
    await Permission.storage.request();

    final picked = await picker.pickImage(source: ImageSource.camera);
    if (picked == null) return;

    final rawImg = File(picked.path);
    final original = img.decodeImage(await rawImg.readAsBytes());
    if (original == null) return;

    final now = DateFormat('dd/MM/yyyy HH:mm:ss').format(DateTime.now());
    final watermarkText = StringBuffer()
      ..writeln("QA Grading")
      ..writeln("Estate: ${selectedKebun ?? ''}")
      ..writeln("Divisi: ${selectedDivisi ?? ''}")
      ..writeln("Blok: ${selectedBlok ?? ''}")
      ..writeln("Petugas: ${_namaPetugasController.text}")
      ..writeln("Waktu: $now")
      ..writeln("Keterangan: ${_komentarController.text}");

    final font = img.arial48;
    final maxW = (original.width * 0.5).toInt();
    final avgChar = font.lineHeight ~/ 2;
    final maxChars = maxW ~/ avgChar;

    final lines = <String>[];
    watermarkText.toString().split('\n').forEach((l) => lines.addAll(wrapText(l, maxChars)));

    final textW = getMaxLineWidth(lines, avgChar);
    final textH = lines.length * font.lineHeight;

    final x = original.width - textW - 30;
    final y = original.height - textH - 30;

    img.fillRect(original,
        x1: x - 10, y1: y - 10, x2: x + textW + 10, y2: y + textH + 10,
        color: img.ColorRgba8(0, 0, 0, 150));

    for (int i = 0; i < lines.length; i++) {
      img.drawString(original,
          font: font, x: x, y: y + i * font.lineHeight,
          lines[i], color: img.ColorRgb8(255, 255, 255));
    }

    final dir = Directory('/storage/emulated/0/DCIM/QA_Agronomy');
    if (!await dir.exists()) await dir.create(recursive: true);
    final filename = 'foto_QA_Grading_${DateTime.now().millisecondsSinceEpoch}.png';
    await File('${dir.path}/$filename').writeAsBytes(img.encodePng(original));

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Foto disimpan di galeri: ${dir.path}/$filename")),
    );

    _komentarController.clear();
  }

  void _saveTPHSample() {
    if (_namaPetugasController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Lengkapi Data.")),
      );
      return;
    }

  setState(() {
    // Parse mentah values (>3kg)
    final int buahAMentah = int.tryParse(_buahAMController.text) ?? 0;
    final int buahBMentah = int.tryParse(_buahBMController.text) ?? 0;
    final int buahCMentah = int.tryParse(_buahCMController.text) ?? 0;
    final int buahDMentah = int.tryParse(_buahDMController.text) ?? 0;

    // Parse BJR mentah values
    final double bjrAMentah = double.tryParse(_bjrAMController.text) ?? 0.0;
    final double bjrBMentah = double.tryParse(_bjrBMController.text) ?? 0.0;
    final double bjrCMentah = double.tryParse(_bjrCMController.text) ?? 0.0;
    final double bjrDMentah = double.tryParse(_bjrDMController.text) ?? 0.0;

    // Parse matang values (>3kg)
    final int buahAMatang = int.tryParse(_buahAMatController.text) ?? 0;
    final int buahBMatang = int.tryParse(_buahBMatController.text) ?? 0;
    final int buahCMatang = int.tryParse(_buahCMatController.text) ?? 0;
    final int buahDMatang = int.tryParse(_buahDMatController.text) ?? 0;

    // Parse BJR matang values
    final double bjrAMatang = double.tryParse(_bjrAMatController.text) ?? 0.0;
    final double bjrBMatang = double.tryParse(_bjrBMatController.text) ?? 0.0;
    final double bjrCMatang = double.tryParse(_bjrCMatController.text) ?? 0.0;
    final double bjrDMatang = double.tryParse(_bjrDMatController.text) ?? 0.0;

    // Parse <3kg
    final int buahMentahKecil = int.tryParse(_buahMentahKecilController.text) ?? 0;
    final int buahMatangKecil = int.tryParse(_buahMatangKecilController.text) ?? 0;

    // Total buah matang & mentah
    final int totalBuahMatang = buahAMatang + buahBMatang + buahCMatang + buahDMatang + buahMatangKecil;
    final int totalBuahMentah = buahAMentah + buahBMentah + buahCMentah + buahDMentah + buahMentahKecil;

    _samples.add({
      "TPH": TPHCounter.toString(),

      // Individual if you still want to store them
      "buahAMentah": buahAMentah.toString(),
      "bjrBuahAMentah": bjrAMentah.toStringAsFixed(2),
      "buahBMentah": buahBMentah.toString(),
      "bjrBuahBMentah": bjrBMentah.toStringAsFixed(2),
      "buahCMentah": buahCMentah.toString(),
      "bjrBuahCMentah": bjrCMentah.toStringAsFixed(2),
      "buahDMentah": buahDMentah.toString(),
      "bjrBuahDMentah": bjrDMentah.toStringAsFixed(2),

      "buahAMatang": buahAMatang.toString(),
      "bjrBuahAMatang": bjrAMatang.toStringAsFixed(2),
      "buahBMatang": buahBMatang.toString(),
      "bjrBuahBMatang": bjrBMatang.toStringAsFixed(2),
      "buahCMatang": buahCMatang.toString(),
      "bjrBuahCMatang": bjrCMatang.toStringAsFixed(2),
      "buahDMatang": buahDMatang.toString(),
      "bjrBuahDMatang": bjrDMatang.toStringAsFixed(2),

      "buahMentahKecil": buahMentahKecil.toString(),
      "buahMatangKecil": buahMatangKecil.toString(),

      // Totals
      "totalBuahMentah": totalBuahMentah.toString(),
      "totalBuahMatang": totalBuahMatang.toString(),
    });

    TPHCounter++;

    _buahAMController.clear();
    _bjrAMController.clear();
    _buahBMController.clear();
    _bjrBMController.clear();
    _buahCMController.clear();
    _bjrCMController.clear();
    _buahDMController.clear();
    _bjrDMController.clear();

    _buahAMatController.clear();
    _bjrAMatController.clear();
    _buahBMatController.clear();
    _bjrBMatController.clear();
    _buahCMatController.clear();
    _bjrCMatController.clear();
    _buahDMatController.clear();
    _bjrDMatController.clear();

    _buahMentahKecilController.clear();
    _buahMatangKecilController.clear();
  });
  }

  // Save All function
  void _saveAll() async {
    if (_samples.isEmpty ||
        selectedKebun == null ||
        selectedDivisi == null ||
        selectedBlok == null ||
        _namaPetugasController.text.isEmpty ||
        _varietasController.text.isEmpty ||
        _tahunTanamController.text.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Lengkapi semua data.")));
      return;
    }

    int totalTPH = _samples.where((s) => s['TPH'] == true).length;
    double totalBuahAMentah = _samples.fold(0, (sum, s) {double value = double.tryParse(s['buahAMentah'] ?? '0') ?? 0; return sum + value;});
    double totalBjrAMentah = _samples.fold(0, (sum, s) {double value = double.tryParse(s['bjrBuahAMentah'] ?? '0') ?? 0; return sum + value;});
    double totalBuahBMentah = _samples.fold(0, (sum, s) {double value = double.tryParse(s['buahBMentah'] ?? '0') ?? 0; return sum + value;});
    double totalBjrBMentah = _samples.fold(0, (sum, s) {double value = double.tryParse(s['bjrBuahBMentah'] ?? '0') ?? 0; return sum + value;});
    double totalBuahCMentah = _samples.fold(0, (sum, s) {double value = double.tryParse(s['buahCMentah'] ?? '0') ?? 0; return sum + value;});
    double totalBjrCMentah = _samples.fold(0, (sum, s) {double value = double.tryParse(s['bjrBuahCMentah'] ?? '0') ?? 0; return sum + value;});
    double totalBuahDMentah = _samples.fold(0, (sum, s) {double value = double.tryParse(s['buahDMentah'] ?? '0') ?? 0; return sum + value;});
    double totalBjrDMentah = _samples.fold(0, (sum, s) {double value = double.tryParse(s['bjrBuahDMentah'] ?? '0') ?? 0; return sum + value;});

    double totalBuahAMatang = _samples.fold(0, (sum, s) {double value = double.tryParse(s['buahAMatang'] ?? '0') ?? 0; return sum + value;});
    double totalBjrAMatang = _samples.fold(0, (sum, s) {double value = double.tryParse(s['bjrBuahAMatang'] ?? '0') ?? 0; return sum + value;});
    double totalBuahBMatang = _samples.fold(0, (sum, s) {double value = double.tryParse(s['buahBMatang'] ?? '0') ?? 0; return sum + value;});
    double totalBjrBMatang = _samples.fold(0, (sum, s) {double value = double.tryParse(s['bjrBuahBMatang'] ?? '0') ?? 0; return sum + value;});
    double totalBuahCMatang = _samples.fold(0, (sum, s) {double value = double.tryParse(s['buahCMatang'] ?? '0') ?? 0; return sum + value;});
    double totalBjrCMatang = _samples.fold(0, (sum, s) {double value = double.tryParse(s['bjrBuahCMatang'] ?? '0') ?? 0; return sum + value;});
    double totalBuahDMatang = _samples.fold(0, (sum, s) {double value = double.tryParse(s['buahDMatang'] ?? '0') ?? 0; return sum + value;});
    double totalBjrDMatang = _samples.fold(0, (sum, s) {double value = double.tryParse(s['bjrBuahDMatang'] ?? '0') ?? 0; return sum + value;});

    int totalBuahMentahKecil = _samples.fold(0, (sum, s) {int value = int.tryParse(s['buahMentahKecil'] ?? '0') ?? 0; return sum + value;});
    int totalBuahMatangKecil = _samples.fold(0, (sum, s) {int value = int.tryParse(s['buahMatangKecil'] ?? '0') ?? 0; return sum + value;});

    int totalBuahMentah = _samples.fold(0, (sum, s) {int value = int.tryParse(s['totalBuahMentah'] ?? '0') ?? 0; return sum + value;});
    int totalBuahMatang = _samples.fold(0, (sum, s) {int value = int.tryParse(s['totalBuahMatang'] ?? '0') ?? 0; return sum + value;});

    final summary = QAGradingSummary(
      tanggalPeriksa: _tanggalPeriksa,
      namaPetugas: _namaPetugasController.text,
      kebun: selectedKebun ?? '',
      divisi: selectedDivisi ?? '',
      blok: selectedBlok ?? '',
      varietas: _varietasController.text,
      tahunTanam: _tahunTanamController.text,
      totalTPH: totalTPH,
      totalBuahAMentah: totalBuahAMentah,
      totalBjrAMentah: totalBjrAMentah,
      totalBuahBMentah: totalBuahBMentah,
      totalBjrBMentah: totalBjrBMentah,
      totalBuahCMentah: totalBuahCMentah,
      totalBjrCMentah: totalBjrCMentah,
      totalBuahDMentah: totalBuahDMentah,
      totalBjrDMentah: totalBjrDMentah,
      totalBuahAMatang: totalBuahAMatang,
      totalBjrAMatang: totalBjrAMatang,
      totalBuahBMatang: totalBuahBMatang,
      totalBjrBMatang: totalBjrBMatang,
      totalBuahCMatang: totalBuahCMatang,
      totalBjrCMatang: totalBjrCMatang,
      totalBuahDMatang: totalBuahDMatang,
      totalBjrDMatang: totalBjrDMatang,
      totalBuahMentahKecil: totalBuahMentahKecil,
      totalBuahMatangKecil: totalBuahMatangKecil,
      totalBuahMentah: totalBuahMentah,
      totalBuahMatang: totalBuahMatang,
    );

    final ringkasan = generateRingkasanText(summary);

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
      title: const Text("Ringkasan QA Grading"),
        content: SingleChildScrollView(child: Text(ringkasan)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Batal"),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(context);

              await QADatabaseGrading.instance.insertQA({
                'tanggal': summary.tanggalPeriksa,
                'nama_petugas': summary.namaPetugas,
                'kebun': summary.kebun,
                'divisi': summary.divisi,
                'blok': summary.blok,
                'varietas': summary.varietas,
                'tahun_tanam': summary.tahunTanam,
                'buah_a_mentah': summary.totalBuahAMentah,
                'bjr_buah_a_mentah': summary.totalBjrAMentah,
                'buah_b_mentah': summary.totalBuahBMentah,
                'bjr_buah_b_mentah': summary.totalBjrBMentah,
                'buah_c_mentah': summary.totalBuahCMentah,
                'bjr_buah_c_mentah': summary.totalBjrCMentah,
                'buah_d_mentah': summary.totalBuahDMentah,
                'bjr_buah_d_mentah': summary.totalBjrDMentah,
                'buah_a_matang': summary.totalBuahAMatang,
                'bjr_buah_a_matang': summary.totalBjrAMatang,
                'buah_b_matang': summary.totalBuahBMatang,
                'bjr_buah_b_matang': summary.totalBjrBMatang,
                'buah_c_matang': summary.totalBuahCMatang,
                'bjr_buah_c_matang': summary.totalBjrCMatang,
                'buah_d_matang': summary.totalBuahDMatang,
                'bjr_buah_d_matang': summary.totalBjrDMatang,
                'buah_kurang3kg_mentah': summary.totalBuahMentahKecil,
                'buah_kurang3kg_matang': summary.totalBuahMatangKecil,
                'total_buah_mentah': summary.totalBuahMentah,
                'total_buah_matang': summary.totalBuahMatang,
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
      appBar: AppBar(title: const Text("QA Grading")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(12),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text("Tanggal Pemeriksaan: $_tanggalPeriksa", style: const TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          TextField(controller: _namaPetugasController, decoration: const InputDecoration(labelText: "Nama Petugas"), enabled: !isLocked,),
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(labelText: "Kebun"),
              value: selectedKebun,
              onChanged: isLocked ? null : (val) => setState(() {
                selectedKebun = val;
                selectedDivisi = null;
                selectedBlok = null;
              }),
              items: kebunOptions.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
            ),
          DropdownButtonFormField<String>(
            decoration: const InputDecoration(labelText: "Divisi"),
            value: selectedDivisi,
            onChanged: isLocked ? null : (val) => setState(() {
              selectedDivisi = val; 
              selectedBlok = null;
            }),
            items: divisiOptions.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
          ),
          DropdownButtonFormField<String>(
            decoration: const InputDecoration(labelText: "Blok"),
            value: selectedBlok,
            onChanged: isLocked ? null : (val) => setState(() => selectedBlok = val),
            items: availableBloks.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
          ),
          const Divider(),
          TextField(controller: _varietasController, decoration: const InputDecoration(labelText: "Varietas")),
          TextField(controller: _tahunTanamController, decoration: const InputDecoration(labelText: "Tahun Tanam")),
          const Divider(),
          const Text("Buah Mentah", style: TextStyle(fontWeight: FontWeight.bold)),
          TextField(controller: _buahAMController, decoration: const InputDecoration(labelText: "Buah A Mentah")),
          TextField(controller: _bjrAMController, decoration: const InputDecoration(labelText: "BJR Buah A Mentah")),
          TextField(controller: _buahBMController, decoration: const InputDecoration(labelText: "Buah B Mentah")),
          TextField(controller: _bjrBMController, decoration: const InputDecoration(labelText: "BJR Buah B Mentah")),
          TextField(controller: _buahCMController, decoration: const InputDecoration(labelText: "Buah C Mentah")),
          TextField(controller: _bjrCMController, decoration: const InputDecoration(labelText: "BJR Buah C Mentah")),
          TextField(controller: _buahDMController, decoration: const InputDecoration(labelText: "Buah D Mentah")),
          TextField(controller: _bjrDMController, decoration: const InputDecoration(labelText: "BJR Buah D Mentah")),
          const Divider(),
          const Text("Buah Matang", style: TextStyle(fontWeight: FontWeight.bold)),
          TextField(controller: _buahAMatController, decoration: const InputDecoration(labelText: "Buah A Matang")),
          TextField(controller: _bjrAMatController, decoration: const InputDecoration(labelText: "BJR Buah A Matang")),
          TextField(controller: _buahBMatController, decoration: const InputDecoration(labelText: "Buah B Matang")),
          TextField(controller: _bjrBMatController, decoration: const InputDecoration(labelText: "BJR Buah B Matang")),
          TextField(controller: _buahCMatController, decoration: const InputDecoration(labelText: "Buah C Matang")),
          TextField(controller: _bjrCMatController, decoration: const InputDecoration(labelText: "BJR Buah C Matang")),
          TextField(controller: _buahDMatController, decoration: const InputDecoration(labelText: "Buah D Matang")),
          TextField(controller: _bjrDMatController, decoration: const InputDecoration(labelText: "BJR Buah D Matang")),
          const Divider(),
          const Text("Buah < 3 kg", style: TextStyle(fontWeight: FontWeight.bold)),
          TextField(controller: _buahMentahKecilController, decoration: const InputDecoration(labelText: "Buah < 3 kg Mentah")),
          TextField(controller: _buahMatangKecilController, decoration: const InputDecoration(labelText: "Buah < 3 kg Matang")),
          const Divider(),
          TextField(
            controller: _komentarController,
            decoration: InputDecoration(labelText: 'Keterangan Foto', border: OutlineInputBorder()),
            maxLines: 3,
          ),
          const SizedBox(height: 8),
          ElevatedButton.icon(
            onPressed: () => ambilFotoDenganWatermark(context),
            icon: const Icon(Icons.camera_alt),
            label: const Text("Ambil Foto"),
            style: ElevatedButton.styleFrom(backgroundColor: primaryColor, foregroundColor: Colors.white),
          ),
          const SizedBox(height: 16),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: primaryColor, foregroundColor: Colors.white),
              onPressed: _saveTPHSample,
              child: const Text("Save TPH Sample"),
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
                children: _samples.map((sample) => ListTile(
                      title: Text("TPH: ${sample['TPH']}"),
                      subtitle: Text(
                        "Total Buah Matang: ${sample['totalBuahMatang']}\n"
                        "Total Buah Mentah: ${sample['totalBuahMentah']}\n"
                        "Matang <3kg: ${sample['buahMatangKecil']}, Mentah <3kg: ${sample['buahMentahKecil']}"
                      ),
                    )).toList(),
              ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: _saveAll,
            child: const Text("Save All"),
            style: ElevatedButton.styleFrom(backgroundColor: primaryColor, foregroundColor: Colors.white),
          ),
        ]),
      ),
    );
  }
}

