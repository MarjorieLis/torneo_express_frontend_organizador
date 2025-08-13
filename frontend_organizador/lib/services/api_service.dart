import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:frontend_organizador/services/auth_service.dart';

// Importar modelos
import '../models/torneo.dart';
import '../models/partido.dart';
import '../models/notificacion.dart';

class ApiService {
  static const String baseUrl = 'http://192.168.0.6:3000/api';

  // === TORNEOS ===
  static Future<Map<String, dynamic>> crearTorneo(Map<String, dynamic> data) async {
    final token = await AuthService.getToken();
    final response = await http.post(
      Uri.parse('$baseUrl/torneos'),
      headers: {
        'Content-Type': 'application/json',
        'x-auth-token': token!,
      },
      body: jsonEncode(data),
    );

    final result = jsonDecode(response.body);
    return result;
  }

  static Future<List<Torneo>> getTorneos() async {
    final token = await AuthService.getToken();
    final response = await http.get(
      Uri.parse('$baseUrl/torneos'),
      headers: {
        'x-auth-token': token!,
      },
    );

    final result = jsonDecode(response.body);
    print('🔍 Respuesta /torneos: $result');
    if (response.statusCode == 200 && result['success'] == true) {
      final List jsonList = result['torneos'];
      return jsonList.map((json) => Torneo.fromJson(json)).toList();
    } else {
      print('❌ Error: ${result['message'] ?? 'Desconocido'}');
      return [];
    }
  }

  static Future<Map<String, dynamic>> editarTorneo(String id, Map<String, dynamic> data) async {
    final token = await AuthService.getToken();
    final response = await http.put(
      Uri.parse('$baseUrl/torneos/$id'),
      headers: {
        'Content-Type': 'application/json',
        'x-auth-token': token!,
      },
      body: jsonEncode(data),
    );
    return jsonDecode(response.body);
  }

  static Future<Map<String, dynamic>> suspenderTorneo(String id) async {
    final token = await AuthService.getToken();
    final response = await http.put(
      Uri.parse('$baseUrl/torneos/$id/suspender'),
      headers: {
        'Content-Type': 'application/json',
        'x-auth-token': token!,
      },
    );
    return jsonDecode(response.body);
  }

  static Future<Map<String, dynamic>> cancelarTorneo(String id) async {
    final token = await AuthService.getToken();
    final response = await http.put(
      Uri.parse('$baseUrl/torneos/$id/cancelar'),
      headers: {
        'Content-Type': 'application/json',
        'x-auth-token': token!,
      },
    );
    return jsonDecode(response.body);
  }

  // === EQUIPOS ===
  static Future<Map<String, dynamic>> obtenerEquiposPendientes() async {
    final token = await AuthService.getToken();
    print('🔐 Token: $token');
    if (token == null) {
      return {'success': false, 'message': 'No autenticado'};
    }

    try {
      final response = await http.get(
        Uri.parse('$baseUrl/equipos/pendientes'),
        headers: {
          'Content-Type': 'application/json',
          'x-auth-token': token,
        },
      );

      print('📡 Estado: ${response.statusCode}');
      print('📦 Cuerpo: ${response.body}');

      return jsonDecode(response.body);
    } catch (e) {
      print('❌ Error en la petición: $e');
      return {'success': false, 'message': 'Error de conexión'};
    }
  }

  static Future<bool> aprobarEquipo(String equipoId) async {
    final token = await AuthService.getToken();
    final url = Uri.parse('$baseUrl/equipos/aprobado/$equipoId');

    try {
      final response = await http.put(
        url,
        headers: {
          'x-auth-token': token!,
          'Content-Type': 'application/json',
        },
      );

      final json = jsonDecode(response.body);
      return json['success'] == true;
    } catch (e) {
      print('❌ Error al aprobar equipo: $e');
      return false;
    }
  }

  static Future<bool> rechazarEquipo(String equipoId) async {
    final token = await AuthService.getToken();
    final url = Uri.parse('$baseUrl/equipos/rechazado/$equipoId');

    try {
      final response = await http.put(
        url,
        headers: {
          'x-auth-token': token!,
          'Content-Type': 'application/json',
        },
      );

      final json = jsonDecode(response.body);
      return json['success'] == true;
    } catch (e) {
      print('❌ Error al rechazar equipo: $e');
      return false;
    }
  }

  static Future<Map<String, dynamic>> crearEquipo(String cuerpo) async {
    final token = await AuthService.getToken();
    print('🔐 Token: $token');
    if (token == null) {
      return {'success': false, 'message': 'No autenticado'};
    }

    try {
      final response = await http.post(
        Uri.parse('$baseUrl/equipos'),
        headers: {
          'Content-Type': 'application/json',
          'x-auth-token': token,
        },
        body: cuerpo,
      );

      print('📡 Estado: ${response.statusCode}');
      print('📦 Cuerpo: ${response.body}');

      return jsonDecode(response.body);
    } catch (e) {
      print('❌ Error en la petición: $e');
      return {'success': false, 'message': 'Error de conexión'};
    }
  }

  // === JUGADORES ===
  static Future<Map<String, dynamic>> obtenerJugadoresDisponibles(String torneoId) async {
    final token = await AuthService.getToken();
    print('🔐 Token: $token');

    if (token == null) {
      return {'success': false, 'message': 'No autenticado'};
    }

    try {
      final response = await http.get(
        Uri.parse('$baseUrl/jugadores/disponibles'),
        headers: {
          'Content-Type': 'application/json',
          'x-auth-token': token,
        },
      );

      print('📡 Estado: ${response.statusCode}');
      print('📦 Cuerpo: ${response.body}');

      return jsonDecode(response.body);
    } catch (e) {
      print('❌ Error en la petición: $e');
      return {'success': false, 'message': 'Error de conexión'};
    }
  }

