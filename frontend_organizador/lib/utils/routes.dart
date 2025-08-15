// utils/routes.dart
import 'package:flutter/material.dart';
import 'package:frontend_organizador/screens/auth/welcome_screen.dart';
import 'package:frontend_organizador/screens/auth/login_screen.dart';
import 'package:frontend_organizador/screens/auth/register_screen.dart';
import 'package:frontend_organizador/screens/auth/register_organizador_screen.dart';
import 'package:frontend_organizador/screens/auth/register_jugador_screen.dart';
import 'package:frontend_organizador/screens/organizador/home_organizador_screen.dart';
import 'package:frontend_organizador/screens/organizador/crear_torneo_screen.dart';
import 'package:frontend_organizador/screens/organizador/gestion_equipos_screen.dart';
import 'package:frontend_organizador/screens/organizador/historial_torneos_screen.dart';
import 'package:frontend_organizador/screens/organizador/programar_partidos_screen.dart';
import 'package:frontend_organizador/screens/organizador/torneos_screen.dart';
import 'package:frontend_organizador/screens/organizador/editar_torneo_screen.dart';
import 'package:frontend_organizador/screens/organizador/detalle_torneo_screen.dart';
import 'package:frontend_organizador/screens/organizador/equipos_aprobados_screen.dart';
import 'package:frontend_organizador/screens/jugador/home_jugador_screen.dart';

class Routes {
  // Autenticación
  static const String welcome = '/welcome';
  static const String login = '/login';
  static const String register = '/register';
  static const String registerOrganizador = '/register/organizador';
  static const String registerJugador = '/register/jugador';

  // Jugador
  static const String homeJugador = '/home_jugador';
  static const String torneosJugador = '/torneos_jugador';
  static const String perfilJugador = '/perfil_jugador';

  // Organizador
  static const String home = '/home';
  static const String crearTorneo = '/crear-torneo';
  static const String gestionEquipos = '/gestion-equipos';
  static const String programarPartidos = '/programar-partidos';
  static const String notificaciones = '/notificaciones';
  static const String estadisticas = '/estadisticas';
  static const String historial = '/historial';
  static const String equiposAprobados = '/equipos-aprobados';

  // === RUTAS ===
  static Map<String, Widget Function(BuildContext)> get routes {
    return {
      welcome: (context) => WelcomeScreen(),
      login: (context) => LoginScreen(),
      register: (context) => RegisterScreen(),
      registerOrganizador: (context) => RegisterOrganizadorScreen(),
      registerJugador: (context) => RegisterJugadorScreen(),
      home: (context) => HomeOrganizadorScreen(),
      homeJugador: (context) => HomeJugadorScreen(), // ✅ Agregado
      crearTorneo: (context) => CrearTorneoScreen(),
      gestionEquipos: (context) => GestionEquiposScreen(),
      historial: (context) => HistorialTorneosScreen(),
      equiposAprobados: (context) => EquiposAprobadosScreen(),
    };
  }
}