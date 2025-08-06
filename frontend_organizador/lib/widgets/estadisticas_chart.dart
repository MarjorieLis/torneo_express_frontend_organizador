// widgets/estadisticas_chart.dart
import 'package:flutter/material.dart';
import '../models/jugador.dart';

class EstadisticasChart extends StatelessWidget {
  const EstadisticasChart({super.key, required this.jugador});

  final Jugador jugador;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildStat('Partidos', jugador.partidosJugados.toString()),
                _buildStat('Goles', jugador.goles.toString()),
                _buildStat('Asistencias', jugador.asistencias.toString()),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildStat('Faltas', jugador.faltas.toString()),
                _buildStat('TA', jugador.tarjetasAmarillas.toString()),
                _buildStat('TR', jugador.tarjetasRojas.toString()),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStat(String label, String value) {
    return Column(
      children: [
        Text(value, style: const TextStyle(
          fontSize: 20, fontWeight: FontWeight.bold)),
        Text(label, style: const TextStyle(fontSize: 14, color: Colors.grey)),
      ],
    );
  }
}