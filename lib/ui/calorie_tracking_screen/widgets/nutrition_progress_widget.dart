import 'package:calorie_tracker_app/domain/models/daily_summary.dart';
import 'package:flutter/material.dart';

class NutritionProgressWidget extends StatelessWidget {
  final DailySummary dailySummary;
  final int targetCalories;
  final double targetProtein;
  final double targetCarbs;
  final double targetFat;

  const NutritionProgressWidget({
    Key? key,
    required this.dailySummary,
    this.targetCalories = 2000,
    this.targetProtein = 150.0,
    this.targetCarbs = 250.0,
    this.targetFat = 65.0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Daily Progress',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 16),
            _buildProgressBar(
              'Calories',
              dailySummary.totalCalories.toDouble(),
              targetCalories.toDouble(),
              Colors.orange,
            ),
            _buildProgressBar(
              'Protein',
              dailySummary.totalProtein,
              targetProtein,
              Colors.blue,
            ),
            _buildProgressBar(
              'Carbs',
              dailySummary.totalCarbs,
              targetCarbs,
              Colors.green,
            ),
            _buildProgressBar(
              'Fat',
              dailySummary.totalFat,
              targetFat,
              Colors.red,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProgressBar(
    String label,
    double current,
    double target,
    Color color,
  ) {
    final progress = current / target;
    final percentage = (progress * 100).clamp(0, 100);

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label),
            Text(
              '${current.toStringAsFixed(1)} / ${target.toStringAsFixed(1)}',
            ),
          ],
        ),
        const SizedBox(height: 4),
        LinearProgressIndicator(
          value: progress,
          backgroundColor: Colors.grey.shade300,
          valueColor: AlwaysStoppedAnimation<Color>(color),
        ),
        const SizedBox(height: 4),
        Align(
          alignment: Alignment.centerRight,
          child: Text(
            '${percentage.toStringAsFixed(1)}%',
            style: const TextStyle(fontSize: 12, color: Colors.grey),
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}
