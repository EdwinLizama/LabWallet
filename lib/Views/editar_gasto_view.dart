import 'package:flutter/material.dart';
import '../Models/gasto_Model.dart';

import '../Handler/base_datos_handler.dart';

class EditarGastoVista extends StatefulWidget {
  final Gasto gasto;

  const EditarGastoVista({super.key, required this.gasto});

  @override
  // ignore: library_private_types_in_public_api
  _EditarGastoVistaState createState() => _EditarGastoVistaState();
}

class _EditarGastoVistaState extends State<EditarGastoVista> {
  final _formKey = GlobalKey<FormState>();
  final bd = BaseDatosHandler();
  late double _monto;
  late String _categoria;
  late String _descripcion;
  late DateTime _fecha;

  @override
  void initState() {
    super.initState();
    _monto = widget.gasto.monto;
    _categoria = widget.gasto.categoria;
    _descripcion = widget.gasto.descripcion;
    _fecha = widget.gasto.fecha;
  }

  void _guardarCambios() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      Gasto gastoActualizado = Gasto(
        id: widget.gasto.id,
        monto: _monto,
        categoria: _categoria,
        descripcion: _descripcion,
        fecha: _fecha,
      );
      await bd.actualizarGasto(
          gastoActualizado); // Llamada al método de actualización
      Navigator.pop(
          // ignore: use_build_context_synchronously
          context,
          true); // Retorna true para indicar que se actualizó
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Editar Gasto")),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              TextFormField(
                initialValue: _monto.toString(),
                decoration: const InputDecoration(labelText: "Monto"),
                keyboardType: TextInputType.number,
                onSaved: (value) => _monto = double.parse(value!),
                validator: (value) =>
                    value!.isEmpty ? "Ingrese un monto" : null,
              ),
              TextFormField(
                initialValue: _descripcion,
                decoration: const InputDecoration(labelText: "Descripción"),
                onSaved: (value) => _descripcion = value!,
                validator: (value) =>
                    value!.isEmpty ? "Ingrese una descripción" : null,
              ),
              DropdownButtonFormField(
                value: _categoria,
                items:
                    ["Alimentacion", "Transporte", "Entretenimiento", "Otros"]
                        .map((categoria) => DropdownMenuItem(
                              value: categoria,
                              child: Text(categoria),
                            ))
                        .toList(),
                onChanged: (value) =>
                    setState(() => _categoria = value as String),
                decoration: const InputDecoration(labelText: "Categoría"),
              ),
              ElevatedButton(
                onPressed: _guardarCambios,
                child: const Text("Guardar cambios"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
