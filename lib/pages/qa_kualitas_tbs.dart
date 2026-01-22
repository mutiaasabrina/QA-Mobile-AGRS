import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:qa_agronomy/database/qa_database_grading.dart';
import '../utils/constants.dart';
import 'menu_page.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image/image.dart' as img;
import 'package:permission_handler/permission_handler.dart';
import 'dart:io';


class QAKualitasTBSPage extends StatefulWidget {
  const QAKualitasTBSPage({super.key});

  @override
  State<QAKualitasTBSPage> createState() => _QAKualitasTBSPageState();
}

class _QAKualitasTBSPageState extends State<QAKualitasTBSPage> {
  // ===================== CONTROLLER =====================
  final _namaPetugasController = TextEditingController();
  final _varietasController = TextEditingController();
  final _tahunTanamController = TextEditingController();
  final _komentarController = TextEditingController();

  final _mentahTPHController = TextEditingController();
  final _masakTPHController = TextEditingController();
  final _overripeTPHController = TextEditingController();
  final _busukkosongTPHController = TextEditingController();
  final _abnormalTPHController = TextEditingController();

  // ===================== STATE =====================
  final List<Map<String, dynamic>> _samples = [];
  bool get isLocked => _samples.isNotEmpty;

  final String _tanggalPeriksa =
      DateFormat('yyyy-MM-dd').format(DateTime.now());

  int TPHCounter = 1;

  String? selectedKebun;
  String? selectedDivisi;
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

  // ===================== FOTO + WATERMARK =====================
  Future<void> ambilFotoDenganWatermark(BuildContext context) async {
    if (_komentarController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Keterangan foto harus diisi")),
      );
      return;
    }

    final picker = ImagePicker();
    await Permission.camera.request();
    await Permission.storage.request();

    final picked = await picker.pickImage(source: ImageSource.camera);
    if (picked == null) return;

    final raw = File(picked.path);
    final image = img.decodeImage(await raw.readAsBytes());
    if (image == null) return;

    final now = DateFormat('dd/MM/yyyy HH:mm:ss').format(DateTime.now());

    final text = """
QA Kualitas TBS
Estate : ${selectedKebun ?? ''}
Divisi : ${selectedDivisi ?? ''}
Blok   : ${selectedBlok ?? ''}
Petugas: ${_namaPetugasController.text}
Waktu  : $now
Ket    : ${_komentarController.text}
""";

    final font = img.arial48;
    img.drawString(
      image,
      text,
      font: font,
      x: 20,
      y: image.height - 300,
      color: img.ColorRgb8(255, 255, 255),
    );

    final dir = Directory('/storage/emulated/0/DCIM/QA_Agronomy');
    if (!await dir.exists()) await dir.create(recursive: true);

    final fileName =
        'QA_Kualitas_TBS_${DateTime.now().millisecondsSinceEpoch}.png';
    await File('${dir.path}/$fileName')
        .writeAsBytes(img.encodePng(image));

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Foto disimpan: ${dir.path}/$fileName")),
    );

    _komentarController.clear();
  }

  // ===================== SAVE TPH =====================
  void _saveTPHSample() {
    setState(() {
      final int mentah = int.tryParse(_mentahTPHController.text) ?? 0;
      final int masak = int.tryParse(_masakTPHController.text) ?? 0;
      final int overripe = int.tryParse(_overripeTPHController.text) ?? 0;
      final int busukKosong =
          int.tryParse(_busukkosongTPHController.text) ?? 0;
      final int abnormal = int.tryParse(_abnormalTPHController.text) ?? 0;

      final total = mentah +
          masak +
          overripe +
          busukKosong +
          abnormal;

      _samples.add({
        "TPH": TPHCounter,
        "mentah": mentah,
        "masak": masak,
        "overripe": overripe,
        "busuk_kosong": busukKosong,
        "abnormal": abnormal,
        "total": total,
      });

      TPHCounter++;

      _mentahTPHController.clear();
      _masakTPHController.clear();
      _overripeTPHController.clear();
      _busukkosongTPHController.clear();
      _abnormalTPHController.clear();
    });
  }

  // ===================== SAVE ALL =====================
  Future<void> _saveAll() async {
    if (_samples.isEmpty) return;

    int sum(String key) =>
        _samples.fold(0, (a, b) => a + (b[key] as int));

    await QADatabaseGrading.instance.insertQA({
      'tanggal': _tanggalPeriksa,
      'nama_petugas': _namaPetugasController.text,
      'kebun': selectedKebun,
      'divisi': selectedDivisi,
      'blok': selectedBlok,
      'varietas': _varietasController.text,
      'tahun_tanam': _tahunTanamController.text,
      'mentah': sum('mentah'),
      'masak': sum('masak'),
      'overripe': sum('overripe'),
      'busuk_kosong': sum('busuk_kosong'),
      'abnormal': sum('abnormal'),
      'total_buah': sum('total'),
      'is_synced': 0,
      'timestamp_sync': null,
    });

    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const MenuPage()),
      (route) => false,
    );
  }

  Future<bool> _onWillPop() async {
  if (_samples.isEmpty) {
    return true; // tidak ada data → boleh keluar
  }

  final shouldExit = await showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text("Peringatan"),
      content: const Text(
        "Data belum disimpan.\nApakah yakin ingin keluar tanpa menyimpan?",
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: const Text("Batal"),
        ),
        ElevatedButton(
          onPressed: () => Navigator.of(context).pop(true),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red,
            foregroundColor: Colors.white,
          ),
          child: const Text("Ya, keluar"),
        ),
      ],
    ),
  );

  return shouldExit ?? false;
}


  // ===================== UI =====================
