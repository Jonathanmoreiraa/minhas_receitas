import 'dart:io';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

// Import para desktop
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

class DBHelper {
  static Database? _db;

  static Future<Database> get database async {
    if (_db != null) return _db!;
    _db = await initDB();
    return _db!;
  }

  static Future<Database> initDB() async {
    if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
      // Inicializa o sqflite_common_ffi para desktop
      sqfliteFfiInit();

      // Usa o databaseFactoryFfi para abrir o banco no desktop
      var databaseFactory = databaseFactoryFfi;

      final dbPath = await databaseFactory.getDatabasesPath();
      final path = join(dbPath, 'receitas.db');

      return await databaseFactory.openDatabase(
        path,
        options: OpenDatabaseOptions(
          version: 1,
          onCreate: (db, version) async {
            await db.execute('''
              CREATE TABLE receitas (
                id INTEGER PRIMARY KEY AUTOINCREMENT,
                nome TEXT,
                ingredientes TEXT,
                modoPreparoJson TEXT,
                imagemCapaPath TEXT
              )
            ''');
          },
        ),
      );
    } else {
      // Mobile (Android/iOS) usa sqflite padrão
      final path = join(await getDatabasesPath(), 'receitas.db');
      return await openDatabase(
        path,
        version: 1,
        onCreate: (db, version) async {
          await db.execute('''
            CREATE TABLE receitas (
              id INTEGER PRIMARY KEY AUTOINCREMENT,
              nome TEXT,
              ingredientes TEXT,
              modoPreparoJson TEXT,
              imagemCapaPath TEXT
            )
          ''');
        },
      );
    }
  }
}
