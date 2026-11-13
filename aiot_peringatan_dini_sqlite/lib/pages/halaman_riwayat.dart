import 'package:flutter/material.dart';
import '../db/database_helper.dart';
import '../models/pembacaan_sensor.dart';
import '../models/sensor.dart';
import '../utils/format.dart';
import '../widgets/sensor_card.dart';
import '../widgets/status_badge.dart';
class HalamanRiwayat extends StatefulWidget {
  const HalamanRiwayat({super.key});
  @override
  State<HalamanRiwayat> createState() => _HalamanRiwayatState();
}
class _HalamanRiwayatState extends State<HalamanRiwayat> {
  late Future<List<PembacaanSensor>> _daftar;
  late Future<StatusSiaga> _status;
  @override
  void initState() {
    super.initState();
    _muatUlang();
  }
  void _muatUlang() {
    setState(() {
      _daftar = DatabaseHelper.instance.ambilSemuaPembacaan();
      _status = DatabaseHelper.instance
          .ambilTerbaruPerJenis()
          .then(statusKeseluruhan);
    });
  }
  Future<void> _koreksi(PembacaanSensor p) async {
    final controller = TextEditingController(text: formatNilai(p.nilai));
    final nilaiBaru = await showDialog<double>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Koreksi Nilai Pembacaan'),
        content: TextField(
          controller: controller,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          decoration: InputDecoration(labelText: 'Nilai (${p.jenis.satuan})'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(
              context,
              double.tryParse(controller.text.replaceAll(',', '.')),
            ),
            child: const Text('Simpan'),
          ),
        ],
      ),
    );
    if (nilaiBaru == null) return;
    await DatabaseHelper.instance.ubahPembacaan(
      PembacaanSensor(
        id: p.id,
        jenisSensor: p.jenisSensor,
        nilai: nilaiBaru,
        lokasiPos: p.lokasiPos,
        waktu: p.waktu,
      ),
    );
    if (!mounted) return;
    _muatUlang();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Riwayat Sensor'),
        actions: [
          FutureBuilder<StatusSiaga>(
            future: _status,
            builder: (context, snap) => snap.hasData
                ? Padding(
                    padding: const EdgeInsets.only(right: 12),
                    child: StatusBadge(status: snap.data!),
                  )
                : const SizedBox.shrink(),
          ),
        ],
      ),
      body: FutureBuilder<List<PembacaanSensor>>(
        future: _daftar,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          final daftar = snapshot.data ?? [];
          if (daftar.isEmpty) {
            return const Center(child: Text('Belum ada riwayat pembacaan.'));
          }
          return ListView.builder(
            itemCount: daftar.length,
            itemBuilder: (context, index) {
              final p = daftar[index];
              final status = hitungStatus(p.jenis, p.nilai);
              return Dismissible(
                key: ValueKey(p.id),
                direction: DismissDirection.endToStart,
                background: Container(
                  color: Colors.red,
                  alignment: Alignment.centerRight,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: const Icon(Icons.delete, color: Colors.white),
                ),
                onDismissed: (_) async {
                  await DatabaseHelper.instance.hapusPembacaan(p.id!);
                  if (!mounted) return;
                  _muatUlang();
                },
                child: ListTile(
                  isThreeLine: true,
                  leading: Icon(ikonSensor(p.jenis)),
                  title: Text(
                      '${p.jenis.label} • ${formatNilai(p.nilai)} ${p.jenis.satuan}'),
                  subtitle: Text('${p.lokasiPos}\n${formatWaktu(p.waktu)}'),
                  trailing: StatusBadge(status: status),
                  onTap: () => _koreksi(p),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
