import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../../domain/user.dart';

class SharedPrefsService {
  static const String userKey = 'user_data';

  Future<void> saveUser(User user) async {
    final prefs = await SharedPreferences.getInstance();
    final userMap = {
      'gender': user.gender?.index,
      'age': user.age,
      'height': user.height,
      'weight': user.weight,
      'activityLevel': user.activityLevel?.index,
      'goal': user.goal?.index,
      'carbPercentage': user.carbPercentage,
      'proteinPercentage': user.proteinPercentage,
      'fatPercentage': user.fatPercentage,
    };
    final userJson = json.encode(userMap);
    await prefs.setString(userKey, userJson);
  }

  Future<User?> loadUser() async {
    final prefs = await SharedPreferences.getInstance();
    final userJson = prefs.getString(userKey);
    if (userJson == null) return null;

    final userMap = json.decode(userJson);
    return User(
      gender: Gender.values[userMap['gender']],
      age: userMap['age'],
      height: userMap['height'],
      weight: userMap['weight'],
      activityLevel: ActivityLevel.values[userMap['activityLevel']],
      goal: Goal.values[userMap['goal']],
      carbPercentage: userMap['carbPercentage'],
      proteinPercentage: userMap['proteinPercentage'],
      fatPercentage: userMap['fatPercentage'],
    );
  }
}
