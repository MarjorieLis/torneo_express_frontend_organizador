import 'package:flutter/material.dart';

class Equipo {
  final String id;
  final String nombre;
  final String estado;
  final DateTime fechaRegistro;
  final String? capitanNombre;
  final List<Jugador> jugadores; // ✅ Agregar esta línea

  Equipo({
    required this.id,
    required this.nombre,
    required this.estado,
    required this.fechaRegistro,
    this.capitanNombre,
    required this.jugadores, // ✅ Requerido
  });

  factory Equipo.fromJson(Map<String, dynamic> json) {
    final capitanData = json['capitan'];
    final String? nombreCapitan = capitanData is Map
        ? capitanData['nombre']?.toString()
        : json['capitanNombre']?.toString();

    final List<dynamic> jugadoresJson = json['jugadores'] ?? [];
    final List<Jugador> jugadores = jugadoresJson.map((j) => Jugador.fromJson(j)).toList();

    return Equipo(
      id: json['id'] ?? json['_id'] ?? '',
      nombre: json['nombre'] ?? 'Sin nombre',
      estado: json['estado'] ?? 'pendiente',
      fechaRegistro: DateTime.tryParse(json['fechaRegistro'] ?? '') ?? DateTime.now(),
      capitanNombre: nombreCapitan ?? 'Sin capitán',
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
      'jugadores': jugadores.map((j) => j.toJson()).toList(),
    };
  }
}

// Clase Jugador
class Jugador {
  final String nombre;

  Jugador({required this.nombre});

  factory Jugador.fromJson(Map<String, dynamic> json) {
    return Jugador(
      nombre: json['nombre'] ?? 'Sin nombre',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'nombre': nombre,
    };
  }
}