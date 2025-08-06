// widgets/info_personal.dart
import 'package:flutter/material.dart';
import '../models/jugador.dart';

class InfoPersonal extends StatelessWidget {
  const InfoPersonal({super.key, required this.jugador});

  final Jugador jugador;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildRow('Descripción', jugador.descripcion),
            const Divider(),
            _buildRow('Metas deportivas', jugador.metas),
            const Divider(),
            _buildRow('Posición', '${jugador.posicionPrincipal} ('
                '${jugador.posicionSecundaria})'),
            const Divider(),
            _buildRow('Camiseta', '#${jugador.numeroCamiseta}'),
          ],
        ),
      ),
    );
  }

  Widget _buildRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            
            child: Text(
              '$label:',
              style: const TextStyle(
                  fontWeight: FontWeight.bold, color: Colors.grey),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(value),
          ),
        ],
      ),
    );
  }
}