// /widgets/action_card.dart
import 'package:flutter/material.dart';

class ActionCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final WidgetBuilder builder; // Cambiado a WidgetBuilder

  ActionCard({required this.icon, required this.label, required this.builder});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      child: InkWell(
        onTap: () => Navigator.push(context, MaterialPageRoute(builder: builder)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 40, color: Colors.blue),
            SizedBox(height: 10),
            Text(label, textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }
}