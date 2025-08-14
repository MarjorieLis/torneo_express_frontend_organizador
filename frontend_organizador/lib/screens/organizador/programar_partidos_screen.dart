// screens/organizador/programar_partidos_screen.dart
import 'package:flutter/material.dart';
import 'package:frontend_organizador/models/equipo.dart';
import 'package:frontend_organizador/models/torneo.dart';
import 'package:frontend_organizador/services/api_service.dart';
import 'package:frontend_organizador/widgets/date_time_picker_widget.dart';

class ProgramarPartidosScreen extends StatefulWidget {
  final Torneo? torneo; // ✅ Parámetro opcional

  const ProgramarPartidosScreen({Key? key, this.torneo}) : super(key: key);

  @override
  _ProgramarPartidosScreenState createState() => _ProgramarPartidosScreenState();
}

class _ProgramarPartidosScreenState extends State<ProgramarPartidosScreen> {
  final _formKey = GlobalKey<FormState>();
  String _tipoProgramacion = 'manual';
  DateTime _fecha = DateTime.now();
  TimeOfDay _hora = TimeOfDay.now();
  String _lugar = '';
  String? _equipoLocalId;
  String? _equipoVisitanteId;
  String? _torneoId;
  String? _capitanId;
  List<String> _titulares = [];
  List<String> _suplentes = [];

  List<Torneo> _torneos = [];
  List<Equipo> _equipos = [];
  bool _loadingEquipos = true;

  @override
  void initState() {
    super.initState();
    _cargarTorneos();

    // ✅ Si se pasó un torneo, selecciónalo automáticamente
    if (widget.torneo != null) {
      _torneoId = widget.torneo!.id;
      _cargarEquipos(_torneoId!);
    }
  }

  Future<void> _cargarTorneos() async {
    final response = await ApiService.obtenerTorneos();
    if (response.isNotEmpty) {
      setState(() {
        _torneos = response;
      });

      // ✅ Si no hay torneo seleccionado y hay uno en widget.torneo, seléccionalo
      if (_torneoId == null && widget.torneo != null) {
        _torneoId = widget.torneo!.id;
        _cargarEquipos(_torneoId!);
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("No se pudieron cargar los torneos")),
      );
    }
  }

  Future<void> _cargarEquipos(String torneoId) async {
    final response = await ApiService.getEquiposPorTorneo(torneoId);
    if (response['success'] == true && response['equipos'] is List) {
      setState(() {
        _equipos = (response['equipos'] as List).map((e) => Equipo.fromJson(e)).toList();
        _loadingEquipos = false;
      });
    } else {
      setState(() {
        _loadingEquipos = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error al cargar equipos: ${response['message'] ?? 'Desconocido'}")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Programar Partidos")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              DropdownButtonFormField<String>(
                value: _torneoId,
                items: _torneos.map((t) {
                  return DropdownMenuItem(
                    value: t.id,
                    child: Text(t.nombre),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _torneoId = value;
                    _loadingEquipos = true;
                    _cargarEquipos(value!);
                  });
                },
                decoration: const InputDecoration(labelText: "Seleccionar Torneo"),
              ),
              const SizedBox(height: 16),

              Card(
                color: Theme.of(context).primaryColor,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text(
                    "Torneo: ${_torneoId != null ? _torneos.firstWhere((t) => t.id == _torneoId).nombre : 'Sin torneo seleccionado'}",
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              DropdownButtonFormField<String>(
                value: _tipoProgramacion,
                items: const [
                  DropdownMenuItem(value: 'manual', child: Text("Manual")),
                  DropdownMenuItem(value: 'automatica', child: Text("Automática")),
                ],
                onChanged: (value) {
                  setState(() {
                    _tipoProgramacion = value!;
                  });
                },
                decoration: const InputDecoration(labelText: "Tipo de programación"),
              ),
              const SizedBox(height: 16),

              if (_tipoProgramacion == 'manual') ...[
                if (_equipos.isEmpty)
                  const Text("No hay equipos registrados en este torneo.")
                else ...[
                  DropdownButtonFormField<String>(
                    value: _equipoLocalId,
                    items: _equipos.map<DropdownMenuItem<String>>((e) {
                      return DropdownMenuItem(
                        value: e.id,
                        child: Text(e.nombre),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _equipoLocalId = value;
                        if (_equipoVisitanteId == value) {
                          _equipoVisitanteId = null;
                        }
                      });
                    },
                    decoration: const InputDecoration(labelText: "Equipo Local"),
                  ),
                  const SizedBox(height: 16),

                  DropdownButtonFormField<String>(
                    value: _equipoVisitanteId,
                    items: _equipos
                        .map<DropdownMenuItem<String>?>((e) {
                          if (e.id == _equipoLocalId) return null;
                          return DropdownMenuItem(
                            value: e.id,
                            child: Text(e.nombre),
                          );
                        })
                        .where((item) => item != null)
                        .cast<DropdownMenuItem<String>>()
                        .toList(),
                    onChanged: (value) {
                      setState(() {
                        _equipoVisitanteId = value;
                      });
                    },
                    decoration: const InputDecoration(labelText: "Equipo Visitante"),
                  ),
                  const SizedBox(height: 16),

                  DateTimePickerWidget(
                    labelText: "Fecha y Hora",
                    selectedDate: _fecha,
                    selectedTime: _hora,
                    onDateSelected: (date) {
                      setState(() {
                        _fecha = date;
                      });
                    },
                    onTimeSelected: (time) {
                      setState(() {
                        _hora = time;
                      });
                    },
                  ),
                  const SizedBox(height: 16),

                  TextFormField(
                    decoration: const InputDecoration(labelText: "Lugar"),
                    onChanged: (value) {
                      _lugar = value;
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) return 'Requerido';
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                ],
              ],

              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () async {
                  print('🆔 Torneo ID: $_torneoId');

                  if (_tipoProgramacion == 'automatica') {
                    final response = await ApiService.programarPartido({
                      'tipoProgramacion': 'automatica',
                      'torneoId': _torneoId,
                    });

                    if (response['success'] == true) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Partidos programados automáticamente")),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("Error: ${response['message'] ?? 'Desconocido'}")),
                      );
                    }
                  } else {
                    if (_formKey.currentState!.validate()) {
                      if (_equipoLocalId == null || _equipoVisitanteId == null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("Selecciona ambos equipos")),
                        );
                        return;
                      }

                      final response = await ApiService.programarPartido({
                        'tipoProgramacion': 'manual',
                        'fecha': _fecha.toIso8601String(),
                        'hora': _hora.format(context),
                        'lugar': _lugar,
                        'equipoLocalId': _equipoLocalId,
                        'equipoVisitanteId': _equipoVisitanteId,
                        'capitanId': _capitanId,
                        'titulares': _titulares,
                        'suplentes': _suplentes,
                      });

                      if (response['success'] == true) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("Partido programado exitosamente")),
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("Error: ${response['message'] ?? 'Desconocido'}")),
                        );
                      }
                    }
                  }
                },
                child: const Text("Programar Partidos"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}