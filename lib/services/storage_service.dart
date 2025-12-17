import 'dart:convert'; 
import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  static const String _weatherHistoryKey = 'weather_history';
  static const String _calculationsHistoryKey = 'calculations_history';
  static const int _maxHistoryItems = 10;

  static Future<void> saveWeatherQuery(Map<String, dynamic> weatherData) async {
    final prefs = await SharedPreferences.getInstance();
    final history = await getWeatherHistory();
    
    history.insert(0, weatherData);
    
    if (history.length > _maxHistoryItems) {
      history.removeLast();
    }
    
    final jsonString = json.encode(history);
    await prefs.setString(_weatherHistoryKey, jsonString);
  }

  static Future<List<Map<String, dynamic>>> getWeatherHistory() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_weatherHistoryKey);
    
    if (jsonString != null && jsonString.isNotEmpty) {
      final List<dynamic> jsonList = json.decode(jsonString);
      return jsonList.cast<Map<String, dynamic>>();
    }
    
    return [];
  }

  static Future<void> saveCalculation(String calculation) async {
    final prefs = await SharedPreferences.getInstance();
    final history = await getCalculationsHistory();
    
    history.insert(0, {
      'calculation': calculation,
      'timestamp': DateTime.now().toIso8601String(),
    });
    
    if (history.length > _maxHistoryItems) {
      history.removeLast();
    }
    
    final jsonString = json.encode(history);
    await prefs.setString(_calculationsHistoryKey, jsonString);
  }

  static Future<List<Map<String, dynamic>>> getCalculationsHistory() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_calculationsHistoryKey);
    
    if (jsonString != null && jsonString.isNotEmpty) {
      final List<dynamic> jsonList = json.decode(jsonString);
      return jsonList.cast<Map<String, dynamic>>();
    }
    
    return [];
  }

  static Future<void> clearHistory(String key) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(key);
  }
}