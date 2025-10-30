import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'screens/bmi_screen.dart';
import 'screens/bmi_cubit/bmi_cubit.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => BmiCubit(),
      child: MaterialApp(
        home: Scaffold(
          appBar: AppBar(
            title: const Text('Лабораторная работа 4 - Аюшиева В.А.'),
          ),
          body: const BmiScreen(),
        ),
      ),
    );
  }
}