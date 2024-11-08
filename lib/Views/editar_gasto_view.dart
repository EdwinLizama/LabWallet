import 'package:flutter/material.dart';
import '../Models/gasto_Model.dart';
import '../Handler/evento_gasto_handler.dart';

class EditarGastoVista extends StatefulWidget {
  final Gasto gasto;

  const EditarGastoVista({super.key, required this.gasto});

  @override
  _EditarGastoVistaState createState() => _EditarGastoVistaState();
}

class _EditarGastoVistaState extends State<EditarGastoVista> {
  final _formKey = GlobalKey<FormState>();
  final _eventoHandler = EventoGastoHandler();
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

  void _guardarCambios() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      Gasto gastoActualizado = Gasto(
        id: widget.gasto.id,
        monto: _monto,
        categoria: _categoria,
        descripcion: _descripcion,
        fecha: _fecha,
      );
      _eventoHandler.AgregarGasto(gastoActualizado);
      Navigator.pop(context);
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
