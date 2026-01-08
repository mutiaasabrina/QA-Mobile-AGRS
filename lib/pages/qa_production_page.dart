import 'package:flutter/material.dart';
import 'package:qa_agronomy/pages/qa_produksi.dart';
import 'package:qa_agronomy/pages/qa_grading.dart';
import 'package:qa_agronomy/utils/constants.dart';

class QAProduksiMenuPage extends StatelessWidget {
  const QAProduksiMenuPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("QA Produksi")),
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
                MaterialPageRoute(builder: (_) => const QAGradingPage()),
              );
            },
            child: const Text("QA Grading"),
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
                MaterialPageRoute(builder: (_) => const QAProduksiPage()),
              );
            },
            child: const Text("QA Produksi"),
          ),
        ],
      ),
    );
  }
}