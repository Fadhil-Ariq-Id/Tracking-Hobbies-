class Activity {
  final int? id;
  final String name;
  final String emoji;
  final ActivityType type;
  final String? backgroundColor;
  final DateTime createdAt;
  final DateTime? lastUpdatedAt;

  Activity({
    this.id,
    required this.name,
    required this.emoji,
    required this.type,
    this.backgroundColor,
    DateTime? createdAt,
    this.lastUpdatedAt,
  }) : createdAt = createdAt ?? DateTime.now();

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'emoji': emoji,
      'type': type.toString(),
      'backgroundColor': backgroundColor,
      'createdAt': createdAt.toIso8601String(),
      'lastUpdatedAt': lastUpdatedAt?.toIso8601String(),
    };
  }

  factory Activity.fromMap(Map<String, dynamic> map) {
    return Activity(
      id: map['id'] as int?,
      name: map['name'] as String,
      emoji: map['emoji'] as String,
      type: ActivityType.values.firstWhere(
        (e) => e.toString() == map['type'],
      ),
      backgroundColor: map['backgroundColor'] as String?,
      createdAt: DateTime.parse(map['createdAt'] as String),
      lastUpdatedAt: map['lastUpdatedAt'] != null
          ? DateTime.parse(map['lastUpdatedAt'] as String)
          : null,
    );
  }

  Activity copyWith({
    int? id,
    String? name,
    String? emoji,
    ActivityType? type,
    String? backgroundColor,
    DateTime? createdAt,
    DateTime? lastUpdatedAt,
  }) {
    return Activity(
      id: id ?? this.id,
      name: name ?? this.name,
      emoji: emoji ?? this.emoji,
      type: type ?? this.type,
      backgroundColor: backgroundColor ?? this.backgroundColor,
      createdAt: createdAt ?? this.createdAt,
      lastUpdatedAt: lastUpdatedAt ?? this.lastUpdatedAt,
    );
  }
}

enum ActivityType {
  timedActivity,
  simpleTally,
  measuredTally,
}