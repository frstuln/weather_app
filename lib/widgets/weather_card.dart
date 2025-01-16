import 'package:flutter/material.dart';

class WeatherCard extends StatelessWidget {
  final Map<String, dynamic> weatherData;

  const WeatherCard({super.key, required this.weatherData});

  @override
  Widget build(BuildContext context) {
    final temp = weatherData['main']['temp'].round();
    final description = weatherData['weather'][0]['description'];
    final icon = weatherData['weather'][0]['icon'];

    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              weatherData['name'],
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 10),
            Image.network(
              'https://openweathermap.org/img/wn/$icon@2x.png',
              height: 100,
            ),
            Text(
              '$temp°C',
              style: Theme.of(context).textTheme.displayMedium,
            ),
            Text(
              description.toString().toUpperCase(),
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ],
        ),
      ),
    );
  }
}
