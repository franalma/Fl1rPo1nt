import 'package:flutter/material.dart';

class Gradient1 {
  SweepGradient get(List<Color> colors) {
    return SweepGradient(
        colors: colors,
        center: Alignment.center, // Center of the sweep
        startAngle: 0.0,
        endAngle: 3.14 * 2); // Full circle
  }
}
