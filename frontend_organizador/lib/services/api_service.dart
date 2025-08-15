// services/api_service.dart
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:frontend_organizador/services/auth_service.dart';

// Importar modelos
import '../models/torneo.dart';
import '../models/partido.dart';
import '../models/notificacion.dart';
import '../models/equipo.dart';
import '../models/jugador.dart'; // ✅ Importa Jugador aquí

class ApiService {
  static const String baseUrl = 'http://192.168.0.9:3000/api';

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
    return jsonDecode(response.body);
  }

  static Future<List<Torneo>> getTorneos() async {
    final token = await AuthService.getToken();
    final response = await http.get(
      Uri.parse('$baseUrl/torneos'),
      headers: {'x-auth-token': token!},
    );

    final result = jsonDecode(response.body);
    if (response.statusCode == 200 && result['success'] == true) {
      final List jsonList = result['torneos'];
      return jsonList.map((json) => Torneo.fromJson(json)).toList();
    } else {
      return [];
    }
  }

  static Future<List<Torneo>> obtenerTorneos() async => await getTorneos();

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
    if (token == null) return {'success': false, 'message': 'No autenticado'};

    try {
      final response = await http.get(
        Uri.parse('$baseUrl/equipos/pendientes'),
        headers: {'x-auth-token': token},
      );
      return jsonDecode(response.body);
    } catch (e) {
      return {'success': false, 'message': 'Error de conexión'};
    }
  }

  static Future<bool> aprobarEquipo(String equipoId) async {
    final token = await AuthService.getToken();
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/equipos/aprobado/$equipoId'),
        headers: {'x-auth-token': token!},
      );
      final json = jsonDecode(response.body);
      return json['success'] == true;
    } catch (e) {
      return false;
    }
  }

  static Future<bool> rechazarEquipo(String equipoId) async {
    final token = await AuthService.getToken();
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/equipos/rechazado/$equipoId'),
        headers: {'x-auth-token': token!},
      );
      final json = jsonDecode(response.body);
      return json['success'] == true;
    } catch (e) {
      return false;
    }
  }

  static Future<Map<String, dynamic>> crearEquipo(String cuerpo) async {
    final token = await AuthService.getToken();
    if (token == null) return {'success': false, 'message': 'No autenticado'};

    try {
      final response = await http.post(
        Uri.parse('$baseUrl/equipos'),
        headers: {'x-auth-token': token},
        body: cuerpo,
      );
      return jsonDecode(response.body);
    } catch (e) {
      return {'success': false, 'message': 'Error de conexión'};
    }
  }

  static Future<List<Equipo>> obtenerEquiposAprobados() async {
    final token = await AuthService.getToken();
    if (token == null) return [];

    try {
      final response = await http.get(
        Uri.parse('$baseUrl/equipos/aprobados'),
        headers: {'x-auth-token': token},
      );
      final data = jsonDecode(response.body);
      if (data['success'] == true && data['equipos'] is List) {
        return (data['equipos'] as List).map((e) => Equipo.fromJson(e)).toList();
      }
      return [];
    } catch (e) {
      return [];
    }
  }

  // === JUGADORES ===
