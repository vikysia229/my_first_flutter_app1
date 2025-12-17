import 'dart:convert';
import 'package:http/http.dart' as http;

class WeatherService {
  static const String _apiKey = '4f8d4628007879d1e7fd99d17c6f85cb'; 
  static const String _baseUrl = 'https://api.openweathermap.org/data/2.5/weather';

  static Future<Map<String, dynamic>> getWeather(String city) async {
    final url = Uri.parse(
      '$_baseUrl?q=$city&appid=$_apiKey&units=metric&lang=ru',
    );

    try {
      final response = await http.get(url);
      
      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else if (response.statusCode == 404) {
        throw Exception('Город не найден');
      } else {
        throw Exception('Ошибка API: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Ошибка сети: $e');
    }
  }

  static Map<String, dynamic> parseWeatherData(Map<String, dynamic> data) {
    return {
      'city': data['name'],
      'temperature': data['main']['temp'].toDouble(),
      'feels_like': data['main']['feels_like'].toDouble(),
      'humidity': data['main']['humidity'],
      'pressure': data['main']['pressure'],
      'wind_speed': data['wind']['speed'].toDouble(),
      'description': data['weather'][0]['description'],
      'icon': data['weather'][0]['icon'],
      'timestamp': DateTime.now().toIso8601String(),
    };
  }

  static String formatTemperature(double temp) {
    return '${temp.toStringAsFixed(1)}°C';
  }

  static double celsiusToFahrenheit(double celsius) {
    return (celsius * 9 / 5) + 32;
  }

  static double fahrenheitToCelsius(double fahrenheit) {
    return (fahrenheit - 32) * 5 / 9;
  }
}