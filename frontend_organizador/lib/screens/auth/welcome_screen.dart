// screens/auth/welcome_screen.dart
import 'package:flutter/material.dart';
import 'package:frontend_organizador/screens/auth/login_screen.dart';
import 'package:frontend_organizador/screens/auth/register_screen.dart';
import 'package:frontend_organizador/utils/routes.dart';

class WelcomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Bienvenido a Torneo Express"),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Organizador UIDE",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 40),
            ElevatedButton(
              onPressed: () => Navigator.pushNamed(context, Routes.login),
              child: Text("Iniciar Sesión"),
            ),
            SizedBox(height: 10),
            TextButton(
              onPressed: () => Navigator.pushNamed(context, Routes.register),
              child: Text("Registrarse como Organizador"),
            ),
          ],
        ),
      ),
    );
  }
}