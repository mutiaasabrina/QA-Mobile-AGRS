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

// The rest of the code remains unchanged


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

  final List<Map<String, dynamic>> pohonSamples = [];
  final String _tanggalPeriksa = DateFormat('yyyy-MM-dd').format(DateTime.now());

  void _addSample() {
    setState(() {
      pohonSamples.add({
        "baris": "",
        "pokok": "",
        "dipanen": false,
        "buahDipanen": "",
        "buahTidakDipanen": "",
        "lfTinggal": "",
        "tphTinggal": "",
        "buahTinggal": "",
      });
    });
  }

  void _saveData() {
    print("== Form QA Produksi ==");
    print("Tanggal Periksa: $_tanggalPeriksa");
    print("Nama Petugas: ${_namaPetugasController.text}");
    print("Kode Blok: ${_kodeBlokController.text}");
    print("Divisi: ${_divisiController.text}");
    print("Kebun: ${_kebunController.text}");
    print("Rotasi: ${_rotasiController.text} hari");

    for (var p in pohonSamples) {
      print("----");
      print("Baris ke: ${p['baris']}, Pokok ke: ${p['pokok']}");
      print("Pkk dipanen: ${p['dipanen'] ? '√' : '✗'}");
      print("Buah di Panen: ${p['buahDipanen']} Mtg/Bsk");
      print("Buah Tdk di Panen: ${p['buahTidakDipanen']} Mtg/Bsk");
      print("LF Tinggal: ${p['lfTinggal']}");
      print("TPH Tinggal: ${p['tphTinggal']}");
      print("Buah Tinggal: ${p['buahTinggal']}");
    }
    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text("Data printed to console (for demo)")));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("QA Produksi")),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            Text("Tanggal Periksa: $_tanggalPeriksa",
                style: const TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            TextField(
                controller: _namaPetugasController,
                decoration: const InputDecoration(labelText: "Nama Petugas")),
            TextField(
                controller: _kodeBlokController,
                decoration: const InputDecoration(labelText: "Kode Blok")),
            TextField(
                controller: _divisiController,
                decoration: const InputDecoration(labelText: "Divisi")),
            TextField(
                controller: _kebunController,
                decoration: const InputDecoration(labelText: "Kebun")),
            TextField(
                controller: _rotasiController,
                decoration: const InputDecoration(labelText: "Rotasi (hari)")),
            const SizedBox(height: 8),
            Expanded(
              child: ListView.builder(
                itemCount: pohonSamples.length,
                itemBuilder: (context, index) {
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 6),
                    child: Padding(
                      padding: const EdgeInsets.all(8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Sample ${index + 1}",
                              style: const TextStyle(fontWeight: FontWeight.bold)),
                          TextField(
                            decoration:
                                const InputDecoration(labelText: "Baris ke-"),
                            onChanged: (val) => pohonSamples[index]['baris'] = val,
                          ),
                          TextField(
                            decoration:
                                const InputDecoration(labelText: "Pokok ke-"),
                            onChanged: (val) => pohonSamples[index]['pokok'] = val,
                          ),
                          Row(
                            children: [
                              Checkbox(
                                value: pohonSamples[index]['dipanen'],
                                onChanged: (val) =>
                                    setState(() => pohonSamples[index]['dipanen'] = val),
                              ),
                              const Text("Pkk di Panen")
                            ],
                          ),
                          TextField(
                            decoration: const InputDecoration(
                                labelText: "Buah di Panen (Mtg/Bsk)"),
                            onChanged: (val) =>
                                pohonSamples[index]['buahDipanen'] = val,
                          ),
                          TextField(
                            decoration: const InputDecoration(
                                labelText: "Buah Tidak di Panen (Mtg/Bsk)"),
                            onChanged: (val) =>
                                pohonSamples[index]['buahTidakDipanen'] = val,
                          ),
                          TextField(
                            decoration: const InputDecoration(
                                labelText: "LF Tinggal (pr,pk,lp,pp)"),
                            onChanged: (val) =>
                                pohonSamples[index]['lfTinggal'] = val,
                          ),
                          TextField(
                            decoration:
                                const InputDecoration(labelText: "TPH Tinggal"),
                            onChanged: (val) =>
                                pohonSamples[index]['tphTinggal'] = val,
                          ),
                          TextField(
                            decoration: const InputDecoration(
                                labelText: "Buah Tinggal (pr,pk,lp,pp)"),
                            onChanged: (val) =>
                                pohonSamples[index]['buahTinggal'] = val,
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            Row(
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                    foregroundColor: Colors.white,
                  ),
                  onPressed: _addSample,
                  child: const Text("Tambah Pohon"),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                    foregroundColor: Colors.white,
                  ),
                  onPressed: _saveData,
                  child: const Text("Save Demo"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
