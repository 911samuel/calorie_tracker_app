import 'package:shared_preferences/shared_preferences.dart';

class MockSharedPreferences {
  static Future<void> setMockInitialValues(Map<String, Object> values) async {
    SharedPreferences.setMockInitialValues(values);
  }
}
