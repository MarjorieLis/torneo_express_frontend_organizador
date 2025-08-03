import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:frontend_organizador/services/api_service.dart';
import 'package:frontend_organizador/models/torneo.dart';

class EditarTorneoScreen extends StatefulWidget {
  final Torneo torneo;

  EditarTorneoScreen({required this.torneo});

  @override
  _EditarTorneoScreenState createState() => _EditarTorneoScreenState();
}

class _EditarTorneoScreenState extends State<EditarTorneoScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nombreController;
  late String? _disciplina;
  late DateTime? _fechaInicio;
  late DateTime? _fechaFin;
  late int? _maxEquipos;
  late String? _formato;
  late TextEditingController _reglasController;
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    final torneo = widget.torneo;
    _nombreController = TextEditingController(text: torneo.nombre);
    _disciplina = torneo.disciplina;
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
        _maxEquipos != null) {
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
        Navigator.pop(context, true); // Indica que se actualizó
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(response['message'] ?? "Error al actualizar")),
        );
      }
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
                  final date = await showDatePicker(
                    context: context,
                    initialDate: _fechaInicio ?? DateTime.now(),
                    firstDate: DateTime(2020),
                    lastDate: DateTime(2030),
                    locale: Locale('es'),
                    helpText: "Fecha de inicio",
                    cancelText: "Cancelar",
                    confirmText: "Aceptar",
                  );
                  if (date != null) setState(() => _fechaInicio = date);
                },
                child: Text(_fechaInicio != null
                    ? "Inicio: ${DateFormat('dd/MM/yyyy').format(_fechaInicio!)}"
                    : "Seleccionar Fecha Inicio"),
              ),
              TextButton(
                onPressed: () async {
                  final date = await showDatePicker(
                    context: context,
                    initialDate: _fechaFin ?? DateTime.now(),
                    firstDate: DateTime(2020),
                    lastDate: DateTime(2030),
                    locale: Locale('es'),
                    helpText: "Fecha de fin",
                    cancelText: "Cancelar",
                    confirmText: "Aceptar",
                  );
                  if (date != null) setState(() => _fechaFin = date);
                },
                child: Text(_fechaFin != null
                    ? "Fin: ${DateFormat('dd/MM/yyyy').format(_fechaFin!)}"
                    : "Seleccionar Fecha Fin"),
              ),
              TextFormField(
                initialValue: _maxEquipos?.toString(),
                decoration: InputDecoration(labelText: "Cantidad de Equipos *"),
                keyboardType: TextInputType.number,
                onChanged: (v) {
                  final num = int.tryParse(v);
                  if (num != null) setState(() => _maxEquipos = num);
                },
                validator: (v) => v!.isEmpty ? "Requerido" : null,
              ),
              DropdownButtonFormField(
                value: _formato,
                items: ['grupos', 'eliminacion', 'mixto'].map((f) {
                  return DropdownMenuItem(value: f, child: Text(f.capitalize()));
                }).toList(),
                onChanged: (v) => setState(() => _formato = v),
                decoration: InputDecoration(labelText: "Formato *"),
                validator: (v) => v == null ? "Requerido" : null,
              ),
              TextFormField(
                controller: _reglasController,
                maxLines: 3,
                decoration: InputDecoration(labelText: "Reglas del Torneo"),
              ),
              SizedBox(height: 20),
              _loading
                  ? CircularProgressIndicator()
                  : ElevatedButton(
                      onPressed: _guardarCambios,
                      child: Text("Guardar Cambios"),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}

extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${this.substring(1)}";
  }
}