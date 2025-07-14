
import 'package:calorie_tracker_app/ui/dashboard/view_model/dashboard.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final workoutTimerProvider =
    StateNotifierProvider<WorkoutTimerNotifier, WorkoutTimerState>(
      (ref) => WorkoutTimerNotifier(weight: 70, met: 8), // Example values
    );
