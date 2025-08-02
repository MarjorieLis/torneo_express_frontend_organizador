import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  static const String baseUrl = 'http://192.168.0.10:3000/api'; // Cambia si es necesario

  // Registro de usuario
  static Future<Map<String, dynamic>> register(Map<String, dynamic> userData) async {
    final response = await http.post(
      Uri.parse('$baseUrl/auth/register'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(userData),
    );

    if (response.statusCode == 201 || response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      return {
        'success': false,
        'message': jsonDecode(response.body)['message'] ?? 'Error en el registro',
      };
    }
  }

  // Inicio de sesión
  static Future<Map<String, dynamic>> login(String email, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/auth/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      // Asegurarse de que el backend devuelva el rol
      final String rol = data['usuario']['rol'] ?? '';
      final String token = data['token'];
      final String nombre = data['usuario']['nombre'];
      final String email = data['usuario']['email'];

      // Guardar en SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('token', token);
      await prefs.setString('usuario_rol', rol);
      await prefs.setString('usuario_nombre', nombre);
      await prefs.setString('usuario_email', email);

      return {
        'success': true,
        'rol': rol,
        'nombre': nombre,
        'email': email,
      };
    } else {
      final error = jsonDecode(response.body);
      return {
        'success': false,
        'message': error['message'] ?? 'Credenciales incorrectas',
      };
    }
  }

  // Cerrar sesión
  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
    await prefs.remove('usuario_rol');
    await prefs.remove('usuario_nombre');
    await prefs.remove('usuario_email');
  }

  // Obtener rol del usuario actual
  static Future<String?> getRol() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('usuario_rol');
  }

  // Verificar si el usuario está autenticado
  static Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    return token != null;
  }
}