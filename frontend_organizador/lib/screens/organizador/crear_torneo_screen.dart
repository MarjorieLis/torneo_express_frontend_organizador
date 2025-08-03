import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:frontend_organizador/services/api_service.dart';
import 'package:frontend_organizador/utils/validators.dart';

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
  String? _formato;
  bool _loading = false;

  // Formato de fecha en español
  final DateFormat _dateFormat = DateFormat('dd/MM/yyyy', 'es');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Crear Torneo"),
        elevation: 2,
      ),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              // Título principal
              Text(
                "Información del Torneo",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue[800],
                ),
              ),
              SizedBox(height: 20),

              // Nombre del torneo
              _buildTextField(
                controller: _nombreController,
                label: "Nombre del Torneo *",
                hint: "Ej: Torneo UIDE 2025",
              ),

              // Disciplina
              _buildDropdown(
                value: _disciplina,
                label: "Disciplina *",
                items: ['Fútbol', 'Baloncesto', 'Voleibol'],
                onChanged: (v) => setState(() => _disciplina = v),
              ),

              // Fechas
              _buildDateButton(
                label: "Fecha de Inicio",
                date: _fechaInicio,
                onSelect: () async {
                  final date = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(2020),
                    lastDate: DateTime(2030),
                    locale: Locale('es'),
                    helpText: "Seleccionar fecha de inicio",
                    cancelText: "Cancelar",
                    confirmText: "Aceptar",
                  );
                  if (date != null) setState(() => _fechaInicio = date);
                },
              ),
              _buildDateButton(
                label: "Fecha de Fin",
                date: _fechaFin,
                onSelect: () async {
                  final date = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(2020),
                    lastDate: DateTime(2030),
                    locale: Locale('es'),
                    helpText: "Seleccionar fecha de fin",
                    cancelText: "Cancelar",
                    confirmText: "Aceptar",
                  );
                  if (date != null) setState(() => _fechaFin = date);
                },
              ),

              // Cantidad de equipos
              _buildTextField(
                controller: TextEditingController(text: _maxEquipos?.toString()),
                label: "Cantidad de Equipos *",
                hint: "Máximo 16",
                keyboardType: TextInputType.number,
                onChanged: (v) {
                  final num = int.tryParse(v);
                  if (num != null) setState(() => _maxEquipos = num);
                },
              ),

              // Formato del torneo
              _buildDropdown(
                value: _formato,
                label: "Formato del Torneo *",
                items: ['grupos', 'eliminacion', 'mixto'],
                labelMapper: (v) => {
                  'grupos': 'Por Grupos',
                  'eliminacion': 'Eliminación Directa',
                  'mixto': 'Mixto'
                }[v]!,
                onChanged: (v) => setState(() => _formato = v),
              ),

              // Reglas
              _buildTextField(
                controller: _reglasController,
                label: "Reglas del Torneo",
                hint: "Ej: Sin tarjetas rojas en primera ronda",
                maxLines: 4,
              ),

              SizedBox(height: 30),

              // Botón de creación
              _loading
                  ? Center(child: CircularProgressIndicator())
                  : ElevatedButton(
                      onPressed: _crearTorneo,
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        backgroundColor: Color(0xFF1565C0),
                      ),
                      child: Text(
                        "Crear Torneo",
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    String? hint,
    int? maxLines,
    TextInputType? keyboardType,
    ValueChanged<String>? onChanged,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        ),
        maxLines: maxLines ?? 1,
        keyboardType: keyboardType,
        onChanged: onChanged,
        validator: (v) => v!.isEmpty ? "Este campo es obligatorio" : null,
      ),
    );
  }

  Widget _buildDropdown({
    required String? value,
    required String label,
    required List<String> items,
    required ValueChanged<String?> onChanged,
    String Function(String)? labelMapper,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: DropdownButtonFormField<String>(
        value: value,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        ),
        items: items.map((String item) {
          return DropdownMenuItem(
            value: item,
            child: Text(labelMapper != null ? labelMapper(item) : item),
          );
        }).toList(),
        onChanged: onChanged,
        validator: (v) => v == null ? "Requerido" : null,
      ),
    );
  }

  Widget _buildDateButton({
    required String label,
    required DateTime? date,
    required VoidCallback onSelect,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.grey[700],
            ),
          ),
          SizedBox(height: 8),
          ElevatedButton.icon(
            onPressed: onSelect,
            icon: Icon(Icons.calendar_today, size: 18),
            label: Text(
              date != null ? _dateFormat.format(date) : "Seleccionar fecha",
              style: TextStyle(fontSize: 16),
            ),
            style: ElevatedButton.styleFrom(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              backgroundColor: Colors.grey[200],
              foregroundColor: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _crearTorneo() async {
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

      final response = await ApiService.crearTorneo(data);
      setState(() => _loading = false);

      if (response['success'] == true) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("✅ Torneo creado correctamente")),
        );
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(response['message'] ?? "Error al crear torneo")),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Por favor, completa todos los campos requeridos")),
      );
    }
  }

  @override
  void dispose() {
    _nombreController.dispose();
    _reglasController.dispose();
    super.dispose();
  }
}