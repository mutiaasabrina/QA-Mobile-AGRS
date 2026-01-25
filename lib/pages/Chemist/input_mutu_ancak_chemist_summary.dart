class SampleAncakChemistSummary {
  final String nama;
  final int jumlahSample;
  final Map<String, int> pokokTersemprot;
  final int gulmaCircle;
  final int gulmaPath;
  final int gulmaTPH;
  final int gulmaGawangan;

  SampleAncakChemistSummary({
    required this.nama,
    required this.jumlahSample,
    required this.pokokTersemprot,
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
  final String kondisiAlatSemprot;
  final String keseragamanNozel;
  final String apdPekerja;
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
    required this.kondisiAlatSemprot,
    required this.keseragamanNozel,
    required this.apdPekerja,
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
    buffer.writeln("Jumlah Sample: ${t.jumlahSample}");

    buffer.writeln("🔹 Kematian Gulma Circle: ${t.gulmaCircle}");
    buffer.writeln("🔹 Kematian Gulma Path: ${t.gulmaPath}");
    buffer.writeln("🔹 Kematian Gulma TPH: ${t.gulmaTPH}");

    if(data.chemist == 'Chemist CPT + Gawangan' || data.chemist == 'Chemist Gawangan')
    {
      buffer.writeln("🔹 Kematian Gulma Gawangan: ${t.gulmaGawangan}");
    }

    void addMap(String title, Map<String, int> map) {
      buffer.writeln("🔹 $title:");
      map.forEach((key, value) {
        if (key.isEmpty || key == "-") {
          return;
        }
        buffer.writeln("     - $key: $value");
      });
    }

    addMap("Pokok Tersemprot", t.pokokTersemprot);

    // addMap("Total Circle", t.gulmaCircle);
    // addMap("Total Path", t.gulmaPath);
    // addMap("Total TPH", t.gulmaTPH);
  }

  return buffer.toString();
}