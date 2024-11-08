// ignore_for_file: file_names

import '../Models/gasto_Model.dart';
import '../Handler/base_datos_handler.dart';

// Controlador para manejar las operaciones de gastos
class GastoControlador {
  final BaseDatosHandler _dbHelper = BaseDatosHandler();

  // Método para agregar un nuevo gasto a la base de datos
  Future<void> agregarGasto(Gasto gasto) async {
    await _dbHelper.insertarGasto(
        gasto); // Llama a la función insertarGasto del handler de base de datos
  }

  // Método para obtener la lista de gastos desde la base de datos
  Future<List<Gasto>> obtenerGastos() async {
    return await _dbHelper
        .obtenerGastos(); // Llama a la función obtenerGastos del handler y devuelve la lista de gastos
  }

  // Método para actualizar un gasto existente en la base de datos
  Future<void> actualizarGasto(Gasto gasto) async {
    await _dbHelper.actualizarGasto(
        gasto); // Llama a la función actualizarGasto del handler de base de datos
  }

  // Método para eliminar un gasto de la base de datos mediante su ID
  Future<void> eliminarGasto(int id) async {
    await _dbHelper.eliminarGasto(
        id); // Llama a la función eliminarGasto del handler, usando el ID del gasto
  }
}
