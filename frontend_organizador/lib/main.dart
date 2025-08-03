import 'package:flutter/material.dart';
import 'utils/routes.dart';
import 'services/auth_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // ✅ Verificamos si hay sesión activa
  final isLoggedIn = await AuthService.isLoggedIn();
  final rol = await AuthService.getRol() ?? '';

  // ✅ Si está logueado Y es organizador, va al home
  // ✅ Si NO, va a la pantalla de bienvenida
  final initialRoute = isLoggedIn && rol == 'organizador'
      ? Routes.home
      : Routes.welcome; // ← Asegúrate de que esta sea la ruta correcta

  runApp(MyApp(initialRoute: initialRoute));
}

class MyApp extends StatelessWidget {
  final String initialRoute;

  const MyApp({super.key, required this.initialRoute});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Torneo Express',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Colors.grey[100],
      ),
      initialRoute: initialRoute,
      routes: Routes.routes,
      debugShowCheckedModeBanner: false,
    );
  }
}