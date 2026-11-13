enum JenisSensor {
  ketinggianAir('ketinggian_air', 'Ketinggian Air', 'cm'),
  pergeseranTanah('pergeseran_tanah', 'Pergeseran Tanah', 'mm'),
  curahHujan('curah_hujan', 'Curah Hujan', 'mm/jam');
  final String kode;
  final String label;
  final String satuan;
  const JenisSensor(this.kode, this.label, this.satuan);
  static JenisSensor dariKode(String kode) => values.firstWhere(
        (j) => j.kode == kode,
        orElse: () => JenisSensor.ketinggianAir,
      );}enum StatusSiaga {
  aman('Aman'),
  waspada('Waspada'),
  siaga('Siaga');
  final String label;
  const StatusSiaga(this.label);
}StatusSiaga hitungStatus(JenisSensor jenis, double nilai) {
  final batas = switch (jenis) {
    JenisSensor.ketinggianAir => (150.0, 250.0),
    JenisSensor.pergeseranTanah => (5.0, 15.0),
    JenisSensor.curahHujan => (20.0, 50.0),
  };if (nilai >= batas.$2) return StatusSiaga.siaga;
  if (nilai >= batas.$1) return StatusSiaga.waspada;
  return StatusSiaga.aman;
}class Sensor {
  final JenisSensor jenis;
  final String lokasiPos;
  final double nilai;
  final String? waktu;
  const Sensor({
    required this.jenis,
    required this.lokasiPos,
    this.nilai = 0,
    this.waktu,
  });Sensor copyWith({double? nilai, String? waktu}) => Sensor(
        jenis: jenis,
        lokasiPos: lokasiPos,
        nilai: nilai ?? this.nilai,
        waktu: waktu ?? this.waktu,
      );
}
