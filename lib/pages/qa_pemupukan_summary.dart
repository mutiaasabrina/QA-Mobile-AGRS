// ignore_for_file: prefer_const_constructors

class TenagaTaburSummary {
  final String nama;
  final int jumlahSample;
  final String jumlahAlatTabur;
  final String apd;
  final Map<String, int> pocket;
  final Map<String, int> pokokTerpupuk;
  final Map<String, int> piringan;
  final Map<String, int> caraAplikasi;
  final Map<String, int> dosis;

  TenagaTaburSummary({
    required this.nama,
    required this.jumlahSample,
    required this.jumlahAlatTabur,
    required this.apd,
    required this.pocket,
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
  final List<TenagaTaburSummary> tenagaTaburList;
  int getTotalSample(){
    return tenagaTaburList.fold(0,(sum, e)=> sum +e.jumlahSample);
  }

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
    required this.tenagaTaburList,
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
  buffer.writeln("Total Pokok Sample: ${data.getTotalSample()}");

  for (final t in data.tenagaTaburList) {
    buffer.writeln("\nTenaga Tabur: ${t.nama}");
    buffer.writeln("Jumlah Sample: ${t.jumlahSample}");
    buffer.writeln("Alat Tabur: ${t.jumlahAlatTabur}");
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

    addMap("Lubang Pocket", t.pocket);
    addMap("Pokok Terpupuk", t.pokokTerpupuk);
    addMap("Kondisi Piringan", t.piringan);
    addMap("Cara Aplikasi", t.caraAplikasi);
    addMap("Dosis Alat Tabur", t.dosis);
  }

  return buffer.toString();
}