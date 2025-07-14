import 'package:calorie_tracker_app/core/theme/app_colors.dart';
import 'package:calorie_tracker_app/core/theme/app_dimensions.dart';
import 'package:calorie_tracker_app/core/theme/app_text_styles.dart';
import 'package:flutter/material.dart';

class StatsRow extends StatelessWidget {
  const StatsRow({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 2,
          child: Container(
            padding: const EdgeInsets.all(AppDimensions.paddingM),
            decoration: BoxDecoration(
              color: AppColors.primaryGreen,
              borderRadius: BorderRadius.circular(AppDimensions.radiusL),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Calories',
                  style: AppTextStyles.h4.copyWith(color: AppColors.background),
                ),

                const SizedBox(height: AppDimensions.spaceM),
                Center(
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      SizedBox(
                        height: 120,
                        width: 120,
                        child: CircularProgressIndicator(
                          value: 0.73,
                          color: AppColors.background,
                          backgroundColor: AppColors.textPrimary,
                          strokeWidth: 10,
                        ),
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            '730',
                            style: AppTextStyles.h3.copyWith(
                              color: AppColors.background,
                            ),
                          ),
                          const SizedBox(height: AppDimensions.spaceXS),
                          Text(
                            '/kCal',
                            style: AppTextStyles.bodySmall.copyWith(
                              color: AppColors.background,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: AppDimensions.spaceM),
        Expanded(
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(AppDimensions.paddingM),
                decoration: BoxDecoration(
                  color: AppColors.cardBackground,
                  borderRadius: BorderRadius.circular(AppDimensions.radiusL),
                ),
                child: Column(
                  children: const [
                    Icon(Icons.directions_walk, color: AppColors.primaryGreen),
                    SizedBox(height: AppDimensions.spaceS),
                    Text('Steps', style: AppTextStyles.subtitle),
                    Text('230', style: AppTextStyles.h4),
                  ],
                ),
              ),
              const SizedBox(height: AppDimensions.spaceM),
              Container(
                padding: const EdgeInsets.all(AppDimensions.paddingM),
                decoration: BoxDecoration(
                  color: AppColors.cardBackground,
                  borderRadius: BorderRadius.circular(AppDimensions.radiusL),
                ),
                child: Column(
                  children: [
                    SizedBox(
                      height: 50,
                      width: 50,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          CircularProgressIndicator(
                            value: 5 / 8,
                            color: AppColors.primaryGreen,
                            backgroundColor: AppColors.background,
                            strokeWidth: 5,
                          ),
                          const Text(''),
                        ],
                      ),
                    ),
                    const SizedBox(height: AppDimensions.spaceS),
                    const Text('Sleep', style: AppTextStyles.subtitle),
                    const Text('5/8 Hours', style: AppTextStyles.bodySmall),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
