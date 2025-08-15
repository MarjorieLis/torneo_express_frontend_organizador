// screens/organizador/editar_torneo_screen.dart
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:frontend_organizador/services/api_service.dart';
import 'package:frontend_organizador/models/torneo.dart';
// ✅ Importa la extensión global
import 'package:frontend_organizador/extensions/string_extension.dart';

class EditarTorneoScreen extends StatefulWidget {
  final Torneo torneo;

  EditarTorneoScreen({required this.torneo});

  @override
  _EditarTorneoScreenState createState() => _EditarTorneoScreenState();
}

class _EditarTorneoScreenState extends State<EditarTorneoScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nombreController;
  String? _disciplina;
  DateTime? _fechaInicio;
  DateTime? _fechaFin;
  int? _maxEquipos;
  String? _formato;
  late TextEditingController _reglasController;
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    final torneo = widget.torneo;

    _nombreController = TextEditingController(text: torneo.nombre);

    // ✅ Asegura que la disciplina sea válida
    final List<String> validDisciplinas = ['Fútbol', 'Baloncesto', 'Voleibol'];
    if (validDisciplinas.contains(torneo.disciplina)) {
      _disciplina = torneo.disciplina;
    } else {
      _disciplina = validDisciplinas.first;
    }

    _fechaInicio = torneo.fechaInicio;
    _fechaFin = torneo.fechaFin;
    _maxEquipos = torneo.maxEquipos;
    _formato = torneo.formato;
    _reglasController = TextEditingController(text: torneo.reglas ?? '');
  }

  @override
  void dispose() {
    _nombreController.dispose();
    _reglasController.dispose();
    super.dispose();
  }

  Future<void> _guardarCambios() async {
    if (_formKey.currentState!.validate() &&
        _fechaInicio != null &&
        _fechaFin != null &&
        _formato != null &&
        _maxEquipos != null &&
        _disciplina != null) {
      setState(() => _loading = true);

      final data = {
        'nombre': _nombreController.text.trim(),
        'disciplina': _disciplina,
        'fechaInicio': _fechaInicio!.toIso8601String(),
        'fechaFin': _fechaFin!.toIso8601String(),
        'maxEquipos': _maxEquipos,
        'reglas': _reglasController.text,
        'formato': _formato,
      };

      final response = await ApiService.editarTorneo(widget.torneo.id, data);
      setState(() => _loading = false);

      if (response['success'] == true) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("✅ Torneo actualizado")),
        );
        Navigator.pop(context, true);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(response['message'] ?? "Error al actualizar")),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Por favor, completa todos los campos requeridos")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Editar Torneo")),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              // Nombre del torneo
              TextFormField(
                controller: _nombreController,
                decoration: InputDecoration(labelText: "Nombre del Torneo *"),
                validator: (v) => v?.isEmpty == true ? "Requerido" : null,
              ),

              // Disciplina
              DropdownButtonFormField<String>(
                value: _disciplina,
                items: const ['Fútbol', 'Baloncesto', 'Voleibol']
                    .map((d) => DropdownMenuItem(value: d, child: Text(d)))
                    .toList(),
                onChanged: (String? value) {
                  if (value != null) {
                    setState(() => _disciplina = value);
                  }
                },
                decoration: InputDecoration(labelText: "Disciplina *"),
                validator: (v) => v == null ? "Requerido" : null,
              ),

              // Fecha de inicio
              TextButton(
                onPressed: () async {
                  final date = await showDatePicker(
                    context: context,
                    initialDate: _fechaInicio ?? DateTime.now(),
                    firstDate: DateTime(2020),
                    lastDate: DateTime(2030),
                    locale: const Locale('es'),
                    helpText: "Fecha de inicio",
                    cancelText: "Cancelar",
                    confirmText: "Aceptar",
                  );
                  if (date != null) {
                    setState(() => _fechaInicio = date);
                  }
                },
                child: Text(
                  _fechaInicio != null
                      ? "Inicio: ${DateFormat('dd/MM/yyyy').format(_fechaInicio!)}"
                      : "Seleccionar Fecha Inicio",
                ),
              ),

              // Fecha de fin
              TextButton(
                onPressed: () async {
                  final date = await showDatePicker(
                    context: context,
                    initialDate: _fechaFin ?? DateTime.now(),
                    firstDate: DateTime(2020),
                    lastDate: DateTime(2030),
                    locale: const Locale('es'),
                    helpText: "Fecha de fin",
                    cancelText: "Cancelar",
                    confirmText: "Aceptar",
                  );
                  if (date != null) {
                    setState(() => _fechaFin = date);
                  }
                },
                child: Text(
                  _fechaFin != null
                      ? "Fin: ${DateFormat('dd/MM/yyyy').format(_fechaFin!)}"
                      : "Seleccionar Fecha Fin",
                ),
              ),

              // Cantidad de equipos
              TextFormField(
                initialValue: _maxEquipos?.toString(),
                decoration: InputDecoration(labelText: "Cantidad de Equipos *"),
                keyboardType: TextInputType.number,
                onChanged: (v) {
                  final num = int.tryParse(v);
                  if (num != null) setState(() => _maxEquipos = num);
                },
                validator: (v) => v?.isEmpty == true ? "Requerido" : null,
              ),

              // Formato
              DropdownButtonFormField<String>(
                value: _formato,
                items: const ['grupos', 'eliminacion', 'mixto']
                    .map((f) => DropdownMenuItem(
                          value: f,
                          child: Text(
                            f.capitalize(), // ✅ Ahora funciona
                          ),
                        ))
                    .toList(),
                onChanged: (String? value) {
                  if (value != null) {
                    setState(() => _formato = value);
                  }
                },
                decoration: InputDecoration(labelText: "Formato *"),
                validator: (v) => v == null ? "Requerido" : null,
              ),

              // Reglas
              TextFormField(
                controller: _reglasController,
                maxLines: 3,
                decoration: InputDecoration(labelText: "Reglas del Torneo"),
              ),

              SizedBox(height: 20),

              // Botón de guardar
              _loading
                  ? const Center(child: CircularProgressIndicator())
                  : ElevatedButton(
                      onPressed: _guardarCambios,
                      child: const Text("Guardar Cambios"),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}