import 'package:flutter/material.dart';
import '../utils/constants.dart';
import 'qa_perawatan.dart';
import 'qa_grading.dart';
import 'qa_tracker_page.dart';
import 'qa_chemist_menu_page.dart';
import 'package:qa_agronomy/database/qa_database_chemist.dart';
import 'package:qa_agronomy/pages/qa_pemupukan_menu.dart';
import 'package:qa_agronomy/pages/qa_production_page.dart';

class MenuPage extends StatefulWidget {
  const MenuPage({super.key});

  @override
  State<MenuPage> createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {
  @override
  void initState() {
    super.initState();
    _checkAncakNeeded();
  }

  void _checkAncakNeeded() async {
    final overdueList = await QADatabaseChemist.instance.getChemistSamplesNeedingAncak();

    if (overdueList.isNotEmpty) {
      final message = overdueList.map((e) =>
        "${e['kebun']} - ${e['divisi']} - ${e['blok']} (${e['tanggal']})"
      ).join('\n');

      WidgetsBinding.instance.addPostFrameCallback((_) {
        showDialog(
          context: context,
          builder: (_) => AlertDialog(
            title: const Text("Mutu Ancak Belum Diisi"),
            content: Text("Silahkan lakukan mutu ancak untuk:\n\n$message"),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("Oke"),
              ),
            ],
          ),
        );
      });
    }
  }

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
              Navigator.push(context, MaterialPageRoute(builder: (context) => const QAProduksiMenuPage()));
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
              Navigator.push(context, MaterialPageRoute(builder: (context) => const QAPerawatanPage()));
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
              Navigator.push(context, MaterialPageRoute(builder: (context) => const QAPupukMenuPage()));
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
              Navigator.push(context, MaterialPageRoute(builder: (context) => const QAChemistMenuPage()));
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

