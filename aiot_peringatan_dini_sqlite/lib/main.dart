import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'cubit/sensor_cubit.dart';
import 'cubit/theme_cubit.dart';
import 'pages/halaman_dashboard.dart';
import 'pages/halaman_riwayat.dart';
import 'theme/app_theme.dart';
void main() {
  runApp(const PeringatanDiniApp());
}
class PeringatanDiniApp extends StatelessWidget {
  const PeringatanDiniApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => SensorCubit()),
        BlocProvider(create: (_) => ThemeCubit()),
      ],
      child: BlocBuilder<ThemeCubit, ThemeMode>(
        builder: (context, mode) => MaterialApp(
          title: 'Peringatan Dini Bencana',
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: mode,
          home: const KerangkaUtama(),
        ),
      ),
    );
  }
}
class KerangkaUtama extends StatefulWidget {
  const KerangkaUtama({super.key});

  @override
  State<KerangkaUtama> createState() => _KerangkaUtamaState();
}
class _KerangkaUtamaState extends State<KerangkaUtama> {
  int _indeks = 0;
  Widget get _halaman =>
      _indeks == 0 ? const HalamanDashboard() : const HalamanRiwayat();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _halaman,
      bottomNavigationBar: NavigationBar(
        selectedIndex: _indeks,
        onDestinationSelected: (i) => setState(() => _indeks = i),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.sensors), label: 'Dashboard'),
          NavigationDestination(icon: Icon(Icons.history), label: 'Riwayat'),
        ],
      ),
    );
  }
}
