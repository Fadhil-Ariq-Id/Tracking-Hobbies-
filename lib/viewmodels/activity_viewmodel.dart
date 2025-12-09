import 'package:flutter/foundation.dart';
import '../models/activity.dart';
import '../models/activity_entry.dart';
import '../services/database_service.dart';

class ActivityViewModel extends ChangeNotifier {
  final DatabaseService _databaseService = DatabaseService.instance;
  List<Activity> _activities = [];
  bool _isLoading = false;

  List<Activity> get activities => _activities;
  bool get isLoading => _isLoading;

  ActivityViewModel() {
    loadActivities();
  }

  Future<void> loadActivities() async {
    _isLoading = true;
    notifyListeners();

    try {
      _activities = await _databaseService.getAllActivities();
    } catch (e) {
      debugPrint('Error loading activities: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addActivity(Activity activity) async {
    try {
      final newActivity = await _databaseService.createActivity(activity);
      _activities.insert(0, newActivity);
      notifyListeners();
    } catch (e) {
      debugPrint('Error adding activity: $e');
    }
  }

  Future<void> updateActivity(Activity activity) async {
    try {
      await _databaseService.updateActivity(activity);
      final index = _activities.indexWhere((a) => a.id == activity.id);
      if (index != -1) {
        _activities[index] = activity;
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Error updating activity: $e');
    }
  }

  Future<void> deleteActivity(int id) async {
    try {
      await _databaseService.deleteActivity(id);
      _activities.removeWhere((a) => a.id == id);
      notifyListeners();
    } catch (e) {
      debugPrint('Error deleting activity: $e');
    }
  }

  Future<List<ActivityEntry>> getEntriesForActivity(int activityId) async {
    try {
      return await _databaseService.getEntriesForActivity(activityId);
    } catch (e) {
      debugPrint('Error getting entries: $e');
      return [];
    }
  }

  Future<void> addEntry(ActivityEntry entry) async {
    try {
      await _databaseService.createEntry(entry);
      // Update the activity's lastUpdatedAt
      final activity = _activities.firstWhere((a) => a.id == entry.activityId);
      await updateActivity(
        activity.copyWith(lastUpdatedAt: DateTime.now()),
      );
    } catch (e) {
      debugPrint('Error adding entry: $e');
    }
  }

  // Get stats for an activity
  Future<Map<String, dynamic>> getActivityStats(int activityId) async {
    try {
      final entries = await getEntriesForActivity(activityId);
      final now = DateTime.now();
      final weekStart = now.subtract(Duration(days: now.weekday - 1));
      final weekEnd = weekStart.add(const Duration(days: 6));

      final weekEntries = entries.where((e) {
        return e.date.isAfter(weekStart.subtract(const Duration(days: 1))) &&
            e.date.isBefore(weekEnd.add(const Duration(days: 1)));
      }).toList();

      final activity = _activities.firstWhere((a) => a.id == activityId);

      if (activity.type == ActivityType.timedActivity) {
        final totalMinutes =
            weekEntries.fold<int>(0, (sum, e) => sum + (e.duration ?? 0));
        return {
          'thisWeek': '${totalMinutes ~/ 60}h ${totalMinutes % 60}m',
          'entries': weekEntries,
        };
      } else if (activity.type == ActivityType.simpleTally) {
        final totalCount =
            weekEntries.fold<int>(0, (sum, e) => sum + (e.count ?? 0));
        return {
          'thisWeek': totalCount,
          'entries': weekEntries,
        };
      } else {
        final totalValue =
            weekEntries.fold<double>(0, (sum, e) => sum + (e.value ?? 0));
        return {
          'thisWeek': totalValue,
          'unit': weekEntries.isNotEmpty ? weekEntries.first.unit : '',
          'entries': weekEntries,
        };
      }
    } catch (e) {
      debugPrint('Error getting stats: $e');
      return {};
    }
  }
}