// screens/auth/register_organizador_screen.dart
import 'package:flutter/material.dart';
import 'package:frontend_organizador/services/auth_service.dart';
import 'package:frontend_organizador/utils/validators.dart';
import 'package:frontend_organizador/screens/organizador/home_organizador_screen.dart';

class RegisterOrganizadorScreen extends StatefulWidget {
  @override
  _RegisterOrganizadorScreenState createState() => _RegisterOrganizadorScreenState();
}

class _RegisterOrganizadorScreenState extends State<RegisterOrganizadorScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nombreController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _loading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Registro de Organizador")),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              Text(
                "Organizador UIDE",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: _nombreController,
                decoration: InputDecoration(labelText: "Nombre Completo *"),
                validator: (v) => v!.isEmpty ? "Requerido" : null,
              ),
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(labelText: "Correo (@uide.edu.ec) *"),
                keyboardType: TextInputType.emailAddress,
                validator: (v) {
                  if (v!.isEmpty) return "Requerido";
                  if (!Validators.isUideEmail(v)) return "Solo correos @uide.edu.ec";
                  if (!Validators.isValidEmail(v)) return "Correo no válido";
                  return null;
                },
              ),
              TextFormField(
                controller: _passwordController,
                obscureText: true,
                decoration: InputDecoration(labelText: "Contraseña *"),
                validator: (v) => v!.length < 6 ? "Mínimo 6 caracteres" : null,
              ),
              TextFormField(
                controller: _confirmPasswordController,
                obscureText: true,
                decoration: InputDecoration(labelText: "Confirmar Contraseña *"),
                validator: (v) => v != _passwordController.text ? "No coinciden" : null,
              ),
              SizedBox(height: 30),
              _loading
                  ? Center(child: CircularProgressIndicator())
                  : ElevatedButton(
                      onPressed: _registrar,
                      child: Text("Registrar Organizador"),
                    ),
              SizedBox(height: 10),
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text("Volver"),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _registrar() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _loading = true);

      final data = {
        'nombre': _nombreController.text.trim(),
        'email': _emailController.text.trim(),
        'password': _passwordController.text,
        'rol': 'organizador',
        'campus': 'UIDE',
      };

      try {
        final response = await AuthService.register(data);

        setState(() => _loading = false);

        if (response['success'] == true) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("✅ Registrado e iniciado sesión")),
          );

          // ✅ REDIRECCIÓN SEGURA AL HOME
          if (mounted) {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => HomeOrganizadorScreen()),
              (route) => false,
            );
          }
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(response['message'] ?? "Error")),
          );
        }
      } catch (e) {
        setState(() => _loading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error de conexión. Verifica tu red.")),
        );
      }
    }
  }

  @override
  void dispose() {
    _nombreController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }
}