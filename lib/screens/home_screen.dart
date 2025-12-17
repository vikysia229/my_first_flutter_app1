import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import '../services/weather_service.dart';
import '../services/storage_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  final TextEditingController _cityController = TextEditingController();
  Map<String, dynamic>? _currentWeather;
  List<Map<String, dynamic>> _weatherHistory = [];
  bool _isLoading = false;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _loadHistory();
  }

  Future<void> _loadHistory() async {
    final history = await StorageService.getWeatherHistory();
    if (mounted) {
      setState(() {
        _weatherHistory = history;
      });
    }
  }

  Future<void> _getWeather() async {
    final city = _cityController.text.trim();
    if (city.isEmpty) return;

    if (mounted) {
      setState(() {
        _isLoading = true;
        _errorMessage = '';
      });
    }

    try {
      final data = await WeatherService.getWeather(city);
      final parsedData = WeatherService.parseWeatherData(data);
      
      await StorageService.saveWeatherQuery(parsedData);
      
      if (mounted) {
        setState(() {
          _currentWeather = parsedData;
        });
        _loadHistory(); 
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = e.toString();
          _currentWeather = null;
        });
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _openWeatherForecast() async {
    const url = 'https://openweathermap.org/weathermap';
    final uri = Uri.parse(url);
    
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Не удалось открыть ссылку')),
        );
      }
    }
  }

  void _navigateToDeveloperScreen() {
    Navigator.pushNamed(context, '/developer');
  }

  void _navigateToCalculatorScreen() {
    Navigator.pushNamed(context, '/calculator');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Погодное приложение'),
        actions: [
          IconButton(
            icon: const Icon(Icons.calculate),
            onPressed: _navigateToCalculatorScreen,
            tooltip: 'Конвертер температур',
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(color: Colors.blue),
              child: Text(
                'Меню',
                style: TextStyle(color: Colors.white, fontSize: 24),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.home),
              title: const Text('Главная'),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              leading: const Icon(Icons.person),
              title: const Text('Разработчик'),
              onTap: _navigateToDeveloperScreen,
            ),
            ListTile(
              leading: const Icon(Icons.calculate),
              title: const Text('Конвертер температур'),
              onTap: _navigateToCalculatorScreen,
            ),
            ListTile(
              leading: const Icon(Icons.language),
              title: const Text('Прогноз погоды онлайн'),
              onTap: _openWeatherForecast,
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _cityController,
                      decoration: const InputDecoration(
                        labelText: 'Введите город',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.search),
                      ),
                      onSubmitted: (_) => _getWeather(),
                    ),
                  ),
                  const SizedBox(width: 10),
                  ElevatedButton.icon(
                    onPressed: _isLoading ? null : _getWeather,
                    icon: const Icon(Icons.search),
                    label: const Text('Найти'),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              if (_isLoading)
                const Center(child: CircularProgressIndicator()),

              if (_errorMessage.isNotEmpty)
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.red[50],
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.red),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.error, color: Colors.red),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          _errorMessage,
                          style: const TextStyle(color: Colors.red),
                        ),
                      ),
                    ],
                  ),
                ),

              if (_currentWeather != null) ...[
                Card(
                  elevation: 4,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        Text(
                          _currentWeather!['city'],
                          style: Theme.of(context).textTheme.headlineSmall,
                        ),
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.network(
                              'https://openweathermap.org/img/wn/${_currentWeather!['icon']}@2x.png',
                              width: 80,
                              height: 80,
                            ),
                            Text(
                              WeatherService.formatTemperature(_currentWeather!['temperature']),
                              style: const TextStyle(fontSize: 48),
                            ),
                          ],
                        ),
                        Text(
                          _currentWeather!['description'],
                          style: Theme.of(context).textTheme.titleMedium,
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 20),
                        Wrap(
                          spacing: 20,
                          runSpacing: 10,
                          alignment: WrapAlignment.spaceAround,
                          children: [
                            _buildWeatherDetail(
                              'Ощущается',
                              '${_currentWeather!['feels_like'].toStringAsFixed(1)}°C',
                              Icons.thermostat,
                            ),
                            _buildWeatherDetail(
                              'Влажность',
                              '${_currentWeather!['humidity']}%',
                              Icons.water_drop,
                            ),
                            _buildWeatherDetail(
                              'Ветер',
                              '${_currentWeather!['wind_speed'].toStringAsFixed(1)} м/с',
                              Icons.air,
                            ),
                            _buildWeatherDetail(
                              'Давление',
                              '${_currentWeather!['pressure']} гПа',
                              Icons.compress,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
              ],

              ElevatedButton.icon(
                onPressed: _openWeatherForecast,
                icon: const Icon(Icons.open_in_browser),
                label: const Text('Открыть карту погоды онлайн'),
                style: ElevatedButton.styleFrom(
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
                            'История запросов',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          if (_weatherHistory.isNotEmpty)
                            IconButton(
                              icon: const Icon(Icons.delete),
                              onPressed: () async {
                                await StorageService.clearHistory('weather_history');
                                _loadHistory();
                              },
                              tooltip: 'Очистить историю',
                            ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      if (_weatherHistory.isEmpty)
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 20),
                          child: Center(
                            child: Text('История запросов пуста'),
                          ),
                        )
                      else
                        ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: _weatherHistory.length,
                          itemBuilder: (context, index) {
                            final item = _weatherHistory[index];
                            final date = DateFormat('dd.MM.yyyy HH:mm').format(
                              DateTime.parse(item['timestamp']),
                            );
                            
                            return ListTile(
                              leading: Image.network(
                                'https://openweathermap.org/img/wn/${item['icon']}.png',
                                width: 40,
                                height: 40,
                              ),
                              title: Text(item['city']),
                              subtitle: Text(
                                '${item['temperature'].toStringAsFixed(1)}°C • $date',
                              ),
                              trailing: Text(item['description']),
                              dense: true,
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
      ),
    );
  }

  Widget _buildWeatherDetail(String title, String value, IconData icon) {
    return Column(
      children: [
        Icon(icon, color: Colors.blue),
        const SizedBox(height: 5),
        Text(title, style: const TextStyle(fontSize: 12)),
        Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
      ],
    );
  }
}