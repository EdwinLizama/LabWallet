import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../Models/gasto_Model.dart';
import '../Handler/evento_gasto_handler.dart';

class AgregarGastoVista extends StatefulWidget {
  const AgregarGastoVista({super.key});

  @override
  _AgregarGastoVistaState createState() => _AgregarGastoVistaState();
}

class _AgregarGastoVistaState extends State<AgregarGastoVista> {
  final _formKey = GlobalKey<FormState>();
  final _eventoHandler = EventoGastoHandler();
  double _monto = 0.0;
  String? _categoria;
  String _descripcion = "";
  DateTime _fecha = DateTime.now();

  // Método para guardar el gasto
  void _guardarGasto() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      Gasto gasto = Gasto(
        monto: _monto,
        categoria: _categoria!,
        descripcion: _descripcion,
        fecha: _fecha,
      );
      _eventoHandler.AgregarGasto(gasto);
      Navigator.pop(context, true); // Retorna true para indicar que se guardó
    }
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
