// models/notificacion.dart
class Notificacion {
  final String id;
  final String mensaje;
  final bool leida;
  final DateTime fecha;

  Notificacion({
    required this.id,
    required this.mensaje,
    required this.leida,
    required this.fecha,
  });

  factory Notificacion.fromJson(Map<String, dynamic> json) {
    return Notificacion(
      id: json['id'] ?? json['_id'] ?? '',
      mensaje: json['mensaje'] ?? 'Sin mensaje',
      leida: json['leida'] == true,
      fecha: DateTime.tryParse(json['fecha'] ?? '') ?? DateTime.now(),
    );
  }
}