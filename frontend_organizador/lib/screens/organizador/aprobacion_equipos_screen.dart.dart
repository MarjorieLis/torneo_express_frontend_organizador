// screens/organizador/aprobacion_equipos_screen.dart

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:frontend_organizador/models/equipo.dart';
import 'package:frontend_organizador/services/api_service.dart';
import 'package:frontend_organizador/services/auth_service.dart';

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

  final token = await AuthService.getToken();
  print('🔐 Token: $token'); // ✅ Verifica que el organizador tenga token

  final response = await ApiService.obtenerEquiposPendientes();
  print('📥 Respuesta del backend: $response'); // ✅ Aquí ves si hay datos

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
    setState(() => _loading = false);
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Aprobar Equipos")),
      body: _loading
          ? Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (equiposPendientes.isEmpty)
                    Center(
                      child: Text(
                        "No hay equipos pendientes de aprobación",
                        style: TextStyle(color: Colors.grey),
                      ),
                    )
                  else
                    Expanded(
                      child: ListView.builder(
                        itemCount: equiposPendientes.length,
                        itemBuilder: (context, index) {
                          final equipo = equiposPendientes[index];

                          return Card(
                            margin: EdgeInsets.symmetric(vertical: 4),
                            child: ListTile(
                              leading: CircleAvatar(child: Icon(Icons.group)),
                              title: Text(equipo.nombre),
                              subtitle: Text("Capitán: ${equipo.capitanNombre}"),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  ElevatedButton(
                                    onPressed: () async {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(content: Text("${equipo.nombre} aprobado")),
                                      );
                                    },
                                    child: Text("Aprobar"),
                                  ),
                                  SizedBox(width: 8),
                                  ElevatedButton(
                                    onPressed: () async {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(content: Text("${equipo.nombre} rechazado")),
                                      );
                                    },
                                    child: Text("Rechazar"),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                ],
              ),
            ),
    );
  }
}