import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class WorkoutTimerState {
  final int seconds;
  final double calories;
  final bool isRunning;

  WorkoutTimerState({
    required this.seconds,
    required this.calories,
    required this.isRunning,
  });

  WorkoutTimerState copyWith({
    int? seconds,
    double? calories,
    bool? isRunning,
  }) {
    return WorkoutTimerState(
      seconds: seconds ?? this.seconds,
      calories: calories ?? this.calories,
      isRunning: isRunning ?? this.isRunning,
    );
  }
}

class WorkoutTimerNotifier extends StateNotifier<WorkoutTimerState> {
  WorkoutTimerNotifier({required this.weight, required this.met})
    : super(WorkoutTimerState(seconds: 0, calories: 0, isRunning: false));

  final double weight; // kg
  final double met; // e.g. 8.0 for running
  Timer? _timer;

  void start() {
    if (state.isRunning) return;
    state = state.copyWith(isRunning: true);
    _timer = Timer.periodic(Duration(seconds: 1), (_) {
      final newSeconds = state.seconds + 1;
      final newCalories = calculateCalories(newSeconds);
      state = state.copyWith(seconds: newSeconds, calories: newCalories);
    });
  }

  void pause() {
    _timer?.cancel();
    state = state.copyWith(isRunning: false);
  }

  void reset() {
    _timer?.cancel();
    state = WorkoutTimerState(seconds: 0, calories: 0, isRunning: false);
  }

  double calculateCalories(int seconds) {
    final durationMinutes = seconds / 60.0;
    return durationMinutes * weight * met * 0.0175;
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}
