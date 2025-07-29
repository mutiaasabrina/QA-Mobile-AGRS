// ignore_for_file: prefer_const_constructors

class TenagaSemprotSummary {
  final String nama;
  final int jumlahSample;
  final String apd;
  final String kondisiAlat;
  final String keseragamanNozel;
  final Map<String, int> ujiPetik;

  TenagaSemprotSummary({
    required this.nama,
    required this.jumlahSample,
    required this.apd,
    required this.kondisiAlat,
    required this.keseragamanNozel,
    required this.ujiPetik
  });
}

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
  final int totalUjiPetik;
  final List<TenagaSemprotSummary> tenagaSemprotList;
  int getTotalSample(){
    return tenagaSemprotList.fold(0,(sum, e)=> sum +e.jumlahSample);
  }

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
    required this.totalUjiPetik,
    required this.tenagaSemprotList,
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
  buffer.writeln("Peletakan Alat Semprot: ${data.peletakanAlatSemprot}");
  buffer.writeln("Total Pokok Sample: ${data.getTotalSample()}");
  buffer.writeln("Total Tenaga Semprot: ${data.tenagaSemprotList.length}");
  buffer.writeln("Total Uji Petik: ${data.totalUjiPetik}");

  for (final t in data.tenagaSemprotList) {
    buffer.writeln("\nTenaga Semprot: ${t.nama}");
    buffer.writeln("Jumlah Sample: ${t.jumlahSample}");
    buffer.writeln("Kondisi Alat Semprot: ${t.kondisiAlat}");
    buffer.writeln("Keseragaman Nozel: ${t.keseragamanNozel}");
    buffer.writeln("APD: ${t.apd}");


    void addMap(String title, Map<String, int> map) {
      buffer.writeln("🔹 $title:");
      map.forEach((key, value) {
        if (key.isEmpty || key == "-") {
          return;
        }
        buffer.writeln("     - $key: $value");
      });
    }

    addMap("Uji Petik", t.ujiPetik);
  }

  return buffer.toString();
}