import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:frontend_organizador/services/api_service.dart'; // ✅ Importa ApiService
import 'package:frontend_organizador/models/notificacion.dart'; // ✅ Asegúrate de tener el modelo

class NotificacionesScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Notificaciones"),
      ),
      body: FutureBuilder<List<Notificacion>>(
        future: ApiService.obtenerNotificaciones(),
        builder: (context, snapshot) {
          // Estado: cargando
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          // Estado: error o sin datos
          if (!snapshot.hasData || snapshot.data == null || snapshot.data!.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.notifications_off, size: 64, color: Colors.grey),
                  const SizedBox(height: 16),
                  const Text(
                    "No tienes notificaciones",
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                ],
              ),
            );
          }

          // Estado: datos listos
          final List<Notificacion> notificaciones = snapshot.data!;

          return RefreshIndicator(
            onRefresh: () async {
              // Opcional: permite refrescar con swipe down
              await Future.delayed(Duration(seconds: 1));
            },
            child: ListView.builder(
              padding: const EdgeInsets.all(8),
              itemCount: notificaciones.length,
              itemBuilder: (context, i) {
                final notif = notificaciones[i];
                return ListTile(
                  leading: Icon(
                    Icons.notifications,
                    color: notif.leida ? Colors.grey : Colors.blue,
                  ),
                  title: Text(
                    notif.mensaje,
                    style: TextStyle(
                      fontWeight: notif.leida ? FontWeight.normal : FontWeight.bold,
                      color: notif.leida ? Colors.grey : null,
                    ),
                  ),
                  trailing: !notif.leida
                      ? Container(
                          width: 8,
                          height: 8,
                          decoration: const BoxDecoration(
                            color: Colors.blue,
                            shape: BoxShape.circle,
                          ),
                        )
                      : null,
                  tileColor: notif.leida ? null : Theme.of(context).highlightColor.withOpacity(0.1),
                );
              },
            ),
          );
        },
      ),
    );
  }
}