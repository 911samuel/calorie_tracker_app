// test/tracked_food_service_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:sqflite/sqflite.dart';
import 'package:calorie_tracker_app/data/services/db_helper.dart';
import 'package:calorie_tracker_app/domain/models/tracked_food.dart';
import 'package:calorie_tracker_app/data/services/tracked_food_service.dart';

import 'tracked_food_service_test.mocks.dart';

@GenerateMocks([DBHelper, Database])
void main() {
  late MockDBHelper mockDBHelper;
  late MockDatabase mockDatabase;
  late TrackedFoodService service;

  setUp(() {
    mockDBHelper = MockDBHelper();
    mockDatabase = MockDatabase();
    service = TrackedFoodService(dbHelper: mockDBHelper);

    when(mockDBHelper.database).thenAnswer((_) async => mockDatabase);
  });

  group('TrackedFoodService', () {
    final testFood = TrackedFood(
      name: 'Rice',
      amount: 100,
      calories: 130,
      protein: 2.7,
      carbs: 28,
      fat: 0.3,
      date: DateTime.parse('2023-01-01T12:00:00'),
      mealType: 'lunch',
    );

    test('insertTrackedFood inserts food into the database', () async {
      when(
        mockDatabase.insert('tracked_foods', any),
      ).thenAnswer((_) async => 1);

      final result = await service.insertTrackedFood(testFood);

      expect(result, 1);
      verify(mockDatabase.insert('tracked_foods', testFood.toMap())).called(1);
    });

    test('deleteTrackedFood deletes food with correct ID', () async {
      when(
        mockDatabase.delete(
          'tracked_foods',
          where: anyNamed('where'),
          whereArgs: anyNamed('whereArgs'),
        ),
      ).thenAnswer((_) async => 1);

      await service.deleteTrackedFood(42);

      verify(
        mockDatabase.delete('tracked_foods', where: 'id = ?', whereArgs: [42]),
      ).called(1);
    });

    test('getTrackedFoodsByDate returns correct list', () async {
      final date = DateTime.parse('2023-01-01T12:00:00');
      final mapData = [testFood.toMap()];

      when(
        mockDatabase.query(
          'tracked_foods',
          where: anyNamed('where'),
          whereArgs: anyNamed('whereArgs'),
          orderBy: anyNamed('orderBy'),
        ),
      ).thenAnswer((_) async => mapData);

      final result = await service.getTrackedFoodsByDate(date);

      expect(result.length, 1);
      expect(result.first.name, testFood.name);
    });

    test('getTrackedFoodsByDateAndMeal returns correct list', () async {
      final date = DateTime.parse('2023-01-01T12:00:00');
      final mapData = [testFood.toMap()];

      when(
        mockDatabase.query(
          'tracked_foods',
          where: anyNamed('where'),
          whereArgs: anyNamed('whereArgs'),
          orderBy: anyNamed('orderBy'),
        ),
      ).thenAnswer((_) async => mapData);

      final result = await service.getTrackedFoodsByDateAndMeal(date, 'lunch');

      expect(result.length, 1);
      expect(result.first.mealType, 'lunch');
    });

    test('getAllTrackedFoods returns all foods sorted by date DESC', () async {
      final mapData = [testFood.toMap()];

      when(
        mockDatabase.query('tracked_foods', orderBy: anyNamed('orderBy')),
      ).thenAnswer((_) async => mapData);

      final result = await service.getAllTrackedFoods();

      expect(result.length, 1);
      expect(result.first.name, testFood.name);
    });
  });
}
