// screens/auth/register_jugador_screen.dart

import 'package:flutter/material.dart';
import 'package:frontend_organizador/services/api_service.dart';
import 'package:frontend_organizador/screens/jugador/home_jugador_screen.dart';
import 'package:shared_preferences/shared_preferences.dart'; // ✅ Importado

class RegisterJugadorScreen extends StatefulWidget {
  @override
  _RegisterJugadorScreenState createState() => _RegisterJugadorScreenState();
}

class _RegisterJugadorScreenState extends State<RegisterJugadorScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nombreController = TextEditingController();
  final _emailController = TextEditingController();
  final _cedulaController = TextEditingController();
  final _passwordController = TextEditingController();
  final _edadController = TextEditingController();
  final _posicionPrincipalController = TextEditingController();
  final _posicionSecundariaController = TextEditingController();
  final _numeroCamisetaController = TextEditingController();
  final _telefonoController = TextEditingController();

  String _genero = 'masculino';
  bool _loading = false; // ✅ Cambiado de true a false

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Registro de Jugador"),
        backgroundColor: Color(0xFF1565C0),
      ),
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

              // Nombre Completo
              TextFormField(
                controller: _nombreController,
                decoration: InputDecoration(
                  labelText: "Nombre Completo *",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                validator: (value) => value!.isEmpty ? "Este campo es obligatorio" : null,
              ),
              SizedBox(height: 16),

              // Correo Electrónico
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: "Correo Electrónico *",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value!.isEmpty) return "Este campo es obligatorio";
                  if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
                    return "Correo no válido";
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),

              // Contraseña
              TextFormField(
                controller: _passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: "Contraseña *",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                validator: (value) => value!.length < 6 ? "Mínimo 6 caracteres" : null,
              ),
              SizedBox(height: 16),

              // Cédula
              TextFormField(
                controller: _cedulaController,
                decoration: InputDecoration(
                  labelText: "Número de Cédula *",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                validator: (value) => value!.isEmpty ? "Este campo es obligatorio" : null,
              ),
              SizedBox(height: 16),

              // Edad
              TextFormField(
                controller: _edadController,
                decoration: InputDecoration(
                  labelText: "Edad *",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                keyboardType: TextInputType.number,
                validator: (value) => value!.isEmpty ? "Este campo es obligatorio" : null,
              ),
              SizedBox(height: 16),

              // Posición Principal
              TextFormField(
                controller: _posicionPrincipalController,
                decoration: InputDecoration(
                  labelText: "Posición Principal *",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                validator: (value) => value!.isEmpty ? "Este campo es obligatorio" : null,
              ),
              SizedBox(height: 16),

              // Posición Secundaria
              TextFormField(
                controller: _posicionSecundariaController,
                decoration: InputDecoration(
                  labelText: "Posición Secundaria",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              SizedBox(height: 16),

              // Número de Camiseta
              TextFormField(
                controller: _numeroCamisetaController,
                decoration: InputDecoration(
                  labelText: "Número de Camiseta",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                keyboardType: TextInputType.number,
              ),
              SizedBox(height: 16),

              // Género
              DropdownButtonFormField<String>(
                value: _genero,
                decoration: InputDecoration(
                  labelText: "Género",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                items: [
                  DropdownMenuItem(value: 'masculino', child: Text("Masculino")),
                  DropdownMenuItem(value: 'femenino', child: Text("Femenino")),
                ],
                onChanged: (value) {
                  setState(() {
                    _genero = value!;
                  });
                },
              ),
              SizedBox(height: 16),

              // Teléfono
              TextFormField(
                controller: _telefonoController,
                decoration: InputDecoration(
                  labelText: "Teléfono",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                keyboardType: TextInputType.phone,
              ),
              SizedBox(height: 30),

              // ✅ Botón de registro (ahora aparecerá)
              _loading
                  ? Center(child: CircularProgressIndicator())
                  : ElevatedButton(
                      onPressed: _registrarJugador,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF1565C0),
                        padding: EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        "Registrarse como Jugador",
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _registrarJugador() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _loading = true); // ✅ Solo activa carga durante el envío

    final data = {
      'nombre': _nombreController.text.trim(),
      'email': _emailController.text.trim(),
      'password': _passwordController.text,
      'rol': 'jugador',
      'jugadorInfo': {
        'cedula': _cedulaController.text.trim(),
        'edad': int.tryParse(_edadController.text) ?? 0,
        'posicionPrincipal': _posicionPrincipalController.text,
        'posicionSecundaria': _posicionSecundariaController.text,
        'genero': _genero,
        'telefono': _telefonoController.text,
      }
    };

    try {
      // ✅ Asegúrate de que este método exista en ApiService
      final response = await ApiService.register(data);

      if (response['success'] == true) {
        // ✅ Guardar datos del usuario
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('token', response['token']);
        await prefs.setString('usuario_rol', response['usuario']['rol']);
        await prefs.setString('usuario_nombre', response['usuario']['nombre']);
        await prefs.setString('usuario_email', response['usuario']['email']);
        await prefs.setString('usuario_id', response['usuario']['id']);

        // ✅ Redirigir al home del jugador
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomeJugadorScreen()),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(response['message'] ?? "Error al registrar")),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error de conexión con el servidor")),
      );
    } finally {
      setState(() => _loading = false); // ✅ Asegura que siempre se detenga
    }
  }

  @override
  void dispose() {
    _nombreController.dispose();
    _emailController.dispose();
    _cedulaController.dispose();
    _passwordController.dispose();
    _edadController.dispose();
    _posicionPrincipalController.dispose();
    _posicionSecundariaController.dispose();
    _numeroCamisetaController.dispose();
    _telefonoController.dispose();
    super.dispose();
  }
}