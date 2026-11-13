import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import '../models/pembacaan_sensor.dart';
class DatabaseHelper {
  DatabaseHelper._internal();
  static final DatabaseHelper instance = DatabaseHelper._internal();
  Database? _database;
  Future<Database> get database async {
    _database ??= await _initDatabase();
    return _database!;
  }
  Future<Database> _initDatabase() async {
    final path = join(await getDatabasesPath(), 'peringatan_dini.db');
    return openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE pembacaan_sensor (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            jenis_sensor TEXT NOT NULL,
            nilai REAL NOT NULL,
            lokasi_pos TEXT NOT NULL,
            waktu TEXT NOT NULL
          )
        ''');
      },
    );
  }
  Future<int> tambahPembacaan(PembacaanSensor p) async {
    final db = await database;
    return db.insert('pembacaan_sensor', p.toMap());
  }
  Future<List<PembacaanSensor>> ambilSemuaPembacaan() async {
    final db = await database;
    final hasil = await db.query('pembacaan_sensor', orderBy: 'id DESC');
    return hasil.map(PembacaanSensor.fromMap).toList();
  }
  Future<List<PembacaanSensor>> ambilTerbaruPerJenis() async {
    final db = await database;
    final hasil = await db.rawQuery('''
      SELECT * FROM pembacaan_sensor
      WHERE id IN (SELECT MAX(id) FROM pembacaan_sensor GROUP BY jenis_sensor)
    ''');
    return hasil.map(PembacaanSensor.fromMap).toList();
  }
  Future<int> ubahPembacaan(PembacaanSensor p) async {
    final db = await database;
    return db.update(
      'pembacaan_sensor',
      p.toMap(),
      where: 'id = ?',
      whereArgs: [p.id],
    );
  } 
  Future<int> hapusPembacaan(int id) async {
    final db = await database;
    return db.delete('pembacaan_sensor', where: 'id = ?', whereArgs: [id]);
  }
}
