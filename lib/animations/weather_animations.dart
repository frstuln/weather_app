import 'package:flutter/material.dart';
import 'package:weather_app_flutter/animations/rain_animation.dart';

class WeatherAnimation extends StatelessWidget {
  final String weatherCondition;

  const WeatherAnimation({super.key, required this.weatherCondition});

  @override
  Widget build(BuildContext context) {
    switch (weatherCondition.toLowerCase()) {
      case 'rain':
        return RainAnimation();
      case 'snow':
        // return SnowAnimation();
        return RainAnimation();
      case 'clouds':
        // return CloudAnimation();
        return RainAnimation();
      default:
        // return SunAnimation();
        return RainAnimation();
    }
  }
}
