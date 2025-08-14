// screens/organizador/aprobacion_equipos_screen.dart
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:frontend_organizador/models/equipo.dart';
import 'package:frontend_organizador/services/api_service.dart';
import 'package:frontend_organizador/services/auth_service.dart';
import 'package:frontend_organizador/widgets/equipo_card.dart';

class AprobacionEquiposScreen extends StatefulWidget {
  const AprobacionEquiposScreen({Key? key}) : super(key: key);

  @override
  _AprobacionEquiposScreenState createState() => _AprobacionEquiposScreenState();
}

class _AprobacionEquiposScreenState extends State<AprobacionEquiposScreen> {
  List<Equipo> equiposPendientes = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _cargarEquiposPendientes();
  }

  Future<void> _cargarEquiposPendientes() async {
    print('🔄 [AprobacionEquiposScreen] Iniciando carga de equipos...');
    setState(() => _loading = true);

    try {
      // ✅ ApiService.obtenerEquiposPendientes() devuelve Map<String, dynamic>
      final response = await ApiService.obtenerEquiposPendientes();

      // ✅ Verifica si la respuesta es exitosa y tiene equipos
      if (response['success'] == true && response['equipos'] is List) {
        final List<Equipo> equipos = (response['equipos'] as List)
            .map((e) => Equipo.fromJson(e))
            .toList();

        setState(() {
          equiposPendientes = equipos;
          _loading = false;
        });
      } else {
        print('⚠️ No hay equipos pendientes: ${response['message']}');
        setState(() {
          equiposPendientes = [];
          _loading = false;
        });
      }
    } catch (e) {
      print('❌ Error al procesar equipos pendientes: $e');
      setState(() {
        equiposPendientes = [];
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final txt = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(title: const Text("Aprobar Equipos")),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16),
              child: equiposPendientes.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.inbox, size: 56, color: cs.outline),
                          const SizedBox(height: 12),
                          Text(
                            "No hay equipos pendientes",
                            style: txt.titleMedium?.copyWith(color: cs.onSurfaceVariant),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            "Cuando existan solicitudes aparecerán aquí.",
                            style: txt.bodyMedium?.copyWith(color: cs.outline),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 16),
                          OutlinedButton.icon(
                            onPressed: _cargarEquiposPendientes,
                            icon: const Icon(Icons.refresh),
                            label: const Text("Actualizar"),
                          ),
                        ],
                      ),
                    )
                  : RefreshIndicator(
                      onRefresh: _cargarEquiposPendientes,
                      child: ListView.builder(
                        physics: const AlwaysScrollableScrollPhysics(),
                        itemCount: equiposPendientes.length,
                        itemBuilder: (context, i) {
                          final e = equiposPendientes[i];
                          return EquipoCard(
                            equipo: e,
                            onAprobar: () async {
                              final success = await ApiService.aprobarEquipo(e.id);
                              if (success) {
                                setState(() {
                                  equiposPendientes.remove(e);
                                });
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text("${e.nombre} aprobado")),
                                );
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text("Error al aprobar ${e.nombre}"),
                                    backgroundColor: Colors.red,
                                  ),
                                );
                              }
                            },
                            onRechazar: () async {
                              final success = await ApiService.rechazarEquipo(e.id);
                              if (success) {
                                setState(() {
                                  equiposPendientes.remove(e);
                                });
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text("${e.nombre} rechazado")),
                                );
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text("Error al rechazar ${e.nombre}"),
                                    backgroundColor: Colors.red,
                                  ),
                                );
                              }
                            },
                          );
                        },
                      ),
                    ),
            ),
    );
  }
}