class WorkoutSession {
  final String id;
  final int durationMinutes;
  final int calories;
  final DateTime dateTime;

  WorkoutSession({
    required this.id,
    required this.durationMinutes,
    required this.calories,
    required this.dateTime,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'duration_minutes': durationMinutes,
      'calories': calories,
      'date_time': dateTime,
    };
  }

  factory WorkoutSession.fromMap(Map<String, dynamic> map) {
    return WorkoutSession(
      id: map['id'],
      durationMinutes: map['duration_minutes'],
      calories: map['calories'],
      dateTime: DateTime.parse(map['date_time']),
    );
  }

    @override
  String toString() {
    return 'WorkoutSession(id: $id, duration: $durationMinutes min, calories: $calories, date: $dateTime)';
  }

}
