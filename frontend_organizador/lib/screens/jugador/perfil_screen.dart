// screens/jugador/perfil_screen.dart
import 'package:flutter/material.dart';

class PerfilScreen extends StatelessWidget {
  final Map<String, dynamic> usuario;

  const PerfilScreen({Key? key, required this.usuario}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final info = usuario['jugadorInfo'];

    return Scaffold(
      appBar: AppBar(
        title: Text("Mi Perfil"),
        backgroundColor: Color(0xFF1565C0),
      ),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              radius: 50,
              backgroundColor: Colors.blue,
              child: Text(
                usuario['nombre'][0].toUpperCase(),
                style: TextStyle(fontSize: 40, color: Colors.white),
              ),
            ),
            SizedBox(height: 20),
            Text("Nombre: ${usuario['nombre']}", style: TextStyle(fontSize: 18)),
            Text("Email: ${usuario['email']}", style: TextStyle(fontSize: 18)),
            if (info != null) ...[
              SizedBox(height: 10),
              Text("Edad: ${info['edad']} años", style: TextStyle(fontSize: 18)),
              Text("Posición: ${info['posicionPrincipal']}", style: TextStyle(fontSize: 18)),
              if (info['posicionSecundaria'].isNotEmpty)
                Text("Posición secundaria: ${info['posicionSecundaria']}", style: TextStyle(fontSize: 18)),
              if (info['numeroCamiseta'] != null)
                Text("Camiseta: #${info['numeroCamiseta']}", style: TextStyle(fontSize: 18)),
              Text("Género: ${info['genero']}", style: TextStyle(fontSize: 18)),
              if (info['telefono'].isNotEmpty)
                Text("Teléfono: ${info['telefono']}", style: TextStyle(fontSize: 18)),
            ],
            SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {
                // Editar perfil (futuro)
              },
              child: Text("Editar Perfil"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF1565C0),
                padding: EdgeInsets.symmetric(horizontal: 30, vertical: 12),
              ),
            )
          ],
        ),
      ),
    );
  }
}