import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'bmi_cubit.dart';

class BmiScreen extends StatefulWidget {
  const BmiScreen({super.key});

  @override
  State<BmiScreen> createState() => _BmiScreenState();
}

class _BmiScreenState extends State<BmiScreen> {
  final _weightController = TextEditingController();
  final _heightController = TextEditingController();
  bool _agreementChecked = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Калькулятор ИМТ - Аюшиева В.А.'),
        actions: [
          IconButton(
            icon: const Icon(Icons.history),
            onPressed: () {
              _showHistory(context);
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Поля ввода
            TextField(
              controller: _weightController,
              decoration: const InputDecoration(
                labelText: 'Вес (кг)',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _heightController,
              decoration: const InputDecoration(
                labelText: 'Рост (см)',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 16),
            
            // Чекбокс согласия
            CheckboxListTile(
              title: const Text('Согласие на обработку данных'),
              value: _agreementChecked,
              onChanged: (value) {
                setState(() {
                  _agreementChecked = value ?? false;
                });
              },
            ),
            
            const SizedBox(height: 24),
            
            // Кнопки
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: _calculateBMI,
                    child: const Text('Рассчитать'),
                  ),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: _reset,
                  child: const Text('Сброс'),
                ),
              ],
            ),
            
            const SizedBox(height: 24),
            
            // Результат
            BlocBuilder<BmiCubit, BmiState>(
              builder: (context, state) {
                if (state is BmiCalculated) {
                  return Column(
                    children: [
                      const Text(
                        'Результат:',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text('ИМТ: ${state.bmi.toStringAsFixed(1)}'),
                      Text('Вес: ${state.weight} кг'),
                      Text('Рост: ${state.height} см'),
                      const SizedBox(height: 20),
                      Text(
                        _getBmiCategory(state.bmi),
                        style: TextStyle(
                          color: _getBmiColor(state.bmi),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  );
                } else {
                  return const SizedBox();
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  void _calculateBMI() {
    if (_weightController.text.isEmpty || _heightController.text.isEmpty) {
      _showSnackBar('Введите вес и рост');
      return;
    }

    if (!_agreementChecked) {
      _showSnackBar('Необходимо согласие на обработку данных');
      return;
    }

    final weight = double.tryParse(_weightController.text);
    final height = double.tryParse(_heightController.text);

    if (weight == null || height == null) {
      _showSnackBar('Введите корректные числа');
      return;
    }

    context.read<BmiCubit>().calculateBMI(weight, height);
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  void _showHistory(BuildContext context) {
    final cubit = context.read<BmiCubit>();
    final history = cubit.getHistory();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('История расчетов'),
        content: history.isEmpty
            ? const Text('Нет сохраненных расчетов')
            : SizedBox(
                width: double.maxFinite,
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: history.length,
                  itemBuilder: (context, index) {
                    final record = history[index];
                    return Card(
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: _getBmiColor(record.bmi),
                          child: Text(
                            record.bmi.toStringAsFixed(1),
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        title: Text('Вес: ${record.weight} кг, Рост: ${record.height} см'),
                        subtitle: Text(
                          'Дата: ${_formatDate(record.date)}',
                          style: const TextStyle(fontSize: 12),
                        ),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red, size: 20),
                          onPressed: () {
                            cubit.deleteRecord(record.id);
                            Navigator.pop(context);
                            _showSnackBar('Запись удалена');
                          },
                        ),
                      ),
                    );
                  },
                ),
              ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Закрыть'),
          ),
        ],
      ),
    );
  }

  void _reset() {
    setState(() {
      _weightController.clear();
      _heightController.clear();
      _agreementChecked = false;
    });
    context.read<BmiCubit>().reset();
  }

  Color _getBmiColor(double bmi) {
    if (bmi < 18.5) return Colors.blue;
    if (bmi < 25) return Colors.green;
    if (bmi < 30) return Colors.orange;
    return Colors.red;
  }

  String _getBmiCategory(double bmi) {
    if (bmi < 18.5) return 'Недостаточный вес';
    if (bmi < 25) return 'Нормальный вес';
    if (bmi < 30) return 'Избыточный вес';
    return 'Ожирение';
  }

  String _formatDate(DateTime date) {
    return '${date.day}.${date.month}.${date.year} ${date.hour}:${date.minute.toString().padLeft(2, '0')}';
  }

  @override
  void dispose() {
    _weightController.dispose();
    _heightController.dispose();
    super.dispose();
  }
}