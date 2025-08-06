// widgets/comentarios_list.dart
import 'package:flutter/material.dart';

class ComentariosList extends StatefulWidget {
  const ComentariosList({super.key});
  @override
  ComentariosListState createState() => ComentariosListState();
}

class ComentariosListState extends State<ComentariosList> {
  final List<String> comentarios = [
    'Gran jugador, sigue así!',
    'Excelente desempeño en el último partido.',
  ];
  final TextEditingController _controller = TextEditingController();

  void _agregarComentario() {
    if (_controller.text.isNotEmpty) {
      setState(() {
        comentarios.add(_controller.text);
      });
      _controller.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: comentarios.length,
          itemBuilder: (context, index) {
            return Card(
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: Text(comentarios[index]),
              ),
            );
          },
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: _controller,
                decoration: const InputDecoration(
                  hintText: 'Agrega un comentario...',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            IconButton(
              onPressed: _agregarComentario,
              icon: const Icon(Icons.send),
            ),
          ],
        ),
      ],
    );
  }
}