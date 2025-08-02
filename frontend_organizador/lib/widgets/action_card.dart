// /widgets/action_card.dart
import 'package:flutter/material.dart';

class ActionCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String routeName;

  ActionCard({required this.icon, required this.label, required this.routeName});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: () => Navigator.pushNamed(context, routeName),
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