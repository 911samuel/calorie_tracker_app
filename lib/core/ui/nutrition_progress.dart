import 'package:calorie_tracker_app/core/theme/app_colors.dart';
import 'package:calorie_tracker_app/core/ui/custom_text.dart';
import 'package:calorie_tracker_app/core/ui/ring_progress.dart';
import 'package:flutter/material.dart';

class NutritionRingProgress extends StatelessWidget {
  final double carbsValue;
  final double proteinValue;
  final double fatValue;
  final double carbsGoal;
  final double proteinGoal;
  final double fatGoal;
  final double? totalCalories;
  final double? totalGoal;

  const NutritionRingProgress({
    super.key,
    required this.carbsValue,
    required this.proteinValue,
    required this.fatValue,
    required this.carbsGoal,
    required this.proteinGoal,
    required this.fatGoal,
    this.totalCalories,
    this.totalGoal,
  });

  @override
  Widget build(BuildContext context) {
    // Use provided calories or calculate from macros
    final calculatedCalories =
        totalCalories ?? (carbsValue * 4 + proteinValue * 4 + fatValue * 9);
    final calculatedGoal =
        totalGoal ?? (carbsGoal * 4 + proteinGoal * 4 + fatGoal * 9);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            CustomText(
              label: 'Your goal:',
              fontSize: 16,
              textAlign: TextAlign.right,
              color: AppColors.cardWhite,
            ),
          ],
        ),

        // Calorie display
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            CustomText(
              label: '${calculatedCalories.toInt()} kcal',
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: AppColors.cardWhite,
            ),
            CustomText(
              label: '${calculatedGoal.toInt()} kcal',
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: AppColors.cardWhite,
            ),
          ],
        ),

        const SizedBox(height: 15),

        // Combined progress bar (like in the image)
        Container(
          height: 20,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.grey[200],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LayoutBuilder(
              builder: (context, constraints) {
                final totalWidth = constraints.maxWidth;

                // Calculate proportions based on total goal
                final carbsWidth =
                    (carbsValue * 4 / calculatedGoal) * totalWidth;
                final proteinWidth =
                    (proteinValue * 4 / calculatedGoal) * totalWidth;
                final fatWidth = (fatValue * 9 / calculatedGoal) * totalWidth;

                return Stack(
                  children: [
                    // Carbs section
                    if (carbsWidth > 0)
                      Positioned(
                        left: 0,
                        child: Container(
                          width: carbsWidth,
                          height: 20,
                          decoration: BoxDecoration(
                            color: AppColors.carbsColor,
                          ),
                        ),
                      ),
                    // Protein section
                    if (proteinWidth > 0)
                      Positioned(
                        left: carbsWidth,
                        child: Container(
                          width: proteinWidth,
                          height: 20,
                          decoration: BoxDecoration(
                            color: AppColors.proteinColor,
                          ),
                        ),
                      ),
                    // Fat section
                    if (fatWidth > 0)
                      Positioned(
                        left: carbsWidth + proteinWidth,
                        child: Container(
                          width: fatWidth,
                          height: 20,
                          decoration: BoxDecoration(
                            color: AppColors.fatColor,
                            borderRadius: BorderRadius.horizontal(
                              right: Radius.circular(10),
                            ),
                          ),
                        ),
                      ),
                  ],
                );
              },
            ),
          ),
        ),

        const SizedBox(height: 30),

        // Individual ring progress bars
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            // Carbs
            _buildNutritionRing(
              value: carbsValue,
              goal: carbsGoal,
              label: 'Carbs',
              color: AppColors.carbsColor,
              backgroundColor: AppColors.carbsBackground,
            ),
            // Protein
            _buildNutritionRing(
              value: proteinValue,
              goal: proteinGoal,
              label: 'Protein',
              color: AppColors.proteinColor,
              backgroundColor: AppColors.proteinBackground,
            ),
            // Fat
            _buildNutritionRing(
              value: fatValue,
              goal: fatGoal,
              label: 'Fat',
              color: AppColors.fatColor,
              backgroundColor: AppColors.fatBackground,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildNutritionRing({
    required double value,
    required double goal,
    required String label,
    required Color color,
    required Color backgroundColor,
  }) {
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
