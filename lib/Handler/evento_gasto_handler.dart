import 'package:flutter/foundation.dart';
import '../Models/gasto_Model.dart';
import '../Controller/gasto_Controller.dart';

class EventoGastoHandler {
  final GastoControlador _controlador = GastoControlador();

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

  Future<void> EditarGasto(Gasto gasto) async {
    try {
      await _controlador.actualizarGasto(gasto);
      if (kDebugMode) {
        print("Gasto actualizado exitosamente");
      }
    } catch (e) {
      if (kDebugMode) {
        print("Error al actualizar gasto: $e");
      }
    }
  }

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

  // método para obtener los gastos agrupados por categoría
  Future<Map<String, double>> obtenerGastosPorCategoria() async {
    try {
      List<Gasto> gastos = await _controlador.obtenerGastos();
      Map<String, double> gastosPorCategoria = {};

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
