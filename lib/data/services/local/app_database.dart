import 'package:calorie_tracker_app/data/services/local/tracked_foods_table.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class AppDatabase {
  static final AppDatabase _instance = AppDatabase._internal();

  factory AppDatabase() => _instance;
  static Database? _database;

  AppDatabase._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'calorie_tracker.db');

    return await openDatabase(path, version: 1, onCreate: _onCreate);
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE ${TrackedFoodsTable.tableName} (
        ${TrackedFoodsTable.columnId} INTEGER PRIMARY KEY AUTOINCREMENT,
        ${TrackedFoodsTable.columnName} TEXT NOT NULL,
        ${TrackedFoodsTable.columnAmount} REAL NOT NULL,
        ${TrackedFoodsTable.columnCalories} INTEGER NOT NULL,
        ${TrackedFoodsTable.columnProtein} REAL NOT NULL,
        ${TrackedFoodsTable.columnCarbs} REAL NOT NULL,
        ${TrackedFoodsTable.columnFat} REAL NOT NULL,
        ${TrackedFoodsTable.columnDate} TEXT NOT NULL,
        ${TrackedFoodsTable.columnMealType} TEXT NOT NULL,
        ${TrackedFoodsTable.columnImageUrl} TEXT
      );
    ''');
  }
}
