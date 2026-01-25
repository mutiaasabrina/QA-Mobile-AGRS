// ignore_for_file: prefer_const_constructors

class TenagaTaburSummary {
  final String nama;
  final int jumlahSample;
  final String jumlahAlatTabur;
  final String apd;
  final Map<String, int> pokokTerpupuk;
  final Map<String, int> piringan;
  final Map<String, int> caraAplikasi;
  final Map<String, int> dosis;

  TenagaTaburSummary({
    required this.nama,
    required this.jumlahSample,
    required this.jumlahAlatTabur,
    required this.apd,
    required this.pokokTerpupuk,
    required this.piringan,
    required this.caraAplikasi,
    required this.dosis,
  });
}

class QAPemupukanSummary {
  final String tanggalPeriksa;
  final String namaPetugas;
  final String kebun;
  final String divisi;
  final String blok;
  final String tanggalPemupukan;
  final String jenisPupuk;
  final String dosis;
  final String tenagaPemupuk;
  final String supervisi;
  final String fisikPupuk;
  final String totalAlatTabur;
  final String totalAlatTaburSeragam;
  final String totalAlatTaburTidakSeragam;
  final int totalUjiPetikAktif;
  final int totalUjiPetikTidakAktif;
  final int totalDosisSesuai;
  final int totalDosisTidakSesuai;
  final String apdPekerja;

  QAPemupukanSummary({
    required this.tanggalPeriksa,
    required this.namaPetugas,
    required this.kebun,
    required this.divisi,
    required this.blok,
    required this.tanggalPemupukan,
    required this.jenisPupuk,
    required this.dosis,
    required this.tenagaPemupuk,
    required this.supervisi,
    required this.fisikPupuk,
    required this.totalAlatTabur,
    required this.totalAlatTaburSeragam,
    required this.totalAlatTaburTidakSeragam,
    required this.totalUjiPetikAktif,
    required this.totalUjiPetikTidakAktif,
    required this.totalDosisSesuai,
    required this.totalDosisTidakSesuai,
    required this.apdPekerja,
  });
}

String generateRingkasanText(QAPemupukanSummary data) {
  final buffer = StringBuffer();

  buffer.writeln("Tanggal Pemeriksaan: ${data.tanggalPeriksa}");
  buffer.writeln("Nama Petugas: ${data.namaPetugas}");
  buffer.writeln("Kebun: ${data.kebun}");
  buffer.writeln("Divisi: ${data.divisi}");
  buffer.writeln("Blok: ${data.blok}");
  buffer.writeln("Tanggal Pemupukan: ${data.tanggalPemupukan}");
  buffer.writeln("Jenis Pupuk: ${data.jenisPupuk}");
  buffer.writeln("Dosis/Pokok: ${data.dosis}");
  buffer.writeln("Tenaga Pemupuk: ${data.tenagaPemupuk}");
  buffer.writeln("Supervisi: ${data.supervisi}");
  buffer.writeln("Fisik Pupuk: ${data.fisikPupuk}");
  buffer.writeln("Total Alat Tabur: ${data.totalAlatTabur}");
  buffer.writeln("Total Alat Tabur Seragam: ${data.totalAlatTaburSeragam}");
  buffer.writeln("Total Alat Tabur Tidak Seragam: ${data.totalAlatTaburTidakSeragam}");
  buffer.writeln("Total Uji Aktif: ${data.totalUjiPetikAktif}");
  buffer.writeln("Total Uji Tidak Aktif: ${data.totalUjiPetikTidakAktif}");
  buffer.writeln("Total Dosis Sesuai: ${data.totalDosisSesuai}");
  buffer.writeln("Total Dosis Tidak Sesuai: ${data.totalDosisTidakSesuai}");
  buffer.writeln("APD Pekerja: ${data.apdPekerja}");
  
  return buffer.toString();
}