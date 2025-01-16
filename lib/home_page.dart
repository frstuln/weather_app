import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:weather_app_flutter/repository/weather_repo.dart';
import 'package:weather_app_flutter/services/fcm_service.dart';
import 'package:weather_app_flutter/widgets/current_weather_widget.dart';
import 'package:weather_app_flutter/widgets/forecast_details_card.dart';
import 'package:weather_app_flutter/widgets/forecast_widget.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:weather_app_flutter/widgets/temp.dart';

class WeatherHomePage extends StatefulWidget {
  const WeatherHomePage({super.key});

  @override
  State<WeatherHomePage> createState() => _WeatherHomePageState();
}

class _WeatherHomePageState extends State<WeatherHomePage> {
  final NotificationService _notificationService = NotificationService();
  final WeatherRepository _weatherRepository = WeatherRepository();
  List<Map<String, dynamic>> weatherHistory = [];

  @override
  void initState() {
    super.initState();
    _initializeServices();
    fetchWeatherData();
  }

  Future<void> _initializeServices() async {
    await _notificationService.initialize();
    await _loadWeatherHistory();
  }

  Future<void> _loadWeatherHistory() async {
    weatherHistory = await _weatherRepository.getWeatherHistory();
    setState(() {});
  }

  String apiKey = 'bd72a6964b94dcd2fb9af7d5f36f5b87';
  String city = 'London';
  Map<String, dynamic>? weatherData;
  List<dynamic>? forecastData;
  bool isLoading = false;
  final TextEditingController _cityController = TextEditingController();

  Future<void> fetchWeatherData() async {
    setState(() {
      isLoading = true;
    });

    try {
      // Fetch current weather
      final weatherResponse = await http.get(Uri.parse(
          'https://api.openweathermap.org/data/2.5/weather?q=$city&appid=$apiKey&units=metric'));

      // Fetch 5-day forecast
      final forecastResponse = await http.get(Uri.parse(
          'https://api.openweathermap.org/data/2.5/forecast?q=$city&appid=$apiKey&units=metric'));

      if (weatherResponse.statusCode == 200 &&
          forecastResponse.statusCode == 200) {
        setState(() {
          weatherData = json.decode(weatherResponse.body);
          forecastData = json.decode(forecastResponse.body)['list'];
          isLoading = false;
        });
        await _weatherRepository.saveWeatherHistory(weatherData ?? {});
      } else {
        throw Exception('Failed to load weather data');
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      if (mounted) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Error'),
            content: Text('Failed to fetch weather data: ${e.toString()}'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('OK'),
              ),
            ],
          ),
        );
      }
    }
  }

  Widget _buildDetailedForecast() {
    if (forecastData == null) return const SizedBox.shrink();

    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Detailed Forecast',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 300,
            child: charts.TimeSeriesChart(
              _createChartData(),
              animate: true,
              dateTimeFactory: const charts.LocalDateTimeFactory(),
              primaryMeasureAxis: charts.NumericAxisSpec(
                tickProviderSpec: charts.BasicNumericTickProviderSpec(
                  desiredTickCount: 5,
                ),
              ),
              domainAxis: charts.DateTimeAxisSpec(
                renderSpec: charts.SmallTickRendererSpec(
                  labelStyle: charts.TextStyleSpec(
                    color: charts.MaterialPalette.white,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<charts.Series<TimeSeriesTemperature, DateTime>> _createChartData() {
    final data = forecastData!.map((item) {
      return TimeSeriesTemperature(
        DateTime.parse(item['dt_txt']),
        item['main']['temp'].toDouble(),
      );
    }).toList();

    return [
      charts.Series<TimeSeriesTemperature, DateTime>(
        id: 'Temperature',
        colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
        domainFn: (TimeSeriesTemperature temp, _) => temp.time,
        measureFn: (TimeSeriesTemperature temp, _) => temp.temperature,
        data: data,
      )
    ];
  }

  LinearGradient _getBackgroundGradient() {
    if (weatherData == null) return _getDefaultGradient();

    final condition =
        weatherData!['weather'][0]['main'].toString().toLowerCase();
    final hour = DateTime.now().hour;
    final isNight = hour < 6 || hour > 18;

    if (isNight) {
      return const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [Color(0xFF1a237e), Color(0xFF000051)],
      );
    }

    switch (condition) {
      case 'clear':
        return const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF4CAF50), Color(0xFF2196F3)],
        );
      case 'clouds':
        return const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF90A4AE), Color(0xFF546E7A)],
        );
      case 'rain':
        return const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF616161), Color(0xFF212121)],
        );
      default:
        return _getDefaultGradient();
    }
  }

  LinearGradient _getDefaultGradient() {
    return const LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [Color(0xFF1976D2), Color(0xFF0D47A1)],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: _getBackgroundGradient(),
        ),
        child: SafeArea(
          child: isLoading
              ? const Center(child: CircularProgressIndicator())
              : CustomScrollView(
                  slivers: [
                    SliverAppBar(
                      floating: true,
                      backgroundColor: Colors.transparent,
                      elevation: 0,
                      title: Row(
                        children: [
                          Expanded(
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(30),
                              ),
                              child: TextField(
                                controller: _cityController,
                                style: const TextStyle(color: Colors.white),
                                decoration: InputDecoration(
                                  hintText: 'Enter city name',
                                  hintStyle: TextStyle(
                                      color: Colors.white.withOpacity(0.7)),
                                  prefixIcon: const Icon(Icons.search,
                                      color: Colors.white),
                                  border: InputBorder.none,
                                  // contentPadding: const EdgeInsets.symmetric(
                                  //     horizontal: 20),
                                ),
                                onSubmitted: (value) {
                                  setState(() {
                                    city = value;
                                  });
                                  fetchWeatherData();
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (weatherData != null)
                      SliverList(
                        delegate: SliverChildListDelegate([
                          CurrentWeatherWidget(weatherData: weatherData!),
                          if (forecastData != null)
                            ForecastWidget(forecastData: forecastData!),
                          WeatherDetailsCard(weatherData: weatherData!),
                        ]),
                      ),
                  ],
                ),
        ),
      ),
    );
  }
}
