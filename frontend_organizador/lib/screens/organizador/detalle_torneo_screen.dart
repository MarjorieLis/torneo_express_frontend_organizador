import 'package:flutter/material.dart';
import 'package:frontend_organizador/models/torneo.dart';
import 'package:frontend_organizador/services/api_service.dart';
import 'package:frontend_organizador/screens/organizador/editar_torneo_screen.dart';

class DetalleTorneoScreen extends StatefulWidget {
  final Torneo torneo;

  DetalleTorneoScreen({required this.torneo});

  @override
  _DetalleTorneoScreenState createState() => _DetalleTorneoScreenState();
}

class _DetalleTorneoScreenState extends State<DetalleTorneoScreen> {
  late Torneo torneo;
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    torneo = widget.torneo;
  }

  Future<void> _suspenderTorneo() async {
    final confirmado = await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Suspender Torneo"),
        content: Text("¿Estás seguro de que deseas suspender este torneo?"),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: Text("No")),
          TextButton(onPressed: () => Navigator.pop(context, true), child: Text("Sí")),
        ],
      ),
    );

    if (confirmado == true) {
      setState(() => _loading = true);
      final response = await ApiService.suspenderTorneo(torneo.id);
      setState(() => _loading = false);

      if (response['success'] == true) {
        setState(() {
          torneo = torneo.copyWith(estado: 'suspendido');
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("✅ Torneo suspendido")),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(response['message'] ?? "Error al suspender")),
        );
      }
    }
  }

  Future<void> _cancelarTorneo() async {
    final confirmado = await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Cancelar Torneo"),
        content: Text("¿Estás seguro de que deseas cancelar este torneo? Esta acción no se puede deshacer."),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: Text("No")),
          TextButton(onPressed: () => Navigator.pop(context, true), child: Text("Sí"), style: TextButton.styleFrom(foregroundColor: Colors.red)),
        ],
      ),
    );

    if (confirmado == true) {
      setState(() => _loading = true);
      final response = await ApiService.cancelarTorneo(torneo.id);
      setState(() => _loading = false);

      if (response['success'] == true) {
        setState(() {
          torneo = torneo.copyWith(estado: 'cancelado');
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("❌ Torneo cancelado")),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(response['message'] ?? "Error al cancelar")),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Detalles del Torneo"),
        actions: [
          if (torneo.estado == 'activo')
            PopupMenuButton<String>(
              onSelected: (opcion) {
                if (opcion == 'editar') {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => EditarTorneoScreen(torneo: torneo),
                    ),
                  ).then((value) {
                    if (value == true) {
                      // Opcional: refrescar detalles
                      setState(() {});
                    }
                  });
                } else if (opcion == 'suspender') {
                  _suspenderTorneo();
                } else if (opcion == 'cancelar') {
                  _cancelarTorneo();
                }
              },
              itemBuilder: (context) => [
                PopupMenuItem(value: 'editar', child: Text("Editar")),
                PopupMenuItem(value: 'suspender', child: Text("Suspender")),
                PopupMenuItem(value: 'cancelar', child: Text("Cancelar")),
              ],
            ),
        ],
      ),
      body: _loading
          ? Center(child: CircularProgressIndicator())
          : Padding(
              padding: EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Nombre del torneo
                  Text(
                    torneo.nombre,
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  Text(
                    torneo.disciplina,
                    style: TextStyle(fontSize: 18, color: Colors.blue[800]),
                  ),
                  SizedBox(height: 20),

                  // Estado del torneo
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: _getStatusColor(torneo.estado),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      torneo.estado.toUpperCase(),
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ),
                  SizedBox(height: 20),

                  // Información básica
                  _buildInfoRow("Disciplina", torneo.disciplina),
                  _buildInfoRow("Equipos", "${torneo.maxEquipos} equipos"),
                  _buildInfoRow("Inicio", _formatDate(torneo.fechaInicio)),
                  _buildInfoRow("Fin", _formatDate(torneo.fechaFin)),
                  _buildInfoRow("Formato", _formatoLabel(torneo.formato)),
                  SizedBox(height: 20),

                  // Reglas del torneo
                  Text(
                    "Reglas del Torneo",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  Text(
                    torneo.reglas ?? "No especificadas",
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(height: 30),

                  // Botones de acción (si está activo)
                  if (torneo.estado == 'activo')
                    Column(
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => EditarTorneoScreen(torneo: torneo),
                              ),
                            ).then((value) {
                              if (value == true) setState(() {});
                            });
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                            padding: EdgeInsets.symmetric(vertical: 16),
                          ),
                          child: Text("Editar Torneo", style: TextStyle(fontSize: 18)),
                        ),
                        SizedBox(height: 12),
                        OutlinedButton(
                          onPressed: _suspenderTorneo,
                          style: OutlinedButton.styleFrom(
                            side: BorderSide(color: Colors.orange),
                            padding: EdgeInsets.symmetric(vertical: 16),
                          ),
                          child: Text("Suspender Torneo", style: TextStyle(color: Colors.orange)),
                        ),
                        SizedBox(height: 12),
                        OutlinedButton(
                          onPressed: _cancelarTorneo,
                          style: OutlinedButton.styleFrom(
                            side: BorderSide(color: Colors.red),
                            padding: EdgeInsets.symmetric(vertical: 16),
                          ),
                          child: Text("Cancelar Torneo", style: TextStyle(color: Colors.red)),
                        ),
                      ],
                    ),
                ],
              ),
            ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Text("$label: ", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          Text(value, style: TextStyle(fontSize: 16)),
        ],
      ),
    );
  }

  Color _getStatusColor(String estado) {
    switch (estado) {
      case 'activo':
        return Colors.green;
      case 'suspendido':
        return Colors.orange;
      case 'cancelado':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  String _formatoLabel(String formato) {
    return {
      'grupos': 'Por Grupos',
      'eliminacion': 'Eliminación Directa',
      'mixto': 'Formato Mixto',
    }[formato] ??
        formato;
  }
}