// models/equipo.dart

class Equipo {
  final String id;
  final String nombre;
  final String estado; // "pendiente", "aprobado", "rechazado"
  final DateTime fechaRegistro;
  final String? capitanNombre; // ✅ Campo clave para mostrar en la UI

  Equipo({
    required this.id,
    required this.nombre,
    required this.estado,
    required this.fechaRegistro,
    this.capitanNombre, // Puede ser null
  });

  factory Equipo.fromJson(Map<String, dynamic> json) {
    return Equipo(
      id: json['id'] ?? json['_id'] ?? '',
      nombre: json['nombre'] ?? 'Sin nombre',
      estado: json['estado'] ?? 'pendiente',
      fechaRegistro: DateTime.tryParse(json['fechaRegistro'] ?? '') ?? DateTime.now(),
      capitanNombre: json['capitanNombre'] ?? json['capitan_nombre'] ?? 'Sin capitán',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nombre': nombre,
      'estado': estado,
      'fechaRegistro': fechaRegistro.toIso8601String(),
      'capitanNombre': capitanNombre,
    };
  }
}