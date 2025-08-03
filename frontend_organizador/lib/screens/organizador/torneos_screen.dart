import 'package:flutter/material.dart';
import 'package:frontend_organizador/services/api_service.dart';
import 'package:frontend_organizador/models/torneo.dart';

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
      child: ListTile(
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
              // Ir a editar
            } else if (opcion == 'suspender') {
              _suspenderTorneo(torneo.id);
            } else if (opcion == 'cancelar') {
              _cancelarTorneo(torneo.id);
            }
          },
          itemBuilder: (context) => [
            PopupMenuItem(value: 'editar', child: Text("Editar")),
            if (torneo.estado == 'activo') ...[
              PopupMenuItem(value: 'suspender', child: Text("Suspender")),
              PopupMenuItem(value: 'cancelar', child: Text("Cancelar")),
            ],
          ],
        ),
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
        SnackBar(content: Text("Torneo suspendido")),
      );
      _cargarTorneos();
    }
  }

  Future<void> _cancelarTorneo(String id) async {
    final response = await ApiService.cancelarTorneo(id);
    if (response['success'] == true) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Torneo cancelado")),
      );
      _cargarTorneos();
    }
  }
}