static Future<List<Jugador>> obtenerJugadoresDisponibles() async {
  final token = await AuthService.getToken();
  if (token == null) return [];

  try {
    final response = await http.get(
      Uri.parse('$baseUrl/jugadores/disponibles'),
      headers: {'x-auth-token': token},
    );

    final data = jsonDecode(response.body);
    if (response.statusCode == 200 && data['success'] == true && data['jugadores'] is List) {
      return (data['jugadores'] as List).map((j) => Jugador.fromJson(j)).toList();
    }
    return [];
  } catch (e) {
    print('❌ Error: $e');
    return [];
  }
}
static Future<Map<String, dynamic>> asignarJugadoresAlEquipo(String equipoId, List<String> jugadorIds) async {
  final token = await AuthService.getToken();
  if (token == null) return {'success': false, 'message': 'No autenticado'};

  try {
    final response = await http.put(
      Uri.parse('$baseUrl/equipos/$equipoId/jugadores'), // ✅ Verifica que esta ruta coincida con el backend
      headers: {
        'Content-Type': 'application/json',
        'x-auth-token': token,
      },
      body: jsonEncode({'jugadorIds': jugadorIds}),
    );

    // ✅ Agrega este print para depurar
    print('📡 Respuesta del backend: ${response.body}');

    return jsonDecode(response.body);
  } catch (e) {
    print('❌ Error al asignar jugadores: $e');
    return {'success': false, 'message': 'Error de conexión'};
  }
}

  static Future<Map<String, dynamic>> asignarJugadores(String equipoId, List<String> jugadorIds) async {
    final token = await AuthService.getToken();
    if (token == null) return {'success': false, 'message': 'No autenticado'};

    try {
      final response = await http.put(
        Uri.parse('$baseUrl/equipos/$equipoId/asignar-jugadores'),
        headers: {
          'Content-Type': 'application/json',
          'x-auth-token': token,
        },
        body: jsonEncode({'jugadorIds': jugadorIds}),
      );
      return jsonDecode(response.body);
    } catch (e) {
      return {'success': false, 'message': 'Error de conexión'};
    }
  }

  static Future<Map<String, dynamic>> buscarJugador(String query) async {
    final token = await AuthService.getToken();
    if (token == null) return {'success': false, 'message': 'No autenticado'};

    try {
      final response = await http.get(
        Uri.parse('$baseUrl/jugadores/buscar?query=$query'),
        headers: {'x-auth-token': token},
      );
      return jsonDecode(response.body);
    } catch (e) {
      return {'success': false, 'message': 'Error de conexión'};
    }
  }

  // === INSCRIPCIONES ===
  static Future<Map<String, dynamic>> obtenerTorneosDisponibles() async {
    final token = await AuthService.getToken();
    if (token == null) return {'success': false, 'message': 'No autenticado'};

    try {
      final response = await http.get(
        Uri.parse('$baseUrl/torneos/disponibles'),
        headers: {'x-auth-token': token},
      );
      return jsonDecode(response.body);
    } catch (e) {
      return {'success': false, 'message': 'Error de conexión'};
    }
  }

  static Future<Map<String, dynamic>> inscribirEquipo(String torneoId, String equipoId) async {
    final token = await AuthService.getToken();
    if (token == null) return {'success': false, 'message': 'No autenticado'};

    try {
      final response = await http.post(
        Uri.parse('$baseUrl/torneos/$torneoId/equipos'),
        headers: {
          'Content-Type': 'application/json',
          'x-auth-token': token,
        },
        body: jsonEncode({'equipoId': equipoId}),
      );
      return jsonDecode(response.body);
    } catch (e) {
      return {'success': false, 'message': 'Error de conexión'};
    }
  }

  // === PARTIDOS ===
  static Future<Map<String, dynamic>> programarPartido(Map<String, dynamic> data) async {
    final token = await AuthService.getToken();
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/partidos/programar'),
        headers: {
          'Content-Type': 'application/json',
          'x-auth-token': token!,
        },
        body: jsonEncode(data),
      );
      return jsonDecode(response.body);
    } catch (e) {
      return {'success': false, 'message': 'Error de conexión'};
    }
  }

  // === EQUIPOS (por torneo) ===
  static Future<Map<String, dynamic>> getEquiposPorTorneo(String torneoId) async {
    final token = await AuthService.getToken();
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/equipos/torneo/$torneoId'),
        headers: {'x-auth-token': token!},
      );
      return jsonDecode(response.body);
    } catch (e) {
      return {'success': false, 'message': 'Error de conexión'};
    }
  }

  // === OTRAS FUNCIONES ===
  static Future<List<Notificacion>> obtenerNotificaciones() async {
    final token = await AuthService.getToken();
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/notificaciones'),
        headers: {'x-auth-token': token!},
      );
      if (response.statusCode == 200) {
        final List<dynamic> jsonList = jsonDecode(response.body);
        return jsonList.map((json) => Notificacion.fromJson(json)).toList();
      }
      return [];
    } catch (e) {
      return [];
    }
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
      }
      return {'success': false, 'message': result['message'] ?? 'Error'};
    } catch (e) {
      return {'success': false, 'message': 'Error de conexión'};
    }
  }
  // services/api_service.dart
// === EQUIPOS ===

// ✅ Método: getEquiposPorEstado
static Future<List<Equipo>> getEquiposPorEstado(String estado) async {
  final token = await AuthService.getToken();
  if (token == null) return [];

  try {
    final response = await http.get(
      Uri.parse('$baseUrl/equipos?estado=$estado'),
      headers: {'x-auth-token': token},
    );

    final data = jsonDecode(response.body);
    if (response.statusCode == 200 && data['success'] == true && data['equipos'] is List) {
      return (data['equipos'] as List).map((e) => Equipo.fromJson(e)).toList();
    } else {
      print('⚠️ ${data['message'] ?? 'No hay equipos con estado: $estado'}');
      return [];
    }
  } catch (e) {
    print('❌ Error al obtener equipos por estado: $e');
    return [];
  }
}

// ✅ Método: actualizarEstadoEquipo
static Future<Map<String, dynamic>> actualizarEstadoEquipo(String id, String estado) async {
  final token = await AuthService.getToken();
  if (token == null) return {'success': false, 'message': 'No autenticado'};

  try {
    final response = await http.put(
      Uri.parse('$baseUrl/equipos/$id'),
      headers: {
        'Content-Type': 'application/json',
        'x-auth-token': token,
      },
      body: jsonEncode({'estado': estado}),
    );

    return jsonDecode(response.body);
  } catch (e) {
    print('❌ Error al actualizar estado del equipo: $e');
    return {'success': false, 'message': 'Error de conexión'};
  }
}
}