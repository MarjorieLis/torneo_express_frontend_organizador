// screens/organizador/torneos_screen.dart
import 'package:flutter/material.dart';
import 'package:frontend_organizador/services/api_service.dart';
import 'package:frontend_organizador/models/torneo.dart';
import 'package:frontend_organizador/screens/organizador/editar_torneo_screen.dart';
import 'package:frontend_organizador/screens/organizador/detalle_torneo_screen.dart';

class TorneosScreen extends StatefulWidget {
  @override
  _TorneosScreenState createState() => _TorneosScreenState();
}

class _TorneosScreenState extends State<TorneosScreen> {
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
      final lista = await ApiService.getTorneos();
      print('✅ Torneos cargados: ${lista.length} torneos');
      setState(() {
        torneos = lista;
        _loading = false;
      });
    } catch (e, stack) {
      print('❌ Error al cargar torneos: $e\n$stack');
      setState(() {
        _error = 'Error de conexión: $e';
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Todos los Torneos")),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _error.isNotEmpty
              ? Center(child: Text("Error: $_error"))
              : torneos.isEmpty
                  ? const Center(child: Text("No hay torneos creados"))
                  : Column(
                      children: [
                        _buildQuickStats(),
                        const SizedBox(height: 24),
                        Expanded(
                          child: ListView.builder(
                            itemCount: torneos.length,
                            itemBuilder: (context, index) {
                              final torneo = torneos[index];
                              return _buildTorneoCard(torneo);
                            },
                          ),
                        ),
                      ],
                    ),
    );
  }

  Widget _buildQuickStats() {
    int activos = torneos.where((t) => t.estado == 'activo').length;
    int suspendidos = torneos.where((t) => t.estado == 'suspendido').length;
    int cancelados = torneos.where((t) => t.estado == 'cancelado').length;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.15),
            blurRadius: 6,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _statItem("Activos", activos.toString(), Icons.sports, Colors.blue),
          _statItem("Suspendidos", suspendidos.toString(), Icons.pause_circle, Colors.orange),
          _statItem("Cancelados", cancelados.toString(), Icons.cancel, Colors.red),
        ],
      ),
    );
  }

  Widget _statItem(String label, String value, IconData icon, Color color) {
    return Column(
      children: [
        Icon(icon, color: color, size: 28),
        const SizedBox(height: 4),
        Text(value, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        Text(label, style: TextStyle(fontSize: 12, color: Colors.grey)),
      ],
    );
  }

  Widget _buildTorneoCard(Torneo torneo) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 3,
      child: Stack(
        children: [
          Padding(
            padding: EdgeInsets.all(16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: 24,
                  backgroundColor: _getStatusColor(torneo.estado),
                  child: Text(
                    torneo.estado == 'activo' && torneo.disciplina.isNotEmpty
                        ? torneo.disciplina[0].toUpperCase()
                        : torneo.estado == 'suspendido'
                            ? '⏸'
                            : '❌',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        torneo.nombre,
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 4),
                      Text(
                        '${torneo.disciplina} • ${torneo.maxEquipos} equipos',
                        style: TextStyle(color: Colors.grey[700]),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Del ${_formatDate(torneo.fechaInicio)} al ${_formatDate(torneo.fechaFin)}',
                        style: TextStyle(color: Colors.grey[600], fontSize: 14),
                      ),
                    ],
                  ),
                ),
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
                          _cargarTorneos();
                        }
                      });
                    } else if (opcion == 'suspender') {
                      _suspenderTorneo(torneo.id);
                    } else if (opcion == 'cancelar') {
                      _confirmarCancelacion(torneo.id);
                    }
                  },
                  itemBuilder: (context) => [
                    PopupMenuItem(value: 'editar', child: Text("Editar")),
                    if (torneo.estado == 'activo')
                      PopupMenuItem(value: 'suspender', child: Text("Suspender")),
                    if (torneo.estado == 'activo' || torneo.estado == 'suspendido')
                      PopupMenuItem(value: 'cancelar', child: Text("Cancelar")),
                  ],
                ),
              ],
            ),
          ),
          if (torneo.estado != 'activo')
            Positioned(
              top: 12,
              right: 12,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: torneo.estado == 'suspendido' ? Colors.orange : Colors.red,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Text(
                  torneo.estado.toUpperCase(),
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          Positioned.fill(
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DetalleTorneoScreen(torneo: torneo),
                    ),
                  );
                },
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
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
    return '${date.day}/${date.month}';
  }

  Future<void> _suspenderTorneo(String id) async {
    final response = await ApiService.suspenderTorneo(id);
    if (response['success'] == true) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("✅ Torneo suspendido correctamente")),
      );
      _cargarTorneos();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(response['message'] ?? "Error al suspender")),
      );
    }
  }

  Future<void> _confirmarCancelacion(String id) async {
    final confirmado = await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Cancelar Torneo"),
        content: Text("¿Estás seguro de que deseas cancelar este torneo? Esta acción no se puede deshacer."),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text("Cancelar"),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text("Sí, cancelar", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirmado == true) {
      await _cancelarTorneo(id);
    }
  }

  Future<void> _cancelarTorneo(String id) async {
    final response = await ApiService.cancelarTorneo(id);
    if (response['success'] == true) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("❌ Torneo cancelado definitivamente")),
      );
      _cargarTorneos();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(response['message'] ?? "Error al cancelar")),
      );
    }
  }
}