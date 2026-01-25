import 'package:flutter/material.dart';
import 'qa_pemupukan_page.dart';
import 'package:qa_agronomy/pages/Pemupukan/mutu_ancak_pemupukan_page.dart';
import 'package:qa_agronomy/utils/constants.dart';

class QAPupukMenuPage extends StatelessWidget {
  const QAPupukMenuPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("QA Pemupukan")),
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
                MaterialPageRoute(builder: (_) => const QAPemupukanPage()),
              );
            },
            child: const Text("QA Kalibrasi Pemupukan"),
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
                MaterialPageRoute(builder: (_) => const MutuAncakPemupukanPage()),
              );
            },
            child: const Text("Mutu Ancak Pemupukan"),
          ),
        ],
      ),
    );
  }
}