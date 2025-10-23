import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class GalleryScreen extends StatelessWidget {
  const GalleryScreen({super.key});

  static const images = [
    {
      'url':
          'https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=400',
      'title': 'Горный пейзаж',
    },
    {
      'url':
          'https://images.unsplash.com/photo-1507525428034-b723cf961d3e?w=400',
      'title': 'Тропический пляж',
    },
    {
      'url':
          'https://images.unsplash.com/photo-1519681393784-d120267933ba?w=400',
      'title': 'Звёздное небо',
    },
    {
      'url': 'https://images.unsplash.com/photo-1441974231531-c6227db76b6e?w=400',
      'title': 'Лесная тропа',
    },
    {
      'url':
          'https://images.unsplash.com/photo-1470071459604-3b5ec3a7fe05?w=400',
      'title': 'Туманное озеро',
    },
    {
      'url':
          'https://images.unsplash.com/photo-1472214103451-9374bd1c798e?w=400',
      'title': 'Закат в горах',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Галерея')),
      body: GridView.builder(
        padding: const EdgeInsets.all(8),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 8,
          mainAxisSpacing: 8,
        ),
        itemCount: images.length,
        itemBuilder: (context, index) {
          final image = images[index];
          return Card(
            clipBehavior: Clip.antiAlias,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: CachedNetworkImage(
                    imageUrl: image['url']!,
                    fit: BoxFit.cover,
                    placeholder: (context, url) =>
                        const Center(child: CircularProgressIndicator()),
                    errorWidget: (context, url, error) =>
                        const Icon(Icons.broken_image),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8),
                  child: Text(
                    image['title']!,
                    style: const TextStyle(fontSize: 14),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
