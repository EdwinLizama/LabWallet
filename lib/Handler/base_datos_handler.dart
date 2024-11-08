import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../Models/gasto_Model.dart';

class BaseDatosHandler {
  // Singleton para asegurar una única instancia de BaseDatosHandler
  static final BaseDatosHandler _instancia = BaseDatosHandler._interno();
  Database? _baseDatos;

  static var instance;

  factory BaseDatosHandler() => _instancia;

  BaseDatosHandler._interno();

  // Getter para obtener la base de datos, la inicializa si es nula
  Future<Database> get baseDatos async {
    if (_baseDatos != null) return _baseDatos!;
    _baseDatos =
        await _inicializarBaseDatos(); // Inicializa la base de datos si no está creada
    return _baseDatos!;
  }

  // Método para inicializar la base de datos y crear tablas si es necesario
  Future<Database> _inicializarBaseDatos() async {
    String rutaDB =
        await getDatabasesPath(); // Ruta predeterminada para bases de datos
    String ruta =
        join(rutaDB, 'gastos.db'); // Nombre del archivo de la base de datos

    return await openDatabase(
      ruta,
      version: 3, // Versión de la base de datos para control de actualizaciones
      onCreate: (db, version) async {
        await _crearTablaGastos(db); // Crea la tabla de gastos
        await _crearTablaConfig(db); // Crea la tabla de configuración
      },
      onUpgrade: (db, oldVersion, newVersion) async {
        // Actualiza la base de datos si la versión ha cambiado
        if (oldVersion < 3) {
          await _crearTablaConfig(db); // Crea la tabla `config` si no existe
        }
      },
    );
  }

  // Método para crear la tabla de gastos
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

  // Método para crear la tabla de configuración limites de gasto
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

  // Inserta un nuevo gasto en la base de datos
  Future<void> insertarGasto(Gasto gasto) async {
    final db = await baseDatos;
    await db.insert('gastos', gasto.toMap());
  }

  // Obtiene todos los gastos de la base de datos
  Future<List<Gasto>> obtenerGastos() async {
    final db = await baseDatos;
    final List<Map<String, dynamic>> mapas = await db.query('gastos');
    return List.generate(mapas.length, (i) => Gasto.fromMap(mapas[i]));
  }

  // Actualiza un gasto existente en la base de datos
  Future<void> actualizarGasto(Gasto gasto) async {
    final db = await baseDatos;
    await db.update('gastos', gasto.toMap(),
        where: 'id = ?', whereArgs: [gasto.id]);
  }

  // Elimina un gasto de la base de datos mediante su ID
  Future<void> eliminarGasto(int id) async {
    final db = await baseDatos;
    await db.delete('gastos', where: 'id = ?', whereArgs: [id]);
  }

  // Métodos para manejar el límite de gasto en la tabla `config`

  // Establece un límite de gasto mensual en la base de datos
  Future<void> establecerLimiteGasto(double limite) async {
    final db = await baseDatos;
    await db.insert(
      'config',
      {'clave': 'limite_gasto', 'valor': limite},
      conflictAlgorithm: ConflictAlgorithm.replace, // Reemplaza si ya existe
    );
  }

  // Obtiene el límite de gasto mensual almacenado en la base de datos
  Future<double> obtenerLimiteGasto() async {
    final db = await baseDatos;
    final List<Map<String, dynamic>> result = await db.query(
      'config',
      columns: ['valor'],
      where: 'clave = ?',
      whereArgs: ['limite_gasto'],
    );
    return result.isNotEmpty
        ? result.first['valor'] as double
        : 0.0; // Devuelve 0.0 si no hay límite
  }

  // Cierra la conexión con la base de datos
  Future<void> cerrar() async {
    final db = await baseDatos;
    db.close();
  }
}
