import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:weather_app_flutter/widgets/forecast_card.dart';

class ForecastWidget extends StatelessWidget {
  final List<dynamic> forecastData;

  const ForecastWidget({super.key, required this.forecastData});

  @override
  Widget build(BuildContext context) {
    final dailyForecasts = _getDailyForecasts();

    return Container(
      height: 180,
      padding: const EdgeInsets.all(16),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: dailyForecasts.length,
        itemBuilder: (context, index) {
          final forecast = dailyForecasts[index];
          return ForecastCard(forecast: forecast);
        },
      ),
    );
  }

  List<Map<String, dynamic>> _getDailyForecasts() {
    final Map<String, Map<String, dynamic>> dailyData = {};

    for (var item in forecastData) {
      final date = DateTime.parse(item['dt_txt']);
      final dateString = DateFormat('yyyy-MM-dd').format(date);

      if (!dailyData.containsKey(dateString)) {
        dailyData[dateString] = item;
      }
    }

    return dailyData.values.take(5).toList();
  }
}
