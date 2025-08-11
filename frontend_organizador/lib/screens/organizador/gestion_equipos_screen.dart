// screens/organizador/gestion_equipos_screen.dart
import 'package:flutter/material.dart';
import 'package:frontend_organizador/models/equipo.dart';
import 'package:frontend_organizador/services/api_service.dart';

class GestionEquiposScreen extends StatefulWidget {
  @override
  _GestionEquiposScreenState createState() => _GestionEquiposScreenState();
}

class _GestionEquiposScreenState extends State<GestionEquiposScreen> {
  List<Equipo> equipos = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _cargarEquiposPendientes();
  }

  Future<void> _cargarEquiposPendientes() async {
    try {
      final data = await ApiService.getEquiposPorEstado('pendiente');
      setState(() {
        equipos = List<Equipo>.from(data.map((json) => Equipo.fromJson(json)));
        isLoading = false;
      });
    } catch (e) {
      setState(() => isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error al cargar equipos")),
      );
    }
  }

  Future<void> _cambiarEstadoEquipo(String id, String nuevoEstado) async {
    final response = await ApiService.actualizarEstadoEquipo(id, nuevoEstado);
    if (response['success'] == true) {
      setState(() {
        equipos.removeWhere((e) => e.id == id);
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Equipo $nuevoEstado")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Aprobar Equipos"),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : equipos.isEmpty
              ? Center(child: Text("No hay equipos pendientes de aprobación"))
              : ListView.builder(
                  itemCount: equipos.length,
                  itemBuilder: (context, index) {
                    final equipo = equipos[index];
                    return Card(
                      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      child: Padding(
                        padding: EdgeInsets.all(12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              equipo.nombre,
                              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            SizedBox(height: 4),
                            Text("Registrado: ${equipo.fechaRegistro.day}/${equipo.fechaRegistro.month}/${equipo.fechaRegistro.year}"),
                            SizedBox(height: 12),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                TextButton.icon(
                                  icon: Icon(Icons.check, color: Colors.green),
                                  label: Text("Aprobar"),
                                  onPressed: () => _cambiarEstadoEquipo(equipo.id, 'aprobado'),
                                ),
                                TextButton.icon(
                                  icon: Icon(Icons.close, color: Colors.red),
                                  label: Text("Rechazar"),
                                  onPressed: () => _cambiarEstadoEquipo(equipo.id, 'rechazado'),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}