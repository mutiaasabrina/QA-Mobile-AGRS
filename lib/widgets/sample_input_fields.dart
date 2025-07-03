import 'package:flutter/material.dart';

class SampleInputFields extends StatelessWidget {
  final TextEditingController barisController;
  final bool dipanen;
  final ValueChanged<bool> onDipanenChanged;
  final TextEditingController buahDipanenController;
  final TextEditingController buahMatangTidakDipanenController;
  final TextEditingController buahBusukTidakDipanenController;
  final TextEditingController lfTinggalController;
  final TextEditingController tphTinggalController;
  final TextEditingController buahTinggalController;

  const SampleInputFields({
    super.key,
    required this.barisController,
    required this.dipanen,
    required this.onDipanenChanged,
    required this.buahDipanenController,
    required this.buahMatangTidakDipanenController,
    required this.buahBusukTidakDipanenController,
    required this.lfTinggalController,
    required this.tphTinggalController,
    required this.buahTinggalController,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(controller: barisController, decoration: const InputDecoration(labelText: "Baris ke-")),
        Row(
          children: [
            Checkbox(value: dipanen, onChanged: (val) => onDipanenChanged(val ?? false)),
            const Text("Pkk di Panen")
          ],
        ),
        TextField(controller: buahDipanenController, decoration: const InputDecoration(labelText: "Buah di Panen")),
        TextField(controller: buahMatangTidakDipanenController, decoration: const InputDecoration(labelText: "Buah Matang Tdk di Panen")),
        TextField(controller: buahBusukTidakDipanenController, decoration: const InputDecoration(labelText: "Buah Busuk Tdk di Panen")),
        TextField(controller: lfTinggalController, decoration: const InputDecoration(labelText: "LF Tinggal")),
        TextField(controller: tphTinggalController, decoration: const InputDecoration(labelText: "LF TPH")),
        TextField(controller: buahTinggalController, decoration: const InputDecoration(labelText: "Buah Tinggal")),
      ],
    );
  }
}
