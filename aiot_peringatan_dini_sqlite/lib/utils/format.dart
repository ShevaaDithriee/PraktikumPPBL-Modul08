String formatNilai(double v) => v.toStringAsFixed(1);

String formatWaktu(String iso) {
  final d = DateTime.tryParse(iso);
  if (d == null) return iso;
  String dua(int n) => n.toString().padLeft(2, '0');
  return '${dua(d.day)}/${dua(d.month)}/${d.year} '
      '${dua(d.hour)}:${dua(d.minute)}:${dua(d.second)}';
}
