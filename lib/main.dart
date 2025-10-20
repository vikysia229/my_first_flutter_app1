// вариант 1
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Лабораторная работа - Аюшиева В.А.'),
        ),
        body: FirstScreen(),
      ),
    );
  }
}

class FirstScreen extends StatefulWidget {
  @override
  _FirstScreenState createState() => _FirstScreenState();
}

class _FirstScreenState extends State<FirstScreen> {
  final _formKey = GlobalKey<FormState>();
  final _weightController = TextEditingController();
  final _heightController = TextEditingController();
  bool _agreementChecked = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Калькулятор ИМТ - Аюшиева В.А.'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _weightController,
                decoration: InputDecoration(labelText: 'Вес (кг)'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Введите вес';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _heightController,
                decoration: InputDecoration(labelText: 'Рост (см)'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Введите рост';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              CheckboxListTile(
                title: Text('Согласие на обработку данных'),
                value: _agreementChecked,
                onChanged: (bool? value) {
                  setState(() {
                    _agreementChecked = value ?? false;
                  });
                },
              ),
              SizedBox(height: 24),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate() && _agreementChecked) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SecondScreen(
                          weight: double.parse(_weightController.text),
                          height: double.parse(_heightController.text),
                        ),
                      ),
                    );
                  }
                },
                child: Text('Рассчитать'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SecondScreen extends StatelessWidget {
  final double weight;
  final double height;

  const SecondScreen({
    Key? key,
    required this.weight,
    required this.height,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bmi = weight / ((height / 100) * (height / 100));
    
    return Scaffold(
      appBar: AppBar(
        title: Text('Результат'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('ИМТ: ${bmi.toStringAsFixed(1)}'),
            SizedBox(height: 16),
            Text('Вес: $weight кг'),
            Text('Рост: $height см'),
          ],
        ),
      ),
    );
  }
}