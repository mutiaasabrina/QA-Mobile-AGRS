import 'package:flutter/material.dart';
import '../utils/constants.dart';
import 'qa_produksi_perawatan.dart';
import 'qa_tracker_page.dart';
import 'qa_pemupukan_page.dart';

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
            child: const Text("QA Produksi dan Perawatan"),
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
            child: const Text("QA Pemupukan"),
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => const QAPemupukanPage()));
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
          const SizedBox(height: 16),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: primaryColor,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.all(16),
            ),
            child: const Text("QA Tracker Hari Ini"),
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => const QATrackerPage()));
            },
          ),
        ],
      ),
    );
  }
}
