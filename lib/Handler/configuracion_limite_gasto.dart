import 'package:flutter/material.dart';
import '../Handler/base_datos_handler.dart';

class ConfiguracionLimiteGasto extends StatefulWidget {
  const ConfiguracionLimiteGasto({super.key});

  @override
  _ConfiguracionLimiteGastoState createState() =>
      _ConfiguracionLimiteGastoState();
}

class _ConfiguracionLimiteGastoState extends State<ConfiguracionLimiteGasto> {
  final _formKey = GlobalKey<FormState>();
  double _limiteGasto = 0.0;
  final _baseDatosHandler =
      BaseDatosHandler(); // Si estás usando la base de datos para el límite

  @override
  void initState() {
    super.initState();
    _cargarLimiteGasto();
  }

  // Cargar el límite de gasto desde la base de datos o SharedPreferences
  void _cargarLimiteGasto() async {
    double limite = await _baseDatosHandler
        .obtenerLimiteGasto(); // Usar SharedPreferences si no usas BD
    setState(() {
      _limiteGasto = limite;
    });
  }

  // Guardar el límite de gasto en la base de datos o SharedPreferences
  void _guardarLimiteGasto() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      await _baseDatosHandler.establecerLimiteGasto(
          _limiteGasto); // Usar SharedPreferences si no usas BD
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Límite de gasto mensual guardado')),
      );
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Configuración de Límite de Gasto")),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              TextFormField(
                initialValue: _limiteGasto.toString(),
                decoration:
                    const InputDecoration(labelText: "Límite de Gasto Mensual"),
                keyboardType: TextInputType.number,
                onSaved: (value) => _limiteGasto = double.parse(value!),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Ingrese un límite de gasto";
                  }
                  if (double.tryParse(value) == null ||
                      double.parse(value) <= 0) {
                    return "Ingrese un valor válido (mayor a 0)";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _guardarLimiteGasto,
                child: const Text("Guardar Límite"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
