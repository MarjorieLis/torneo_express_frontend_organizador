// services/api_service.dart
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:frontend_organizador/services/auth_service.dart';

// Importar modelos
import '../models/torneo.dart';
import '../models/partido.dart';
import '../models/notificacion.dart';
import '../models/equipo.dart';
import '../models/jugador.dart';

class ApiService {
  // ✅ Cambia la IP según tu entorno
  // - Emulador Android: 10.0.2.2
  // - Dispositivo físico: tu IP local (192.168.x.x)
  // - Backend en la nube: URL pública
  static const String baseUrl = 'http://172.16.82.29:3000/api'; // ✅ Cambiado para emulador

  // === TORNEOS ===
  static Future<Map<String, dynamic>> crearTorneo(Map<String, dynamic> data) async {
    final token = await AuthService.getToken();
    if (token == null) return {'success': false, 'message': 'No autenticado'};

    try {
      final response = await http.post(
        Uri.parse('$baseUrl/torneos'),
        headers: {
          'Content-Type': 'application/json',
          'x-auth-token': token,
        },
        body: jsonEncode(data),
      );

      print('📡 [POST /torneos] Estado: ${response.statusCode}');
      print('📦 Respuesta: ${response.body}');

      return jsonDecode(response.body);
    } catch (e) {
      print('❌ Error al crear torneo: $e');
      return {'success': false, 'message': 'Error de conexión'};
    }
  }

