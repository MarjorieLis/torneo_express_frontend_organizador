// screens/organizador/notificaciones_screen.dart
import 'package:flutter/material.dart';
import 'package:frontend_organizador/models/torneo.dart';
import 'package:frontend_organizador/services/api_service.dart';

class NotificacionesScreen extends StatefulWidget {
  @override
  _NotificacionesScreenState createState() => _NotificacionesScreenState();
}

class _NotificacionesScreenState extends State<NotificacionesScreen> {
  List<Torneo> torneos = [];
  String? torneoId;
  String tipoNotificacion = 'cambio_horario';
  String mensaje = '';

  @override
  void initState() {
    super.initState();
    _cargarTorneos();
  }

  Future<void> _cargarTorneos() async {
    final data = await ApiService.getTorneos();
    setState(() {
      torneos = data;
      if (torneos.isNotEmpty) torneoId = torneos[0].id;
    });
  }

  Future<void> _enviarNotificacion() async {
    if (mensaje.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Escribe un mensaje")),
      );
      return;
    }

    final data = {
      'torneoId': torneoId,
      'tipo': tipoNotificacion,
      'mensaje': mensaje,
    };

    final response = await ApiService.enviarNotificacion(data);
    if (response['success']) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Notificación enviada")),
      );
      setState(() => mensaje = '');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error al enviar")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Enviar Notificación")),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: ListView(
          children: [
            Text("Torneo", style: TextStyle(fontWeight: FontWeight.bold)),
            DropdownButton<String>(
              value: torneoId,
              items: torneos.map((t) {
                return DropdownMenuItem(value: t.id, child: Text(t.nombre));
              }).toList(),
              onChanged: (v) => setState(() => torneoId = v),
              isExpanded: true,
            ),
            SizedBox(height: 16),
            Text("Tipo de notificación", style: TextStyle(fontWeight: FontWeight.bold)),
            DropdownButton<String>(
              value: tipoNotificacion,
              items: [
                DropdownMenuItem(value: 'cambio_horario', child: Text("Cambio de horario")),
                DropdownMenuItem(value: 'resultado', child: Text("Resultado de partido")),
                DropdownMenuItem(value: 'suspension', child: Text("Suspensión de partido")),
                DropdownMenuItem(value: 'general', child: Text("Alerta general")),
              ],
              onChanged: (v) => setState(() => tipoNotificacion = v!),
            ),
            SizedBox(height: 16),
            TextFormField(
              maxLines: 5,
              decoration: InputDecoration(
                labelText: "Mensaje",
                border: OutlineInputBorder(),
              ),
              onChanged: (v) => mensaje = v,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _enviarNotificacion,
              child: Text("Enviar Notificación"),
            ),
          ],
        ),
      ),
    );
  }
}