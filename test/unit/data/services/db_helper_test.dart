import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main() {
  // Initialize for ffi
  sqfliteFfiInit();
  databaseFactory = databaseFactoryFfi;

  group('DBHelper schema tests', () {
    late Database db;

    setUp(() async {
      db = await databaseFactory.openDatabase(inMemoryDatabasePath);
      await _createTrackedFoodsTable(db); // We simulate DBHelper's _onCreate
    });

    tearDown(() async {
      await db.close();
    });

    test('tracked_foods table exists', () async {
      final result = await db.rawQuery(
        "SELECT name FROM sqlite_master WHERE type='table' AND name='tracked_foods'",
      );
      expect(result.length, 1);
      expect(result.first['name'], 'tracked_foods');
    });

    test('Insert and retrieve tracked food', () async {
      final food = {
        'name': 'Test Food',
        'amount': 100.0,
        'calories': 200,
        'protein': 10.0,
        'carbs': 30.0,
        'fat': 5.0,
        'date': '2025-07-18T00:00:00',
        'mealType': 'lunch',
        'imageUrl': null,
      };

      final id = await db.insert('tracked_foods', food);
      expect(id, greaterThan(0));

      final result = await db.query(
        'tracked_foods',
        where: 'id = ?',
        whereArgs: [id],
      );

      expect(result.length, 1);
      expect(result.first['name'], food['name']);
    });
  });
}

/// 🧪 Local replica of the table creation logic from DBHelper._onCreate
Future<void> _createTrackedFoodsTable(Database db) async {
  await db.execute('''
    CREATE TABLE tracked_foods (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      name TEXT NOT NULL,
      amount REAL NOT NULL,
      calories INTEGER NOT NULL,
      protein REAL NOT NULL,
      carbs REAL NOT NULL,
      fat REAL NOT NULL,
      date TEXT NOT NULL,
      mealType TEXT NOT NULL,
      imageUrl TEXT
    )
  ''');
}
