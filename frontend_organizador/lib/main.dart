// lib/main.dart

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart'; // 👈 Requerido para MaterialLocalizations
import 'package:intl/date_symbol_data_local.dart'; // Para formatos de fecha

// Importaciones de pantallas
import 'package:frontend_organizador/screens/auth/login_screen.dart';
import 'package:frontend_organizador/screens/auth/register_screen.dart';
import 'package:frontend_organizador/screens/auth/register_organizador_screen.dart';
import 'package:frontend_organizador/screens/auth/register_jugador_screen.dart';
import 'package:frontend_organizador/screens/organizador/home_organizador_screen.dart';
import 'package:frontend_organizador/screens/jugador/home_jugador_screen.dart'; // ✅ Importado
import 'package:frontend_organizador/utils/routes.dart';
import 'package:frontend_organizador/services/auth_service.dart';

// Pantallas del organizador
import 'package:frontend_organizador/screens/auth/welcome_screen.dart';
import 'package:frontend_organizador/screens/organizador/crear_torneo_screen.dart';
import 'package:frontend_organizador/screens/organizador/gestion_equipos_screen.dart';
import 'package:frontend_organizador/screens/organizador/historial_torneos_screen.dart';
import 'package:frontend_organizador/screens/organizador/notificaciones_screen.dart';
import 'package:frontend_organizador/screens/organizador/estadisticas_screen.dart';
import 'package:frontend_organizador/screens/organizador/programar_partidos_screen.dart';
import 'package:frontend_organizador/screens/organizador/torneos_screen.dart';
import 'package:frontend_organizador/screens/organizador/editar_torneo_screen.dart';
import 'package:frontend_organizador/screens/organizador/detalle_torneo_screen.dart';

// Modelo
import 'package:frontend_organizador/models/torneo.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 🔥 Inicializa el soporte para formatos de fecha (especialmente en español)
  await initializeDateFormatting();

  // Obtener estado de autenticación y rol
  final isLoggedIn = await AuthService.isLoggedIn();
  final rol = await AuthService.getRol() ?? '';

  // Definir ruta inicial
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
        Routes.homeJugador: (context) => const HomeJugadorScreen(),

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

      // ✅ LOCALIZACIONES: Esenciales para AlertDialog, DatePicker, etc.
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,   // Textos como "OK", "Cancelar"
        GlobalWidgetsLocalizations.delegate,   // Widgets básicos
        GlobalCupertinoLocalizations.delegate, // Para iOS (opcional)
      ],
      supportedLocales: const [
        Locale('es', ''), // Español
        Locale('en', ''), // Inglés
      ],
    );
  }
}