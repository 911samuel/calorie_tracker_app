import 'dart:convert';

import 'package:calorie_tracker_app/data/services/shared_prefs_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:calorie_tracker_app/domain/models/user.dart';


@GenerateMocks([SharedPreferences])
void main() {

  setUp(() {
  });

  test('saveUser should encode user and save to SharedPreferences', () async {
    final user = User(
      gender: Gender.male,
      age: 25,
      height: 180,
      weight: 75,
      activityLevel: ActivityLevel.high,
      goal: Goal.lose,
      carbPercentage: 50,
      proteinPercentage: 30,
      fatPercentage: 20,
    );

    SharedPreferences.setMockInitialValues({}); // Set initial empty prefs
    final prefs = await SharedPreferences.getInstance();
    final service = SharedPrefsService();

    await service.saveUser(user);

    final jsonString = prefs.getString(SharedPrefsService.userKey);
    expect(jsonString, isNotNull);

    final jsonMap = jsonString != null ? jsonDecode(jsonString) : null;
    expect(jsonMap['gender'], Gender.male.index);
    expect(jsonMap['age'], 25);
    expect(jsonMap['height'], 180);
    expect(jsonMap['weight'], 75);
    expect(jsonMap['activityLevel'], ActivityLevel.high.index);
    expect(jsonMap['goal'], Goal.lose.index);
    expect(jsonMap['carbPercentage'], 50);
    expect(jsonMap['proteinPercentage'], 30);
    expect(jsonMap['fatPercentage'], 20);
  });

  test('loadUser should return null if no user data is saved', () async {
    SharedPreferences.setMockInitialValues({}); // Empty state
    final service = SharedPrefsService();

    final user = await service.loadUser();
    expect(user, isNull);
  });

  test('loadUser should decode and return User object from SharedPreferences', () async {
    final userMap = {
      'gender': Gender.female.index,
      'age': 30,
      'height': 165.0,
      'weight': 60.0,
      'activityLevel': ActivityLevel.high.index,
      'goal': Goal.lose.index,
      'carbPercentage': 45.0,
      'proteinPercentage': 35.0,
      'fatPercentage': 20.0,
    };

    final jsonString = jsonEncode(userMap);
    SharedPreferences.setMockInitialValues({
      SharedPrefsService.userKey: jsonString,
    });

    final service = SharedPrefsService();
    final loadedUser = await service.loadUser();

    expect(loadedUser, isNotNull);
    expect(loadedUser!.gender, Gender.female);
    expect(loadedUser.age, 30);
    expect(loadedUser.height, 165);
    expect(loadedUser.weight, 60);
    expect(loadedUser.activityLevel, ActivityLevel.high);
    expect(loadedUser.goal, Goal.lose);
    expect(loadedUser.carbPercentage, 45);
    expect(loadedUser.proteinPercentage, 35);
    expect(loadedUser.fatPercentage, 20);
  });
}
