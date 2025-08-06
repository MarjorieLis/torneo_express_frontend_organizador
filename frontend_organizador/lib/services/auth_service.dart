// services/auth_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  static const String baseUrl = 'http://10.0.2.2:3000/api';

  // Registro de usuario
  static Future<Map<String, dynamic>> register(Map<String, dynamic> userData) async {
    final response = await http.post(
      Uri.parse('$baseUrl/auth/register'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(userData),
    );

    final data = jsonDecode(response.body);

    if (response.statusCode == 201 && data['success'] == true) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('token', data['token']);
      await prefs.setString('usuario_rol', data['usuario']['rol']);
      await prefs.setString('usuario_nombre', data['usuario']['nombre']);
      await prefs.setString('usuario_email', data['usuario']['email']);

      if (data['usuario']['rol'] == 'jugador' && data['usuario']['jugadorInfo'] != null) {
        await prefs.setString('jugador_info', jsonEncode(data['usuario']['jugadorInfo']));
      }
    }

    return data;
  }

  // Inicio de sesión
  static Future<Map<String, dynamic>> login(String email, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/auth/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );

    final data = jsonDecode(response.body);

    if (response.statusCode == 200 && data['success'] == true) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('token', data['token']);
      await prefs.setString('usuario_rol', data['usuario']['rol']);
      await prefs.setString('usuario_nombre', data['usuario']['nombre']);
      await prefs.setString('usuario_email', data['usuario']['email']);

      if (data['usuario']['rol'] == 'jugador' && data['usuario']['jugadorInfo'] != null) {
        await prefs.setString('jugador_info', jsonEncode(data['usuario']['jugadorInfo']));
      }

      return data;
    } else {
      return data;
    }
  }

  // Cerrar sesión
  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
    await prefs.remove('usuario_rol');
    await prefs.remove('usuario_nombre');
    await prefs.remove('usuario_email');
    await prefs.remove('jugador_info');
  }

  // Obtener rol
  static Future<String?> getRol() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('usuario_rol');
  }

  // Verificar si está autenticado
  static Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    return token != null;
  }

  // Obtener token
  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  // ✅ Obtener información del jugador
  static Future<Map<String, dynamic>?> getJugadorInfo() async {
    final prefs = await SharedPreferences.getInstance();
    final info = prefs.getString('jugador_info');
    return info != null ? jsonDecode(info) : null;
  }
  static Future<String?> getUserId() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getString('usuario_id'); // Debe guardarse al hacer login
}
}