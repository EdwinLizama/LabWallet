import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../Models/gasto_Model.dart';
import '../Handler/evento_gasto_handler.dart';
import '../Handler/base_datos_handler.dart';

import 'agregar_gasto_view.dart';
import 'editar_gasto_view.dart';
import 'filtrar_gasto_view.dart';
import 'reporte_view.dart';
import '../Handler/configuracion_limite_gasto.dart';
import 'circular_view.dart';

class VistaPrincipal extends StatefulWidget {
  const VistaPrincipal({super.key});

  @override
  _VistaPrincipalState createState() => _VistaPrincipalState();
}

class _VistaPrincipalState extends State<VistaPrincipal> {
  final EventoGastoHandler eventoHandler = EventoGastoHandler();
  final BaseDatosHandler _baseDatosHandler = BaseDatosHandler();
  List<Gasto> _gastos = [];
  double _totalGastos = 0.0;
  double _limiteGasto = 0.0; // Variable para almacenar el límite de gasto

  @override
  void initState() {
    super.initState();
    _cargarGastos();
    _cargarLimiteGasto(); // Cargar el límite de gasto al iniciar
  }

  // Cargar gastos y calcular el total acumulado
  void _cargarGastos() async {
    List<Gasto> gastos = await eventoHandler.obtenerGastos();
    setState(() {
      _gastos = gastos;
      _totalGastos = gastos.fold(0, (sum, gasto) => sum + gasto.monto);
    });

    // Verificar si el total acumulado excede el límite después de cargar los gastos
    if (_limiteGasto > 0 && _totalGastos > _limiteGasto) {
      _mostrarAlertaExcesoGasto();
    }
  }

  // Cargar el límite de gasto desde la base de datos
  void _cargarLimiteGasto() async {
    double limite = await _baseDatosHandler.obtenerLimiteGasto();
    setState(() {
      _limiteGasto = limite;
    });
  }

  // Mostrar alerta si el total de gastos excede el límite
  void _mostrarAlertaExcesoGasto() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Límite de Gasto Excedido"),
          content: Text(
            "Has superado tu límite de gasto mensual de \$$_limiteGasto.\n"
            "Total de gastos acumulados: \$${_totalGastos.toStringAsFixed(2)}",
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text("Aceptar"),
            ),
          ],
        );
      },
    );
  }

  // Agregar un gasto y actualizar la lista
  void _agregarGasto() async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const AgregarGastoVista()),
    );
    _cargarGastos(); // Actualizar la lista de gastos después de agregar uno nuevo
  }

  // Editar un gasto y actualizar la lista
  void _editarGasto(Gasto gasto) async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => EditarGastoVista(gasto: gasto)),
    );
    _cargarGastos();
  }

  // Confirmar y eliminar un gasto
  void _confirmarEliminarGasto(int id) async {
    final confirmado = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Confirmar eliminación"),
          content:
              const Text("¿Estás seguro de que deseas eliminar este gasto?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text("Cancelar"),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text("Eliminar"),
            ),
          ],
        );
      },
    );

    if (confirmado == true) {
      await eventoHandler.EliminarGasto(id);
      _cargarGastos();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Gasto eliminado exitosamente')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Control de Gastos"),
        actions: [
          // Botón para abrir la pantalla de configuración del límite de gasto
          IconButton(
            icon: const Icon(Icons.settings),
            tooltip: 'Configurar Límite de Gasto',
            onPressed: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const ConfiguracionLimiteGasto()),
              );
              _cargarLimiteGasto(); // Recargar el límite después de regresar de la configuración
            },
          ),
          // Botón para navegar a Filtrar Gastos
          IconButton(
            icon: const Icon(Icons.filter_list),
            tooltip: 'Filtrar Gastos',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const FiltrarGastoView()),
              );
            },
          ),
          // Botón para navegar a Reporte Mensual
          IconButton(
            icon: const Icon(Icons.analytics),
            tooltip: 'Reporte Mensual',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ReporteVista()),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.circle),
            tooltip: 'Reporte Categoria',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const ReporteCategoria()),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Tarjeta con el límite de gasto y el total acumulado
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      "Límite de Gasto Mensual: \$${_limiteGasto.toStringAsFixed(2)}",
                      style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.blueAccent),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "Total de Gastos Acumulados: \$${_totalGastos.toStringAsFixed(2)}",
                      style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.redAccent),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          ),
          // Lista de gastos
          Expanded(
            child: ListView.builder(
              itemCount: _gastos.length,
              itemBuilder: (context, index) {
                Gasto gasto = _gastos[index];
                return Card(
                  elevation: 2,
                  margin:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: ListTile(
                    title: Text(
                      gasto.descripcion,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      '${gasto.categoria} - ${DateFormat('dd/MM/yyyy').format(gasto.fecha)}',
                      style: const TextStyle(color: Colors.grey),
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          '\$${gasto.monto.toStringAsFixed(2)}',
                          style: const TextStyle(
                              color: Colors.green, fontWeight: FontWeight.bold),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () => _confirmarEliminarGasto(gasto.id!),
                        ),
                      ],
                    ),
                    onTap: () => _editarGasto(gasto),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _agregarGasto,
        child: const Icon(Icons.add),
      ),
    );
  }
}
