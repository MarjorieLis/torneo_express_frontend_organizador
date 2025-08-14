// models/torneo.dart
import 'package:frontend_organizador/models/partido.dart';

class Torneo {
  final String id;
  final String nombre;
  final String disciplina;
  final DateTime fechaInicio;
  final DateTime fechaFin;
  final int maxEquipos;
  final String reglas;
  final String formato;
  final String estado;
  final List<String> equipos;
  final List<Partido> partidos;

  Torneo({
    required this.id,
    required this.nombre,
    required this.disciplina,
    required this.fechaInicio,
    required this.fechaFin,
    required this.maxEquipos,
    required this.reglas,
    required this.formato,
    required this.estado,
    required this.equipos,
    required this.partidos,
  });

  factory Torneo.fromJson(Map<String, dynamic> json) {
    // ✅ Manejar `partidos` como opcional (puede venir null)
    final partidosJson = json['partidos'] as List?;
    final partidos = partidosJson?.map((e) => Partido.fromJson(e)).toList() ?? [];

    return Torneo(
      id: json['_id'] ?? json['id'] ?? '',
      nombre: json['nombre'] ?? 'Sin nombre',
      disciplina: json['disciplina'] ?? '',
      fechaInicio: DateTime.tryParse(json['fechaInicio'] ?? '') ?? DateTime.now(),
      fechaFin: DateTime.tryParse(json['fechaFin'] ?? '') ?? DateTime.now(),
      maxEquipos: json['maxEquipos'] ?? 0,
      reglas: json['reglas'] ?? '',
      formato: json['formato'] ?? '',
      estado: json['estado'] ?? 'activo',
      equipos: (json['equipos'] as List?)?.map((e) => e.toString()).toList() ?? [],
      partidos: partidos,
    );
  }

  // ✅ copyWith (sin cambios, ya está bien)
  Torneo copyWith({
    String? id,
    String? nombre,
    String? disciplina,
    DateTime? fechaInicio,
    DateTime? fechaFin,
    int? maxEquipos,
    String? reglas,
    String? formato,
    String? estado,
    List<String>? equipos,
    List<Partido>? partidos,
  }) {
    return Torneo(
      id: id ?? this.id,
      nombre: nombre ?? this.nombre,
      disciplina: disciplina ?? this.disciplina,
      fechaInicio: fechaInicio ?? this.fechaInicio,
      fechaFin: fechaFin ?? this.fechaFin,
      maxEquipos: maxEquipos ?? this.maxEquipos,
      reglas: reglas ?? this.reglas,
      formato: formato ?? this.formato,
      estado: estado ?? this.estado,
      equipos: equipos ?? this.equipos,
      partidos: partidos ?? this.partidos,
    );
  }
}