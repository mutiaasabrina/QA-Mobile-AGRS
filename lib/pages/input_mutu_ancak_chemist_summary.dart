class SampleAncakChemistSummary {
  final String baris;
  final int jumlahSample;
  final Map<String, int> gulmaCircle;
  final Map<String, int> gulmaPath;
  final Map<String, int> gulmaTPH;
  final Map<String, int> gulmaGawangan;

  SampleAncakChemistSummary({
    required this.baris,
    required this.jumlahSample,
    required this.gulmaCircle,
    required this.gulmaPath,
    required this.gulmaTPH,
    required this.gulmaGawangan,
  });
}

class ChemistAncakSummary {
  final String tanggalPeriksa;
  final String namaPetugas;
  final String kebun;
  final String divisi;
  final String blok;
  final String tanggalPenyemprotan;
  final String luasan;
  final String chemist;
  final String jenisChemist;
  final String dosis;
  final String tanggalPeriksaMutuAncak;
  final List<SampleAncakChemistSummary> sampleAncakList;
  int getTotalSample(){
    return sampleAncakList.fold(0,(sum, e)=> sum +e.jumlahSample);
  }

  ChemistAncakSummary({
    required this.tanggalPeriksa,
    required this.namaPetugas,
    required this.kebun,
    required this.divisi,
    required this.blok,
    required this.tanggalPenyemprotan,
    required this.luasan,
    required this.chemist,
    required this.jenisChemist,
    required this.dosis,
    required this.tanggalPeriksaMutuAncak,
    required this.sampleAncakList,
  });
}

String generateRingkasanText(ChemistAncakSummary data) {
  final buffer = StringBuffer();

  buffer.writeln("Tanggal Pemeriksaan Terakhir: ${data.tanggalPeriksa}");
  buffer.writeln("Nama Petugas: ${data.namaPetugas}");
  buffer.writeln("Kebun: ${data.kebun}");
  buffer.writeln("Divisi: ${data.divisi}");
  buffer.writeln("Blok: ${data.blok}");
  buffer.writeln("Tanggal Semprot: ${data.tanggalPenyemprotan}");
  buffer.writeln("Luasan: ${data.luasan}");
  buffer.writeln("Chemist: ${data.chemist}");
  buffer.writeln("Jenis Chemist yang digunakan: ${data.jenisChemist}");
  buffer.writeln("Dosis / Knapsack (liter/ha): ${data.dosis}");
  buffer.writeln("Total Pokok Sample: ${data.getTotalSample()}");

  buffer.writeln("\nTanggal Periksa Mutu Ancak: ${data.tanggalPeriksaMutuAncak}");
  for (final t in data.sampleAncakList) {
    buffer.writeln("Baris: ${t.baris}");
    buffer.writeln("Jumlah Sample: ${t.jumlahSample}");

    void addMap(String title, Map<String, int> map) {
      buffer.writeln("🔹 $title:");
      map.forEach((key, value) {
        if (key.isEmpty || key == "-") {
          return;
        }
        buffer.writeln("     - $key: $value");
      });
    }

    addMap("Total Circle", t.gulmaCircle);
    addMap("Total Path", t.gulmaPath);
    addMap("Total TPH", t.gulmaTPH);
  }

  return buffer.toString();
}