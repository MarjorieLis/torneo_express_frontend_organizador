// screens/auth/register_screen.dart
import 'package:flutter/material.dart';
import 'package:frontend_organizador/screens/auth/register_organizador_screen.dart';
import 'package:frontend_organizador/screens/auth/register_jugador_screen.dart';

class RegisterScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Selecciona tu rol"),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "¿Cómo deseas registrarte?",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 40),
              ElevatedButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => RegisterOrganizadorScreen(),
                    ),
                  );
                },
                icon: Icon(Icons.group, size: 32),
                label: Text("  Organizador", style: TextStyle(fontSize: 18)),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  backgroundColor: Color(0xFF1565C0),
                ),
                // minWidth: 200,
                // height: 60,
              ),
              SizedBox(height: 20),
              ElevatedButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => RegisterJugadorScreen(),
                    ),
                  );
                },
                icon: Icon(Icons.sports_soccer, size: 32),
                label: Text("  Jugador", style: TextStyle(fontSize: 18)),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  backgroundColor: Color(0xFF0D47A1),
                ),
              ),
              SizedBox(height: 40),
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text("¿Ya tienes cuenta? Inicia sesión"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}