// ignore_for_file: file_names

class Gasto {
  // Campos de la clase Gasto
  int?
      id; // ID único del gasto, puede ser nulo si aún no está guardado en la base de datos
  double monto; // Monto del gasto
  String categoria; // Categoría del gasto (ej., "Alimentación", "Transporte")
  String descripcion; // Descripción del gasto
  DateTime fecha; // Fecha en la que se realizó el gasto

  // Constructor de la clase `Gasto`
  Gasto({
    this.id,
    required this.monto,
    required this.categoria,
    required this.descripcion,
    required this.fecha,
  });

  // Convertir un mapa de datos en un objeto `Gasto`
  factory Gasto.fromMap(Map<String, dynamic> map) => Gasto(
        id: map['id'], // Obtiene el ID del mapa
        monto: map['monto'], // Obtiene el monto del mapa
        categoria: map['categoria'], // Obtiene la categoría del mapa
        descripcion: map['descripcion'], // Obtiene la descripción del mapa
        fecha: DateTime.parse(map['fecha']), // Convierte la fecha a `DateTime`
      );

  // Convertir un objeto `Gasto` a un mapa de datos (para almacenar en la base de datos)
  Map<String, dynamic> toMap() {
    return {
      'id': id, // ID del gasto
      'monto': monto, // Monto del gasto
      'categoria': categoria, // Categoría del gasto
      'descripcion': descripcion, // Descripción del gasto
      'fecha': fecha
          .toIso8601String(), // Convierte la fecha a formato de texto ISO 8601
    };
  }
}
