import 'package:calorie_tracker_app/core/theme/app_colors.dart';
import 'package:calorie_tracker_app/core/ui/ring_progress.dart';
import 'package:flutter/material.dart';

class NutritionRing extends StatelessWidget {
  const NutritionRing({super.key, 
    required this.value,
    required this.goal,
    required this.label,
    required this.color,
    required this.backgroundColor,
  });

  final double value;
  final double goal;
  final String label;
  final Color color;
  final Color backgroundColor;

  @override
  Widget build(BuildContext context) {
    final progress = (value / goal).clamp(0.0, 1.0);
    return Column(
      children: [
        RingProgressBar(
          progress: progress,
          size: 80,
          strokeWidth: 6,
          progressColor: color,
          backgroundColor: backgroundColor,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '${value.toInt()} g',
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: AppColors.cardWhite,
                ),
              ),
              Text(
                label,
                style: const TextStyle(
                  fontSize: 12,
                  color: AppColors.cardWhite,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
