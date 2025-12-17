import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../services/weather_service.dart';
import '../services/storage_service.dart';

class CalculatorScreen extends StatefulWidget {
  const CalculatorScreen({super.key});

  @override
  State<CalculatorScreen> createState() => CalculatorScreenState();
}

class CalculatorScreenState extends State<CalculatorScreen> {
  final TextEditingController _celsiusController = TextEditingController();
  final TextEditingController _fahrenheitController = TextEditingController();
  List<Map<String, dynamic>> _calculationsHistory = [];
  String _lastConversion = '';

  @override
  void initState() {
    super.initState();
    _loadHistory();
  }

  Future<void> _loadHistory() async {
    final history = await StorageService.getCalculationsHistory();
    if (mounted) {
      setState(() {
        _calculationsHistory = history;
      });
    }
  }

  void _convertCelsiusToFahrenheit() {
    final celsiusText = _celsiusController.text;
    if (celsiusText.isEmpty) return;

    try {
      final celsius = double.parse(celsiusText);
      final fahrenheit = WeatherService.celsiusToFahrenheit(celsius);
      
      _fahrenheitController.text = fahrenheit.toStringAsFixed(2);
      
      final conversion = '$celsius°C = ${fahrenheit.toStringAsFixed(2)}°F';
      _saveCalculation(conversion);
      
      setState(() {
        _lastConversion = conversion;
      });
    } catch (e) {
      _showError('Введите корректное число');
    }
  }

  void _convertFahrenheitToCelsius() {
    final fahrenheitText = _fahrenheitController.text;
    if (fahrenheitText.isEmpty) return;

    try {
      final fahrenheit = double.parse(fahrenheitText);
      final celsius = WeatherService.fahrenheitToCelsius(fahrenheit);
      
      _celsiusController.text = celsius.toStringAsFixed(2);
      
      final conversion = '$fahrenheit°F = ${celsius.toStringAsFixed(2)}°C';
      _saveCalculation(conversion);
      
      setState(() {
        _lastConversion = conversion;
      });
    } catch (e) {
      _showError('Введите корректное число');
    }
  }

  Future<void> _saveCalculation(String calculation) async {
    await StorageService.saveCalculation(calculation);
    _loadHistory(); 
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }

  void _clearFields() {
    _celsiusController.clear();
    _fahrenheitController.clear();
    setState(() {
      _lastConversion = '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Конвертер температур'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              elevation: 3,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    const Text(
                      'Формулы конвертации',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      '°F = (°C × 9/5) + 32',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.blue[700],
                        fontFamily: 'monospace',
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '°C = (°F - 32) × 5/9',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.blue[700],
                        fontFamily: 'monospace',
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Поля ввода
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    children: [
                      const Text(
                        'Цельсий (°C)',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      TextField(
                        controller: _celsiusController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: '0.0',
                          suffixText: '°C',
                        ),
                        onChanged: (_) {
                          _fahrenheitController.clear();
                        },
                      ),
                      const SizedBox(height: 10),
                      ElevatedButton.icon(
                        onPressed: _convertCelsiusToFahrenheit,
                        icon: const Icon(Icons.arrow_downward),
                        label: const Text('В Фаренгейты'),
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size.fromHeight(48),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: Column(
                    children: [
                      const Text(
                        'Фаренгейт (°F)',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      TextField(
                        controller: _fahrenheitController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: '32.0',
                          suffixText: '°F',
                        ),
                        onChanged: (_) {
                          _celsiusController.clear();
                        },
                      ),
                      const SizedBox(height: 10),
                      ElevatedButton.icon(
                        onPressed: _convertFahrenheitToCelsius,
                        icon: const Icon(Icons.arrow_upward),
                        label: const Text('В Цельсии'),
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size.fromHeight(48),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            if (_lastConversion.isNotEmpty)
              Card(
                color: Colors.green[50],
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Row(
                    children: [
                      const Icon(Icons.check_circle, color: Colors.green),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          'Последняя конвертация: $_lastConversion',
                          style: const TextStyle(fontSize: 16),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            const SizedBox(height: 20),

            OutlinedButton.icon(
              onPressed: _clearFields,
              icon: const Icon(Icons.clear),
              label: const Text('Очистить поля'),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
            ),
            const SizedBox(height: 20),

            Card(
              elevation: 3,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'История расчетов',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        if (_calculationsHistory.isNotEmpty)
                          IconButton(
                            icon: const Icon(Icons.delete),
                            onPressed: () async {
                              await StorageService.clearHistory('calculations_history');
                              _loadHistory();
                            },
                            tooltip: 'Очистить историю',
                          ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    if (_calculationsHistory.isEmpty)
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 20),
                        child: Center(
                          child: Text('История расчетов пуста'),
                        ),
                      )
                    else
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: _calculationsHistory.length,
                        itemBuilder: (context, index) {
                          final item = _calculationsHistory[index];
                          final date = DateFormat('dd.MM.yyyy HH:mm').format(
                            DateTime.parse(item['timestamp']),
                          );
                          
                          return Card(
                            margin: const EdgeInsets.symmetric(vertical: 4),
                            child: ListTile(
                              leading: const Icon(Icons.calculate, color: Colors.blue),
                              title: Text(item['calculation']),
                              subtitle: Text(date),
                              dense: true,
                            ),
                          );
                        },
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}