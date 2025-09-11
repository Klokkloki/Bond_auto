import 'package:flutter/material.dart';

class CarImageGallery extends StatelessWidget {
  final List<String> images;

  const CarImageGallery({super.key, required this.images});

  @override
  Widget build(BuildContext context) {
    if (images.isEmpty) {
      return Container(
        height: 200,
        color: Colors.grey[200],
        child: const Center(
          child: Icon(Icons.directions_car, size: 64, color: Colors.grey),
        ),
      );
    }

    return SizedBox(
      height: 200,
      child: PageView.builder(
        itemCount: images.length,
        itemBuilder: (context, index) {
          return Image.network(
            images[index],
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) => Container(
              color: Colors.grey[200],
              child: const Center(
                child: Icon(Icons.directions_car, size: 64, color: Colors.grey),
              ),
            ),
          );
        },
      ),
    );
  }
}




