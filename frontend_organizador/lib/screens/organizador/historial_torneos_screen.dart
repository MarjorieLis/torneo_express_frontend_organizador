// screens/organizador/historial_torneos_screen.dart
import 'package:flutter/material.dart';
import 'package:frontend_organizador/models/torneo.dart';
import 'package:frontend_organizador/services/api_service.dart';

class HistorialTorneosScreen extends StatefulWidget {
  @override
  _HistorialTorneosScreenState createState() => _HistorialTorneosScreenState();
}

class _HistorialTorneosScreenState extends State<HistorialTorneosScreen> {
  List<Torneo> torneos = [];
  List<Torneo> torneosFiltrados = [];
  String filtroDeporte = 'todos';
  String filtroEstado = 'todos';
  int? filtroAnio;

  final deportes = ['todos', 'Fútbol', 'Baloncesto', 'Voleibol'];
  final estados = ['todos', 'finalizado', 'cancelado'];

  @override
  void initState() {
    super.initState();
    _cargarTorneos();
  }

  Future<void> _cargarTorneos() async {
    final data = await ApiService.getTorneosPasados();
    final torneosList = List<Torneo>.from(data.map((json) => Torneo.fromJson(json)));
    setState(() {
      torneos = torneosList;
      torneosFiltrados = torneosList;
    });
  }

  void _aplicarFiltros() {
    setState(() {
      torneosFiltrados = torneos.where((t) {
        final porDeporte = filtroDeporte == 'todos' || t.disciplina == filtroDeporte;
        final porEstado = filtroEstado == 'todos' || t.estado == filtroEstado;
        final porAnio = filtroAnio == null || t.fechaInicio.year == filtroAnio;
        return porDeporte && porEstado && porAnio;
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Historial de Torneos")),
      body: Column(
        children: [
          // Filtros
          Padding(
            padding: EdgeInsets.all(12),
            child: Wrap(
              spacing: 10,
              children: [
                DropdownButton<String>(
                  value: filtroDeporte,
                  items: deportes.map((d) => DropdownMenuItem(value: d, child: Text(d))).toList(),
                  onChanged: (v) {
                    setState(() => filtroDeporte = v!);
                    _aplicarFiltros();
                  },
                ),
                DropdownButton<String>(
                  value: filtroEstado,
                  items: estados.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
                  onChanged: (v) {
                    setState(() => filtroEstado = v!);
                    _aplicarFiltros();
                  },
                ),
                DropdownButton<int>(
                  value: filtroAnio,
                  hint: Text("Año"),
                  items: [
                    DropdownMenuItem(value: null, child: Text("Todos")),
                    for (int i = 2020; i <= DateTime.now().year; i++)
                      DropdownMenuItem(value: i, child: Text("$i")),
                  ],
                  onChanged: (v) {
                    setState(() => filtroAnio = v);
                    _aplicarFiltros();
                  },
                ),
              ],
            ),
          ),
          Divider(),
          Expanded(
            child: torneosFiltrados.isEmpty
                ? Center(child: Text("No se encontraron torneos"))
                : ListView.builder(
                    itemCount: torneosFiltrados.length,
                    itemBuilder: (context, index) {
                      final t = torneosFiltrados[index];
                      return Card(
                        margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        child: ListTile(
                          title: Text(t.nombre),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("${t.disciplina} • ${t.fechaInicio.year}"),
                              Text("Equipos: ${t.equipos.length} • Estado: ${t.estado}"),
                            ],
                          ),
                          trailing: Icon(Icons.arrow_forward_ios, size: 16),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => DetalleTorneoScreen(torneo: t),
                              ),
                            );
                          },
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

// Pantalla de detalle (opcional)
class DetalleTorneoScreen extends StatelessWidget {
  final Torneo torneo;

  DetalleTorneoScreen({required this.torneo});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Detalle del Torneo")),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(torneo.nombre, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            Text("Disciplina: ${torneo.disciplina}"),
            Text("Fechas: ${torneo.fechaInicio.day}/${torneo.fechaInicio.month} - ${torneo.fechaFin.day}/${torneo.fechaFin.month}"),
            Text("Equipos: ${torneo.equipos.length}"),
            Text("Formato: ${torneo.formato}"),
            Text("Estado: ${torneo.estado}"),
            SizedBox(height: 20),
            Text("Reglas:", style: TextStyle(fontWeight: FontWeight.bold)),
            Text(torneo.reglas),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Exportando información...")),
                );
              },
              child: Text("Exportar Información"),
            ),
          ],
        ),
      ),
    );
  }
}