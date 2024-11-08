import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ConfiguracionLimiteGasto extends StatefulWidget {
  const ConfiguracionLimiteGasto({super.key});

  @override
  _ConfiguracionLimiteGastoState createState() =>
      _ConfiguracionLimiteGastoState();
}

class _ConfiguracionLimiteGastoState extends State<ConfiguracionLimiteGasto> {
  final _formKey = GlobalKey<FormState>();
  double _limiteGasto = 0.0;

  @override
  void initState() {
    super.initState();
    _cargarLimiteGasto();
  }

  // Cargar el límite de gasto desde SharedPreferences
  void _cargarLimiteGasto() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _limiteGasto = prefs.getDouble('limiteGasto') ?? 0.0;
    });
  }

  // Guardar el límite de gasto en SharedPreferences
  void _guardarLimiteGasto() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setDouble('limiteGasto', _limiteGasto);
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
