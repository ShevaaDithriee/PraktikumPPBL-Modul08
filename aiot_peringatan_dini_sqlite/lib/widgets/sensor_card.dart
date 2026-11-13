import 'package:flutter/material.dart';
import '../models/sensor.dart';
import '../utils/format.dart';
import 'primary_button.dart';
import 'status_badge.dart';
IconData ikonSensor(JenisSensor j) => switch (j) {
      JenisSensor.ketinggianAir => Icons.water_drop,
      JenisSensor.pergeseranTanah => Icons.terrain,
      JenisSensor.curahHujan => Icons.grain,
    };
class SensorCard extends StatelessWidget {
  final Sensor sensor;
  final VoidCallback onInput;
  const SensorCard({super.key, required this.sensor, required this.onInput});
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final status = hitungStatus(sensor.jenis, sensor.nilai);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(ikonSensor(sensor.jenis), color: theme.colorScheme.primary),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(sensor.jenis.label,
                      style: theme.textTheme.titleMedium),
                ),
                StatusBadge(status: status),
              ],
            ),
            const SizedBox(height: 4),
            Text(sensor.lokasiPos, style: theme.textTheme.bodySmall),
            const SizedBox(height: 12),
            Text(
              '${formatNilai(sensor.nilai)} ${sensor.jenis.satuan}',
              style: theme.textTheme.headlineMedium
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
            Text(
              sensor.waktu == null
                  ? 'Belum ada pembacaan'
                  : 'Update: ${formatWaktu(sensor.waktu!)}',
              style: theme.textTheme.bodySmall,
            ),
            const SizedBox(height: 8),
            Align(
              alignment: Alignment.centerRight,
              child: PrimaryButton(
                label: 'Input Manual',
                icon: Icons.edit_note,
                onPressed: onInput,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
