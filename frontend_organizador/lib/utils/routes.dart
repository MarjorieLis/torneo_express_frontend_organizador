import 'package:flutter/material.dart';
import 'package:frontend_organizador/screens/auth/welcome_screen.dart';
import 'package:frontend_organizador/screens/auth/login_screen.dart';
import 'package:frontend_organizador/screens/organizador/home_organizador_screen.dart';
import 'package:frontend_organizador/screens/organizador/crear_torneo_screen.dart';
import 'package:frontend_organizador/screens/organizador/gestion_equipos_screen.dart';
// ❌ Eliminamos esta importación ya que no se puede usar sin parámetro
// import 'package:frontend_organizador/screens/organizador/programar_partidos_screen.dart';
import 'package:frontend_organizador/screens/organizador/notificaciones_screen.dart';
import 'package:frontend_organizador/screens/organizador/estadisticas_screen.dart';
import 'package:frontend_organizador/screens/organizador/historial_torneos_screen.dart';
import 'package:frontend_organizador/screens/auth/register_screen.dart';
import 'package:frontend_organizador/screens/auth/register_organizador_screen.dart';
import 'package:frontend_organizador/screens/auth/register_jugador_screen.dart';

class Routes {
  static const String welcome = '/welcome';
  static const String login = '/login';
  static const String home = '/home';
  static const String register = '/register';
  static const String registerOrganizador = '/register/organizador';
  static const String registerJugador = '/register/jugador';
  static const String crearTorneo = '/crear-torneo';
  static const String gestionEquipos = '/gestion-equipos';
  static const String programarPartidos = '/programar-partidos';
  static const String notificaciones = '/notificaciones';
  static const String estadisticas = '/estadisticas';
  static const String historial = '/historial';

  // ✅ CORRECTO: Usa Widget Function(BuildContext)
  static Map<String, Widget Function(BuildContext)> get routes {
    return {
      welcome: (context) => WelcomeScreen(),
      login: (context) => LoginScreen(),
      register: (context) => RegisterScreen(),
      registerOrganizador: (context) => RegisterOrganizadorScreen(),
      registerJugador: (context) => RegisterJugadorScreen(),
      home: (context) => HomeOrganizadorScreen(),
      crearTorneo: (context) => CrearTorneoScreen(),
      gestionEquipos: (context) => GestionEquiposScreen(),
      // ❌ Eliminado porque requiere parámetro obligatorio
      // programarPartidos: (context) => ProgramarPartidosScreen(),
      notificaciones: (context) => NotificacionesScreen(),
      estadisticas: (context) => EstadisticasScreen(),
      historial: (context) => HistorialTorneosScreen(),
    };
  }
}
