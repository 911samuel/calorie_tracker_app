import 'package:calorie_tracker_app/data/services/db_helper.dart';
import 'package:calorie_tracker_app/domain/models/tracked_food.dart';

class TrackedFoodService {
  final DBHelper _dbHelper;

  TrackedFoodService({required DBHelper dbHelper}) : _dbHelper = dbHelper;

  Future<int> insertTrackedFood(TrackedFood food) async {
    final db = await _dbHelper.database;
    return await db.insert('tracked_foods', food.toMap());
  }

  Future<void> deleteTrackedFood(int id) async {
    final db = await _dbHelper.database;
    await db.delete('tracked_foods', where: 'id = ?', whereArgs: [id]);
  }

  Future<List<TrackedFood>> getTrackedFoodsByDate(DateTime date) async {
    final db = await _dbHelper.database;
    final dateString = date.toIso8601String().split(
      'T',
    )[0]; // Get date part only

    final maps = await db.query(
      'tracked_foods',
      where: 'date LIKE ?',
      whereArgs: ['$dateString%'],
      orderBy: 'date ASC',
    );

    return maps.map((map) => TrackedFood.fromMap(map)).toList();
  }

  Future<List<TrackedFood>> getTrackedFoodsByDateAndMeal(
    DateTime date,
    String mealType,
  ) async {
    final db = await _dbHelper.database;
    final dateString = date.toIso8601String().split('T')[0];

    final maps = await db.query(
      'tracked_foods',
      where: 'date LIKE ? AND mealType = ?',
      whereArgs: ['$dateString%', mealType],
      orderBy: 'date ASC',
    );

    return maps.map((map) => TrackedFood.fromMap(map)).toList();
  }

  Future<List<TrackedFood>> getAllTrackedFoods() async {
    final db = await _dbHelper.database;
    final maps = await db.query('tracked_foods', orderBy: 'date DESC');
    return maps.map((map) => TrackedFood.fromMap(map)).toList();
  }
}
