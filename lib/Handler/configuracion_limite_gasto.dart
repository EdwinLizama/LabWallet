import 'package:flutter/material.dart';
import '../Handler/base_datos_handler.dart';

// Widget Stateful para la pantalla de configuración del límite de gasto mensual
class ConfiguracionLimiteGasto extends StatefulWidget {
  const ConfiguracionLimiteGasto({super.key});

  @override
  _ConfiguracionLimiteGastoState createState() =>
      _ConfiguracionLimiteGastoState();
}

class _ConfiguracionLimiteGastoState extends State<ConfiguracionLimiteGasto> {
  // Llave para el formulario de validación
  final _formKey = GlobalKey<FormState>();

  // Variable para almacenar el límite de gasto ingresado por el usuario
  double _limiteGasto = 0.0;

  // Instancia del controlador de base de datos para almacenar y recuperar el límite
  final _baseDatosHandler = BaseDatosHandler();

  @override
  void initState() {
    super.initState();
    _cargarLimiteGasto(); // Cargar el límite actual al iniciar la vista
  }

  // Método para cargar el límite de gasto desde la base de datos
  void _cargarLimiteGasto() async {
    double limite = await _baseDatosHandler.obtenerLimiteGasto();
    setState(() {
      _limiteGasto = limite; // Actualiza el valor en la interfaz
    });
  }

  // Método para guardar el límite de gasto en la base de datos
  void _guardarLimiteGasto() async {
    if (_formKey.currentState!.validate()) {
      // Verifica que el formulario sea válido
      _formKey.currentState!.save(); // Guarda el valor ingresado
      await _baseDatosHandler.establecerLimiteGasto(
          _limiteGasto); // Guarda el límite en la base de datos

      // Muestra un mensaje de confirmación y regresa a la pantalla anterior
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
                initialValue:
                    _limiteGasto.toString(), // Muestra el límite actual
                decoration:
                    const InputDecoration(labelText: "Límite de Gasto Mensual"),
                keyboardType: TextInputType.number, // Permite solo números
                onSaved: (value) => _limiteGasto =
                    double.parse(value!), // Guarda el valor ingresado
                validator: (value) {
                  // Validaciones para el campo
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
