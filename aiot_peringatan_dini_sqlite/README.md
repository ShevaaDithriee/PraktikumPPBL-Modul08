# aiot_peringatan_dini_sqlite

Cara memakai:
1. flutter create aiot_peringatan_dini_sqlite
2. Ganti folder lib/ proyek tersebut dengan folder lib/ dari paket ini
3. cd aiot_peringatan_dini_sqlite && flutter pub add flutter_bloc sqflite path
4. Hapus test/widget_test.dart (merujuk MyApp bawaan)
5. flutter analyze && flutter run
Catatan: jika skema tabel diubah setelah aplikasi pernah berjalan, uninstall aplikasi dari emulator agar onCreate berjalan lagi.
