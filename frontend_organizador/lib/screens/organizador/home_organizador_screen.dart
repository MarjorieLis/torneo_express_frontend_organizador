import 'package:flutter/material.dart';
import 'package:frontend_organizador/models/torneo.dart';
import 'package:frontend_organizador/screens/organizador/crear_torneo_screen.dart';
import 'package:frontend_organizador/screens/organizador/gestion_equipos_screen.dart';
import 'package:frontend_organizador/screens/organizador/historial_torneos_screen.dart';
import 'package:frontend_organizador/screens/organizador/notificaciones_screen.dart';
import 'package:frontend_organizador/screens/organizador/estadisticas_screen.dart';
import 'package:frontend_organizador/screens/organizador/programar_partidos_screen.dart';
import 'package:frontend_organizador/widgets/tournament_card.dart';
import 'package:frontend_organizador/services/auth_service.dart';
import 'package:frontend_organizador/utils/routes.dart';
import 'package:frontend_organizador/screens/organizador/torneos_screen.dart';

class HomeOrganizadorScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // ⚠️ Torneo de ejemplo solo para navegar a ProgramarPartidosScreen
    final torneoEjemplo = Torneo(
      id: '1',
      nombre: 'Torneo de Ejemplo',
      disciplina: 'Fútbol',
      fechaInicio: DateTime.now(),
      fechaFin: DateTime.now().add(Duration(days: 7)),
      maxEquipos: 8,
      reglas: 'Reglas básicas',
      formato: 'Eliminación directa',
      estado: 'activo',
      equipos: [],
      partidos: [],
    );

    return Scaffold(
      appBar: AppBar(
        title: Text("Torneo Express - Organizador"),
        actions: [
          IconButton(onPressed: () {}, icon: Icon(Icons.notifications)),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(child: Text("Organizador UIDE")),
            ListTile(
              title: Text("Cerrar sesión"),
              onTap: () async {
                await AuthService.logout();
                Navigator.pushNamedAndRemoveUntil(context, Routes.welcome, (route) => false);
              },
            ),
            ListTile(
              leading: Icon(Icons.list),
              title: Text("Torneos"),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => TorneosScreen()),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.history),
              title: Text("Historial de Torneos"),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => HistorialTorneosScreen()),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.notifications),
              title: Text("Notificaciones"),
              onTap: () {
                // Navegar a notificaciones
              },
            ),
          ],
        ),
      ),
      body: GridView(
        padding: EdgeInsets.all(16),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 1.2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
        ),
        children: [
          ActionCard(icon: Icons.add, label: "Crear Torneo", route: CrearTorneoScreen()),
          ActionCard(icon: Icons.group, label: "Aprobar Equipos", route: GestionEquiposScreen()),
          ActionCard(
            icon: Icons.event,
            label: "Programar Partidos",
            route: ProgramarPartidosScreen(torneo: torneoEjemplo), // ✅ Corregido aquí
          ),
          ActionCard(icon: Icons.notifications, label: "Notificar", route: NotificacionesScreen()),
          ActionCard(icon: Icons.analytics, label: "Estadísticas", route: EstadisticasScreen()),
          ActionCard(icon: Icons.history, label: "Historial", route: HistorialTorneosScreen()),
        ],
      ),
    );
  }
}

class ActionCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final Widget route;

  ActionCard({required this.icon, required this.label, required this.route});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      child: InkWell(
        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => route)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 40, color: Colors.blue),
            SizedBox(height: 10),
            Text(label, textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }
}
