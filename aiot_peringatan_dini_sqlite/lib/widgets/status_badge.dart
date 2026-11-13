import 'package:flutter/material.dart';
import '../models/sensor.dart';

class StatusBadge extends StatelessWidget {
  final StatusSiaga status;
  const StatusBadge({super.key, required this.status});

  static Color warna(StatusSiaga s) => switch (s) {
        StatusSiaga.aman => Colors.green.shade700,
        StatusSiaga.waspada => Colors.orange.shade800,
        StatusSiaga.siaga => Colors.red.shade700,
      };

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: warna(status),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        status.label,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 12,
        ),
      ),
    );
  }
}
