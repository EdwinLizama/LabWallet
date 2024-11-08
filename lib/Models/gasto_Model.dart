// ignore_for_file: file_names

class Gasto {
  int? id;
  double monto;
  String categoria;
  String descripcion;
  DateTime fecha;

  Gasto(
      {this.id,
      required this.monto,
      required this.categoria,
      required this.descripcion,
      required this.fecha});

  // Convertir de mapa a objeto
  factory Gasto.fromMap(Map<String, dynamic> map) => Gasto(
        id: map['id'],
        monto: map['monto'],
        categoria: map['categoria'],
        descripcion: map['descripcion'],
        fecha: DateTime.parse(map['fecha']),
      );

  // Convertir de objeto a mapa
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'monto': monto,
      'categoria': categoria,
      'descripcion': descripcion,
      'fecha': fecha.toIso8601String(),
    };
  }
}
