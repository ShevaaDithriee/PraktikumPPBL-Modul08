import 'dart:async';
import 'dart:math';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../db/database_helper.dart';
import '../models/pembacaan_sensor.dart';
import '../models/sensor.dart';
class SensorCubit extends Cubit<List<Sensor>> {
  SensorCubit()
      : super(const [
          Sensor(jenis: JenisSensor.ketinggianAir, lokasiPos: 'Pos Sungai Citarum'),
          Sensor(jenis: JenisSensor.pergeseranTanah, lokasiPos: 'Pos Lereng Lembang'),
          Sensor(jenis: JenisSensor.curahHujan, lokasiPos: 'Pos Cekungan Bandung'),
        ]) {
    _muatAwal();
  }
  Timer? _timer;
  final _acak = Random();
  bool get simulasiAktif => _timer != null;
  Future<void> _muatAwal() async {
    final data = await DatabaseHelper.instance.ambilTerbaruPerJenis();
    if (isClosed || data.isEmpty) return;
    emit(state.map((s) {
      final cocok = data.where((p) => p.jenis == s.jenis);
      if (cocok.isEmpty) return s;
      return s.copyWith(nilai: cocok.first.nilai, waktu: cocok.first.waktu);
    }).toList());
  }
  Future<void> catatPembacaan(JenisSensor jenis, double nilai) async {
    final waktu = DateTime.now().toIso8601String();
    final sensor = state.firstWhere((s) => s.jenis == jenis);
    emit(state
        .map((s) => s.jenis == jenis ? s.copyWith(nilai: nilai, waktu: waktu) : s)
        .toList());
    await DatabaseHelper.instance.tambahPembacaan(
      PembacaanSensor(
        jenisSensor: jenis.kode,
        nilai: nilai,
        lokasiPos: sensor.lokasiPos,
        waktu: waktu,
      ),
    );
  }
  double _nilaiAcak(JenisSensor jenis) {
    final maks = switch (jenis) {
      JenisSensor.ketinggianAir => 320.0,
      JenisSensor.pergeseranTanah => 25.0,
      JenisSensor.curahHujan => 70.0,
    };
    return double.parse((_acak.nextDouble() * maks).toStringAsFixed(1));
  }
  void mulaiSimulasi() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 5), (_) {
      for (final s in List<Sensor>.of(state)) {
        catatPembacaan(s.jenis, _nilaiAcak(s.jenis));
      }
    });
  }
  void hentikanSimulasi() {
    _timer?.cancel();
    _timer = null;
  }
  @override
  Future<void> close() {
    _timer?.cancel();
    return super.close();
  }
}
