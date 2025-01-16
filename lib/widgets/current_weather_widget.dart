import 'package:flutter/material.dart';

class CurrentWeatherWidget extends StatelessWidget {
  final Map<String, dynamic> weatherData;

  const CurrentWeatherWidget({super.key, required this.weatherData});

  @override
  Widget build(BuildContext context) {
    final temp = weatherData['main']['temp'].round();
    final description = weatherData['weather'][0]['description'];
    final icon = weatherData['weather'][0]['icon'];

    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        children: [
          Text(
            weatherData['name'],
            style: const TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 10),
          Image.network(
            'https://openweathermap.org/img/wn/$icon@4x.png',
            height: 150,
          ),
          Text(
            '$temp°',
            style: const TextStyle(
              fontSize: 80,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          Text(
            description.toString().toUpperCase(),
            style: TextStyle(
              fontSize: 20,
              color: Colors.white.withOpacity(0.8),
            ),
          ),
        ],
      ),
    );
  }
}
