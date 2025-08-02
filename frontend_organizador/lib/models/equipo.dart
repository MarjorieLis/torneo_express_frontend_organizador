class Equipo {
  final String id;
  final String nombre;
  final String disciplina;
  final String cedulaCapitan;
  final String estado; // "pendiente", "aprobado", "rechazado"
  final DateTime fechaRegistro;

  Equipo({
    required this.id,
    required this.nombre,
    required this.disciplina,
    required this.cedulaCapitan,
    required this.estado,
    required this.fechaRegistro,
  });

  factory Equipo.fromJson(Map<String, dynamic> json) {
    return Equipo(
      id: json['_id'],
      nombre: json['nombre'],
      disciplina: json['disciplina'],
      cedulaCapitan: json['cedulaCapitan'],
      estado: json['estado'],
      fechaRegistro: DateTime.parse(json['fechaRegistro']),
    );
  }
}