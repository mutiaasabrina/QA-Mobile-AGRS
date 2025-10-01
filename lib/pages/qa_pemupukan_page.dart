import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:convert';
import '../utils/constants.dart';
import 'menu_page.dart';
import 'qa_pemupukan_summary.dart';
import 'package:qa_agronomy/database/qa_database_pemupukan.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image/image.dart' as img;
import 'package:permission_handler/permission_handler.dart';
import 'dart:io';

class QAPemupukanPage extends StatefulWidget {
  const QAPemupukanPage({super.key});

  @override
  State<QAPemupukanPage> createState() => _QAPemupukanPageState();
}

class _QAPemupukanPageState extends State<QAPemupukanPage> {
  final _namaPetugasController = TextEditingController();
  final _dosisController = TextEditingController();
  final _jumlahAlatTaburController = TextEditingController();
  final _jumlahSampleUjiPetikController = TextEditingController();
  final _alatTaburSeragamController = TextEditingController();
  final _alatTaburTidakSeragamController = TextEditingController();
  final _komentarController = TextEditingController();

  final TextEditingController _titikPocketController =
    TextEditingController(text: "4"); // default 4 titik pocket


  List<TextEditingController> _dosisSampleControllers =[];
  String dosisUjiPetikResult ="";


  final String _tanggalPeriksa = DateFormat('yyyy-MM-dd').format(DateTime.now());
  final String _tanggalPemupukan = DateFormat('yyyy-MM-dd').format(DateTime.now());

  String? selectedKebun;
  String? selectedDivisi;
  String? selectedBlok;
  String? selectedJenisPupuk;
  String? selectedAPD;
  String? selectedTenagaPemupuk;
  String? selectedSupervisi;
  String? selectedFisikPupuk;

 // String? selectedDosisUjiPetik;

  bool _ujiPetik = false;
  final List<Map<String, dynamic>> _samples = [];
  bool _isLocked = false;
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
  final List<String> dosisUjiOptions = ['Sesuai', 'Tidak Sesuai'];

  List<String> wrapText(String text, int maxCharsPerLine) {
    final words = text.split(' ');
    List<String> lines = [];
    String currentLine = '';

    for (final word in words) {
      if ((currentLine + ' ' + word).trim().length <= maxCharsPerLine) {
        currentLine += ' $word';
      } else {
        lines.add(currentLine.trim());
        currentLine = word;
      }
    }
    if (currentLine.isNotEmpty) {
      lines.add(currentLine.trim());
    }

    return lines;
  }

  int getMaxLineWidth(List<String> lines, int avgCharWidth) {
    return lines
        .map((line) => line.length * avgCharWidth)
        .reduce((a, b) => a > b ? a : b);
  }

