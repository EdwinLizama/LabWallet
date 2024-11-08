import 'package:flutter/material.dart';
import '../Models/gasto_Model.dart';
import '../Handler/evento_gasto_handler.dart';
import 'agregar_gasto_view.dart';
import 'editar_gasto_view.dart';
import 'filtrar_gasto_view.dart';
import 'reporte_view.dart';

class VistaPrincipal extends StatefulWidget {
  const VistaPrincipal({super.key});

  @override
  _VistaPrincipalState createState() => _VistaPrincipalState();
}

class _VistaPrincipalState extends State<VistaPrincipal> {
  final EventoGastoHandler eventoHandler = EventoGastoHandler();
  List<Gasto> _gastos = [];
  double _totalGastos = 0.0;

  @override
  void initState() {
    super.initState();
    _cargarGastos();
  }

  // Cargar gastos y calcular el total acumulado
  void _cargarGastos() async {
    List<Gasto> gastos = await eventoHandler.obtenerGastos();
    setState(() {
      _gastos = gastos;
      _totalGastos = gastos.fold(0, (sum, gasto) => sum + gasto.monto);
    });
  }

  // Agregar un gasto y actualizar la lista
  void _agregarGasto() async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const AgregarGastoVista()),
    );
    _cargarGastos();
  }

  // Editar un gasto y actualizar la lista
  void _editarGasto(Gasto gasto) async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => EditarGastoVista(gasto: gasto)),
    );
    _cargarGastos();
  }

  // Eliminar un gasto y actualizar la lista
  void _eliminarGasto(int id) async {
    await eventoHandler.EliminarGasto(id);
    _cargarGastos();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Control de Gastos"),
        actions: [
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
        ],
      ),
      body: Column(
        children: [
          // Lista de gastos
          Expanded(
            child: ListView.builder(
              itemCount: _gastos.length,
              itemBuilder: (context, index) {
                Gasto gasto = _gastos[index];
                return ListTile(
                  title: Text(gasto.descripcion),
                  subtitle:
                      Text('${gasto.categoria} - ${gasto.fecha.toLocal()}'),
                  trailing: Text('\$${gasto.monto.toStringAsFixed(2)}'),
                  onTap: () => _editarGasto(gasto),
                  onLongPress: () => _eliminarGasto(gasto.id!),
                );
              },
            ),
          ),
          // Total acumulado de los gastos
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              "Total de Gastos Acumulados: \$${_totalGastos.toStringAsFixed(2)}",
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
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
