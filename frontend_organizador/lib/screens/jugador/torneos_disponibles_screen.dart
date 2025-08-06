// screens/jugador/torneos_disponibles_screen.dart
import 'package:flutter/material.dart';
import 'package:frontend_organizador/services/api_service.dart';
import 'package:frontend_organizador/models/torneo.dart';

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
    } catch (e) {
      setState(() {
        _error = 'No se pudo conectar al servidor';
      });
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
                        return ListTile(
                          title: Text(torneo.nombre),
                          subtitle: Text("${torneo.disciplina} • ${torneo.estado}"),
                        );
                      },
                    ),
    );
  }
}