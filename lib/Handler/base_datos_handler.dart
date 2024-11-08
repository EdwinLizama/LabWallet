import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../Models/gasto_Model.dart';

class BaseDatosHandler {
  static final BaseDatosHandler _instancia = BaseDatosHandler._interno();
  Database? _baseDatos;

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
      version: 1,
      onCreate: _crearTablaGastos,
    );
  }

  Future<void> _crearTablaGastos(Database db, int version) async {
    await db.execute('''
      CREATE TABLE gastos(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        monto REAL,
        categoria TEXT,
        descripcion TEXT,
        fecha TEXT
      )
    ''');
  }

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

  Future<void> cerrar() async {
    final db = await baseDatos;
    db.close();
  }
}
