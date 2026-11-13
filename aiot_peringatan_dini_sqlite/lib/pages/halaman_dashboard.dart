import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/sensor_cubit.dart';
import '../models/sensor.dart';
import '../widgets/sensor_card.dart';
import '../widgets/theme_toggle_button.dart';
class HalamanDashboard extends StatefulWidget {
  const HalamanDashboard({super.key});
  @override
  State<HalamanDashboard> createState() => _HalamanDashboardState();
}
class _HalamanDashboardState extends State<HalamanDashboard> {
  late bool _simulasi;
  @override
  void initState() {
    super.initState();
    _simulasi = context.read<SensorCubit>().simulasiAktif;
  }
  Future<void> _inputManual(Sensor sensor) async {
    final controller = TextEditingController();
    final nilai = await showDialog<double>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Input ${sensor.jenis.label}'),
        content: TextField(
          controller: controller,
          autofocus: true,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          decoration: InputDecoration(
            labelText: 'Nilai (${sensor.jenis.satuan})',
          ),
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
    if (nilai == null || !mounted) return;
    await context.read<SensorCubit>().catatPembacaan(sensor.jenis, nilai);
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Pembacaan tersimpan ke SQLite.')),
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard Sensor'),
        actions: const [ThemeToggleButton()],
      ),
      body: Column(
        children: [
          SwitchListTile(
            title: const Text('Simulasi otomatis (tiap 5 detik)'),
            value: _simulasi,
            onChanged: (v) {
              final cubit = context.read<SensorCubit>();
              v ? cubit.mulaiSimulasi() : cubit.hentikanSimulasi();
              setState(() => _simulasi = v);
            },
          ),
          Expanded(
            child: BlocBuilder<SensorCubit, List<Sensor>>(
              builder: (context, daftar) => ListView.builder(
                itemCount: daftar.length,
                itemBuilder: (context, i) => SensorCard(
                  sensor: daftar[i],
                  onInput: () => _inputManual(daftar[i]),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
