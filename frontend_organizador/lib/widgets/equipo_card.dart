import 'package:flutter/material.dart';

/// Tarjeta bonita y responsiva para cada equipo
class EquipoCard extends StatelessWidget {
  final String nombre;
  final String capitan;
  final VoidCallback onAprobar;
  final VoidCallback onRechazar;

  const EquipoCard({
    super.key,
    required this.nombre,
    required this.capitan,
    required this.onAprobar,
    required this.onRechazar,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final txt = Theme.of(context).textTheme;

    return Card(
      elevation: 0,
      color: cs.surface,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Avatar
            CircleAvatar(
              radius: 24,
              backgroundColor: cs.primaryContainer,
              child: Icon(Icons.group, color: cs.onPrimaryContainer),
            ),
            const SizedBox(width: 12),

            // Texto flexible
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Nombre del equipo
                  Text(
                    nombre,
                    style: txt.titleMedium?.copyWith(fontWeight: FontWeight.w600),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 6),

                  // Capitán
                  Row(
                    children: [
                      Icon(Icons.person_outline, size: 18, color: cs.onSurfaceVariant),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          "Capitán: $capitan",
                          style: txt.bodyMedium?.copyWith(color: cs.onSurfaceVariant),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 12),

                  // Acciones (se adaptan al espacio)
                  Wrap(
                    spacing: 12,
                    runSpacing: 8,
                    children: [
                      FilledButton.icon(
                        onPressed: onAprobar,
                        icon: const Icon(Icons.check_rounded),
                        label: const Text("Aprobar"),
                      ),
                      OutlinedButton.icon(
                        onPressed: onRechazar,
                        icon: const Icon(Icons.close_rounded),
                        label: const Text("Rechazar"),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: cs.error,
                          side: BorderSide(color: cs.error),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}