// widgets/jugador_card.dart
import 'package:flutter/material.dart';
import '../models/jugador.dart';

class JugadorCard extends StatelessWidget {
  const JugadorCard({super.key, required this.jugador});

  final Jugador jugador;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4),
      elevation: 2,
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.green,
          child: Text(
            jugador.numeroCamiseta.toString(),
            style: const TextStyle(
              color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
        title: Text(
          jugador.nombreCompleto,
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        subtitle: Text(jugador.posicionPrincipal),
        trailing: const Icon(Icons.verified, color: Colors.blue),
      ),
    );
  }
}