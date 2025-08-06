// widgets/multimedia_grid.dart
import 'package:flutter/material.dart';

class MultimediaGrid extends StatelessWidget {
  const MultimediaGrid({super.key, required this.videos});

  final List<String> videos;

  @override
  Widget build(BuildContext context) {
    if (videos.isEmpty) {
      return Center(child: Text('No hay videos disponibles'));
    }

    return GridView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
        childAspectRatio: 16 / 9,
      ),
      itemCount: videos.length,
      itemBuilder: (context, index) {
        return Card(
          child: Image.network(videos[index], fit: BoxFit.cover),
        );
      },
    );
  }
}