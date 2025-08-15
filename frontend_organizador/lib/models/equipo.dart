// models/equipo.dart
import 'package:frontend_organizador/models/jugador.dart';

class Equipo {
  final String id;
  final String nombre;
  final String estado;
  final DateTime fechaRegistro;
  final String? capitanNombre;
  final String? capitanTelefono;
  final String? torneoId;
  final List<Jugador> jugadores;

  Equipo({
    required this.id,
    required this.nombre,
    required this.estado,
    required this.fechaRegistro,
    this.capitanNombre,
    this.capitanTelefono,
    this.torneoId,
    required this.jugadores,
  });

  factory Equipo.fromJson(Map<String, dynamic> json) {
    final capitanData = json['capitan'];
    final String? nombreCapitan = capitanData is Map
        ? capitanData['nombre']?.toString()
        : json['capitanNombre']?.toString();

    final String? telefonoCapitan = capitanData is Map
        ? capitanData['telefono']?.toString()
        : json['capitanTelefono']?.toString();

    final List<dynamic> jugadoresJson = json['jugadores'] ?? [];
    final List<Jugador> jugadores = jugadoresJson.map((j) => Jugador.fromJson(j)).toList();

    return Equipo(
      id: json['id'] ?? json['_id'] ?? '',
      nombre: json['nombre'] ?? 'Sin nombre',
      estado: json['estado'] ?? 'pendiente',
      fechaRegistro: DateTime.tryParse(json['fechaRegistro'] ?? '') ?? DateTime.now(),
      capitanNombre: nombreCapitan ?? 'Sin capitán',
      capitanTelefono: telefonoCapitan,
      torneoId: json['torneoId'] ?? json['torneo_id'],
      jugadores: jugadores,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nombre': nombre,
      'estado': estado,
      'fechaRegistro': fechaRegistro.toIso8601String(),
      'capitanNombre': capitanNombre,
      'capitanTelefono': capitanTelefono,
      'torneoId': torneoId,
      'jugadores': jugadores.map((j) => j.toJson()).toList(),
    };
  }
}