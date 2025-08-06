class Jugador {
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
  });

  // Constructor fromJson
  factory Jugador.fromJson(Map<String, dynamic> json) {
    return Jugador(
      id: json['id'],
      nombreCompleto: json['nombre_completo'],
      email: json['email'],
      edad: json['edad'],
      posicionPrincipal: json['posicion_principal'],
      posicionSecundaria: json['posicion_secundaria'],
      numeroCamiseta: json['numero_camiseta'],
      telefono: json['telefono'],
      descripcion: json['descripcion'],
      metas: json['metas'],
      fotoPerfil: json['foto_perfil'],
      partidosJugados: json['partidos_jugados'] ?? 0,
      goles: json['goles'] ?? 0,
      asistencias: json['asistencias'] ?? 0,
      faltas: json['faltas'] ?? 0,
      tarjetasAmarillas: json['tarjetas_amarillas'] ?? 0,
      tarjetasRojas: json['tarjetas_rojas'] ?? 0,
    );
  }

  String id;
  String nombreCompleto;
  String email;
  int edad;
  String posicionPrincipal;
  String? posicionSecundaria;
  int numeroCamiseta;
  String telefono;
  String descripcion;
  String metas;
  String? fotoPerfil;
  // Nuevas propiedades para estadísticas
  int partidosJugados;
  int goles;
  int asistencias;
  int faltas;
  int tarjetasAmarillas;
  int tarjetasRojas;

  // Validar correo institucional
  bool get esCorreoInstitucional {
    return email.endsWith('@uide.edu.ec');
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
    };
  }
}