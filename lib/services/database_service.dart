import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/activity.dart';
import '../models/activity_entry.dart';

class DatabaseService {
  static final DatabaseService instance = DatabaseService._init();
  static Database? _database;

  DatabaseService._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('timespent.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  Future<void> _createDB(Database db, int version) async {
    const idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    const textType = 'TEXT NOT NULL';
    const intType = 'INTEGER';
    const realType = 'REAL';

    await db.execute('''
      CREATE TABLE activities (
        id $idType,
        name $textType,
        emoji $textType,
        type $textType,
        backgroundColor TEXT,
        createdAt $textType,
        lastUpdatedAt TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE activity_entries (
        id $idType,
        activityId $intType NOT NULL,
        date $textType,
        duration $intType,
        count $intType,
        value $realType,
        unit TEXT,
        notes TEXT,
        FOREIGN KEY (activityId) REFERENCES activities (id) ON DELETE CASCADE
      )
    ''');
  }

  // Activity CRUD operations
  Future<Activity> createActivity(Activity activity) async {
    final db = await instance.database;
    final id = await db.insert('activities', activity.toMap());
    return activity.copyWith(id: id);
  }

  Future<List<Activity>> getAllActivities() async {
    final db = await instance.database;
    final result = await db.query('activities', orderBy: 'createdAt DESC');
    return result.map((map) => Activity.fromMap(map)).toList();
  }

  Future<Activity?> getActivity(int id) async {
    final db = await instance.database;
    final maps = await db.query(
      'activities',
      where: 'id = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return Activity.fromMap(maps.first);
    }
    return null;
  }

  Future<int> updateActivity(Activity activity) async {
    final db = await instance.database;
    return db.update(
      'activities',
      activity.toMap(),
      where: 'id = ?',
      whereArgs: [activity.id],
    );
  }

  Future<int> deleteActivity(int id) async {
    final db = await instance.database;
    return await db.delete(
      'activities',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // Activity Entry CRUD operations
  Future<ActivityEntry> createEntry(ActivityEntry entry) async {
    final db = await instance.database;
    final id = await db.insert('activity_entries', entry.toMap());
    return ActivityEntry(
      id: id,
      activityId: entry.activityId,
      date: entry.date,
      duration: entry.duration,
      count: entry.count,
      value: entry.value,
      unit: entry.unit,
      notes: entry.notes,
    );
  }

  Future<List<ActivityEntry>> getEntriesForActivity(int activityId) async {
    final db = await instance.database;
    final result = await db.query(
      'activity_entries',
      where: 'activityId = ?',
      whereArgs: [activityId],
      orderBy: 'date DESC',
    );
    return result.map((map) => ActivityEntry.fromMap(map)).toList();
  }

  Future<List<ActivityEntry>> getEntriesForDateRange(
    int activityId,
    DateTime start,
    DateTime end,
  ) async {
    final db = await instance.database;
    final result = await db.query(
      'activity_entries',
      where: 'activityId = ? AND date >= ? AND date <= ?',
      whereArgs: [
        activityId,
        start.toIso8601String(),
        end.toIso8601String(),
      ],
      orderBy: 'date DESC',
    );
    return result.map((map) => ActivityEntry.fromMap(map)).toList();
  }

  Future<int> deleteEntry(int id) async {
    final db = await instance.database;
    return await db.delete(
      'activity_entries',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<void> close() async {
    final db = await instance.database;
    db.close();
  }
}