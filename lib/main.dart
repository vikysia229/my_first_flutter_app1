import 'package:flutter/material.dart';
import 'screens/home_screen.dart';
import 'screens/developer_screen.dart';
import 'screens/calculator_screen.dart';

void main() {
  runApp(const WeatherApp());
}

class WeatherApp extends StatelessWidget {
  const WeatherApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Погодное приложение',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: const HomeScreen(),
      routes: {
        '/developer': (context) => const DeveloperScreen(),
        '/calculator': (context) => const CalculatorScreen(),
      },
    );
  }
}