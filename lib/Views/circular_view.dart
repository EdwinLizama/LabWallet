import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import '../Handler/evento_gasto_handler.dart';

class ReporteCategoria extends StatefulWidget {
  const ReporteCategoria({super.key});

  @override
  _ReporteCategoriaState createState() => _ReporteCategoriaState();
}

class _ReporteCategoriaState extends State<ReporteCategoria> {
  final EventoGastoHandler eventoHandler = EventoGastoHandler();
  Map<String, double> _gastosPorCategoria = {};

  @override
  void initState() {
    super.initState();
    _cargarGastosPorCategoria();
  }

  // Método para cargar los gastos agrupados por categoría
  void _cargarGastosPorCategoria() async {
    Map<String, double> gastosAgrupados =
        await eventoHandler.obtenerGastosPorCategoria();
    setState(() {
      _gastosPorCategoria = gastosAgrupados;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Verifica si los datos están cargados
    if (_gastosPorCategoria.isEmpty) {
      return Scaffold(
        appBar:
            AppBar(title: const Text("Distribución de Gastos por Categoría")),
        body: const Center(child: Text("No hay datos para mostrar.")),
      );
    }

    // Datos para la gráfica circular
    List<charts.Series<MapEntry<String, double>, String>> series = [
      charts.Series<MapEntry<String, double>, String>(
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
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                "Resumen de Gastos por Categoría",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            // Gráfico circular de gastos por categoría
            SizedBox(
              height: 300,
              child: charts.PieChart(
                series,
                animate: true,
                defaultRenderer: charts.ArcRendererConfig(
                  arcWidth: 60,
                  arcRendererDecorators: [
                    charts.ArcLabelDecorator(
                      labelPosition: charts.ArcLabelPosition.outside,
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
                  String categoria = _gastosPorCategoria.keys.elementAt(index);
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
