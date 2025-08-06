// lib/screens/jugador/home_screen.dart
import 'package:flutter/material.dart';
import 'package:frontend_organizador/screens/jugador/torneos_disponibles_screen.dart';
import 'package:frontend_organizador/services/auth_service.dart';
import 'package:frontend_organizador/utils/routes.dart';

class HomeJugadorScreen extends StatelessWidget {
  const HomeJugadorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Inicio Jugador'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async{
              await AuthService.logout();
              Navigator.pushReplacementNamed(context, Routes.welcome);
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
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => TorneosDisponiblesScreen(),
                  ),
                );
              },
              child: const Text('Ver Torneos Disponibles'),
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