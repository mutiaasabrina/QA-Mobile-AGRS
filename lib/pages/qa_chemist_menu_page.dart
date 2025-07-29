import 'package:flutter/material.dart';
import 'package:qa_agronomy/pages/qa_chemist_page.dart';
import 'package:qa_agronomy/pages/mutu_ancak_chemist_page.dart';
import 'package:qa_agronomy/utils/constants.dart';

class QAChemistMenuPage extends StatelessWidget {
  const QAChemistMenuPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("QA Chemist")),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: primaryColor,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.all(16),
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const QAChemistPage()),
              );
            },
            child: const Text("QA Kalibrasi Chemist"),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: primaryColor,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.all(16),
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const MutuAncakChemistPage()),
              );
            },
            child: const Text("Mutu Ancak Chemist"),
          ),
        ],
      ),
    );
  }
}