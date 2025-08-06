// screens/jugador/detalle_torneo_screen.dart
import 'package:flutter/material.dart';
import 'package:frontend_organizador/models/torneo.dart';
import 'package:frontend_organizador/screens/jugador/inscripcion_equipo_screen.dart';

class DetalleTorneoScreen extends StatelessWidget {
  final Torneo torneo;

  const DetalleTorneoScreen({Key? key, required this.torneo}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(torneo.nombre)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Información del Torneo",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),

            // Información del torneo
            _buildDetailRow("Disciplina:", torneo.disciplina),
            _buildDetailRow("Estado:", torneo.estado),
            _buildDetailRow("Fecha de Inicio:", _formatDate(torneo.fechaInicio)),
            _buildDetailRow("Fecha de Fin:", _formatDate(torneo.fechaFin)),
            _buildDetailRow("Máximo Equipos:", "${torneo.maxEquipos} equipos"),
            _buildDetailRow("Reglas:", torneo.reglas), // Probablemente aquí hay overflow
            _buildDetailRow("Formato:", torneo.formato),

            // Botón para inscribirse al equipo
            ElevatedButton(
              onPressed: () {
                // Lógica para inscribirse al equipo
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => InscripcionEquipoScreen(torneo: torneo),
                  ),
                );
              },
              child: Text("Inscribirse al Equipo"),
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
        Expanded(child: Text(value)), // ✅ Añade Expanded para ajustar el texto
      ],
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}