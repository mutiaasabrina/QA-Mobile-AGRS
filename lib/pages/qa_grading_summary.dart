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
  final double totalBjrAMentah;
  final double totalBuahBMentah;
  final double totalBjrBMentah;
  final double totalBuahCMentah;
  final double totalBjrCMentah;
  final double totalBuahDMentah;
  final double totalBjrDMentah;
  final double totalBuahAMatang;
  final double totalBjrAMatang;
  final double totalBuahBMatang;
  final double totalBjrBMatang;
  final double totalBuahCMatang;
  final double totalBjrCMatang;
  final double totalBuahDMatang;
  final double totalBjrDMatang;
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
    required this.totalBjrAMentah,
    required this.totalBuahBMentah,
    required this.totalBjrBMentah,
    required this.totalBuahCMentah,
    required this.totalBjrCMentah,
    required this.totalBuahDMentah,
    required this.totalBjrDMentah,
    required this.totalBuahAMatang,
    required this.totalBjrAMatang,
    required this.totalBuahBMatang,
    required this.totalBjrBMatang,
    required this.totalBuahCMatang,
    required this.totalBjrCMatang,
    required this.totalBuahDMatang,
    required this.totalBjrDMatang,
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

  buffer.writeln("\nTotal Buah A Mentah: ${data.totalBuahAMentah} (BJR: ${data.totalBjrAMentah})");
  buffer.writeln("Total Buah B Mentah: ${data.totalBuahBMentah} (BJR: ${data.totalBjrBMentah})");
  buffer.writeln("Total Buah C Mentah: ${data.totalBuahCMentah} (BJR: ${data.totalBjrCMentah})");
  buffer.writeln("Total Buah D Mentah: ${data.totalBuahDMentah} (BJR: ${data.totalBjrDMentah})");

  buffer.writeln("\nTotal Buah A Matang: ${data.totalBuahAMatang} (BJR: ${data.totalBjrAMatang})");
  buffer.writeln("Total Buah B Matang: ${data.totalBuahBMatang} (BJR: ${data.totalBjrBMatang})");
  buffer.writeln("Total Buah C Matang: ${data.totalBuahCMatang} (BJR: ${data.totalBjrCMatang})");
  buffer.writeln("Total Buah D Matang: ${data.totalBuahDMatang} (BJR: ${data.totalBjrDMatang})");

  buffer.writeln("\nTotal Buah Mentah Kecil: ${data.totalBuahMentahKecil}");
  buffer.writeln("Total Buah Matang Kecil: ${data.totalBuahMatangKecil}");

  buffer.writeln("\nTotal Buah Mentah: ${data.totalBuahMentah}");
  buffer.writeln("Total Buah Matang: ${data.totalBuahMatang}");
  
  return buffer.toString();
}