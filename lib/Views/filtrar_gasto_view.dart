import 'package:flutter/material.dart';
import '../Models/gasto_Model.dart';
import '../Handler/evento_gasto_handler.dart';

class FiltrarGastoView extends StatefulWidget {
  const FiltrarGastoView({super.key});

  @override
  _FiltrarGastoViewState createState() => _FiltrarGastoViewState();
}

class _FiltrarGastoViewState extends State<FiltrarGastoView> {
  final EventoGastoHandler eventoHandler = EventoGastoHandler();
  List<Gasto> _gastosFiltrados = [];
  String? _categoriaSeleccionada;
  double _totalFiltrado = 0.0;

  @override
  void initState() {
    super.initState();
    _cargarGastosFiltrados();
  }

  void _cargarGastosFiltrados() async {
    List<Gasto> gastos = await eventoHandler.obtenerGastos();

    // Filtrar los gastos por categoría seleccionada
    List<Gasto> gastosFiltrados = gastos.where((gasto) {
      return _categoriaSeleccionada == null ||
          gasto.categoria == _categoriaSeleccionada;
    }).toList();

    // Calcular el total de los gastos filtrados
    double totalFiltrado =
        gastosFiltrados.fold(0, (sum, gasto) => sum + gasto.monto);

    setState(() {
      _gastosFiltrados = gastosFiltrados;
      _totalFiltrado = totalFiltrado;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Filtrar Gastos por Categoría")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Dropdown para seleccionar la categoría
            DropdownButtonFormField<String>(
              value: _categoriaSeleccionada,
              decoration: const InputDecoration(labelText: "Categoría"),
              items: ['Alimentacion', 'Transporte', 'Entretenimiento', 'Otros']
                  .map((categoria) => DropdownMenuItem(
                        value: categoria,
                        child: Text(categoria),
                      ))
                  .toList(),
              onChanged: (value) {
                setState(() {
                  _categoriaSeleccionada = value;
                });
                _cargarGastosFiltrados();
              },
            ),
            const SizedBox(height: 20),
            // Total de gastos filtrados
            Text(
              "Total Filtrado: \$${_totalFiltrado.toStringAsFixed(2)}",
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            // Lista de gastos filtrados
            Expanded(
              child: ListView.builder(
                itemCount: _gastosFiltrados.length,
                itemBuilder: (context, index) {
                  Gasto gasto = _gastosFiltrados[index];
                  return ListTile(
                    title: Text(gasto.descripcion),
                    subtitle: Text(gasto.categoria),
                    trailing: Text('\$${gasto.monto.toStringAsFixed(2)}'),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
