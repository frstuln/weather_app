import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ForecastCard extends StatelessWidget {
  final Map<String, dynamic> forecast;

  const ForecastCard({super.key, required this.forecast});

  @override
  Widget build(BuildContext context) {
    final date = DateTime.parse(forecast['dt_txt']);
    final temp = forecast['main']['temp'].round();
    final icon = forecast['weather'][0]['icon'];

    return Card(
      color: Colors.white.withOpacity(0.2),
      margin: const EdgeInsets.only(right: 16),
      child: Container(
        width: 100,
        padding: const EdgeInsets.all(8),
        child: Column(
          children: [
            Text(
              DateFormat('EEE').format(date),
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
              ),
            ),
            Image.network(
              'https://openweathermap.org/img/wn/$icon@2x.png',
              height: 50,
            ),
            Text(
              '$temp°',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
