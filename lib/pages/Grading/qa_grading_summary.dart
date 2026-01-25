// ignore_for_file: prefer_const_constructors

class QAGradingSummary {
  final String tanggalPeriksa;
  final String namaPetugas;
  final String kebun;
  final String divisi;
  final String blok;
  final String varietas;
  final String tahunTanam;
  final int totalTPH;
  final double totalBuahAMentah;
  final double totalBeratAMentah;
  final double totalBuahBMentah;
  final double totalBeratBMentah;
  final double totalBuahCMentah;
  final double totalBeratCMentah;
  final double totalBuahDMentah;
  final double totalBeratDMentah;
  final double totalBuahAMatang;
  final double totalBeratAMatang;
  final double totalBuahBMatang;
  final double totalBeratBMatang;
  final double totalBuahCMatang;
  final double totalBeratCMatang;
  final double totalBuahDMatang;
  final double totalBeratDMatang;
  final int totalBuahMentahKecil;
  final int totalBuahMatangKecil;
  final int totalBuahMentah;
  final int totalBuahMatang;

  QAGradingSummary({
    required this.tanggalPeriksa,
    required this.namaPetugas,
    required this.kebun,
    required this.divisi,
    required this.blok,
    required this.varietas,
    required this.tahunTanam,
    required this.totalTPH,
    required this.totalBuahAMentah,
    required this.totalBeratAMentah,
    required this.totalBuahBMentah,
    required this.totalBeratBMentah,
    required this.totalBuahCMentah,
    required this.totalBeratCMentah,
    required this.totalBuahDMentah,
    required this.totalBeratDMentah,
    required this.totalBuahAMatang,
    required this.totalBeratAMatang,
    required this.totalBuahBMatang,
    required this.totalBeratBMatang,
    required this.totalBuahCMatang,
    required this.totalBeratCMatang,
    required this.totalBuahDMatang,
    required this.totalBeratDMatang,
    required this.totalBuahMentahKecil,
    required this.totalBuahMatangKecil,
    required this.totalBuahMentah,
    required this.totalBuahMatang,
  });
}

String generateRingkasanText(QAGradingSummary data) {
  final buffer = StringBuffer();

  buffer.writeln("Tanggal Pemeriksaan: ${data.tanggalPeriksa}");
  buffer.writeln("Nama Petugas: ${data.namaPetugas}");
  buffer.writeln("Kebun: ${data.kebun}");
  buffer.writeln("Divisi: ${data.divisi}");
  buffer.writeln("Blok: ${data.blok}");
  buffer.writeln("Varietas: ${data.varietas}");
  buffer.writeln("Tahun Tanam: ${data.tahunTanam}");
  buffer.writeln("Total TPH: ${data.totalTPH}");

  buffer.writeln("\nTotal Buah A Mentah: ${data.totalBuahAMentah} (Berat: ${data.totalBeratAMentah})");
  buffer.writeln("Total Buah B Mentah: ${data.totalBuahBMentah} (Berat: ${data.totalBeratBMentah})");
  buffer.writeln("Total Buah C Mentah: ${data.totalBuahCMentah} (Berat: ${data.totalBeratCMentah})");
  buffer.writeln("Total Buah D Mentah: ${data.totalBuahDMentah} (Berat: ${data.totalBeratDMentah})");

  buffer.writeln("\nTotal Buah A Matang: ${data.totalBuahAMatang} (Berat: ${data.totalBeratAMatang})");
  buffer.writeln("Total Buah B Matang: ${data.totalBuahBMatang} (Berat: ${data.totalBeratBMatang})");
  buffer.writeln("Total Buah C Matang: ${data.totalBuahCMatang} (Berat: ${data.totalBeratCMatang})");
  buffer.writeln("Total Buah D Matang: ${data.totalBuahDMatang} (Berat: ${data.totalBeratDMatang})");

  buffer.writeln("\nTotal Buah Mentah Kecil: ${data.totalBuahMentahKecil}");
  buffer.writeln("Total Buah Matang Kecil: ${data.totalBuahMatangKecil}");

  buffer.writeln("\nTotal Buah Mentah: ${data.totalBuahMentah}");
  buffer.writeln("Total Buah Matang: ${data.totalBuahMatang}");
  
  return buffer.toString();
}