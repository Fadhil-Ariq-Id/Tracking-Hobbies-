class ActivityEntry {
  final int? id;
  final int activityId;
  final DateTime date;
  final int? duration; // in minutes for timed activities
  final int? count; // for simple tally
  final double? value; // for measured tally
  final String? unit; // unit for measured tally (kg, mi, etc.)
  final String? notes;

  ActivityEntry({
    this.id,
    required this.activityId,
    required this.date,
    this.duration,
    this.count,
    this.value,
    this.unit,
    this.notes,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'activityId': activityId,
      'date': date.toIso8601String(),
      'duration': duration,
      'count': count,
      'value': value,
      'unit': unit,
      'notes': notes,
    };
  }

  factory ActivityEntry.fromMap(Map<String, dynamic> map) {
    return ActivityEntry(
      id: map['id'] as int?,
      activityId: map['activityId'] as int,
      date: DateTime.parse(map['date'] as String),
      duration: map['duration'] as int?,
      count: map['count'] as int?,
      value: map['value'] as double?,
      unit: map['unit'] as String?,
      notes: map['notes'] as String?,
    );
  }
}