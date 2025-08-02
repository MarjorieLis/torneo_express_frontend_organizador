class Notificacion {
  final String id;
  final String torneoId;
  final String mensaje;
  final String tipo; // "cambio_horario", "resultado", "suspensión"
  final DateTime fecha;
  final bool leida;

  Notificacion({
    required this.id,
    required this.torneoId,
    required this.mensaje,
    required this.tipo,
    required this.fecha,
    required this.leida,
  });

  factory Notificacion.fromJson(Map<String, dynamic> json) {
    return Notificacion(
      id: json['_id'],
      torneoId: json['torneoId'],
      mensaje: json['mensaje'],
      tipo: json['tipo'],
      fecha: DateTime.parse(json['fecha']),
      leida: json['leida'],
    );
  }
}