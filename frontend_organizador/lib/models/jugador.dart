// models/jugador.dart
class Jugador {
  final String id;
  final String nombreCompleto;
  final String email;
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
  final String? equipoId; // ✅ Campo clave

  Jugador({
    required this.id,
    required this.nombreCompleto,
    required this.email,
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

  factory Jugador.fromJson(Map<String, dynamic> json) {
    return Jugador(
      id: json['id'] ?? '',
      nombreCompleto: json['nombre_completo'] ?? 'Sin nombre',
      email: json['email'] ?? '',
      edad: json['edad'] ?? 0,
      posicionPrincipal: json['posicion_principal'] ?? '',
      posicionSecundaria: json['posicion_secundaria'],
      numeroCamiseta: json['numero_camiseta'] ?? 0,
      telefono: json['telefono'] ?? '',
      descripcion: json['descripcion'] ?? '',
      metas: json['metas'] ?? '',
      fotoPerfil: json['foto_perfil'],
      partidosJugados: json['partidos_jugados'] ?? 0,
      goles: json['goles'] ?? 0,
      asistencias: json['asistencias'] ?? 0,
      faltas: json['faltas'] ?? 0,
      tarjetasAmarillas: json['tarjetas_amarillas'] ?? 0,
      tarjetasRojas: json['tarjetas_rojas'] ?? 0,
      equipoId: json['equipoId'] ?? json['equipo_id'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nombre_completo': nombreCompleto,
      'email': email,
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