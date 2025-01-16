import 'package:flutter/material.dart';
import 'package:simple_animations/animation_builder/custom_animation_builder.dart';
import 'package:weather_app_flutter/animations/rain_drop.dart';

class RainAnimation extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CustomAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: const Duration(seconds: 2),
      builder: (context, value, child) {
        return CustomPaint(
          painter: RainDrop(value),
          size: const Size(double.infinity, double.infinity),
        );
      },
    );
  }
}