Widget build(BuildContext context) {
  return PopScope(
  canPop: false,
  onPopInvokedWithResult: (didPop, result) async {
    if (didPop) return;

    final shouldLeave = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Peringatan"),
        content: const Text(
          "Data belum disimpan. Apakah yakin ingin keluar tanpa menyimpan?",
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text("Batal"),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text("Ya, keluar"),
          ),
        ],
      ),
    );

    if (shouldLeave == true && context.mounted) {
      Navigator.of(context).pop(result);
    }
  },
    child : Scaffold(
      appBar: AppBar(title: const Text("QA Grading TBS")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(12),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text("Tanggal: $_tanggalPeriksa",
              style: const TextStyle(fontWeight: FontWeight.bold)),

          TextField(
            controller: _namaPetugasController,
            decoration: const InputDecoration(labelText: "Nama Petugas"),
            enabled: !isLocked,
          ),

          DropdownButtonFormField(
            decoration: const InputDecoration(labelText: "Kebun"),
            value: selectedKebun,
            onChanged:
                isLocked ? null : (v) => setState(() => selectedKebun = v as String?),
            items: kebunOptions
                .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                .toList(),
          ),

          DropdownButtonFormField(
            decoration: const InputDecoration(labelText: "Divisi"),
            value: selectedDivisi,
            onChanged: isLocked
                ? null
                : (v) => setState(() {
                      selectedDivisi = v as String?;
                      selectedBlok = null;
                    }),
            items: divisiOptions
                .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                .toList(),
          ),

          DropdownButtonFormField(
            decoration: const InputDecoration(labelText: "Blok"),
            value: selectedBlok,
            onChanged:
                isLocked ? null : (v) => setState(() => selectedBlok = v as String?),
            items: availableBloks
                .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                .toList(),
          ),

          const Divider(),
          const Text("Klasifikasi Buah per TPH",
              style: TextStyle(fontWeight: FontWeight.bold)),

          _numField(_mentahTPHController, "Mentah"),
          _numField(_masakTPHController, "Masak"),
          _numField(_overripeTPHController, "Overripe"),
          _numField(_busukkosongTPHController, "Busuk / Kosong"),
          _numField(_abnormalTPHController, "Abnormal"),

          const SizedBox(height: 12),
          ElevatedButton(
            onPressed: _saveTPHSample,
            style: ElevatedButton.styleFrom(backgroundColor: primaryColor, foregroundColor: Colors.white),
            child: const Text("Save TPH"),
          ),

          const Divider(),
          const Text("Sample Tersimpan",
              style: TextStyle(fontWeight: FontWeight.bold)),

          ..._samples.map((s) => ListTile(
                title: Text("TPH ${s['TPH']}"),
                subtitle: Text(
                    "Mentah ${s['mentah']} | Masak ${s['masak']}"),
              )),

          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: _saveAll,
            style: ElevatedButton.styleFrom(backgroundColor: primaryColor, foregroundColor: Colors.white),
            child: const Text("Save All"),
          ),
        ]),
      ),
    )
    );
  }

  Widget _numField(TextEditingController c, String label) {
    return TextField(
      controller: c,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(labelText: label),
    );
  }
}

