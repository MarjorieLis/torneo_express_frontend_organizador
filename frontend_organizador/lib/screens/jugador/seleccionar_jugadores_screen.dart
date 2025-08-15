// screens/organizador/seleccionar_jugadores_screen.dart
import 'package:flutter/material.dart';
import 'package:frontend_organizador/models/jugador.dart';
import 'package:frontend_organizador/services/api_service.dart';

class SeleccionarJugadoresScreen extends StatefulWidget {
  final String equipoId;

  const SeleccionarJugadoresScreen({Key? key, required this.equipoId}) : super(key: key);

  @override
  _SeleccionarJugadoresScreenState createState() => _SeleccionarJugadoresScreenState();
}

class _SeleccionarJugadoresScreenState extends State<SeleccionarJugadoresScreen> {
  List<Jugador> jugadoresDisponibles = [];
  List<Jugador> jugadoresFiltrados = []; // ✅ Declarado
  List<String> jugadoresSeleccionados = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _cargarJugadoresDisponibles();
  }

  Future<void> _cargarJugadoresDisponibles() async {
    setState(() => _loading = true);
    try {
      final List<Jugador> jugadores = await ApiService.obtenerJugadoresDisponibles();
      setState(() {
        jugadoresDisponibles = jugadores;
        jugadoresFiltrados = jugadores;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error de conexión")),
      );
    } finally {
      setState(() => _loading = false);
    }
  }

  void _seleccionarJugador(Jugador jugador) {
    setState(() {
      if (jugadoresSeleccionados.contains(jugador.id)) {
        jugadoresSeleccionados.remove(jugador.id);
      } else {
        jugadoresSeleccionados.add(jugador.id);
      }
    });
  }

  Future<void> _confirmarSeleccion() async {
    if (jugadoresSeleccionados.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Selecciona al menos un jugador")),
      );
      return;
    }

    final response = await ApiService.asignarJugadoresAlEquipo(widget.equipoId, jugadoresSeleccionados);
    if (response['success'] == true) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Jugadores asignados correctamente")),
      );
      Navigator.pop(context, jugadoresSeleccionados);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(response['message'] ?? "Error al asignar jugadores")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Seleccionar Jugadores")),
      body: _loading
          ? Center(child: CircularProgressIndicator())
          : Column(
              children: [
                TextField(
                  decoration: InputDecoration(hintText: "Buscar por nombre, cédula o correo"),
                  onChanged: (query) {
                    setState(() {
                      jugadoresFiltrados = jugadoresDisponibles
                          .where((j) =>
                              j.nombreCompleto.toLowerCase().contains(query.toLowerCase()) ||
                              j.cedula.contains(query) ||
                              j.email.toLowerCase().contains(query.toLowerCase()))
                          .toList();
                    });
                  },
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: jugadoresFiltrados.length,
                    itemBuilder: (context, index) {
                      final jugador = jugadoresFiltrados[index];
                      return CheckboxListTile(
                        title: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(jugador.nombreCompleto),
                            Text("${jugador.cedula} - ${jugador.posicionPrincipal}"),
                          ],
                        ),
                        value: jugadoresSeleccionados.contains(jugador.id),
                        onChanged: (value) => _seleccionarJugador(jugador),
                      );
                    },
                  ),
                ),
                ElevatedButton(
                  onPressed: _confirmarSeleccion,
                  child: Text("Confirmar"),
                ),
              ],
            ),
    );
  }
}