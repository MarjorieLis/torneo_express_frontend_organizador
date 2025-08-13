// screens/organizador/equipos_aprobados_screen.dart
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:frontend_organizador/models/equipo.dart';
import 'package:frontend_organizador/services/api_service.dart';
import 'package:frontend_organizador/widgets/equipo_card.dart';

class EquiposAprobadosScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Equipos Aprobados"),
      ),
      body: FutureBuilder<List<Equipo>>(
        future: ApiService.obtenerEquiposAprobados(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.check_circle, size: 64, color: Colors.grey),
                  const SizedBox(height: 16),
                  const Text(
                    "No hay equipos aprobados",
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                ],
              ),
            );
          }

          final equipos = snapshot.data!;

          return ListView.builder(
            padding: const EdgeInsets.all(8),
            itemCount: equipos.length,
            itemBuilder: (context, i) {
              final e = equipos[i];
              return EquipoCard(
                equipo: e,
              ); // ✅ No pasas onAprobar ni onRechazar
            },
          );
        },
      ),
    );
  }
}