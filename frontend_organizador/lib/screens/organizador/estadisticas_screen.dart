// screens/organizador/estadisticas_screen.dart
import 'package:flutter/material.dart';
import 'package:frontend_organizador/models/torneo.dart';
import 'package:frontend_organizador/services/api_service.dart';

class EstadisticasScreen extends StatefulWidget {
  @override
  _EstadisticasScreenState createState() => _EstadisticasScreenState();
}

class _EstadisticasScreenState extends State<EstadisticasScreen> {
  List<Torneo> torneos = [];
  String? torneoId;
  Map<String, dynamic>? estadisticas;

  @override
  void initState() {
    super.initState();
    _cargarTorneos();
  }

  Future<void> _cargarTorneos() async {
    final data = await ApiService.getTorneos();
    setState(() {
      torneos = data;
      if (torneos.isNotEmpty) {
        torneoId = torneos[0].id;
        _cargarEstadisticas(torneoId!);
      }
    });
  }

  Future<void> _cargarEstadisticas(String id) async {
    final data = await ApiService.getEstadisticas(id);
    setState(() {
      estadisticas = data;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Estadísticas del Torneo")),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            DropdownButton<String>(
              value: torneoId,
              items: torneos.map((t) {
                return DropdownMenuItem(value: t.id, child: Text(t.nombre));
              }).toList(),
              onChanged: (v) {
                setState(() {
                  torneoId = v;
                  estadisticas = null;
                });
                _cargarEstadisticas(v!);
              },
              isExpanded: true,
            ),
            SizedBox(height: 20),
            if (estadisticas == null)
              Center(child: CircularProgressIndicator())
            else
              Expanded(
                child: ListView(
                  children: [
                    _buildEstadistica("🏆 Mayor Goleador", "${estadisticas!['goleador'] ?? 'N/A'} (${estadisticas!['goles']} goles)"),
                    _buildEstadistica("🅰️ Más Asistencias", "${estadisticas!['asistencias'] ?? 'N/A'} (${estadisticas!['asistencias_cant']} asistencias)"),
                    _buildEstadistica("🧤 Mejor Portero", "${estadisticas!['portero'] ?? 'N/A'} (${estadisticas!['goles_recibidos']} recibidos)"),
                    _buildEstadistica("🃏 Más Faltas", "${estadisticas!['faltas_jugador'] ?? 'N/A'} (${estadisticas!['faltas']} faltas)"),
                    _buildEstadistica("🏆 Equipo con más victorias", "${estadisticas!['mejor_equipo'] ?? 'N/A'} (${estadisticas!['victorias_equipo']} victorias)"),
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("Reporte exportado a PDF")),
                        );
                      },
                      child: Text("Exportar Reporte (PDF)"),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildEstadistica(String titulo, String valor) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(titulo, style: TextStyle(fontWeight: FontWeight.bold)),
            Text(valor, style: TextStyle(fontSize: 16)),
          ],
        ),
      ),
    );
  }
}