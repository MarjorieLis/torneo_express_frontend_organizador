// models/torneo.dart
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
  });

  factory Torneo.fromJson(Map<String, dynamic> json) {
    final equiposJson = json['equipos'] as List?;
    final equipos = equiposJson?.map((e) => e.toString()).toList() ?? [];

    return Torneo(
      id: json['_id'] ?? json['id'] ?? '',
      nombre: json['nombre'] ?? 'Sin nombre',
      disciplina: json['disciplina'] ?? 'Sin disciplina', // ✅ Valor por defecto
      fechaInicio: DateTime.tryParse(json['fechaInicio'] ?? '') ?? DateTime.now(),
      fechaFin: DateTime.tryParse(json['fechaFin'] ?? '') ?? DateTime.now(),
      maxEquipos: json['maxEquipos'] ?? 0,
      reglas: json['reglas'] ?? 'Sin reglas',
      formato: json['formato'] ?? 'grupos',
      estado: json['estado'] ?? 'activo',
      equipos: equipos,
    );
  }
}