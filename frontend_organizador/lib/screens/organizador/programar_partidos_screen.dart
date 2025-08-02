// screens/organizador/programar_partidos_screen.dart
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:frontend_organizador/models/torneo.dart';
import 'package:frontend_organizador/services/api_service.dart';

class ProgramarPartidosScreen extends StatefulWidget {
  @override
  _ProgramarPartidosScreenState createState() => _ProgramarPartidosScreenState();
}

class _ProgramarPartidosScreenState extends State<ProgramarPartidosScreen> {
  List<Torneo> torneos = [];
  String? torneoSeleccionado;
  bool esAutomatico = true;
  DateTime? fechaInicio;
  TimeOfDay? horaInicio;
  String? lugar;

  @override
  void initState() {
    super.initState();
    _cargarTorneos();
  }

  Future<void> _cargarTorneos() async {
    final data = await ApiService.getTorneos();
    setState(() {
      torneos = data;
      if (torneos.isNotEmpty) torneoSeleccionado = torneos[0].id;
    });
  }

  Future<void> _programarPartidos() async {
    if (torneoSeleccionado == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Selecciona un torneo")),
      );
      return;
    }

    final data = {
      'torneoId': torneoSeleccionado,
      'tipo': esAutomatico ? 'automatico' : 'manual',
      'fechaInicio': fechaInicio?.toIso8601String(),
      'hora': horaInicio != null ? horaInicio!.format(context) : null,
      'lugar': lugar,
    };

    final response = await ApiService.programarPartidos(data);
    if (response['success']) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Partidos programados correctamente")),
      );
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(response['message'] ?? "Error al programar")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Programar Partidos")),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: ListView(
          children: [
            Text("Selecciona torneo", style: TextStyle(fontWeight: FontWeight.bold)),
            DropdownButton<String>(
              value: torneoSeleccionado,
              items: torneos.map((t) {
                return DropdownMenuItem(value: t.id, child: Text(t.nombre));
              }).toList(),
              onChanged: (v) => setState(() => torneoSeleccionado = v),
              isExpanded: true,
            ),
            SizedBox(height: 16),
            Text("Tipo de programación", style: TextStyle(fontWeight: FontWeight.bold)),
            Row(
              children: [
                Expanded(
                  child: RadioListTile(
                    title: Text("Automática"),
                    value: true,
                    groupValue: esAutomatico,
                    onChanged: (v) => setState(() => esAutomatico = v!),
                  ),
                ),
                Expanded(
                  child: RadioListTile(
                    title: Text("Manual"),
                    value: false,
                    groupValue: esAutomatico,
                    onChanged: (v) => setState(() => esAutomatico = v!),
                  ),
                ),
              ],
            ),
            if (!esAutomatico) ...[
              SizedBox(height: 16),
              Text("Detalles (Manual)", style: TextStyle(fontWeight: FontWeight.bold)),
              TextButton(
                onPressed: () async {
                  final date = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(2020),
                    lastDate: DateTime(2030),
                  );
                  if (date != null) setState(() => fechaInicio = date);
                },
                child: Text(fechaInicio != null
                    ? "Fecha: ${DateFormat('dd/MM/yyyy').format(fechaInicio!)}"
                    : "Seleccionar fecha"),
              ),
              TextButton(
                onPressed: () async {
                  final time = await showTimePicker(context: context, initialTime: TimeOfDay.now());
                  if (time != null) setState(() => horaInicio = time);
                },
                child: Text(horaInicio != null ? "Hora: ${horaInicio!.format(context)}" : "Seleccionar hora"),
              ),
              TextFormField(
                decoration: InputDecoration(labelText: "Lugar"),
                onChanged: (v) => lugar = v,
              ),
            ],
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _programarPartidos,
              child: Text("Programar Partidos"),
            ),
          ],
        ),
      ),
    );
  }
}