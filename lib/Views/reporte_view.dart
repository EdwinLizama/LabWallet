import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import '../Models/gasto_Model.dart';
import '../Handler/evento_gasto_handler.dart';

class ReporteVista extends StatefulWidget {
  const ReporteVista({super.key});

  @override
  _ReporteVistaState createState() => _ReporteVistaState();
}

class _ReporteVistaState extends State<ReporteVista> {
  final EventoGastoHandler eventoHandler = EventoGastoHandler();
  Map<String, double> _gastosPorCategoria = {};

  @override
  void initState() {
    super.initState();
    _cargarGastosPorCategoria();
  }

  // Método para cargar los gastos y agruparlos por categoría
  void _cargarGastosPorCategoria() async {
    List<Gasto> gastos = await eventoHandler.obtenerGastos();
    Map<String, double> gastosPorCategoria = {};

    for (var gasto in gastos) {
      // Sumar los gastos en la categoría correspondiente
      gastosPorCategoria[gasto.categoria] =
          (gastosPorCategoria[gasto.categoria] ?? 0) + gasto.monto;
    }

    setState(() {
      _gastosPorCategoria = gastosPorCategoria;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Crear los datos para el gráfico circular
    List<charts.Series<MapEntry<String, double>, String>> series = [
      charts.Series(
        id: 'GastosPorCategoria',
        data: _gastosPorCategoria.entries.toList(),
        domainFn: (MapEntry<String, double> entry, _) => entry.key,
        measureFn: (MapEntry<String, double> entry, _) => entry.value,
        colorFn: (_, index) =>
            charts.MaterialPalette.blue.makeShades(10)[index! % 10],
        labelAccessorFn: (MapEntry<String, double> entry, _) =>
            '${entry.key}: \$${entry.value.toStringAsFixed(2)}',
      ),
    ];

    return Scaffold(
      appBar: AppBar(title: const Text("Distribución de Gastos por Categoría")),
      body: Center(
        child: _gastosPorCategoria.isEmpty
            ? const Text("No hay datos para mostrar.")
            : Column(
                children: [
                  const Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Text(
                      "Resumen de Gastos por Categoría",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                  // Gráfico circular de gastos por categoría
                  SizedBox(
                    height: 300,
                    child: charts.PieChart(
                      series,
                      animate: true,
                      defaultRenderer: charts.ArcRendererConfig(
                        arcRendererDecorators: [
                          charts.ArcLabelDecorator(
                            labelPosition: charts.ArcLabelPosition.inside,
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  // Lista de categorías con el gasto total en cada una
                  Expanded(
                    child: ListView.builder(
                      itemCount: _gastosPorCategoria.length,
                      itemBuilder: (context, index) {
                        String categoria =
                            _gastosPorCategoria.keys.elementAt(index);
                        double total = _gastosPorCategoria[categoria]!;
                        return ListTile(
                          title: Text(categoria),
                          trailing: Text('\$${total.toStringAsFixed(2)}'),
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