  Future<void> ambilFotoDenganWatermark({
    required String estate,
    required String divisi,
    required String blok,
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
      final watermarkText = "QA Pemupukan\nEstate: $estate\nDivisi: $divisi\nBlok: $blok\nPetugas: $petugas\nWaktu: $dateStr\nKeterangan: $komentar";

      final font = img.arial48;
      final margin = 30;
      final maxTextWidthPx = (original.width * 0.5).toInt();
      final avgCharWidth = font.lineHeight ~/ 2;
      final maxCharsPerLine = maxTextWidthPx ~/ avgCharWidth;

      // wrap baris demi baris
      List<String> wrappedLines = [];
      for (final line in watermarkText.split('\n')) {
        wrappedLines.addAll(wrapText(line, maxCharsPerLine));
      }

      // GANTI: pakai maxLineWidth dari fungsi akurat
      final textWidth = getMaxLineWidth(wrappedLines, avgCharWidth);
      final textHeight = wrappedLines.length * font.lineHeight;

      final x = original.width - textWidth - margin;
      final y = original.height - textHeight - margin;

      // Gambar background pas
      img.fillRect(
        original,
        x1: x - 10,
        y1: y - 10,
        x2: x + textWidth + 10,
        y2: y + textHeight + 10,
        color: img.ColorRgba8(0, 0, 0, 150),
      );

      // Gambar teksnya
      for (int i = 0; i < wrappedLines.length; i++) {
        img.drawString(
          original,
          font: font,
          x: x,
          y: y + i * font.lineHeight,
          wrappedLines[i],
          color: img.ColorRgb8(255, 255, 255),
        );
      }

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

  void _saveSample() {
  if (_namaPetugasController.text.isEmpty ||
      selectedKebun == null ||
      selectedDivisi == null ||
      selectedBlok == null ||
      selectedJenisPupuk == null ||
      selectedAPD == null ||
      _jumlahAlatTaburController.text.isEmpty ||
      _alatTaburSeragamController.text.isEmpty ||
      _alatTaburTidakSeragamController.text.isEmpty ||
      selectedTenagaPemupuk == null ||
      selectedSupervisi == null ||
      selectedFisikPupuk == null ||
      (_ujiPetik && (_dosisSampleControllers.any((c)=> c.text.isEmpty) || _ujiPetik && _hasilUjiPetikController.text.isEmpty))) 
  {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Lengkapi semua data.")));
        return;
  }

  setState(() {
    _samples.add({
      'pokok': _pokokCounter++,
      'ujiPetik': _ujiPetik,
      'jumlahSample': _ujiPetik ? _jumlahSampleUjiPetikController.text : '-',
      'dosisAlatTabur': _ujiPetik ? dosisUjiPetikResult : '-',
    });

    //selectedDosisUjiPetik = null;
    _jumlahSampleUjiPetikController.clear();
    _ujiPetik = false;
    dosisUjiPetikResult ="";
    _isLocked = true;
    _hasilUjiPetikController.clear();
  });
}

  void _saveAll() {
  if (_samples.isEmpty || 
      _namaPetugasController.text.isEmpty ||
      selectedKebun == null ||
      selectedDivisi == null ||
      selectedBlok == null ||
      selectedJenisPupuk == null ||
      selectedAPD == null ||
      _jumlahAlatTaburController.text.isEmpty ||
      _alatTaburSeragamController.text.isEmpty ||
      _alatTaburTidakSeragamController.text.isEmpty ||
      selectedTenagaPemupuk == null ||
      selectedSupervisi == null ||
      selectedFisikPupuk == null ||
      (_ujiPetik && (_dosisSampleControllers.any((c)=> c.text.isEmpty) || _ujiPetik && _hasilUjiPetikController.text.isEmpty))) 
  {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Lengkapi semua data.")));
        return;
  }

  int totalUjiPetikAktif = _samples.where((s) => s['ujiPetik'] == true).length;
  int totalUjiPetikNonAktif = _samples.where((s) => s['ujiPetik'] == false).length;
  int totalDosisSesuai = _samples.where((s) => s['dosisAlatTabur'] == 'Sesuai').length;
  int totalDosisTidakSesuai = _samples.where((s) => s['dosisAlatTabur'] == 'Tidak Sesuai').length;

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
    totalAlatTabur: _jumlahAlatTaburController.text,
    totalAlatTaburSeragam: _alatTaburSeragamController.text,
    totalAlatTaburTidakSeragam: _alatTaburTidakSeragamController.text,
    totalUjiPetikAktif: totalUjiPetikAktif,
    totalUjiPetikTidakAktif: totalUjiPetikNonAktif,
    totalDosisSesuai: totalDosisSesuai,
    totalDosisTidakSesuai: totalDosisTidakSesuai,
    apdPekerja: selectedAPD ?? '',
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
            'fisik_pupuk': selectedFisikPupuk,
            'total_alat_tabur': _jumlahAlatTaburController.text,
            'alat_tabur_seragam': _alatTaburSeragamController.text,
            'alat_tabur_tidak_seragam': _alatTaburTidakSeragamController.text,
            'total_uji_petik_aktif': totalUjiPetikAktif,
            'total_uji_petik_nonaktif': totalUjiPetikNonAktif,
            'total_dosis_sesuai': totalDosisSesuai,
            'total_dosis_tidak_sesuai': totalDosisTidakSesuai,
            'apd_pekerja': selectedAPD,
            'ringkasan': ringkasan,
            'is_synced': 0,
            'timestamp_sync': null,
          });
          
          Navigator.of(context).popUntil((route) => route.isFirst);
          Navigator.push(context, MaterialPageRoute(builder: (context) => const MenuPage()));
        },
          child: const Text("Ok"),
        ),
      ],
),
);
} 
  final TextEditingController _hasilUjiPetikController = TextEditingController();

  
