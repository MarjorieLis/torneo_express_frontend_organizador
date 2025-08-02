class Usuario {
  final String id;
  final String nombre;
  final String email;
  final String rol; // 'organizador', 'jugador', etc.
  final String campus;
  final bool verificado;

  Usuario({
    required this.id,
    required this.nombre,
    required this.email,
    required this.rol,
    required this.campus,
    required this.verificado,
  });

  factory Usuario.fromJson(Map<String, dynamic> json) {
    return Usuario(
      id: json['_id'],
      nombre: json['nombre'],
      email: json['email'],
      rol: json['rol'],
      campus: json['campus'],
      verificado: json['verificado'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'nombre': nombre,
      'email': email,
      'rol': rol,
      'campus': campus,
      'verificado': verificado,
    };
  }
}