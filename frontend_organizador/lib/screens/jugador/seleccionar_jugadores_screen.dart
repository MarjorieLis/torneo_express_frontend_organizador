import 'package:flutter/material.dart';
import 'package:frontend_organizador/models/jugador.dart';

class SeleccionarJugadoresScreen extends StatefulWidget {
  final List<Jugador> disponibles;
  final List<Jugador> preseleccionados;

  const SeleccionarJugadoresScreen({
    Key? key,
    required this.disponibles,
    required this.preseleccionados,
  }) : super(key: key);

  @override
  State<SeleccionarJugadoresScreen> createState() =>
      _SeleccionarJugadoresScreenState();
}

class _SeleccionarJugadoresScreenState
    extends State<SeleccionarJugadoresScreen> {
  final TextEditingController _search = TextEditingController();
  late List<Jugador> _filtrados;
  late List<Jugador> _seleccionLocal;

  @override
  void initState() {
    super.initState();
    _filtrados = List.of(widget.disponibles);
    _seleccionLocal = List.of(widget.preseleccionados);
    _search.addListener(_aplicarFiltro);
  }

  @override
  void dispose() {
    _search.removeListener(_aplicarFiltro);
    _search.dispose();
    super.dispose();
  }

  void _aplicarFiltro() {
    final q = _search.text.trim().toLowerCase();
    setState(() {
      if (q.isEmpty) {
        _filtrados = List.of(widget.disponibles);
      } else {
        _filtrados = widget.disponibles.where((j) {
          final nombre = j.nombreCompleto.toLowerCase();
          final correo = (j.email ?? '').toLowerCase();
          final cedula = (j.cedula ?? '').toLowerCase();
          return nombre.contains(q) || correo.contains(q) || cedula.contains(q);
        }).toList();
      }
    });
  }

  bool _estaSeleccionado(Jugador j) => _seleccionLocal.any((x) => x.id == j.id);

  void _toggle(Jugador j) {
    final yaEnEquipo = j.equipoId != null && j.equipoId!.isNotEmpty;
    if (yaEnEquipo) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("${j.nombreCompleto} ya pertenece a un equipo")),
      );
      return;
    }
    setState(() {
      if (_estaSeleccionado(j)) {
        _seleccionLocal.removeWhere((x) => x.id == j.id);
      } else {
        _seleccionLocal.add(j);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final txt = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Seleccionar Jugadores"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, _seleccionLocal),
            child: const Text("Confirmar"),
          )
        ],
      ),
      body: Column(
        children: [
          // Buscador fijo arriba
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
            child: TextField(
              controller: _search,
              decoration: const InputDecoration(
                hintText: "Buscar por nombre, cédula o correo",
                prefixIcon: Icon(Icons.search),
              ),
            ),
          ),

          // Chips con seleccionados (visión rápida)
          if (_seleccionLocal.isNotEmpty)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Wrap(
                spacing: 8,
                runSpacing: 8,
                children: _seleccionLocal.map((j) {
                  return InputChip(
                    label:
                        Text(j.nombreCompleto, overflow: TextOverflow.ellipsis),
                    onDeleted: () => _toggle(j),
                  );
                }).toList(),
              ),
            ),

          // Lista grande
          Expanded(
            child: _filtrados.isEmpty
                ? Center(
                    child: Text(
                      "Sin resultados",
                      style:
                          txt.bodyMedium?.copyWith(color: cs.onSurfaceVariant),
                    ),
                  )
                : ListView.separated(
                    itemCount: _filtrados.length,
                    separatorBuilder: (_, __) => const Divider(height: 1),
                    itemBuilder: (context, i) {
                      final j = _filtrados[i];
                      final seleccionado = _estaSeleccionado(j);
                      final bloqueado =
                          j.equipoId != null && j.equipoId!.isNotEmpty;
                      return ListTile(
                        leading: CircleAvatar(
                            child: Text(j.nombreCompleto.isNotEmpty
                                ? j.nombreCompleto[0]
                                : '?')),
                        title: Text(j.nombreCompleto,
                            maxLines: 1, overflow: TextOverflow.ellipsis),
                        subtitle:
                            Text("Posición: ${j.posicionPrincipal ?? '—'}"),
                        trailing: bloqueado
                            ? const Icon(Icons.block, color: Colors.red)
                            : Checkbox(
                                value: seleccionado,
                                onChanged: (_) => _toggle(j),
                              ),
                        onTap: () => _toggle(j),
                      );
                    },
                  ),
          ),
        ],
      ),

      // Barra inferior con contador y confirmar
      bottomNavigationBar: SafeArea(
        minimum: const EdgeInsets.all(16),
        child: Row(
          children: [
            Expanded(
              child: OutlinedButton.icon(
                onPressed: () => setState(() => _seleccionLocal.clear()),
                icon: const Icon(Icons.clear_all),
                label: const Text("Limpiar"),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: FilledButton.icon(
                onPressed: () => Navigator.pop(context, _seleccionLocal),
                icon: const Icon(Icons.check),
                label: Text("Confirmar (${_seleccionLocal.length})"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
