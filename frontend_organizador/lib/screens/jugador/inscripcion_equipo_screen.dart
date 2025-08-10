// screens/jugador/inscripcion_equipo_screen.dart

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:frontend_organizador/models/torneo.dart';
import 'package:frontend_organizador/models/jugador.dart';
import 'package:frontend_organizador/services/api_service.dart';
import 'package:frontend_organizador/services/auth_service.dart';

class InscripcionEquipoScreen extends StatefulWidget {
  final Torneo torneo;

  const InscripcionEquipoScreen({Key? key, required this.torneo}) : super(key: key);

  @override
  _InscripcionEquipoScreenState createState() => _InscripcionEquipoScreenState();
}

class _InscripcionEquipoScreenState extends State<InscripcionEquipoScreen> {
  final _nombreEquipoController = TextEditingController();
  final _capitanNombreController = TextEditingController();
  final _capitanTelefonoController = TextEditingController();
  final _searchController = TextEditingController();

  List<Jugador> jugadoresDisponibles = [];
  List<Jugador> jugadoresFiltrados = [];
  List<Jugador> jugadoresSeleccionados = [];

  bool _loading = true;
  bool _searching = false;

  @override
  void initState() {
    super.initState();
    _cargarJugadoresDisponibles();
    // 🔥 Escuchar cambios en el campo de búsqueda
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _nombreEquipoController.dispose();
    _capitanNombreController.dispose();
    _capitanTelefonoController.dispose();
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  /// Carga todos los jugadores disponibles para este torneo
  Future<void> _cargarJugadoresDisponibles() async {
    setState(() => _loading = true);
    try {
      final response = await ApiService.obtenerJugadoresDisponibles(widget.torneo.id);
      if (response['success'] == true && response['jugadores'] is List) {
        final List<Jugador> jugadores = (response['jugadores'] as List)
            .map((j) => Jugador.fromJson(j))
            .toList();

        setState(() {
          jugadoresDisponibles = jugadores;
          jugadoresFiltrados = jugadores;
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(response['message'] ?? "No se pudieron cargar jugadores")),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error de conexión con el servidor")),
      );
    } finally {
      setState(() => _loading = false);
    }
  }

  /// Se ejecuta cuando el texto de búsqueda cambia
  void _onSearchChanged() async {
    final query = _searchController.text.trim();

    // Si está vacío, mostrar todos los disponibles
    if (query.isEmpty) {
      setState(() {
        jugadoresFiltrados = jugadoresDisponibles;
      });
      return;
    }

    // Evitar múltiples llamadas simultáneas
    if (_searching) return;

    setState(() {
      _searching = true;
      jugadoresFiltrados = []; // Limpiar mientras busca
    });

    try {
      final response = await ApiService.buscarJugador(query);

      if (response['success'] == true && response['jugadores'] is List) {
        final List<Jugador> resultados = (response['jugadores'] as List)
            .map((j) => Jugador.fromJson(j))
            .toList();

        // ✅ Filtrar solo jugadores disponibles (sin equipo o no inscritos en este torneo)
        final disponibles = resultados.where((jugador) {
          return jugadoresDisponibles.any((d) => d.id == jugador.id);
        }).toList();

        setState(() {
          jugadoresFiltrados = disponibles;
        });
      } else {
        setState(() {
          jugadoresFiltrados = [];
        });
        if (response['message'] != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(response['message'])),
          );
        }
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error al buscar jugador")),
      );
      setState(() {
        jugadoresFiltrados = [];
      });
    } finally {
      setState(() {
        _searching = false;
      });
    }
  }

