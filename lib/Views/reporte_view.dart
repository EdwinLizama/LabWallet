import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import '../Models/gasto_Model.dart';
import '../Handler/evento_gasto_handler.dart';
import 'package:intl/intl.dart';

class ReporteVista extends StatefulWidget {
  const ReporteVista({super.key});

  @override
  _ReporteVistaState createState() => _ReporteVistaState();
}

class _ReporteVistaState extends State<ReporteVista> {
  final EventoGastoHandler eventoHandler = EventoGastoHandler();
  Map<String, double> _gastosPorMes = {};

  @override
  void initState() {
    super.initState();
    _cargarGastosPorMes();
  }

  // Método para cargar los gastos y agruparlos por mes
  void _cargarGastosPorMes() async {
    List<Gasto> gastos = await eventoHandler.obtenerGastos();
    Map<String, double> gastosPorMes = {};

    for (var gasto in gastos) {
      // Formatear la fecha para obtener solo el mes y el año (ej. "08/2023")
      String mesAnio = DateFormat('MM/yyyy').format(gasto.fecha);

      // Sumar los gastos en el mes correspondiente
      gastosPorMes[mesAnio] = (gastosPorMes[mesAnio] ?? 0) + gasto.monto;
    }

    setState(() {
      _gastosPorMes = gastosPorMes;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Crear los datos para el gráfico de barras
    List<charts.Series<MapEntry<String, double>, String>> series = [
      charts.Series(
        id: 'GastosMensuales',
        data: _gastosPorMes.entries.toList(),
        domainFn: (MapEntry<String, double> entry, _) => entry.key,
        measureFn: (MapEntry<String, double> entry, _) => entry.value,
        colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
        labelAccessorFn: (MapEntry<String, double> entry, _) =>
            '\$${entry.value.toStringAsFixed(2)}',
      ),
    ];

    return Scaffold(
      appBar: AppBar(title: const Text("Resumen de Gastos por Mes")),
      body: Center(
        child: _gastosPorMes.isEmpty
            ? const Text("No hay datos para mostrar.")
            : Column(
                children: [
                  const Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Text(
                      "Resumen de Gastos Mensuales",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                  // Gráfico de barras de gastos por mes
                  SizedBox(
                    height: 300,
                    child: charts.BarChart(
                      series,
                      animate: true,
                      barRendererDecorator: charts.BarLabelDecorator<String>(),
                      domainAxis: const charts.OrdinalAxisSpec(),
                    ),
                  ),
                  const SizedBox(height: 20),
                  // Lista de meses con el gasto total de cada mes
                  Expanded(
                    child: ListView.builder(
                      itemCount: _gastosPorMes.length,
                      itemBuilder: (context, index) {
                        String mesAnio = _gastosPorMes.keys.elementAt(index);
                        double total = _gastosPorMes[mesAnio]!;
                        return ListTile(
                          title: Text(mesAnio),
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
