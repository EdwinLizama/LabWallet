import 'package:flutter/material.dart';
import 'Views/vista_principal.dart';
import 'Handler/base_datos_handler.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final BaseDatosHandler dbHandler = BaseDatosHandler();

  // Inicializa la base de datos
  await dbHandler.baseDatos;

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Control de Gastos Personales',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const VistaPrincipal(),
    );
  }
}
