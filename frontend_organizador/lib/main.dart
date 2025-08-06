// lib/main.dart
import 'package:flutter/material.dart';
import 'package:frontend_organizador/screens/auth/login_screen.dart';
import 'package:frontend_organizador/screens/auth/register_screen.dart';
import 'package:frontend_organizador/screens/auth/register_organizador_screen.dart';
import 'package:frontend_organizador/screens/auth/register_jugador_screen.dart';
import 'package:frontend_organizador/screens/organizador/home_organizador_screen.dart';
import 'package:frontend_organizador/screens/jugador/home_jugador_screen.dart'; // ✅ Importado
import 'package:frontend_organizador/utils/routes.dart';
import 'package:frontend_organizador/services/auth_service.dart';

import 'screens/auth/welcome_screen.dart';
import 'screens/organizador/crear_torneo_screen.dart';
import 'screens/organizador/gestion_equipos_screen.dart';
import 'screens/organizador/historial_torneos_screen.dart';
import 'screens/organizador/notificaciones_screen.dart';
import 'screens/organizador/estadisticas_screen.dart';
import 'screens/organizador/programar_partidos_screen.dart';
import 'screens/organizador/torneos_screen.dart';
import 'screens/organizador/editar_torneo_screen.dart';
import 'screens/organizador/detalle_torneo_screen.dart';
import 'package:frontend_organizador/models/torneo.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final isLoggedIn = await AuthService.isLoggedIn();
  final rol = await AuthService.getRol() ?? '';
  
  // ✅ Si está logueado y es jugador, va a su home
  final initialRoute = isLoggedIn
      ? (rol == 'organizador' ? Routes.home : Routes.homeJugador)
      : Routes.welcome;

  runApp(MyApp(initialRoute: initialRoute));
}

class MyApp extends StatelessWidget {
  final String initialRoute;

  const MyApp({super.key, required this.initialRoute});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Torneo Express',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.blue),
      initialRoute: initialRoute,
      routes: {
        // Autenticación
        Routes.welcome: (context) => WelcomeScreen(),
        Routes.login: (context) => LoginScreen(),
        Routes.register: (context) => RegisterScreen(),
        Routes.registerOrganizador: (context) => RegisterOrganizadorScreen(),
        Routes.registerJugador: (context) => RegisterJugadorScreen(),

        // Jugador
        Routes.homeJugador: (context) => const HomeJugadorScreen(), // ✅ Nueva ruta

        // Organizador
        Routes.home: (context) => HomeOrganizadorScreen(),
        Routes.crearTorneo: (context) => CrearTorneoScreen(),
        Routes.gestionEquipos: (context) => GestionEquiposScreen(),
        Routes.programarPartidos: (context) {
          final torneo = ModalRoute.of(context)!.settings.arguments as Torneo;
          return ProgramarPartidosScreen(torneo: torneo);
},
        Routes.notificaciones: (context) => NotificacionesScreen(),
        Routes.estadisticas: (context) => EstadisticasScreen(),
        Routes.historial: (context) => HistorialTorneosScreen(),
      },
    );
  }
}