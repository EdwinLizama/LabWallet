import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../Models/gasto_Model.dart';

class BaseDatosHandler {
  static final BaseDatosHandler _instancia = BaseDatosHandler._interno();
  Database? _baseDatos;

  static var instance;

  factory BaseDatosHandler() => _instancia;

  BaseDatosHandler._interno();

  Future<Database> get baseDatos async {
    if (_baseDatos != null) return _baseDatos!;
    _baseDatos = await _inicializarBaseDatos();
    return _baseDatos!;
  }

  Future<Database> _inicializarBaseDatos() async {
    String rutaDB = await getDatabasesPath();
    String ruta = join(rutaDB, 'gastos.db');

    return await openDatabase(
      ruta,
      version: 3, // Incrementa la versión para activar `onUpgrade`
      onCreate: (db, version) async {
        await _crearTablaGastos(db);
        await _crearTablaConfig(db);
      },
      onUpgrade: (db, oldVersion, newVersion) async {
        if (oldVersion < 3) {
          // Verificación en la actualización
          await _crearTablaConfig(db);
        }
      },
    );
  }

  Future<void> _crearTablaGastos(Database db) async {
    await db.execute('''
      CREATE TABLE IF NOT EXISTS gastos(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        monto REAL NOT NULL,
        categoria TEXT NOT NULL,
        descripcion TEXT,
        fecha TEXT NOT NULL
      )
    ''');
  }

  Future<void> _crearTablaConfig(Database db) async {
    await db.execute('''
      CREATE TABLE IF NOT EXISTS config(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        clave TEXT UNIQUE,
        valor REAL
      )
    ''');
  }

  // Métodos para manejar los gastos
  Future<void> insertarGasto(Gasto gasto) async {
    final db = await baseDatos;
    await db.insert('gastos', gasto.toMap());
  }

  Future<List<Gasto>> obtenerGastos() async {
    final db = await baseDatos;
    final List<Map<String, dynamic>> mapas = await db.query('gastos');
    return List.generate(mapas.length, (i) => Gasto.fromMap(mapas[i]));
  }

  Future<void> actualizarGasto(Gasto gasto) async {
    final db = await baseDatos;
    await db.update('gastos', gasto.toMap(),
        where: 'id = ?', whereArgs: [gasto.id]);
  }

  Future<void> eliminarGasto(int id) async {
    final db = await baseDatos;
    await db.delete('gastos', where: 'id = ?', whereArgs: [id]);
  }

  // Métodos para manejar el límite de gasto en `config`
  Future<void> establecerLimiteGasto(double limite) async {
    final db = await baseDatos;
    await db.insert(
      'config',
      {'clave': 'limite_gasto', 'valor': limite},
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<double> obtenerLimiteGasto() async {
    final db = await baseDatos;
    final List<Map<String, dynamic>> result = await db.query(
      'config',
      columns: ['valor'],
      where: 'clave = ?',
      whereArgs: ['limite_gasto'],
    );
    return result.isNotEmpty ? result.first['valor'] as double : 0.0;
  }

  Future<void> cerrar() async {
    final db = await baseDatos;
    db.close();
  }
}
