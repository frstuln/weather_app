import 'package:cloud_firestore/cloud_firestore.dart';

class WeatherRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> saveWeatherHistory(Map<String, dynamic> weatherData) async {
    await _firestore.collection('weather_history').add({
      'timestamp': FieldValue.serverTimestamp(),
      'data': weatherData,
    });
  }

  Future<List<Map<String, dynamic>>> getWeatherHistory() async {
    final snapshot = await _firestore
        .collection('weather_history')
        .orderBy('timestamp', descending: true)
        .limit(10)
        .get();

    return snapshot.docs.map((doc) => doc.data()).toList();
  }
}
