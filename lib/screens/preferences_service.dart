import 'package:shared_preferences/shared_preferences.dart';

class PreferencesService {
  static const String _weightKey = 'last_weight';
  static const String _heightKey = 'last_height';
  static const String _agreementKey = 'agreement';

  Future<void> saveLastInput(double weight, double height) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble(_weightKey, weight);
    await prefs.setDouble(_heightKey, height);
  }

  Future<(double?, double?)> getLastInput() async {
    final prefs = await SharedPreferences.getInstance();
    final weight = prefs.getDouble(_weightKey);
    final height = prefs.getDouble(_heightKey);
    return (weight, height);
  }

  Future<void> saveAgreement(bool agreed) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_agreementKey, agreed);
  }

  Future<bool> getAgreement() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_agreementKey) ?? false;
  }
}