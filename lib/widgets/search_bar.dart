import 'dart:ui';
import 'package:flutter/material.dart';

class SearchBar extends StatelessWidget {
  final TextEditingController? controller;
  final String? hintText;
  final VoidCallback? onTap;
  final ValueChanged<String>? onChanged;

  const SearchBar({
    super.key,
    this.controller,
    this.hintText,
    this.onTap,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.10),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.white.withOpacity(0.15)),
          ),
          child: Row(
            children: [
              const Icon(Icons.directions_car, color: Colors.black54),
              const SizedBox(width: 10),
              Expanded(
                child: TextField(
                  controller: controller,
                  onTap: onTap,
                  onChanged: onChanged,
                  style: const TextStyle(color: Colors.black87),
                  decoration: InputDecoration.collapsed(
                    hintText: hintText ?? 'Марка, модель, VIN',
                    hintStyle: const TextStyle(color: Colors.black54),
                  ),
                ),
              ),
              const Icon(Icons.tune, color: Colors.black54),
            ],
          ),
        ),
      ),
    );
  }
}

