// screens/jugador/inscripcion_equipo_screen.dart
import 'package:flutter/material.dart';
import 'package:frontend_organizador/models/torneo.dart';

class InscripcionEquipoScreen extends StatelessWidget {
  final Torneo torneo;

  const InscripcionEquipoScreen({Key? key, required this.torneo}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Inscripción al Equipo")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Detalles del Torneo",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            _buildDetailRow("Nombre del Torneo:", torneo.nombre),
            _buildDetailRow("Disciplina:", torneo.disciplina),
            _buildDetailRow("Estado:", torneo.estado),

            // Formulario de inscripción
            TextField(
              decoration: InputDecoration(labelText: "Nombre del Equipo"),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                // Lógica para enviar la inscripción
                // Aquí puedes llamar a la API para registrar el equipo
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Equipo inscrito correctamente")),
                );
              },
              child: Text("Enviar Inscripción"),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Row(
      children: [
        Text(label, style: TextStyle(fontWeight: FontWeight.bold)),
        Text(value),
      ],
    );
  }
}