import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

void main() {
  runApp(const MaterialApp(home: LandingPage()));
}

const Color primaryColor = Color.fromARGB(255, 46, 65, 45);

class LandingPage extends StatelessWidget {
  const LandingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/landingpage.jpg"),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "QA Agronomy Services Dept",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: primaryColor,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                ),
                child: const Text("Start QA", style: TextStyle(fontSize: 18)),
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const MenuPage()));
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class MenuPage extends StatelessWidget {
  const MenuPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Pilih Jenis QA")),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: primaryColor,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.all(16),
            ),
            child: const Text("QA Produksi"),
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => const QAProduksiPage()));
            },
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: primaryColor,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.all(16),
            ),
            child: const Text("QA Perawatan"),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Coming Soon!")));
            },
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: primaryColor,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.all(16),
            ),
            child: const Text("QA Pemupukan"),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Coming Soon!")));
            },
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: primaryColor,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.all(16),
            ),
            child: const Text("QA Chemist"),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Coming Soon!")));
            },
          ),
        ],
      ),
    );
  }
}

class QAProduksiPage extends StatefulWidget {
  const QAProduksiPage({super.key});

  @override
  State<QAProduksiPage> createState() => _QAProduksiPageState();
}

class _QAProduksiPageState extends State<QAProduksiPage> {
  final _namaPetugasController = TextEditingController();
  final _kodeBlokController = TextEditingController();
  final _divisiController = TextEditingController();
  final _kebunController = TextEditingController();
  final _rotasiController = TextEditingController();

  final List<Map<String, dynamic>> _samples = [];
  final String _tanggalPeriksa = DateFormat('yyyy-MM-dd').format(DateTime.now());

  final _barisController = TextEditingController();
  final _pokokController = TextEditingController();
  bool _dipanen = false;
  final _buahDipanenController = TextEditingController();
  final _buahTidakDipanenController = TextEditingController();
  final _lfTinggalController = TextEditingController();
  final _tphTinggalController = TextEditingController();
  final _buahTinggalController = TextEditingController();

  void _savePokokSample() {
    if (_barisController.text.isEmpty || _pokokController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Baris & Pokok harus diisi.")));
      return;
    }

    setState(() {
      _samples.add({
        "baris": _barisController.text,
        "pokok": _pokokController.text,
        "dipanen": _dipanen,
        "buahDipanen": _buahDipanenController.text,
        "buahTidakDipanen": _buahTidakDipanenController.text,
        "lfTinggal": _lfTinggalController.text,
        "tphTinggal": _tphTinggalController.text,
        "buahTinggal": _buahTinggalController.text,
      });
      _clearPokokForm();
    });
  }

  void _clearPokokForm() {
    _barisController.clear();
    _pokokController.clear();
    _dipanen = false;
    _buahDipanenController.clear();
    _buahTidakDipanenController.clear();
    _lfTinggalController.clear();
    _tphTinggalController.clear();
    _buahTinggalController.clear();
  }

  void _saveAll() {
    if (_samples.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Minimal 1 pokok sample harus diisi.")));
      return;
    }

    if (_namaPetugasController.text.isEmpty ||
        _kodeBlokController.text.isEmpty ||
        _divisiController.text.isEmpty ||
        _kebunController.text.isEmpty ||
        _rotasiController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Lengkapi semua data form blok.")));
      return;
    }

    print("== Form QA Produksi ==");
    print("Tanggal Periksa: $_tanggalPeriksa");
    print("Nama Petugas: ${_namaPetugasController.text}");
    print("Kode Blok: ${_kodeBlokController.text}");
    print("Divisi: ${_divisiController.text}");
    print("Kebun: ${_kebunController.text}");
    print("Rotasi: ${_rotasiController.text} hari");

    for (var p in _samples) {
      print("----");
      print("Baris ke: ${p['baris']}, Pokok ke: ${p['pokok']}");
      print("Pkk dipanen: ${p['dipanen'] ? '√' : '✗'}");
      print("Buah di Panen: ${p['buahDipanen']} Mtg/Bsk");
      print("Buah Tdk di Panen: ${p['buahTidakDipanen']} Mtg/Bsk");
      print("LF Tinggal: ${p['lfTinggal']}");
      print("TPH Tinggal: ${p['tphTinggal']}");
      print("Buah Tinggal: ${p['buahTinggal']}");
    }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Berhasil"),
        content: const Text("Data berhasil disimpan."),
        actions: [
          TextButton(
            onPressed: () {
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
            TextField(controller: _kodeBlokController, decoration: const InputDecoration(labelText: "Kode Blok")),
            TextField(controller: _divisiController, decoration: const InputDecoration(labelText: "Divisi")),
            TextField(controller: _kebunController, decoration: const InputDecoration(labelText: "Kebun")),
            TextField(controller: _rotasiController, decoration: const InputDecoration(labelText: "Rotasi (hari)")),
            const SizedBox(height: 12),
            const Divider(),
            const Text("Masukkan Pokok Sample", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            TextField(controller: _barisController, decoration: const InputDecoration(labelText: "Baris ke-")),
            TextField(controller: _pokokController, decoration: const InputDecoration(labelText: "Pokok ke-")),
            Row(
              children: [
                Checkbox(
                  value: _dipanen,
                  onChanged: (val) => setState(() => _dipanen = val ?? false),
                ),
                const Text("Pkk di Panen")
              ],
            ),
            TextField(controller: _buahDipanenController, decoration: const InputDecoration(labelText: "Buah di Panen (Mtg/Bsk)")),
            TextField(controller: _buahTidakDipanenController, decoration: const InputDecoration(labelText: "Buah Tidak di Panen (Mtg/Bsk)")),
            TextField(controller: _lfTinggalController, decoration: const InputDecoration(labelText: "LF Tinggal (pr,pk,lp,pp)")),
            TextField(controller: _tphTinggalController, decoration: const InputDecoration(labelText: "TPH Tinggal")),
            TextField(controller: _buahTinggalController, decoration: const InputDecoration(labelText: "Buah Tinggal (pr,pk,lp,pp)")),
            const SizedBox(height: 8),
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
                      subtitle: Text("Dipanen: ${p['dipanen'] ? '√' : '✗'}, Buah Panen: ${p['buahDipanen']}, Tidak Panen: ${p['buahTidakDipanen']}"),
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