  static Future<List<Torneo>> getTorneos() async {
    final token = await AuthService.getToken();
    if (token == null) {
      print('❌ Token no disponible');
      return [];
    }

    try {
      final response = await http.get(
        Uri.parse('$baseUrl/torneos'),
        headers: {'x-auth-token': token},
      );

      print('📡 [GET /torneos] Estado: ${response.statusCode}');
      print('📦 Respuesta: ${response.body}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['success'] == true && data['torneos'] is List) {
          return (data['torneos'] as List).map((t) => Torneo.fromJson(t)).toList();
        } else {
          print('⚠️ No hay torneos: ${data['message']}');
          return [];
        }
      } else {
        print('❌ HTTP Error: ${response.statusCode}');
        return [];
      }
    } catch (e) {
      print('❌ Excepción en getTorneos: $e');
      return [];
    }
  }

  static Future<List<Torneo>> obtenerTorneos() async => await getTorneos();

  static Future<Map<String, dynamic>> editarTorneo(String id, Map<String, dynamic> data) async {
    final token = await AuthService.getToken();
    if (token == null) return {'success': false, 'message': 'No autenticado'};

    try {
      final response = await http.put(
        Uri.parse('$baseUrl/torneos/$id'),
        headers: {
          'Content-Type': 'application/json',
          'x-auth-token': token,
        },
        body: jsonEncode(data),
      );

      print('📡 [PUT /torneos/$id] Estado: ${response.statusCode}');
      return jsonDecode(response.body);
    } catch (e) {
      print('❌ Error al editar torneo: $e');
      return {'success': false, 'message': 'Error de conexión'};
    }
  }

  static Future<Map<String, dynamic>> suspenderTorneo(String id) async {
    final token = await AuthService.getToken();
    if (token == null) return {'success': false, 'message': 'No autenticado'};

    try {
      final response = await http.put(
        Uri.parse('$baseUrl/torneos/$id/suspender'),
        headers: {
          'Content-Type': 'application/json',
          'x-auth-token': token,
        },
      );

      print('📡 [PUT /torneos/$id/suspender] Estado: ${response.statusCode}');
      return jsonDecode(response.body);
    } catch (e) {
      print('❌ Error al suspender torneo: $e');
      return {'success': false, 'message': 'Error de conexión'};
    }
  }

  static Future<Map<String, dynamic>> cancelarTorneo(String id) async {
    final token = await AuthService.getToken();
    if (token == null) return {'success': false, 'message': 'No autenticado'};

    try {
      final response = await http.put(
        Uri.parse('$baseUrl/torneos/$id/cancelar'),
        headers: {
          'Content-Type': 'application/json',
          'x-auth-token': token,
        },
      );

      print('📡 [PUT /torneos/$id/cancelar] Estado: ${response.statusCode}');
      return jsonDecode(response.body);
    } catch (e) {
      print('❌ Error al cancelar torneo: $e');
      return {'success': false, 'message': 'Error de conexión'};
    }
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

      print('📡 [GET /equipos/pendientes] Estado: ${response.statusCode}');
      return jsonDecode(response.body);
    } catch (e) {
      print('❌ Error al obtener equipos pendientes: $e');
      return {'success': false, 'message': 'Error de conexión'};
    }
  }

  static Future<bool> aprobarEquipo(String equipoId) async {
    final token = await AuthService.getToken();
    if (token == null) return false;

    try {
      final response = await http.put(
        Uri.parse('$baseUrl/equipos/aprobado/$equipoId'),
        headers: {'x-auth-token': token},
      );

      final json = jsonDecode(response.body);
      print('📡 [PUT /equipos/aprobado/$equipoId] Éxito: ${json['success']}');
      return json['success'] == true;
    } catch (e) {
      print('❌ Error al aprobar equipo: $e');
      return false;
    }
  }

  static Future<bool> rechazarEquipo(String equipoId) async {
    final token = await AuthService.getToken();
    if (token == null) return false;

    try {
      final response = await http.put(
        Uri.parse('$baseUrl/equipos/rechazado/$equipoId'),
        headers: {'x-auth-token': token},
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
    if (token == null) return {'success': false, 'message': 'No autenticado'};

    try {
      final response = await http.post(
        Uri.parse('$baseUrl/equipos'),
        headers: {
          'Content-Type': 'application/json',
          'x-auth-token': token,
        },
        body: cuerpo,
      );

      print('📡 [POST /equipos] Estado: ${response.statusCode}');
      return jsonDecode(response.body);
    } catch (e) {
      print('❌ Error al crear equipo: $e');
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

      print('📡 [GET /equipos/aprobados] Estado: ${response.statusCode}');
      final data = jsonDecode(response.body);
      if (data['success'] == true && data['equipos'] is List) {
        return (data['equipos'] as List).map((e) => Equipo.fromJson(e)).toList();
      }
      return [];
    } catch (e) {
      print('❌ Error al obtener equipos aprobados: $e');
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

      print('📡 [GET /jugadores/disponibles] Estado: ${response.statusCode}');
      final data = jsonDecode(response.body);
      if (response.statusCode == 200 && data['success'] == true && data['jugadores'] is List) {
        return (data['jugadores'] as List).map((j) => Jugador.fromJson(j)).toList();
      }
      return [];
    } catch (e) {
      print('❌ Error al obtener jugadores disponibles: $e');
      return [];
    }
  }

  static Future<Map<String, dynamic>> asignarJugadoresAlEquipo(String equipoId, List<String> jugadorIds) async {
  final token = await AuthService.getToken();
  if (token == null) return {'success': false, 'message': 'No autenticado'};

  try {
    final response = await http.put(
      Uri.parse('$baseUrl/equipos/$equipoId/jugadores'), // ✅ Correcto
      // ❌ NO uses: /equipos/temp/jugadores
      headers: {
        'Content-Type': 'application/json',
        'x-auth-token': token,
      },
      body: jsonEncode({'jugadorIds': jugadorIds}),
    );

    print('📡 Respuesta del backend: ${response.body}');

    return jsonDecode(response.body);
  } catch (e) {
    print('❌ Error al asignar jugadores: $e');
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

      print('📡 [GET /jugadores/buscar] Query: $query, Estado: ${response.statusCode}');
      return jsonDecode(response.body);
    } catch (e) {
      print('❌ Error al buscar jugador: $e');
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

      print('📡 [GET /torneos/disponibles] Estado: ${response.statusCode}');
      return jsonDecode(response.body);
    } catch (e) {
      print('❌ Error al obtener torneos disponibles: $e');
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

      print('📡 [POST /torneos/$torneoId/equipos] Estado: ${response.statusCode}');
      return jsonDecode(response.body);
    } catch (e) {
      print('❌ Error al inscribir equipo: $e');
      return {'success': false, 'message': 'Error de conexión'};
    }
  }

  // === PARTIDOS ===
  static Future<Map<String, dynamic>> programarPartido(Map<String, dynamic> data) async {
    final token = await AuthService.getToken();
    if (token == null) return {'success': false, 'message': 'No autenticado'};

    try {
      final response = await http.post(
        Uri.parse('$baseUrl/partidos/programar'),
        headers: {
          'Content-Type': 'application/json',
          'x-auth-token': token,
        },
        body: jsonEncode(data),
      );

      print('📡 [POST /partidos/programar] Estado: ${response.statusCode}');
      return jsonDecode(response.body);
    } catch (e) {
      print('❌ Error al programar partido: $e');
      return {'success': false, 'message': 'Error de conexión'};
    }
  }

  // === EQUIPOS (por torneo) ===
  static Future<Map<String, dynamic>> getEquiposPorTorneo(String torneoId) async {
    final token = await AuthService.getToken();
    if (token == null) return {'success': false, 'message': 'No autenticado'};

    try {
      final response = await http.get(
        Uri.parse('$baseUrl/equipos/torneo/$torneoId'),
        headers: {'x-auth-token': token},
      );

      print('📡 [GET /equipos/torneo/$torneoId] Estado: ${response.statusCode}');
      return jsonDecode(response.body);
    } catch (e) {
      print('❌ Error al obtener equipos por torneo: $e');
      return {'success': false, 'message': 'Error de conexión'};
    }
  }

  // === NOTIFICACIONES ===
  static Future<List<Notificacion>> obtenerNotificaciones() async {
    final token = await AuthService.getToken();
    if (token == null) return [];

    try {
      final response = await http.get(
        Uri.parse('$baseUrl/notificaciones'),
        headers: {'x-auth-token': token},
      );

      if (response.statusCode == 200) {
        final List<dynamic> jsonList = jsonDecode(response.body);
        return jsonList.map((json) => Notificacion.fromJson(json)).toList();
      }
      return [];
    } catch (e) {
      print('❌ Error al obtener notificaciones: $e');
      return [];
    }
  }

  // === OTRAS FUNCIONES ===
  static Future<Map<String, dynamic>> register(Map<String, dynamic> data) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/auth/register'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(data),
      );

      final result = jsonDecode(response.body);
      print('📡 [POST /auth/register] Estado: ${response.statusCode}');

      if (response.statusCode == 201 || response.statusCode == 200) {
        return {'success': true, 'token': result['token'], 'usuario': result['usuario']};
      }
      return {'success': false, 'message': result['message'] ?? 'Error en el registro'};
    } catch (e) {
      print('❌ Error en register: $e');
      return {'success': false, 'message': 'Error de conexión con el servidor'};
    }
  }
  // === MÉTODOS PARA GESTIÓN DE EQUIPOS ===

// ✅ Obtener equipos por estado
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
      print('⚠️ No hay equipos con estado "$estado": ${data['message'] ?? 'Desconocido'}');
      return [];
    }
  } catch (e) {
    print('❌ Error al obtener equipos por estado: $e');
    return [];
  }
}

// ✅ Actualizar estado de un equipo
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

    final result = jsonDecode(response.body);
    return result;
  } catch (e) {
    print('❌ Error al actualizar estado del equipo: $e');
    return {'success': false, 'message': 'Error de conexión'};
  }
}
}