// screens/jugador/seleccionar_jugadores_screen.dart
import 'package:flutter/material.dart';
import 'package:frontend_organizador/models/jugador.dart';

class SeleccionarJugadoresScreen extends StatefulWidget {
  final List<Jugador> jugadoresDisponibles;
  final List<Jugador> jugadoresSeleccionados;

  const SeleccionarJugadoresScreen({
    Key? key,
    required this.jugadoresDisponibles,
    required this.jugadoresSeleccionados,
  }) : super(key: key);

  @override
  _SeleccionarJugadoresScreenState createState() => _SeleccionarJugadoresScreenState();
}

class _SeleccionarJugadoresScreenState extends State<SeleccionarJugadoresScreen> {
  List<Jugador> jugadoresSeleccionados = [];
  late List<Jugador> jugadoresFiltrados;

  @override
  void initState() {
    super.initState();
    jugadoresSeleccionados = List.from(widget.jugadoresSeleccionados);
    jugadoresFiltrados = List.from(widget.jugadoresDisponibles);
  }

  void _seleccionarJugador(Jugador jugador) {
    setState(() {
      if (jugadoresSeleccionados.contains(jugador)) {
        jugadoresSeleccionados.remove(jugador);
      } else {
        jugadoresSeleccionados.add(jugador);
      }
    });
  }

  void _confirmarSeleccion() {
    if (jugadoresSeleccionados.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Selecciona al menos un jugador")),
      );
      return;
    }
    Navigator.pop(context, jugadoresSeleccionados);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Seleccionar Jugadores"),
        // ✅ Botón en la derecha del appBar
        actions: [
          TextButton(
            onPressed: _confirmarSeleccion,
            child: Text(
              "Confirmar (${jugadoresSeleccionados.length})",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          SizedBox(width: 8),
        ],
      ),
      body: Column(
        children: [
          // Campo de búsqueda
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: "Buscar por nombre, cédula o correo",
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              onChanged: (query) {
                setState(() {
                  jugadoresFiltrados = widget.jugadoresDisponibles
                      .where((j) =>
                          j.nombreCompleto.toLowerCase().contains(query.toLowerCase()) ||
                          j.cedula.contains(query) ||
                          j.email.toLowerCase().contains(query.toLowerCase()))
                      .toList();
                });
              },
            ),
          ),
          // Lista de jugadores
          Expanded(
            child: ListView.builder(
              itemCount: jugadoresFiltrados.length,
              itemBuilder: (context, index) {
                final jugador = jugadoresFiltrados[index];
                return CheckboxListTile(
                  title: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(jugador.nombreCompleto, style: TextStyle(fontSize: 16)),
                      Text("${jugador.cedula} - ${jugador.posicionPrincipal}", style: TextStyle(fontSize: 14, color: Colors.grey)),
                    ],
                  ),
                  value: jugadoresSeleccionados.contains(jugador),
                  onChanged: (value) => _seleccionarJugador(jugador),
                );
              },
            ),
          ),
        ],
      ),
      // ✅ Botón de confirmar en la parte inferior (opcional, para mayor visibilidad)
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _confirmarSeleccion,
        label: Text("Confirmar (${jugadoresSeleccionados.length})"),
        icon: Icon(Icons.check),
        backgroundColor: Colors.green,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}