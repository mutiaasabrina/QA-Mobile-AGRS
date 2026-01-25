class SampleAncakPemupukanSummary {
  final String nama;
  final int jumlahSample;
  final Map<String, int> pokokTerpupuk;
  final Map<String, int> piringan;
  final Map<String, int> caraAplikasi;

  SampleAncakPemupukanSummary({
    required this.nama,
    required this.jumlahSample,
    required this.pokokTerpupuk,
    required this.piringan,
    required this.caraAplikasi,
  });
}

class PemupukanAncakSummary {
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
  final int totalUjiPetikAktif;
  final int totalHasilUjiPetikSesuai;
  final String tanggalPeriksaMutuAncak;
  final List<SampleAncakPemupukanSummary> tenagaTaburList;
  int getTotalSample(){
    return tenagaTaburList.fold(0,(sum, e)=> sum +e.jumlahSample);
  }

  PemupukanAncakSummary({
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
    required this.totalUjiPetikAktif,
    required this.totalHasilUjiPetikSesuai,
    required this.tanggalPeriksaMutuAncak,
    required this.tenagaTaburList,
  });
}

String generateRingkasanText(PemupukanAncakSummary data) {
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
  buffer.writeln("Uji Petik Aktif: ${data.totalUjiPetikAktif}");
  buffer.writeln("Uji Petik Sesuai: ${data.totalHasilUjiPetikSesuai}");
  buffer.writeln("Total Pokok Sample: ${data.getTotalSample()}");

  for (final t in data.tenagaTaburList) {
    buffer.writeln("\nTenaga Tabur: ${t.nama}");
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

    addMap("Pokok Terpupuk", t.pokokTerpupuk);
    addMap("Kondisi Piringan", t.piringan);
    addMap("Cara Aplikasi", t.caraAplikasi);
  }

  return buffer.toString();
}