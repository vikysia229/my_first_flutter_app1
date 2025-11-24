import 'package:flutter_bloc/flutter_bloc.dart';
import 'preferences_service.dart';

class BmiRecord {
  final int id;
  final double weight;
  final double height;
  final double bmi;
  final DateTime date;

  BmiRecord({
    required this.id,
    required this.weight,
    required this.height,
    required this.bmi,
    required this.date,
  });
}

abstract class BmiState {}

class BmiInitial extends BmiState {}

class BmiCalculated extends BmiState {
  final double bmi;
  final double weight;
  final double height;
  final List<BmiRecord> history;

  BmiCalculated({
    required this.bmi,
    required this.weight,
    required this.height,
    required this.history,
  });
}

class BmiCubit extends Cubit<BmiState> {
  List<BmiRecord> _history = [];
  int _nextId = 1;
  final PreferencesService _preferencesService = PreferencesService();

  BmiCubit() : super(BmiInitial());

  Future<void> calculateBMI(double weight, double height) async {
    try {
      final bmi = weight / ((height / 100) * (height / 100));
      
      // Сохраняем в SharedPreferences
      await _preferencesService.saveLastInput(weight, height);
      
      // Добавляем в историю
      final record = BmiRecord(
        id: _nextId++,
        weight: weight,
        height: height,
        bmi: bmi,
        date: DateTime.now(),
      );
      _history.insert(0, record);
      
      emit(BmiCalculated(
        bmi: bmi,
        weight: weight,
        height: height,
        history: List.from(_history),
      ));
    } catch (e) {
      emit(BmiInitial());
    }
  }

  void deleteRecord(int id) {
    _history.removeWhere((record) => record.id == id);
    emit(BmiInitial());
  }

  List<BmiRecord> getHistory() {
    return List.from(_history);
  }

  void reset() {
    emit(BmiInitial());
  }
}