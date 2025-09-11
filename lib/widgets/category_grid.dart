import 'dart:ui';
import 'package:flutter/material.dart';

class CategoryGrid extends StatelessWidget {
  const CategoryGrid({super.key});

  @override
  Widget build(BuildContext context) {
    final categories = [
      {'label': 'Новые', 'icon': Icons.fiber_new},
      {'label': 'С пробегом', 'icon': Icons.speed},
      {'label': 'Мото', 'icon': Icons.motorcycle},
      {'label': 'Комтранс', 'icon': Icons.local_shipping},
      {'label': 'Б/у', 'icon': Icons.directions_car},
    ];

    return SizedBox(
      height: 100,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          final cat = categories[index];
          return Column(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(18),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                  child: Container(
                    width: 72,
                    height: 72,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.08),
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(color: Colors.white.withOpacity(0.12)),
                    ),
                    child: Icon(
                      cat['icon'] as IconData,
                      color: Colors.black54,
                      size: 32,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 6),
              Text(
                cat['label'] as String,
                style: const TextStyle(fontSize: 12, color: Colors.black),
              ),
            ],
          );
        },
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        itemCount: categories.length,
      ),
    );
  }
}

