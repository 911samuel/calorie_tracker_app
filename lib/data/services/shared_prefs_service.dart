import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../../domain/models/user.dart';

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

    int? parseEnum(dynamic value) {
      if (value is int) return value;
      if (value is String) return int.tryParse(value);
      return null;
    }

    double? parseDouble(dynamic value) {
      if (value == null) return null;
      if (value is double) return value;
      if (value is int) return value.toDouble();
      if (value is String) return double.tryParse(value);
      return null;
    }


    return User(
      gender: Gender.values[parseEnum(userMap['gender']) ?? 0],
      age: userMap['age'] is int ? userMap['age'] : int.tryParse(userMap['age'].toString()),
      height: parseDouble(userMap['height']),
      weight: parseDouble(userMap['weight']),
      activityLevel:
          ActivityLevel.values[parseEnum(userMap['activityLevel']) ?? 0],
      goal: Goal.values[parseEnum(userMap['goal']) ?? 0],
      carbPercentage: parseDouble(userMap['carbPercentage']),
      proteinPercentage: parseDouble(userMap['proteinPercentage']),
      fatPercentage: parseDouble(userMap['fatPercentage']),
    );
  }
}
