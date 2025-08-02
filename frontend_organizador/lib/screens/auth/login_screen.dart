import 'package:flutter/material.dart';
import 'package:frontend_organizador/services/auth_service.dart';
import 'package:frontend_organizador/screens/organizador/home_organizador_screen.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Iniciar Sesión - Organizador")),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(labelText: "Correo UIDE (@uide.edu.ec)"),
                validator: (value) {
                  if (value!.isEmpty) return "Requerido";
                  if (!value.endsWith('@uide.edu.ec')) return "Debe ser correo UIDE";
                  return null;
                },
              ),
              TextFormField(
                controller: _passwordController,
                obscureText: true,
                decoration: InputDecoration(labelText: "Contraseña"),
                validator: (value) => value!.isEmpty ? "Requerido" : null,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    final success = await AuthService.login(
                      _emailController.text,
                      _passwordController.text,
                    );
                    if (success) {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => HomeOrganizadorScreen()),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("Credenciales incorrectas")),
                      );
                    }
                  }
                },
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