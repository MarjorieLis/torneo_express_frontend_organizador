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
  bool _loading = false;

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
              _loading
                  ? CircularProgressIndicator()
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

  Future<void> _iniciarSesion() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _loading = true);

      final result = await AuthService.login(
        _emailController.text.trim(),
        _passwordController.text,
      );

      setState(() => _loading = false);

      if (result['success'] == true) {
        final String rol = result['rol'];

        if (rol == 'organizador') {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => HomeOrganizadorScreen()),
          );
        } else {
          // Si el usuario no es organizador
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Acceso denegado. Solo organizadores.")),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(result['message'])),
        );
      }
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}