// models/jugador.dart
class Jugador {
  final String id;
  final String nombreCompleto;
  final String email;
  final String cedula;
  final int edad;
  final String posicionPrincipal;
  final String? posicionSecundaria;
  final int numeroCamiseta;
  final String telefono;
  final String descripcion;
  final String metas;
  final String? fotoPerfil;
  final int partidosJugados;
  final int goles;
  final int asistencias;
  final int faltas;
  final int tarjetasAmarillas;
  final int tarjetasRojas;
  final String? equipoId;

  Jugador({
    required this.id,
    required this.nombreCompleto,
    required this.email,
    required this.cedula,
    required this.edad,
    required this.posicionPrincipal,
    this.posicionSecundaria,
    required this.numeroCamiseta,
    required this.telefono,
    required this.descripcion,
    required this.metas,
    this.fotoPerfil,
    this.partidosJugados = 0,
    this.goles = 0,
    this.asistencias = 0,
    this.faltas = 0,
    this.tarjetasAmarillas = 0,
    this.tarjetasRojas = 0,
    this.equipoId,
  });

  // models/jugador.dart
factory Jugador.fromJson(Map<String, dynamic> json) {
  // Función auxiliar para convertir String a int
  int parseInt(dynamic value) {
    if (value == null) return 0;
    if (value is int) return value;
    if (value is String) return int.tryParse(value) ?? 0;
    return 0;
  }

  return Jugador(
    id: json['id'] ?? '',
    nombreCompleto: json['nombre_completo'] ?? 'Sin nombre',
    email: json['email'] ?? '',
    cedula: json['cedula'] ?? '',
    edad: parseInt(json['edad']),
    posicionPrincipal: json['posicion_principal'] ?? '',
    posicionSecundaria: json['posicion_secundaria'],
    numeroCamiseta: parseInt(json['numero_camiseta']),
    telefono: json['telefono'] ?? '',
    descripcion: json['descripcion'] ?? '',
    metas: json['metas'] ?? '',
    fotoPerfil: json['foto_perfil'],
    partidosJugados: parseInt(json['partidos_jugados']),
    goles: parseInt(json['goles']),
    asistencias: parseInt(json['asistencias']),
    faltas: parseInt(json['faltas']),
    tarjetasAmarillas: parseInt(json['tarjetas_amarillas']),
    tarjetasRojas: parseInt(json['tarjetas_rojas']),
    equipoId: json['equipoId'] ?? json['equipo_id'],
  );
}

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nombre_completo': nombreCompleto,
      'email': email,
      'cedula': cedula,
      'edad': edad,
      'posicion_principal': posicionPrincipal,
      'posicion_secundaria': posicionSecundaria,
      'numero_camiseta': numeroCamiseta,
      'telefono': telefono,
      'descripcion': descripcion,
      'metas': metas,
      'foto_perfil': fotoPerfil,
      'partidos_jugados': partidosJugados,
      'goles': goles,
      'asistencias': asistencias,
      'faltas': faltas,
      'tarjetas_amarillas': tarjetasAmarillas,
      'tarjetas_rojas': tarjetasRojas,
      'equipoId': equipoId,
    };
  }
}