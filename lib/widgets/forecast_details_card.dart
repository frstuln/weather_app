import 'package:flutter/material.dart';
import 'package:weather_app_flutter/widgets/details_row.dart';

class WeatherDetailsCard extends StatelessWidget {
  final Map<String, dynamic> weatherData;

  const WeatherDetailsCard({super.key, required this.weatherData});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.2),
          borderRadius: BorderRadius.circular(20),
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Weather Details',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            DetailRow(
              icon: Icons.thermostat,
              label: 'Feels Like',
              value: '${weatherData['main']['feels_like'].round()}°',
            ),
            DetailRow(
              icon: Icons.water_drop,
              label: 'Humidity',
              value: '${weatherData['main']['humidity']}%',
            ),
            DetailRow(
              icon: Icons.air,
              label: 'Wind Speed',
              value: '${weatherData['wind']['speed']} m/s',
            ),
            DetailRow(
              icon: Icons.compress,
              label: 'Pressure',
              value: '${weatherData['main']['pressure']} hPa',
            ),
          ],
        ),
      ),
    );
  }
}
