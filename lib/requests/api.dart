import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/nasa.dart';

class NasaApi {
  static const String _apiKey = '9lOb5FddMt1e6ZlDps8Kb5fUqkKFIXa6s5ky8G1Z';
  static const String _baseUrl = 'https://api.nasa.gov/planetary/apod';

  static Future<NasaApod> getApod() async {
    final Uri url = Uri.parse('$_baseUrl?api_key=$_apiKey');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonData = json.decode(response.body);
      return NasaApod.fromJson(jsonData);
    } else {
      throw Exception('Failed to load data: ${response.statusCode}');
    }
  }
}