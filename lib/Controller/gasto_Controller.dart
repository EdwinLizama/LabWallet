// ignore_for_file: file_names

import '../Models/gasto_Model.dart';
import '../Handler/base_datos_handler.dart';

class GastoControlador {
  final BaseDatosHandler _dbHelper = BaseDatosHandler();

  Future<void> agregarGasto(Gasto gasto) async {
    await _dbHelper.insertarGasto(gasto);
  }

  Future<List<Gasto>> obtenerGastos() async {
    return await _dbHelper.obtenerGastos();
  }

  Future<void> actualizarGasto(Gasto gasto) async {
    await _dbHelper.actualizarGasto(gasto);
  }

  Future<void> eliminarGasto(int id) async {
    await _dbHelper.eliminarGasto(id);
  }
}
