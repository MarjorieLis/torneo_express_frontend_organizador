// screens/jugador/inscripcion_equipo_screen.dart
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:frontend_organizador/models/torneo.dart';
import 'package:frontend_organizador/models/jugador.dart';
import 'package:frontend_organizador/screens/jugador/seleccionar_jugadores_screen.dart';
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

  Future<void> _cargarJugadoresDisponibles() async {
    setState(() => _loading = true);
    try {
      final response = await ApiService.obtenerJugadoresDisponibles();
      setState(() {
        jugadoresDisponibles = response;
        jugadoresFiltrados = response;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error de conexión")),
      );
    } finally {
      setState(() => _loading = false);
    }
  }

  void _onSearchChanged() async {
    final query = _searchController.text.trim();
    if (query.isEmpty) {
      setState(() => jugadoresFiltrados = jugadoresDisponibles);
      return;
    }

    setState(() => _searching = true);

    try {
      final response = await ApiService.buscarJugador(query);
      if (response['success'] == true) {
        final jugador = Jugador.fromJson(response['jugador']);
        final estaDisponible = jugadoresDisponibles.any((j) => j.id == jugador.id);
        final yaSeleccionado = jugadoresSeleccionados.any((j) => j.id == jugador.id);

        if (estaDisponible && !yaSeleccionado) {
          setState(() => jugadoresFiltrados = [jugador]);
        } else if (yaSeleccionado) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("${jugador.nombreCompleto} ya seleccionado")),
          );
        }
      }
    } catch (e) {
      setState(() => jugadoresFiltrados = []);
    } finally {
      setState(() => _searching = false);
    }
  }

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

  Future<void> _enviarInscripcion() async {
    final nombre = _nombreEquipoController.text.trim();
    final capitanNombre = _capitanNombreController.text.trim();
    final telefono = _capitanTelefonoController.text.trim();

    if (nombre.isEmpty || capitanNombre.isEmpty || telefono.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Completa todos los campos")),
      );
      return;
    }

    if (jugadoresSeleccionados.length < 2) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Selecciona al menos 2 jugadores")),
      );
      return;
    }

    final capitanId = await AuthService.getUserId();
    if (capitanId == null) return;

    // ✅ Enviar todos los datos, incluyendo jugadores, en la creación del equipo
    final cuerpo = jsonEncode({
      'nombre': nombre,
      'torneoId': widget.torneo.id,
      'capitanId': capitanId,
      'capitanNombre': capitanNombre,
      'capitanTelefono': telefono,
      'jugadorIds': jugadoresSeleccionados.map((j) => j.id).toList(),
      'estado': 'pendiente'
    });

    final response = await ApiService.crearEquipo(cuerpo);
    if (response['success'] == true) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("✅ Equipo inscrito correctamente")),
      );
      Navigator.pop(context, true);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(response['message'] ?? "Error al inscribir equipo")),
      );
    }
  }

  Widget _buildDetailRow(String label, String value) {
    return Row(
      children: [
        SizedBox(width: 120, child: Text(label, style: TextStyle(fontWeight: FontWeight.bold))),
        Expanded(child: Text(value)),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final txt = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(title: const Text("Inscripción al Equipo")),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Detalles del Torneo", style: txt.titleLarge?.copyWith(fontWeight: FontWeight.w700)),
                    const SizedBox(height: 12),
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          children: [
                            _buildDetailRow("Torneo:", widget.torneo.nombre),
                            _buildDetailRow("Disciplina:", widget.torneo.disciplina),
                            _buildDetailRow("Estado:", widget.torneo.estado),
                            _buildDetailRow("Fechas:", "${widget.torneo.fechaInicio} - ${widget.torneo.fechaFin}"),
                            _buildDetailRow("Máx. Equipos:", "${widget.torneo.maxEquipos}"),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text("Datos del Equipo", style: txt.titleMedium?.copyWith(fontWeight: FontWeight.w700)),
                    TextField(controller: _nombreEquipoController, decoration: const InputDecoration(labelText: "Nombre del Equipo *")),
                    const SizedBox(height: 20),
                    Text("Datos del Capitán", style: txt.titleMedium?.copyWith(fontWeight: FontWeight.w700)),
                    TextField(controller: _capitanNombreController, decoration: const InputDecoration(labelText: "Nombre *")),
                    TextField(controller: _capitanTelefonoController, decoration: const InputDecoration(labelText: "Teléfono *")),
                    const SizedBox(height: 24),
                    Row(
                      children: [
                        Text("Jugadores (${jugadoresSeleccionados.length})", style: txt.titleMedium?.copyWith(fontWeight: FontWeight.w700)),
                        const Spacer(),
                        OutlinedButton.icon(
                          onPressed: () async {
                            final seleccion = await Navigator.push<List<Jugador>>(
                              context,
                              MaterialPageRoute(
                                builder: (_) => SeleccionarJugadoresScreen(
                                  jugadoresDisponibles: jugadoresDisponibles,
                                  jugadoresSeleccionados: jugadoresSeleccionados,
                                ),
                              ),
                            );
                            if (seleccion != null) {
                              setState(() => jugadoresSeleccionados = seleccion);
                            }
                          },
                          icon: const Icon(Icons.group_add_outlined),
                          label: const Text("Seleccionar"),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    if (jugadoresSeleccionados.isEmpty)
                      Text("No has seleccionado jugadores.")
                    else
                      Wrap(
                        spacing: 8,
                        children: jugadoresSeleccionados
                            .map((j) => InputChip(
                                  label: Text(j.nombreCompleto),
                                  onDeleted: () => setState(() => jugadoresSeleccionados.remove(j)),
                                ))
                            .toList(),
                      ),
                    const SizedBox(height: 28),
                    FilledButton.icon(
                      onPressed: _enviarInscripcion,
                      icon: const Icon(Icons.send_rounded),
                      label: const Text("Enviar Inscripción"),
                      style: FilledButton.styleFrom(minimumSize: const Size.fromHeight(48)),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}