# Analisis, Pembahasan, dan Kesimpulan

## Analisis

Aplikasi Peringatan Dini Bencana dibuat untuk memantau tiga jenis parameter lingkungan, yaitu ketinggian air, pergeseran tanah, dan curah hujan. Setiap jenis sensor memiliki satuan dan pos pemantauan tersendiri. Data pembacaan ditampilkan pada dashboard, diberi status berdasarkan ambang batas, lalu dapat disimpan sebagai riwayat agar pengguna dapat meninjau dan mengoreksi data sebelumnya.

Aplikasi menggunakan Flutter dengan pola state management `flutter_bloc`. `SensorCubit` menyimpan kondisi terbaru sensor dan menangani input manual maupun simulasi otomatis. Data persistennya dikelola oleh `DatabaseHelper` menggunakan SQLite melalui `sqflite`. Tabel `pembacaan_sensor` menyimpan jenis sensor, nilai, lokasi pos, dan waktu pembacaan. Dengan demikian, dashboard mengambil pembacaan terbaru per jenis sensor, sedangkan halaman riwayat menampilkan seluruh catatan berdasarkan urutan terbaru.

Penentuan status menggunakan dua ambang untuk setiap parameter. Ketinggian air berada pada status waspada mulai 150 cm dan siaga mulai 250 cm; pergeseran tanah pada 5 mm dan 15 mm; curah hujan pada 20 mm/jam dan 50 mm/jam. Status keseluruhan mengikuti tingkat tertinggi dari pembacaan terbaru masing-masing jenis sensor. Rentang di bawah ambang pertama diberi status aman.

## Pembahasan

Fitur dashboard memudahkan pengguna melihat kondisi tiga sensor dalam satu halaman. Pengguna dapat memasukkan nilai secara manual untuk merepresentasikan data dari perangkat, sementara simulasi otomatis menghasilkan nilai acak setiap lima detik untuk memperagakan perubahan pembacaan. Setiap pembacaan yang dicatat langsung memperbarui state aplikasi dan disimpan ke SQLite, sehingga data terbaru tetap tersedia setelah aplikasi dibuka kembali.

SQLite sesuai untuk prototipe atau aplikasi lokal karena penyimpanan dapat dilakukan langsung pada perangkat tanpa server. Riwayat juga menyediakan operasi baca, koreksi, dan hapus: pengguna dapat membuka catatan untuk mengubah nilainya dan menggeser item untuk menghapusnya. Pemisahan model, Cubit, helper basis data, halaman, dan widget membantu menjaga tanggung jawab kode tetap terstruktur.

Simulasi yang tersedia masih menggunakan angka acak, bukan data dari perangkat IoT atau layanan pemantauan nyata. Ambang status juga merupakan nilai tetap di dalam kode. Karena itu, aplikasi ini menunjukkan alur pencatatan dan penyajian peringatan secara edukatif, tetapi belum dapat dipakai sebagai sumber peringatan keselamatan. Penggunaan nyata memerlukan integrasi sensor dan konektivitas, kalibrasi serta validasi ambang oleh pihak berwenang, penanganan data tidak valid atau sensor terputus, dan mekanisme penyampaian notifikasi yang andal. Input manual saat ini juga hanya memeriksa apakah teks dapat diubah menjadi angka, sehingga validasi nilai dan batas fisik masih dapat ditingkatkan.

## Kesimpulan

Aplikasi Peringatan Dini Bencana dengan SQLite berhasil mendemonstrasikan pemantauan beberapa jenis sensor, pengelompokan status aman, waspada, dan siaga, serta penyimpanan pembacaan dan riwayat secara lokal. Integrasi Flutter, `flutter_bloc`, dan SQLite mendukung pembaruan tampilan, simulasi pembacaan, serta pengelolaan data yang sederhana. Untuk menjadikannya sistem peringatan dini yang siap digunakan, aplikasi perlu dikembangkan dengan sumber data sensor nyata, ambang terverifikasi, validasi dan penanganan kegagalan, serta kanal notifikasi yang sesuai.
