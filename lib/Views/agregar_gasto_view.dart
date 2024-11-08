import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../Models/gasto_Model.dart';
import '../Handler/evento_gasto_handler.dart';
import '../Handler/base_datos_handler.dart'; // Asegúrate de tener acceso al límite de gasto

class AgregarGastoVista extends StatefulWidget {
  const AgregarGastoVista({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _AgregarGastoVistaState createState() => _AgregarGastoVistaState();
}

class _AgregarGastoVistaState extends State<AgregarGastoVista> {
  final _formKey = GlobalKey<FormState>();
  final _eventoHandler = EventoGastoHandler();
  final _baseDatosHandler =
      BaseDatosHandler(); // Controlador para el límite de gasto
  double _monto = 0.0;
  String? _categoria;
  String _descripcion = "";
  DateTime _fecha = DateTime.now();
  double _limiteGasto = 0.0;

  @override
  void initState() {
    super.initState();
    _cargarLimiteGasto();
  }

  // Cargar el límite de gasto desde la base de datos o SharedPreferences
  void _cargarLimiteGasto() async {
    double limite = await _baseDatosHandler.obtenerLimiteGasto();
    setState(() {
      _limiteGasto = limite;
    });
  }

  // Guardar el gasto y verificar el límite mensual
  void _guardarGasto() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      Gasto gasto = Gasto(
        monto: _monto,
        categoria: _categoria!,
        descripcion: _descripcion,
        fecha: _fecha,
      );

      // Calcular el gasto total del mes actual
      double totalGastoMes = await _calcularGastoMensual(_fecha);
      double nuevoTotalMes = totalGastoMes + _monto;

      // Verificar si el nuevo total excede el límite de gasto
      if (_limiteGasto > 0 && nuevoTotalMes > _limiteGasto) {
        _mostrarAlertaExcesoGasto(nuevoTotalMes);
      } else {
        await _eventoHandler.AgregarGasto(gasto);
        // ignore: use_build_context_synchronously
        Navigator.pop(context, true); // Cierra la pantalla y retorna true
      }
    }
  }

  // Calcular el total de gastos del mes
  Future<double> _calcularGastoMensual(DateTime fecha) async {
    List<Gasto> gastos = await _eventoHandler.obtenerGastos();
    String mesAnio = DateFormat('MM/yyyy').format(fecha);
    double total = gastos
        .where((gasto) => DateFormat('MM/yyyy').format(gasto.fecha) == mesAnio)
        .fold(0, (sum, gasto) => sum + gasto.monto);
    return total;
  }

  // Mostrar una alerta si se excede el límite de gasto mensual
  void _mostrarAlertaExcesoGasto(double totalGastoMes) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Límite de Gasto Excedido"),
          content: Text(
            "Has superado tu límite de gasto mensual de \$$_limiteGasto.\n"
            "Total de gastos este mes con el nuevo gasto: \$${totalGastoMes.toStringAsFixed(2)}",
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

  // Método para seleccionar la fecha
  void _seleccionarFecha(BuildContext context) async {
    DateTime? fechaSeleccionada = await showDatePicker(
      context: context,
      initialDate: _fecha,
      firstDate: DateTime(2000),
      lastDate: DateTime.now(), // No permite seleccionar fechas futuras
    );
    if (fechaSeleccionada != null) {
      setState(() {
        _fecha = fechaSeleccionada;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Agregar Gasto")),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Campo para ingresar el monto
              TextFormField(
                decoration: const InputDecoration(labelText: "Monto"),
                keyboardType: TextInputType.number,
                onSaved: (value) => _monto = double.parse(value!),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Ingrese un monto";
                  }
                  final monto = double.tryParse(value);
                  if (monto == null || monto <= 0) {
                    return "Ingrese un monto válido (mayor a 0)";
                  }
                  return null;
                },
              ),
              // Campo para ingresar la descripción
              TextFormField(
                decoration: const InputDecoration(labelText: "Descripción"),
                onSaved: (value) => _descripcion = value!,
                validator: (value) => value == null || value.isEmpty
                    ? "Ingrese una descripción"
                    : null,
              ),
              // Menú desplegable para seleccionar la categoría
              DropdownButtonFormField<String>(
                value: _categoria,
                items:
                    ["Alimentacion", "Transporte", "Entretenimiento", "Otros"]
                        .map((categoria) => DropdownMenuItem(
                              value: categoria,
                              child: Text(categoria),
                            ))
                        .toList(),
                onChanged: (value) => setState(() => _categoria = value),
                decoration: const InputDecoration(labelText: "Categoría"),
                validator: (value) =>
                    value == null ? "Seleccione una categoría" : null,
              ),
              // Selector de fecha
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("Fecha del gasto"),
                  TextButton(
                    onPressed: () => _seleccionarFecha(context),
                    child: Text(DateFormat('dd/MM/yyyy').format(_fecha)),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              // Botón para guardar
              ElevatedButton(
                onPressed: _guardarGasto,
                child: const Text("Guardar"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
