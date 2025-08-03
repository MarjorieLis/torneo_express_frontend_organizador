import 'package:flutter/material.dart';
import 'package:frontend_organizador/services/api_service.dart';
import 'package:frontend_organizador/models/torneo.dart';
import 'package:frontend_organizador/screens/organizador/editar_torneo_screen.dart';

class TorneosScreen extends StatefulWidget {
  @override
  _TorneosScreenState createState() => _TorneosScreenState();
}

class _TorneosScreenState extends State<TorneosScreen> {
  List<Torneo> torneos = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _cargarTorneos();
  }

  Future<void> _cargarTorneos() async {
    setState(() => _loading = true);
    final lista = await ApiService.getTorneos();
    setState(() {
      torneos = lista;
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Todos los Torneos")),
      body: _loading
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: torneos.length,
              itemBuilder: (context, index) {
                final torneo = torneos[index];
                return _buildTorneoCard(torneo);
              },
            ),
    );
  }

  Widget _buildTorneoCard(Torneo torneo) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Stack(
        children: [
          // Contenido principal del ListTile
          ListTile(
            leading: CircleAvatar(
              child: Text(torneo.disciplina[0]),
              backgroundColor: _getStatusColor(torneo.estado),
            ),
            title: Text(torneo.nombre),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('${torneo.disciplina} • ${torneo.maxEquipos} equipos'),
                Text('Del ${_formatDate(torneo.fechaInicio)} al ${_formatDate(torneo.fechaFin)}'),
              ],
            ),
            trailing: PopupMenuButton<String>(
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
          ),
          // ✅ Badge de estado (visible solo si no es "activo")
          if (torneo.estado != 'activo')
            Positioned(
              top: 8,
              right: 8,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: torneo.estado == 'suspendido' ? Colors.orange : Colors.red,
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 4,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: Text(
                  torneo.estado.toUpperCase(),
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
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

  // ✅ Confirmación antes de cancelar
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