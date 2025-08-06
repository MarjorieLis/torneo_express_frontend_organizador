// screens/jugador/torneos_disponibles_screen.dart
import 'package:flutter/material.dart';
import 'package:frontend_organizador/services/api_service.dart';
import 'package:frontend_organizador/models/torneo.dart';
import 'package:frontend_organizador/screens/jugador/detalle_torneo_screen.dart';

class TorneosDisponiblesScreen extends StatefulWidget {
  @override
  _TorneosDisponiblesScreenState createState() => _TorneosDisponiblesScreenState();
}

class _TorneosDisponiblesScreenState extends State<TorneosDisponiblesScreen> {
  List<Torneo> torneos = [];
  bool _loading = true;
  String _error = '';

  @override
  void initState() {
    super.initState();
    _cargarTorneos();
  }

  Future<void> _cargarTorneos() async {
    setState(() {
      _loading = true;
      _error = '';
    });

    try {
      final response = await ApiService.obtenerTorneosDisponibles();
      print('🔍 Respuesta del backend: $response');

      if (response['success'] == true) {
        final List<dynamic> data = response['torneos'];
        setState(() {
          torneos = data.map((t) => Torneo.fromJson(t)).toList();
        });
      } else {
        setState(() {
          _error = response['message'] ?? 'Error desconocido';
        });
      }
    } catch (e, stack) {
      setState(() {
        _error = 'Error al procesar los datos';
      });
      print('❌ Excepción: $e');
      print('Stack: $stack');
    } finally {
      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Torneos Disponibles")),
      body: _loading
          ? Center(child: CircularProgressIndicator())
          : _error.isNotEmpty
              ? Center(child: Text("Error: $_error"))
              : torneos.isEmpty
                  ? Center(child: Text("No hay torneos disponibles"))
                  : ListView.builder(
                      itemCount: torneos.length,
                      itemBuilder: (context, index) {
                        final torneo = torneos[index];
                        return Card(
                          margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          child: ListTile(
                            title: Text(torneo.nombre),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("${torneo.disciplina} • ${torneo.estado}"),
                                Text(
                                  "Del ${_formatDate(torneo.fechaInicio)} al ${_formatDate(torneo.fechaFin)}",
                                  style: TextStyle(fontSize: 14),
                                ),
                              ],
                            ),
                            trailing: IconButton(
                              icon: Icon(Icons.arrow_forward_ios),
                              onPressed: () {
                                // Navegar a la pantalla de detalle del torneo
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => DetalleTorneoScreen(torneo: torneo),
                                  ),
                                );
                              },
                            ),
                          ),
                        );
                      },
                    ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}