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
  List<Jugador> jugadoresDisponibles = [];
  List<Jugador> jugadoresSeleccionados = [];

  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _cargarJugadoresDisponibles();
  }

  Future<void> _cargarJugadoresDisponibles() async {
    setState(() => _loading = true);
    try {
      final response = await ApiService.obtenerJugadoresDisponibles(widget.torneo.id);
      if (response['success'] == true && response['jugadores'] is List) {
        setState(() {
          jugadoresDisponibles = (response['jugadores'] as List)
              .map((j) => Jugador.fromJson(j))
              .toList();
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

  void _seleccionarJugador(Jugador jugador) {
    setState(() {
      final yaEnEquipo = jugador.equipoId != null && jugador.equipoId!.isNotEmpty;
      if (yaEnEquipo) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("${jugador.nombreCompleto} ya pertenece a un equipo")),
        );
        return;
      }

      if (jugadoresSeleccionados.contains(jugador)) {
        jugadoresSeleccionados.remove(jugador);
      } else {
        jugadoresSeleccionados.add(jugador);
      }
    });
  }

  void _enviarInscripcion() async {
    final nombreEquipo = _nombreEquipoController.text.trim();
    final capitanNombre = _capitanNombreController.text.trim();
    final capitanTelefono = _capitanTelefonoController.text.trim();

    if (nombreEquipo.isEmpty || capitanNombre.isEmpty || capitanTelefono.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Por favor, completa todos los campos obligatorios.")),
      );
      return;
    }

    if (jugadoresSeleccionados.length < 2) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Selecciona al menos 2 jugadores para formar el equipo.")),
      );
      return;
    }

    try {
      final String? capitanId = await AuthService.getUserId();
      if (capitanId == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("No se pudo identificar al usuario actual.")),
        );
        return;
      }

      final cuerpo = jsonEncode({
        'nombre': nombreEquipo,
        'torneoId': widget.torneo.id,
        'capitánId': capitanId,
        'capitánNombre': capitanNombre,
        'capitánTelefono': capitanTelefono,
        'jugadorIds': jugadoresSeleccionados.map((j) => j.id).toList(),
      });

      final response = await ApiService.crearEquipo(cuerpo);

      if (response['success'] == true) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Equipo inscrito correctamente")),
        );
        Navigator.pop(context, true); // Regresar con éxito
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(response['message'] ?? "Error al inscribir el equipo")),
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

                  TextField(controller: _nombreEquipoController, decoration: InputDecoration(labelText: "Nombre del Equipo *")),
                  SizedBox(height: 16),

                  Text("Datos del Capitán", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  TextField(controller: _capitanNombreController, decoration: InputDecoration(labelText: "Nombre Completo *")),
                  TextField(controller: _capitanTelefonoController, keyboardType: TextInputType.phone, decoration: InputDecoration(labelText: "Teléfono *")),

                  SizedBox(height: 24),

                  Text("Seleccionar Jugadores (${jugadoresSeleccionados.length}/${jugadoresDisponibles.length})", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  Expanded(
                    child: ListView.builder(
                      itemCount: jugadoresDisponibles.length,
                      itemBuilder: (context, index) {
                        final jugador = jugadoresDisponibles[index];
                        final estaSeleccionado = jugadoresSeleccionados.contains(jugador);
                        final yaEnEquipo = jugador.equipoId != null && jugador.equipoId!.isNotEmpty;

                        return Card(
                          margin: EdgeInsets.symmetric(vertical: 4),
                          child: ListTile(
                            leading: CircleAvatar(child: Text(jugador.nombreCompleto[0])),
                            title: Text(jugador.nombreCompleto),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Posición: ${jugador.posicionPrincipal}"),
                                if (jugador.posicionSecundaria?.isNotEmpty == true) Text("Alt. ${jugador.posicionSecundaria!}"),
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
                  ElevatedButton(onPressed: _enviarInscripcion, child: Text("Enviar Inscripción")),
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

  @override
  void dispose() {
    _nombreEquipoController.dispose();
    _capitanNombreController.dispose();
    _capitanTelefonoController.dispose();
    super.dispose();
  }
}