  /// Seleccionar o deseleccionar un jugador
  void _seleccionarJugador(Jugador jugador) {
    final yaEnEquipo = jugador.equipoId != null && jugador.equipoId!.isNotEmpty;
    if (yaEnEquipo) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("${jugador.nombreCompleto} ya pertenece a un equipo")),
      );
      return;
    }

    setState(() {
      if (jugadoresSeleccionados.contains(jugador)) {
        jugadoresSeleccionados.remove(jugador);
      } else {
        jugadoresSeleccionados.add(jugador);
      }
    });
  }

  /// Enviar la inscripción del equipo
  Future<void> _enviarInscripcion() async {
    final nombreEquipo = _nombreEquipoController.text.trim();
    final capitanNombre = _capitanNombreController.text.trim();
    final capitanTelefono = _capitanTelefonoController.text.trim();

    if (nombreEquipo.isEmpty || capitanNombre.isEmpty || capitanTelefono.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Completa todos los campos obligatorios.")),
      );
      return;
    }

    if (jugadoresSeleccionados.length < 2) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Selecciona al menos 2 jugadores.")),
      );
      return;
    }

    try {
      final String? capitanId = await AuthService.getUserId();
      if (capitanId == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("No se pudo identificar al capitán.")),
        );
        return;
      }

      final cuerpo = jsonEncode({
        'nombre': nombreEquipo,
        'torneoId': widget.torneo.id,
        'capitanId': capitanId,
        'capitanNombre': capitanNombre,
        'capitanTelefono': capitanTelefono,
        'jugadorIds': jugadoresSeleccionados.map((j) => j.id).toList(),
      });

      final response = await ApiService.crearEquipo(cuerpo);

      if (response['success'] == true) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("✅ Equipo inscrito correctamente")),
        );
        Navigator.pop(context, true);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(response['message'] ?? "Error al inscribir")),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error de conexión con el servidor")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Inscripción al Equipo")),
      body: _loading
          ? Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Detalles del Torneo", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  SizedBox(height: 16),
                  _buildDetailRow("Torneo:", widget.torneo.nombre),
                  _buildDetailRow("Disciplina:", widget.torneo.disciplina),
                  _buildDetailRow("Estado:", widget.torneo.estado),
                  _buildDetailRow("Fechas:", "${widget.torneo.fechaInicio} - ${widget.torneo.fechaFin}"),
                  _buildDetailRow("Máx. Equipos:", "${widget.torneo.maxEquipos}"),
                  SizedBox(height: 24),

                  TextField(
                    controller: _nombreEquipoController,
                    decoration: InputDecoration(labelText: "Nombre del Equipo *"),
                  ),
                  SizedBox(height: 16),

                  Text("Datos del Capitán", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  TextField(
                    controller: _capitanNombreController,
                    decoration: InputDecoration(labelText: "Nombre Completo *"),
                  ),
                  TextField(
                    controller: _capitanTelefonoController,
                    keyboardType: TextInputType.phone,
                    decoration: InputDecoration(labelText: "Teléfono *"),
                  ),
                  SizedBox(height: 24),

                  Text("Buscar Jugador", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: "Buscar por cédula o correo",
                      prefixIcon: Icon(Icons.search),
                      suffixIcon: _searching
                          ? SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2))
                          : null,
                    ),
                  ),
                  SizedBox(height: 16),

                  Text("Seleccionar Jugadores (${jugadoresSeleccionados.length})", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  Expanded(
                    child: jugadoresFiltrados.isEmpty && !_searching
                        ? Center(
                            child: Text(
                              _searchController.text.isEmpty
                                  ? "No hay jugadores disponibles"
                                  : "No se encontraron jugadores",
                              style: TextStyle(color: Colors.grey),
                            ),
                          )
                        : ListView.builder(
                            itemCount: jugadoresFiltrados.length,
                            itemBuilder: (context, index) {
                              final jugador = jugadoresFiltrados[index];
                              final estaSeleccionado = jugadoresSeleccionados.contains(jugador);
                              final yaEnEquipo = jugador.equipoId != null && jugador.equipoId!.isNotEmpty;

                              return Card(
                                margin: EdgeInsets.symmetric(vertical: 4),
                                child: ListTile(
                                  leading: CircleAvatar(child: Text(jugador.nombreCompleto[0].toUpperCase())),
                                  title: Text(jugador.nombreCompleto),
                                  subtitle: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text("Posición: ${jugador.posicionPrincipal}"),
                                      if (jugador.posicionSecundaria?.isNotEmpty == true)
                                        Text("Alt. ${jugador.posicionSecundaria!}"),
                                      if (yaEnEquipo) Text("Ya inscrito", style: TextStyle(color: Colors.red)),
                                    ],
                                  ),
                                  trailing: yaEnEquipo
                                      ? Icon(Icons.block, color: Colors.red)
                                      : Checkbox(
                                          value: estaSeleccionado,
                                          onChanged: yaEnEquipo ? null : (v) => _seleccionarJugador(jugador),
                                        ),
                                ),
                              );
                            },
                          ),
                  ),
                  SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _enviarInscripcion,
                    child: Text("Enviar Inscripción"),
                  ),
                ],
              ),
            ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Row(
      children: [
        SizedBox(width: 120, child: Text(label, style: TextStyle(fontWeight: FontWeight.bold))),
        Expanded(child: Text(value)),
      ],
    );
  }
}