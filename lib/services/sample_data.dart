import '../models/activity.dart';
import '../models/activity_entry.dart';
import 'database_service.dart';

class SampleData {
  static Future<void> initializeSampleData() async {
    final db = DatabaseService.instance;
    
    // Check if data already exists
    final existingActivities = await db.getAllActivities();
    if (existingActivities.isNotEmpty) {
      return; // Data already initialized
    }

    // Create sample activities
    final reading = await db.createActivity(Activity(
      name: 'Reading',
      emoji: '📚',
      type: ActivityType.timedActivity,
      backgroundColor: '#FFF4E6',
    ));

    final running = await db.createActivity(Activity(
      name: 'Running',
      emoji: '🏃',
      type: ActivityType.simpleTally,
      backgroundColor: '#E8F5E9',
    ));

    // Add sample entries for reading (last 3 weeks)
    final now = DateTime.now();
    for (int i = 0; i < 21; i++) {
      final date = now.subtract(Duration(days: 20 - i));
      if (i % 3 != 0) { // Skip some days to create pattern
        await db.createEntry(ActivityEntry(
          activityId: reading.id!,
          date: date,
          duration: 30 + (i % 5) * 15, // 30-90 minutes
        ));
      }
    }

    // Add sample entries for running
    for (int i = 0; i < 21; i++) {
      final date = now.subtract(Duration(days: 20 - i));
      if (i % 4 != 0) {
        await db.createEntry(ActivityEntry(
          activityId: running.id!,
          date: date,
          count: 1,
        ));
      }
    }
  }
}