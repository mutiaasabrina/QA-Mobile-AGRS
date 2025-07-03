import 'package:flutter/material.dart';

class SampleDropdown extends StatelessWidget {
  final Map<String, String?> dropdownSelections;
  final VoidCallback onChanged;

  const SampleDropdown({
    super.key,
    required this.dropdownSelections,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final dropdownOptions = {
      "Kondisi Circle": ["Baik", "Semak", "Dominan Anak Sawit", "Dominan Sampah (Berondolan Busuk)"],
      "Kondisi Path": ["Baik", "Tidak Baik"],
      "Kondisi TPH": ["Baik", "Tidak Baik"],
      "Lalang": ["Ada", "Tidak Ada"],
      "Anak Kayu": ["Ada", "Tidak Ada"],
      "Perumpung": ["Ada", "Tidak Ada"],
      "Purun Tikus": ["Ada", "Tidak Ada"],
      "Pakis Udang": ["Ada", "Tidak Ada"],
      "Titi Panen": ["Ada", "Tidak Ada"],
      "Jalan dan Jembatan": ["Baik", "Sedang", "Jelek"],
      "Pruning": ["Baik", "Over", "Sengkleh", "Under"],
      "Susunan Pelepah": ["Rapi", "Tidak Rapi"],
      "Serangan Tikus": ["Ada", "Tidak Ada"],
      "Serangan Rayap": ["Ada", "Tidak Ada"],
      "Thirathaba": ["Ada", "Tidak Ada"],
      "UPDPKS": ["Ada", "Tidak Ada"],
    };

    return Column(
      children: dropdownOptions.entries.map((entry) {
        final label = entry.key;
        final options = entry.value;
        return DropdownButtonFormField<String>(
          decoration: InputDecoration(labelText: label),
          value: dropdownSelections[label],
          onChanged: (val) {
            dropdownSelections[label] = val;
            onChanged();
          },
          items: options.map((opt) => DropdownMenuItem(value: opt, child: Text(opt))).toList(),
        );
      }).toList(),
    );
  }
}
