// screens/auth/login_screen.dart
import 'package:flutter/material.dart';
import 'package:frontend_organizador/services/auth_service.dart';
import 'package:frontend_organizador/screens/jugador/home_jugador_screen.dart';
import 'package:frontend_organizador/screens/organizador/home_organizador_screen.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _loading = false;

  Future<void> _iniciarSesion() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _loading = true);

    final result = await AuthService.login(
      _emailController.text.trim(),
      _passwordController.text,
    );

    setState(() => _loading = false);

    if (result['success'] == true) {
      final String rol = result['usuario']['rol'];
      if (rol == 'organizador') {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomeOrganizadorScreen()),
        );
      } else if (rol == 'jugador') {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomeJugadorScreen()),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(result['message'] ?? "Error al iniciar sesión")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Iniciar Sesión")),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(labelText: "Correo"),
                validator: (v) => v!.isEmpty ? "Requerido" : null,
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _passwordController,
                obscureText: true,
                decoration: InputDecoration(labelText: "Contraseña"),
                validator: (v) => v!.isEmpty ? "Requerido" : null,
              ),
              SizedBox(height: 30),
              _loading
                  ? Center(child: CircularProgressIndicator())
                  : ElevatedButton(
                      onPressed: _iniciarSesion,
                      child: Text("Ingresar"),
                    ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}