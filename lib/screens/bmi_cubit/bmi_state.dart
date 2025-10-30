import 'package:flutter/foundation.dart';

@immutable
abstract class BmiState {}

class BmiInitial extends BmiState {}

class BmiCalculated extends BmiState {
  final double bmi;
  final double weight;
  final double height;
  
  BmiCalculated({
    required this.bmi,
    required this.weight,
    required this.height,
  });
}

class BmiError extends BmiState {
  final String message;
  
  BmiError(this.message);
}