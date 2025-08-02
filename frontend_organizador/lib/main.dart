import 'package:flutter/material.dart';
import 'utils/routes.dart';
import 'utils/theme.dart';
import 'services/auth_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final isLoggedIn = await AuthService.isLoggedIn();
  final rol = await AuthService.getRol() ?? '';

  runApp(MyApp(
    initialRoute: isLoggedIn && rol == 'organizador' ? '/home' : '/login',
  ));
}


class MyApp extends StatelessWidget {
  final String initialRoute;

  const MyApp({super.key, required this.initialRoute});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Torneo Express: Organización de juegos y resultados',
      theme: AppTheme.theme,
      initialRoute: initialRoute,
      routes: Routes.routes,
      debugShowCheckedModeBanner: false,
    );
  }
}
