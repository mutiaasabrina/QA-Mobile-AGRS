class QAChemistSummary {
  final String tanggalPeriksa;
  final String namaPetugas;
  final String kebun;
  final String divisi;
  final String blok;
  final String tanggalPenyemprotan;
  final String luasan;
  final String jumlahTenagaKerja;
  final String chemist;
  final String jenisChemist;
  final String dosis;
  final String bahanHerbisida;
  final String programPengendalianGulma;
  final String kartuPengambilanPencampuran;
  final String kalibrasiAlatNozel;
  final String gelasUkurPerkakas;
  final String peletakanAlatSemprot;
  final String kondisiAlatSemprot;
  final String keseragamanNozel;
  final String apdPekerja;
  final String kesesuaianKalibrasiDosis;

  QAChemistSummary({
    required this.tanggalPeriksa,
    required this.namaPetugas,
    required this.kebun,
    required this.divisi,
    required this.blok,
    required this.tanggalPenyemprotan,
    required this.luasan,
    required this.jumlahTenagaKerja,
    required this.chemist,
    required this.jenisChemist,
    required this.dosis,
    required this.bahanHerbisida,
    required this.programPengendalianGulma,
    required this.kartuPengambilanPencampuran,
    required this.kalibrasiAlatNozel,
    required this.gelasUkurPerkakas,
    required this.peletakanAlatSemprot,
    required this.kondisiAlatSemprot,
    required this.keseragamanNozel,
    required this.apdPekerja,
    required this.kesesuaianKalibrasiDosis,
  });
}

String generateRingkasanText(QAChemistSummary data) {
  final buffer = StringBuffer();

  buffer.writeln("Tanggal Pemeriksaan: ${data.tanggalPeriksa}");
  buffer.writeln("Nama Petugas: ${data.namaPetugas}");
  buffer.writeln("Kebun: ${data.kebun}");
  buffer.writeln("Divisi: ${data.divisi}");
  buffer.writeln("Blok: ${data.blok}");
  buffer.writeln("Tanggal Semprot: ${data.tanggalPenyemprotan}");
  buffer.writeln("Luasan: ${data.luasan}");
  buffer.writeln("Jumlah Tenaga Kerja: ${data.jumlahTenagaKerja}");
  buffer.writeln("Chemist: ${data.chemist}");
  buffer.writeln("Jenis Chemist yang digunakan: ${data.jenisChemist}");

  buffer.writeln("\nDosis / Knapsack (liter/ha): ${data.dosis}");
  buffer.writeln("Bahan Herbisida: ${data.bahanHerbisida}");
  buffer.writeln("Program Pengendalian Gulam: ${data.programPengendalianGulma}");
  buffer.writeln("Kartu Pengambilan dan Pencampuran: ${data.kartuPengambilanPencampuran}");
  buffer.writeln("Kalibrasi Alat & Nozel: ${data.kalibrasiAlatNozel}");
  buffer.writeln("Gelas Ukur & Perkakas: ${data.gelasUkurPerkakas}");

  buffer.writeln("\nPeletakan Alat Semprot: ${data.peletakanAlatSemprot}");
  buffer.writeln("Kondisi Alat Semprot: ${data.kondisiAlatSemprot}");
  buffer.writeln("Keseragaman Alat Semprot: ${data.keseragamanNozel}");

  buffer.writeln("\nAPD Pekerja: ${data.apdPekerja}");

  buffer.writeln("\nKesesuaian Dosis Kalibrasi: ${data.kesesuaianKalibrasiDosis}");

  return buffer.toString();
}