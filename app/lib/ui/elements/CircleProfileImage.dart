import 'package:flutter/material.dart';

class CircleProfileImage {
  final String imageUrl;
  final double size;

  CircleProfileImage({required this.imageUrl, required this.size});

  Widget build() {
    return SizedBox(
      width: 20,
      height: 50,
      child: ClipOval(
        child: Image.network(imageUrl,
            width: size, height: size, fit: BoxFit.cover),
      ),
    );
  }
}

