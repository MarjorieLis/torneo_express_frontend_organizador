// lib/screens/jugador/home_screen.dart
import 'package:flutter/material.dart';
import 'package:frontend_organizador/utils/routes.dart';

class HomeJugadorScreen extends StatelessWidget {
  const HomeJugadorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Inicio'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              Navigator.pushReplacementNamed(context, Routes.login);
            },
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.sports_soccer, size: 80, color: Colors.blue),
            const SizedBox(height: 20),
            const Text(
              'Bienvenido a Torneo Express',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            const Text('Organiza y sigue tus torneos deportivos'),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, Routes.torneosJugador);
              },
              child: const Text('Ver Torneos'),
            ),
            const SizedBox(height: 10),
            OutlinedButton(
              onPressed: () {
                Navigator.pushNamed(context, Routes.perfilJugador);
              },
              child: const Text('Mi Perfil'),
            ),
          ],
        ),
      ),
    );
  }
}