  static Future<Map<String, dynamic>> buscarJugador(String query) async {
    final token = await AuthService.getToken();
    print('🔐 Token: $token');
    if (token == null) {
      return {'success': false, 'message': 'No autenticado'};
    }

    try {
      final response = await http.get(
        Uri.parse('$baseUrl/jugadores/buscar?query=$query'),
        headers: {
          'Content-Type': 'application/json',
          'x-auth-token': token,
        },
      );

      print('📡 Estado: ${response.statusCode}');
      print('📦 Cuerpo: ${response.body}');

      return jsonDecode(response.body);
    } catch (e) {
      print('❌ Error en la petición: $e');
      return {'success': false, 'message': 'Error de conexión'};
    }
  }

  // === INSCRIPCIONES Y PARTIDOS ===
  static Future<Map<String, dynamic>> obtenerTorneosDisponibles() async {
    final token = await AuthService.getToken();
    print('🔐 Token: $token');

    if (token == null) {
      return {'success': false, 'message': 'No autenticado'};
    }

    try {
      final response = await http.get(
        Uri.parse('$baseUrl/torneos/disponibles'),
        headers: {
          'Content-Type': 'application/json',
          'x-auth-token': token,
        },
      );

      print('📡 Estado: ${response.statusCode}');
      print('📦 Cuerpo: ${response.body}');

      final data = jsonDecode(response.body);
      if (response.statusCode == 200 && data['success'] == true) {
        return data;
      } else {
        return {
          'success': false,
          'message': data['message'] ?? 'Error desconocido'
        };
      }
    } catch (e) {
      print('❌ Error en la petición: $e');
      return {'success': false, 'message': 'Error de conexión'};
    }
  }

  static Future<Map<String, dynamic>> inscribirEquipo(String torneoId, String equipoId) async {
    final token = await AuthService.getToken();
    print('🔐 Token: $token');

    if (token == null) {
      return {'success': false, 'message': 'No autenticado'};
    }

    try {
      final response = await http.post(
        Uri.parse('$baseUrl/torneos/$torneoId/equipos'),
        headers: {
          'Content-Type': 'application/json',
          'x-auth-token': token,
        },
        body: jsonEncode({'equipoId': equipoId}),
      );

      print('📡 Estado: ${response.statusCode}');
      print('📦 Cuerpo: ${response.body}');

      return jsonDecode(response.body);
    } catch (e) {
      print('❌ Error en la petición: $e');
      return {'success': false, 'message': 'Error de conexión'};
    }
  }

  static Future<Map<String, dynamic>> programarPartidos(Map<String, dynamic> data) async {
    final token = await AuthService.getToken();
    final response = await http.post(
      Uri.parse('$baseUrl/partidos/programar'),
      headers: {
        'Content-Type': 'application/json',
        'x-auth-token': token!,
      },
      body: jsonEncode(data),
    );
    return jsonDecode(response.body);
  }

  // === NOTIFICACIONES ===
  static Future<List<Notificacion>> obtenerNotificaciones() async {
    final token = await AuthService.getToken();
    final url = Uri.parse('$baseUrl/notificaciones');

    try {
      final response = await http.get(
        url,
        headers: {
          'x-auth-token': token!,
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> jsonList = jsonDecode(response.body);
        return jsonList.map((json) => Notificacion.fromJson(json)).toList();
      } else {
        print('❌ Error al obtener notificaciones: ${response.statusCode}');
        return [];
      }
    } catch (e) {
      print('❌ Error de conexión a notificaciones: $e');
      return [];
    }
  }

  static Future<Map<String, dynamic>> enviarNotificacion(Map<String, dynamic> data) async {
    final response = await http.post(
      Uri.parse('$baseUrl/notificaciones'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(data),
    );
    return jsonDecode(response.body);
  }

  // === ESTADÍSTICAS Y HISTORIAL ===
  static Future<Map<String, dynamic>> getEstadisticas(String torneoId) async {
    final response = await http.get(Uri.parse('$baseUrl/torneos/$torneoId/estadisticas'));
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    }
    return {};
  }

  static Future<List<dynamic>> getTorneosPasados() async {
    final response = await http.get(Uri.parse('$baseUrl/torneos/historial'));
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    }
    return [];
  }

  static Future<List<dynamic>> getEquiposPorEstado(String estado) async {
    final response = await http.get(Uri.parse('$baseUrl/equipos?estado=$estado'));
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    }
    return [];
  }

  static Future<Map<String, dynamic>> actualizarEstadoEquipo(String id, String estado) async {
    final response = await http.put(
      Uri.parse('$baseUrl/equipos/$id'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'estado': estado}),
    );
    return jsonDecode(response.body);
  }

  static Future<Map<String, dynamic>> register(Map<String, dynamic> data) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/auth/register'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(data),
      );

      final result = jsonDecode(response.body);

      if (response.statusCode == 201 || response.statusCode == 200) {
        return {'success': true, 'token': result['token'], 'usuario': result['usuario']};
      } else {
        return {'success': false, 'message': result['message'] ?? 'Error en el registro'};
      }
    } catch (e) {
      print('❌ Error en register: $e');
      return {'success': false, 'message': 'Error de conexión con el servidor'};
    }
  }
}