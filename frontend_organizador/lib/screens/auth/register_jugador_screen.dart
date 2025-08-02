// screens/auth/register_jugador_screen.dart
import 'package:flutter/material.dart';
import 'package:frontend_organizador/services/auth_service.dart';
import 'package:frontend_organizador/utils/validators.dart';

class RegisterJugadorScreen extends StatefulWidget {
  @override
  _RegisterJugadorScreenState createState() => _RegisterJugadorScreenState();
}

class _RegisterJugadorScreenState extends State<RegisterJugadorScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nombreController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _edadController = TextEditingController();
  final _posicionPrincipalController = TextEditingController();
  final _posicionSecundariaController = TextEditingController();
  final _numeroCamisetaController = TextEditingController();
  final _telefonoController = TextEditingController();
  bool _loading = false;

  String _genero = 'masculino';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Registro de Jugador")),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              Text(
                "Completa tu perfil",
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
                decoration: InputDecoration(labelText: "Correo *"),
                keyboardType: TextInputType.emailAddress,
                validator: (v) {
                  if (v!.isEmpty) return "Requerido";
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
                controller: _edadController,
                decoration: InputDecoration(labelText: "Edad *"),
                keyboardType: TextInputType.number,
                validator: (v) => v!.isEmpty ? "Requerido" : null,
              ),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _posicionPrincipalController,
                      decoration: InputDecoration(labelText: "Posición Principal *"),
                      validator: (v) => v!.isEmpty ? "Requerido" : null,
                    ),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: TextFormField(
                      controller: _posicionSecundariaController,
                      decoration: InputDecoration(labelText: "Posición Secundaria"),
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _numeroCamisetaController,
                      decoration: InputDecoration(labelText: "Número de Camiseta"),
                      keyboardType: TextInputType.number,
                    ),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      value: _genero,
                      items: ['masculino', 'femenino', 'otro'].map((g) {
                        return DropdownMenuItem(value: g, child: Text(g.capitalize()));
                      }).toList(),
                      onChanged: (v) => setState(() => _genero = v!),
                      decoration: InputDecoration(labelText: "Género"),
                    ),
                  ),
                ],
              ),
              TextFormField(
                controller: _telefonoController,
                decoration: InputDecoration(labelText: "Teléfono"),
                keyboardType: TextInputType.phone,
              ),
              SizedBox(height: 30),
              _loading
                  ? Center(child: CircularProgressIndicator())
                  : ElevatedButton(
                      onPressed: _registrar,
                      child: Text("Registrarse como Jugador"),
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
        'rol': 'jugador',
        'campus': 'UIDE',
        'edad': int.tryParse(_edadController.text),
        'posicionPrincipal': _posicionPrincipalController.text,
        'posicionSecundaria': _posicionSecundariaController.text,
        'numeroCamiseta': _numeroCamisetaController.text.isEmpty
            ? null
            : int.tryParse(_numeroCamisetaController.text),
        'genero': _genero,
        'telefono': _telefonoController.text,
      };

      try {
        final response = await AuthService.register(data);
        if (response['success'] == true) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Registrado. Inicia sesión")),
          );
          Navigator.popUntil(context, ModalRoute.withName('/login'));
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(response['message'])),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error de conexión")),
        );
      } finally {
        setState(() => _loading = false);
      }
    }
  }

  @override
  void dispose() {
    _nombreController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _edadController.dispose();
    _posicionPrincipalController.dispose();
    _posicionSecundariaController.dispose();
    _numeroCamisetaController.dispose();
    _telefonoController.dispose();
    super.dispose();
  }
}

// Extensión para capitalizar
extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${this.substring(1)}";
  }
}