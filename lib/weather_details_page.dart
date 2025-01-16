import 'package:flutter/material.dart';
import 'package:weather_app_flutter/widgets/details_row.dart';

class WeatherDetails extends StatelessWidget {
  final Map<String, dynamic> weatherData;

  const WeatherDetails({super.key, required this.weatherData});

  @override
  Widget build(BuildContext context) {
    final humidity = weatherData['main']['humidity'];
    final pressure = weatherData['main']['pressure'];
    final windSpeed = weatherData['wind']['speed'];

    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Weather Details',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 10),
            DetailRow(
                icon: Icons.water_drop, label: 'Humidity', value: '$humidity%'),
            DetailRow(
                icon: Icons.speed, label: 'Pressure', value: '$pressure hPa'),
            DetailRow(
                icon: Icons.air, label: 'Wind Speed', value: '$windSpeed m/s'),
          ],
        ),
      ),
    );
  }
}
