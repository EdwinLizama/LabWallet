import 'package:flutter/foundation.dart';
import '../Models/gasto_Model.dart';
import '../Controller/gasto_Controller.dart';

// Clase `EventoGastoHandler` que se encarga de manejar eventos relacionados con los gastos.
class EventoGastoHandler {
  // Instancia del controlador de gastos, que conecta con la base de datos.
  final GastoControlador _controlador = GastoControlador();

  // Método para agregar un gasto a la base de datos.
  Future<void> AgregarGasto(Gasto gasto) async {
    try {
      await _controlador.agregarGasto(gasto);
      if (kDebugMode) {
        print("Gasto añadido exitosamente");
      }
    } catch (e) {
      if (kDebugMode) {
        print("Error al añadir gasto: $e");
      }
    }
  }

  // Método para eliminar un gasto de la base de datos usando su `id`.
  Future<void> EliminarGasto(int id) async {
    try {
      await _controlador.eliminarGasto(id);
      if (kDebugMode) {
        print("Gasto eliminado exitosamente");
      }
    } catch (e) {
      if (kDebugMode) {
        print("Error al eliminar gasto: $e");
      }
    }
  }

  // Método para actualizar un gasto en la base de datos.
  Future<void> EditarGasto(Gasto gasto) async {
    try {
      await _controlador.actualizarGasto(gasto);
      if (kDebugMode) {
        //kDebugMode es una variable global que se encuentra en el archivo main.dart y se utiliza para habilitar o deshabilitar la impresión de mensajes de depuración.
        print("Gasto actualizado exitosamente"); //
      }
    } catch (e) {
      if (kDebugMode) {
        print("Error al actualizar gasto: $e");
      }
    }
  }

  // Método para obtener todos los gastos de la base de datos.
  Future<List<Gasto>> obtenerGastos() async {
    try {
      return await _controlador.obtenerGastos();
    } catch (e) {
      if (kDebugMode) {
        print("Error al obtener gastos: $e");
      }
      return [];
    }
  }

  // Método para obtener los gastos agrupados por categoría.
  Future<Map<String, double>> obtenerGastosPorCategoria() async {
    try {
      // Llama al controlador para obtener la lista de todos los gastos.
      List<Gasto> gastos = await _controlador.obtenerGastos();
      Map<String, double> gastosPorCategoria = {};

      // Agrupa y suma los gastos por cada categoría.
      for (var gasto in gastos) {
        gastosPorCategoria[gasto.categoria] =
            (gastosPorCategoria[gasto.categoria] ?? 0) + gasto.monto;
      }

      return gastosPorCategoria;
    } catch (e) {
      if (kDebugMode) {
        print("Error al obtener gastos por categoría: $e");
      }
      return {};
    }
  }
}
