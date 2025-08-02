import 'package:flutter/material.dart';
import 'utils/routes.dart';
import 'utils/theme.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Torneo Express: Organizacion de juegos y resultados',
      theme: AppTheme.theme,
      initialRoute: '/welcome',
      routes: Routes.routes,
      debugShowCheckedModeBanner: false,
    );
  }
}