import 'package:http/http.dart' as http;
import 'dart:convert';

//Importar los modelos
import '../models/torneo.dart';
import '../models/partido.dart';

class ApiService {
  static const String baseUrl = 'http://localhost:3000/api';

  static Future<Map<String, dynamic>> crearTorneo(Map<String, dynamic> data) async {
    final response = await http.post(
      Uri.parse('$baseUrl/torneos'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(data),
    );
    return jsonDecode(response.body);
  }

  static Future<List<Torneo>> getTorneos() async {
    final response = await http.get(Uri.parse('$baseUrl/torneos'));
    if (response.statusCode == 200) {
      final List jsonList = jsonDecode(response.body);
      return jsonList.map((json) => Torneo.fromJson(json)).toList();
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

static Future<Map<String, dynamic>> programarPartidos(Map<String, dynamic> data) async {
  final response = await http.post(
    Uri.parse('$baseUrl/partidos/programar'),
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode(data),
  );
  return jsonDecode(response.body);
}

static Future<Map<String, dynamic>> enviarNotificacion(Map<String, dynamic> data) async {
  final response = await http.post(
    Uri.parse('$baseUrl/notificaciones'),
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode(data),
  );
  return jsonDecode(response.body);
}

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
}