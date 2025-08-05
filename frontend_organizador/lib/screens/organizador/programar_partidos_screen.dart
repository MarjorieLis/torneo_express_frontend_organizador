import 'package:flutter/material.dart';
import 'package:frontend_organizador/models/torneo.dart';
import 'package:frontend_organizador/services/api_service.dart';

class ProgramarPartidosScreen extends StatefulWidget {
  final Torneo torneo;

  const ProgramarPartidosScreen({Key? key, required this.torneo}) : super(key: key);

  @override
  _ProgramarPartidosScreenState createState() => _ProgramarPartidosScreenState();
}

class _ProgramarPartidosScreenState extends State<ProgramarPartidosScreen> {
  String _modo = 'manual'; // 'manual' o 'automatica'
  List<Map<String, dynamic>> partidos = [];
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    _inicializarPartidos();
  }

  void _inicializarPartidos() {
    final equipos = widget.torneo.equipos;
    if (equipos.isEmpty) {
      // ✅ Mostrar snackbar de forma segura después del primer frame
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("No hay equipos inscritos en este torneo")),
        );
      });
      return;
    }

    final List<Map<String, dynamic>> nuevosPartidos = [];
    for (int i = 0; i < equipos.length; i++) {
      for (int j = i + 1; j < equipos.length; j++) {
        nuevosPartidos.add({
          'local': equipos[i],
          'visitante': equipos[j],
          'fecha': null,
          'hora': null,
          'lugar': '',
          'capitanLocal': '',
          'capitanVisitante': '',
          'jugadoresLocales': [],
          'jugadoresVisitantes': [],
        });
      }
    }

    setState(() {
      partidos = nuevosPartidos;
    });
  }

  Future<void> _generarCalendarioAutomatico() async {
    setState(() => _loading = true);

    try {
      final DateTime inicio = widget.torneo.fechaInicio;
      TimeOfDay horaInicio = TimeOfDay(hour: 16, minute: 0);

      for (int i = 0; i < partidos.length; i++) {
        final dias = i ~/ 3;
        final horaOffset = (i % 3) * 2;

        final fecha = inicio.add(Duration(days: dias));
        final hora = TimeOfDay(
          hour: (horaInicio.hour + horaOffset) % 24,
          minute: horaInicio.minute,
        );
        final lugar = 'Cancha ${i % 3 + 1}';

        setState(() {
          partidos[i]['fecha'] = fecha;
          partidos[i]['hora'] = hora;
          partidos[i]['lugar'] = lugar;
        });
      }

      WidgetsBinding.instance.addPostFrameCallback((_) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("✅ Calendario generado automáticamente")),
        );
      });
    } catch (e) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error al generar calendario")),
        );
      });
    } finally {
      setState(() => _loading = false);
    }
  }

  Future<void> _guardarProgramacion() async {
    if (_modo == 'manual') {
      for (var partido in partidos) {
        if (partido['fecha'] == null ||
            partido['hora'] == null ||
            partido['lugar'].toString().trim().isEmpty ||
            partido['capitanLocal'].toString().trim().isEmpty ||
            partido['capitanVisitante'].toString().trim().isEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Completa todos los campos obligatorios")),
          );
          return;
        }
      }
    }

    setState(() => _loading = true);

    final data = {
      'torneoId': widget.torneo.id,
      'modo': _modo,
      'partidos': partidos.map((p) {
        return {
          'equipoLocal': p['local'],
          'equipoVisitante': p['visitante'],
          'fecha': p['fecha']?.toIso8601String(),
          'hora': {
            'hour': p['hora']?.hour,
            'minute': p['hora']?.minute,
          },
          'lugar': p['lugar'],
          'capitanLocal': p['capitanLocal'],
          'capitanVisitante': p['capitanVisitante'],
          'jugadoresLocales': p['jugadoresLocales'],
          'jugadoresVisitantes': p['jugadoresVisitantes'],
        };
      }).toList(),
    };

    final response = await ApiService.programarPartidos(data);
    setState(() => _loading = false);

    if (response['success'] == true) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("✅ Partidos programados correctamente")),
      );
      Navigator.pop(context, true);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: ${response['message'] ?? 'Desconocido'}")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Programar Partidos")),
      body: _loading
          ? Center(child: CircularProgressIndicator())
          : Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                children: [
                  DropdownButtonFormField<String>(
                    value: _modo,
                    decoration: InputDecoration(
                      labelText: "Modo de programación",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    items: [
                      DropdownMenuItem(value: 'manual', child: Text("Manual")),
                      DropdownMenuItem(value: 'automatica', child: Text("Automática")),
                    ],
                    onChanged: (String? newValue) {
                      if (newValue != null) {
                        setState(() {
                          _modo = newValue;
                          if (_modo == 'automatica') {
                            _generarCalendarioAutomatico();
                          }
                        });
                      }
                    },
                  ),
                  SizedBox(height: 20),

                  if (_modo == 'manual')
                    ElevatedButton.icon(
                      onPressed: _generarCalendarioAutomatico,
                      icon: Icon(Icons.auto_fix_high),
                      label: Text("Generar automáticamente"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange,
                        padding: EdgeInsets.symmetric(vertical: 16),
                      ),
                    ),
                  SizedBox(height: 20),

                  Expanded(
                    child: ListView.builder(
                      itemCount: partidos.length,
                      itemBuilder: (context, index) {
                        final partido = partidos[index];
                        return _buildPartidoCard(partido, index);
                      },
                    ),
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _guardarProgramacion,
                    child: Text("Guardar Programación"),
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 16),
                      backgroundColor: Colors.blue,
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  Widget _buildPartidoCard(Map<String, dynamic> partido, int index) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 4),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "${partido['local']} vs ${partido['visitante']}",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    readOnly: true,
                    onTap: () async {
                      final date = await showDatePicker(
                        context: context,
                        initialDate: partido['fecha'] ?? DateTime.now(),
                        firstDate: widget.torneo.fechaInicio,
                        lastDate: widget.torneo.fechaFin,
                      );
                      if (date != null) {
                        setState(() {
                          partido['fecha'] = date;
                        });
                      }
                    },
                    decoration: InputDecoration(
                      labelText: "Fecha",
                      hintText: partido['fecha'] != null
                          ? "${partido['fecha'].day}/${partido['fecha'].month}/${partido['fecha'].year}"
                          : "Seleccionar",
                      border: OutlineInputBorder(),
                    ),
                    initialValue: partido['fecha'] != null
                        ? "${partido['fecha'].day}/${partido['fecha'].month}/${partido['fecha'].year}"
                        : null,
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: TextFormField(
                    readOnly: true,
                    onTap: () async {
                      final time = await showTimePicker(
                        context: context,
                        initialTime: partido['hora'] ?? TimeOfDay.now(),
                      );
                      if (time != null) {
                        setState(() {
                          partido['hora'] = time;
                        });
                      }
                    },
                    decoration: InputDecoration(
                      labelText: "Hora",
                      hintText: partido['hora']?.format(context) ?? "Seleccionar",
                      border: OutlineInputBorder(),
                    ),
                    initialValue: partido['hora']?.format(context),
                  ),
                ),
              ],
            ),
            SizedBox(height: 12),
            TextFormField(
              decoration: InputDecoration(labelText: "Lugar *"),
              initialValue: partido['lugar'],
              onChanged: (v) => partido['lugar'] = v,
            ),
            SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    decoration: InputDecoration(labelText: "Capitán Local *"),
                    initialValue: partido['capitanLocal'],
                    onChanged: (v) => partido['capitanLocal'] = v,
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: TextFormField(
                    decoration: InputDecoration(labelText: "Capitán Visitante *"),
                    initialValue: partido['capitanVisitante'],
                    onChanged: (v) => partido['capitanVisitante'] = v,
                  ),
                ),
              ],
            ),
            SizedBox(height: 12),
            Text("Jugadores Titulares y Suplentes", style: TextStyle(fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            TextFormField(
              maxLines: 3,
              decoration: InputDecoration(
                labelText: "Jugadores Locales",
                hintText: "Uno por línea",
                border: OutlineInputBorder(),
              ),
              onChanged: (v) {
                partido['jugadoresLocales'] = v.split('\n').where((e) => e.trim().isNotEmpty).toList();
              },
            ),
            SizedBox(height: 8),
            TextFormField(
              maxLines: 3,
              decoration: InputDecoration(
                labelText: "Jugadores Visitantes",
                hintText: "Uno por línea",
                border: OutlineInputBorder(),
              ),
              onChanged: (v) {
                partido['jugadoresVisitantes'] = v.split('\n').where((e) => e.trim().isNotEmpty).toList();
              },
            ),
          ],
        ),
      ),
    );
  }
}