void _calculateDosisUjiPetik() {
  if (_dosisController.text.isEmpty || _hasilUjiPetikController.text.isEmpty) return;

  final double dosisPerPokokKg = double.tryParse(_dosisController.text) ?? 0;
  final double dosisPerPokokGram = dosisPerPokokKg * 1000;
  final int titikPocket = int.tryParse(_titikPocketController.text) ?? 4;
  final double targetPerTitik = dosisPerPokokGram / titikPocket;


  final double hasilUji = double.tryParse(_hasilUjiPetikController.text) ?? 0;
  final double toleransi = targetPerTitik * 0.05;

  final double selisih = (hasilUji - targetPerTitik).abs();

  setState(() {
    dosisUjiPetikResult = selisih <= toleransi ? "Sesuai" : "Tidak Sesuai";
  });
}

  @override
  void dispose() {
    for (var c in _dosisSampleControllers) {
      c.dispose();
    }
    _namaPetugasController.dispose();
    _dosisController.dispose();
    _jumlahAlatTaburController.dispose();
    _alatTaburSeragamController.dispose();
    _alatTaburTidakSeragamController.dispose();
    _jumlahSampleUjiPetikController.dispose();
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
            TextField(controller: _namaPetugasController, decoration: const InputDecoration(labelText: "Nama Petugas"), enabled: !_isLocked,),
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(labelText: "Kebun"),
              value: selectedKebun,
              onChanged: _isLocked ? null : (val) => setState(() => selectedKebun = val),
              items: kebunOptions.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
            ),
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(labelText: "Divisi"),
              value: selectedDivisi,
              onChanged: _isLocked ? null : (val) => setState(() => selectedDivisi = val),
              items: divisiOptions.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
            ),
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(labelText: "Kode Blok"),
              value: selectedBlok,
              onChanged: _isLocked ? null : (val) => setState(() => selectedBlok = val),
              items: availableBloks.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
            ),
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(labelText: "Jenis Pupuk"),
              value: selectedJenisPupuk,
              onChanged: _isLocked ? null : (val) => setState(() => selectedJenisPupuk = val),
              items: jenisPupukOptions.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
            ),
            TextField(controller: _dosisController, decoration: const InputDecoration(labelText: "Dosis/Pokok"), enabled: !_isLocked),
            TextField(
                controller: _titikPocketController,
                decoration: const InputDecoration(labelText: "Jumlah Titik Pocket"),
                keyboardType: TextInputType.number,
                onChanged: (_) => _calculateDosisUjiPetik(),
              ),
              const SizedBox(height: 16),            
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(labelText: "APD Pekerja"),
              value: selectedAPD,
              onChanged: _isLocked ? null : (val) => setState(() => selectedAPD = val),
              items: apdOptions.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
            ),
            TextField(controller: _jumlahAlatTaburController, decoration: InputDecoration(labelText: "Jumlah Alat Tabur", hintText: _isLocked ? "Data Ini Sudah Tersedia": null,), keyboardType: TextInputType.number, enabled: !_isLocked,),
            TextField(controller: _alatTaburSeragamController, decoration: InputDecoration(labelText: "Jumlah Alat Tabur Seragam", hintText: _isLocked ? "Data Ini Sudah Tersedia": null,), keyboardType: TextInputType.number, enabled: !_isLocked,),
            TextField(controller: _alatTaburTidakSeragamController, decoration: InputDecoration(labelText: "Jumlah Alat Tabur Tidak Seragam", hintText: _isLocked ? "Data Ini Sudah Tersedia": null,), keyboardType: TextInputType.number, enabled: !_isLocked,),
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(labelText: "Tenaga Pemupuk"),
              value: selectedTenagaPemupuk,
              onChanged: _isLocked ? null : (val) => setState(() => selectedTenagaPemupuk = val),
              items: tenagaPemupukOptions.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
            ),
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(labelText: "Supervisi"),
              value: selectedSupervisi,
              onChanged: _isLocked ? null : (val) => setState(() => selectedSupervisi = val),
              items: supervisiOptions.map((e) => DropdownMenuItem(value: e, child: Text(e, softWrap: true, style: TextStyle(fontSize: 14),))).toList(),
            ),
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(labelText: "Fisik Pupuk"),
              value: selectedFisikPupuk,
              onChanged: _isLocked ? null : (val) => setState(() => selectedFisikPupuk = val),
              items: fisikPupukOptions.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
            ),
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
                  petugas: _namaPetugasController.text,
                  context: context,
                );
              },
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
              const SizedBox(height: 8),
              TextField(
                controller: _hasilUjiPetikController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: "Berat pupuk dari salah satu titik pocket (gram)",
                ),
                onChanged: (_) => _calculateDosisUjiPetik(),
              ),
              const SizedBox(height: 8),
              Text(
                "Dosis Alat Tabur: $dosisUjiPetikResult",
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
            const SizedBox(height: 12),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: primaryColor, foregroundColor: Colors.white),onPressed: _saveSample, child: const Text("Save Data Pemupukan")),
            const SizedBox(height: 16),
            const Divider(),
            const Text("Daftar Sample Yang Sudah Diinput"),
            if (_samples.isEmpty)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 8.0),
                child: Text("Belum ada sample yang diinput."),
              )
            else
              ..._samples.map(
                (s) => ListTile(
                  title: Text("Uji Petik Ke: ${s['pokok']}"),
                  subtitle: Text(
                    "Uji Petik: ${s['ujiPetik'] ? 'Ya' : 'Tidak'}\nKesessuaian: ${s['dosisAlatTabur']}",
                  ),
                ),
              ),
            const SizedBox(height: 16),
            ElevatedButton( style: ElevatedButton.styleFrom(backgroundColor: primaryColor, foregroundColor: Colors.white),onPressed: _saveAll, child: const Text("Save All")),
          ],
        ),
),
);
}
}