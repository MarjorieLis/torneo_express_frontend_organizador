import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:frontend_organizador/services/api_service.dart';
import 'package:frontend_organizador/models/torneo.dart';

class CrearTorneoScreen extends StatefulWidget {
  @override
  _CrearTorneoScreenState createState() => _CrearTorneoScreenState();
}

class _CrearTorneoScreenState extends State<CrearTorneoScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nombreController = TextEditingController();
  final _reglasController = TextEditingController();
  String? _disciplina;
  DateTime? _fechaInicio;
  DateTime? _fechaFin;
  int? _maxEquipos;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Crear Torneo")),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _nombreController,
                decoration: InputDecoration(labelText: "Nombre del Torneo *"),
                validator: (v) => v!.isEmpty ? "Requerido" : null,
              ),
              DropdownButtonFormField(
                value: _disciplina,
                items: ['Fútbol', 'Baloncesto', 'Voleibol'].map((d) {
                  return DropdownMenuItem(value: d, child: Text(d));
                }).toList(),
                onChanged: (v) => setState(() => _disciplina = v),
                decoration: InputDecoration(labelText: "Disciplina *"),
                validator: (v) => v == null ? "Requerido" : null,
              ),
              TextButton(
                onPressed: () async {
                  final date = await showDatePicker(context: context, initialDate: DateTime.now(), firstDate: DateTime(2020), lastDate: DateTime(2030));
                  if (date != null) setState(() => _fechaInicio = date);
                },
                child: Text(_fechaInicio != null ? "Inicio: ${DateFormat('dd/MM/yyyy').format(_fechaInicio!)}" : "Seleccionar Fecha Inicio"),
              ),
              TextButton(
                onPressed: () async {
                  final date = await showDatePicker(context: context, initialDate: DateTime.now(), firstDate: DateTime(2020), lastDate: DateTime(2030));
                  if (date != null) setState(() => _fechaFin = date);
                },
                child: Text(_fechaFin != null ? "Fin: ${DateFormat('dd/MM/yyyy').format(_fechaFin!)}" : "Seleccionar Fecha Fin"),
              ),
              TextFormField(
                keyboardType: TextInputType.number,
                decoration: InputDecoration(labelText: "Cantidad de Equipos *"),
                validator: (v) => v!.isEmpty ? "Requerido" : null,
                onChanged: (v) => _maxEquipos = int.tryParse(v),
              ),
              TextFormField(
                maxLines: 3,
                controller: _reglasController,
                decoration: InputDecoration(labelText: "Reglas del Torneo"),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate() && _fechaInicio != null && _fechaFin != null) {
                    final torneo = {
                      'nombre': _nombreController.text,
                      'disciplina': _disciplina,
                      'fechaInicio': _fechaInicio!.toIso8601String(),
                      'fechaFin': _fechaFin!.toIso8601String(),
                      'maxEquipos': _maxEquipos,
                      'reglas': _reglasController.text,
                    };

                    final response = await ApiService.crearTorneo(torneo);
                    if (response['success']) {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Torneo creado")));
                      Navigator.pop(context);
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(response['message'])));
                    }
                  }
                },
                child: Text("Crear Torneo"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}