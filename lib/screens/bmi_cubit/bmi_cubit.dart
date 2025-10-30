import 'package:flutter_bloc/flutter_bloc.dart';
import 'bmi_state.dart';

class BmiCubit extends Cubit<BmiState> {
  BmiCubit() : super(BmiInitial());

  void calculateBMI(double weight, double height) {
    try {
      final bmi = weight / ((height / 100) * (height / 100));
      
      emit(BmiCalculated(
        bmi: bmi,
        weight: weight,
        height: height,
      ));
    } catch (e) {
      emit(BmiError('Ошибка расчета: $e'));
    }
  }

  void reset() {
    emit(BmiInitial());
  }
}