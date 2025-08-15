// screens/organizador/detalle_torneo_screen.dart
import 'package:flutter/material.dart';
import 'package:frontend_organizador/models/torneo.dart';
import 'package:frontend_organizador/screens/organizador/editar_torneo_screen.dart';
import 'package:frontend_organizador/extensions/string_extension.dart';
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
            _buildDetailRow("Equipos Inscritos:", "${torneo.equipos.length} equipos"),
            _buildDetailRow("Formato:", _formatoLabel(torneo.formato)),
            _buildDetailRow("Reglas:", torneo.reglas),

            SizedBox(height: 32),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => EditarTorneoScreen(torneo: torneo),
                  ),
                );
              },
              child: Text("Editar Torneo"),
            ),
            SizedBox(height: 8),
            OutlinedButton(
              onPressed: () {
                // TODO: Implementar suspensión
              },
              child: Text("Suspender Torneo"),
            ),
            SizedBox(height: 8),
            OutlinedButton(
              onPressed: () {
                // TODO: Implementar cancelación
              },
              child: Text("Cancelar Torneo"),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: Text(
              value,
              softWrap: true,
              style: TextStyle(color: Colors.grey[800]),
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  String _formatoLabel(String formato) {
    return {
      'grupos': 'Por Grupos',
      'eliminacion': 'Eliminación Directa',
      'mixto': 'Mixto',
    }[formato] ?? formato.capitalize();
  }
}

