// /lib/models/partido.dart

class Partido {
  final String id;
  final String torneoId;
  final String equipoA;
  final String equipoB;
  final DateTime fecha;
  final String lugar;
  final String estado;
  final int golesA;
  final int golesB;

  Partido({
    required this.id,
    required this.torneoId,
    required this.equipoA,
    required this.equipoB,
    required this.fecha,
    required this.lugar,
    required this.estado,
    required this.golesA,
    required this.golesB,
  });

  factory Partido.fromJson(Map<String, dynamic> json) {
    return Partido(
      id: json['_id'],
      torneoId: json['torneoId'],
      equipoA: json['equipoA'],
      equipoB: json['equipoB'],
      fecha: DateTime.parse(json['fecha']),
      lugar: json['lugar'],
      estado: json['estado'],
      golesA: json['golesA'] ?? 0,
      golesB: json['golesB'] ?? 0,
    );
  }
}