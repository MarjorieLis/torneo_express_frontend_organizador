import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  static const String baseUrl = 'http://192.168.0.2:3000/api'; // Asegúrate de que esta IP sea correcta

  // Registro de usuario
  static Future<Map<String, dynamic>> register(Map<String, dynamic> userData) async {
    final response = await http.post(
      Uri.parse('$baseUrl/auth/register'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(userData),
    );

    final data = jsonDecode(response.body);

    // ✅ GUARDAR TOKEN Y DATOS SI EL REGISTRO ES EXITOSO
    if (response.statusCode == 201 && data['success'] == true) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('token', data['token']);
      await prefs.setString('usuario_rol', data['usuario']['rol']);
      await prefs.setString('usuario_nombre', data['usuario']['nombre']);
      await prefs.setString('usuario_email', data['usuario']['email']);

      // ✅ Guardar jugadorInfo si existe
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

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      final String rol = data['usuario']['rol'] ?? '';
      final String token = data['token'];
      final String nombre = data['usuario']['nombre'];
      final String email = data['usuario']['email'];

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('token', token);
      await prefs.setString('usuario_rol', rol);
      await prefs.setString('usuario_nombre', nombre);
      await prefs.setString('usuario_email', email);

      // ✅ Guardar jugadorInfo si es jugador
      if (rol == 'jugador' && data['usuario']['jugadorInfo'] != null) {
        await prefs.setString('jugador_info', jsonEncode(data['usuario']['jugadorInfo']));
      }

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
    await prefs.remove('jugador_info'); // ✅ Eliminar también la info del jugador
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
}