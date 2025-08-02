// services/auth_service.dart
import 'package:http/http.dart' as http;
import 'dart:convert';

class AuthService {
  static const String baseUrl = 'http://localhost:3000/api'; // Cambia a tu URL

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
  static Future<bool> login(String email, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/auth/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      // Guardar token (ej. con SharedPreferences)
      // await SharedPreferences.getInstance().then((prefs) {
      //   prefs.setString('token', data['token']);
      // });
      return true;
    } else {
      return false;
    }
  }
  
}