import 'package:flutter/material.dart';

class Partido {
  final String id;
  final String torneoId;
  final String equipoLocal;
  final String equipoVisitante;
  final DateTime fecha;
  final TimeOfDay hora;
  final String lugar;
  final String estado; // programado, jugado, suspendido
  final Map<String, dynamic> resultado; // { golesLocal: 2, golesVisitante: 1 }

  Partido({
    required this.id,
    required this.torneoId,
    required this.equipoLocal,
    required this.equipoVisitante,
    required this.fecha,
    required this.hora,
    required this.lugar,
    required this.estado,
    required this.resultado,
  });

  factory Partido.fromJson(Map<String, dynamic> json) {
    return Partido(
      id: json['_id'] ?? '',
      torneoId: json['torneoId'] ?? '',
      equipoLocal: json['equipoLocal'] ?? '',
      equipoVisitante: json['equipoVisitante'] ?? '',
      fecha: DateTime.parse(json['fecha']),
      hora: TimeOfDay(
        hour: json['hora']['hour'],
        minute: json['hora']['minute'],
      ),
      lugar: json['lugar'] ?? '',
      estado: json['estado'] ?? 'programado',
      resultado: json['resultado'] ?? {'golesLocal': 0, 'golesVisitante': 0},
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'torneoId': torneoId,
      'equipoLocal': equipoLocal,
      'equipoVisitante': equipoVisitante,
      'fecha': fecha.toIso8601String(),
      'hora': {'hour': hora.hour, 'minute': hora.minute},
      'lugar': lugar,
      'estado': estado,
      'resultado': resultado,
    };
  }
}