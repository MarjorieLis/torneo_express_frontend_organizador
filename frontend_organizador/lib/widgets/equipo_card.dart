import 'package:flutter/material.dart';
import 'package:frontend_organizador/models/equipo.dart'; // ✅ Importa el modelo

/// Tarjeta bonita y responsiva para cada equipo
class EquipoCard extends StatelessWidget {
  final Equipo equipo; 
  final VoidCallback onAprobar;
  final VoidCallback onRechazar;

  const EquipoCard({
    super.key,
    required this.equipo, 
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
                    equipo.nombre, // ✅ Usar equipo.nombre
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
                          "Capitán: ${equipo.capitanNombre ?? 'Sin capitán'}", // ✅ Usar equipo.capitanNombre
                          style: txt.bodyMedium?.copyWith(color: cs.onSurfaceVariant),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 8),

                  // ✅ Mostrar lista de jugadores
                  Wrap(
                    spacing: 4,
                    runSpacing: 2,
                    children: [
                      for (var jugador in equipo.jugadores)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: cs.primaryContainer,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            jugador.nombre,
                            style: txt.bodySmall?.copyWith(
                              color: cs.onPrimaryContainer,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                    ],
                  ),

                  const SizedBox(height: 12),

                  // Acciones
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