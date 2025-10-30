import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'bmi_cubit/bmi_cubit.dart';
import 'bmi_cubit/bmi_state.dart';

class BmiScreen extends StatefulWidget {
  const BmiScreen({super.key});

  @override
  State<BmiScreen> createState() => _BmiScreenState();
}

class _BmiScreenState extends State<BmiScreen> {
  final _formKey = GlobalKey<FormState>();
  final _weightController = TextEditingController();
  final _heightController = TextEditingController();
  bool _agreementChecked = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Калькулятор ИМТ - Аюшиева В.А.'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: BlocBuilder<BmiCubit, BmiState>(
          builder: (context, state) {
            return Column(
              children: [
                // Форма ввода
                _buildInputForm(context),
                
                const SizedBox(height: 20),
                
                // Отображение результата или ошибки
                _buildResult(state),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildInputForm(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          TextFormField(
            controller: _weightController,
            decoration: const InputDecoration(labelText: 'Вес (кг)'),
            keyboardType: TextInputType.number,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Введите вес';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _heightController,
            decoration: const InputDecoration(labelText: 'Рост (см)'),
            keyboardType: TextInputType.number,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Введите рост';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          CheckboxListTile(
            title: const Text('Согласие на обработку данных'),
            value: _agreementChecked,
            onChanged: (bool? value) {
              setState(() {
                _agreementChecked = value ?? false;
              });
            },
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate() && _agreementChecked) {
                      // Вызываем кубит для расчета
                      context.read<BmiCubit>().calculateBMI(
                        double.parse(_weightController.text),
                        double.parse(_heightController.text),
                      );
                    }
                  },
                  child: const Text('Рассчитать'),
                ),
              ),
              const SizedBox(width: 10),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    _weightController.clear();
                    _heightController.clear();
                    _agreementChecked = false;
                  });
                  context.read<BmiCubit>().reset();
                },
                child: const Text('Сброс'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildResult(BmiState state) {
    if (state is BmiCalculated) {
      return Column(
        children: [
          const Text(
            'Результат:',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          Text('ИМТ: ${state.bmi.toStringAsFixed(1)}'),
          Text('Вес: ${state.weight} кг'),
          Text('Рост: ${state.height} см'),
        ],
      );
    } else if (state is BmiError) {
      return Text(
        state.message,
        style: const TextStyle(color: Colors.red),
      );
    } else {
      return const SizedBox(); 
    }
  }
}