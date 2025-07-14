import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:calorie_tracker_app/core/ui/text_field.dart';
import 'package:calorie_tracker_app/ui/onboarding/view_model/onboarding_view_model.dart';

class NutrientGoalsStep extends ConsumerWidget {
  final VoidCallback onNext;
  final TextEditingController carbsController;
  final TextEditingController proteinController;
  final TextEditingController fatController;

  const NutrientGoalsStep({
    super.key,
    required this.onNext,
    required this.carbsController,
    required this.proteinController,
    required this.fatController,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text("What are your nutrient goals?"),
        const SizedBox(height: 24),
        CustomTextField(
          controller: carbsController,
          keyboardType: TextInputType.number,
          suffixText: "%carbs",
          hintText: '90',
          isOnboarding: true,
          onChanged: (value) {
            final val = double.tryParse(value);
            if (val != null) {
              ref.read(onboardingViewModelProvider.notifier).updateCarbsGoal(val);
            }
          },
        ),
        const SizedBox(height: 16),
        CustomTextField(
          controller: proteinController,
          keyboardType: TextInputType.number,
          suffixText: "%proteins",
          hintText: '70',
          isOnboarding: true,
          onChanged: (value) {
            final val = double.tryParse(value);
            if (val != null) {
              ref.read(onboardingViewModelProvider.notifier).updateProteinGoal(val);
            }
          },
        ),
        const SizedBox(height: 16),
        CustomTextField(
          controller: fatController,
          keyboardType: TextInputType.number,
          suffixText: "%fats",
          hintText: '80',
          isOnboarding: true,
          onChanged: (value) {
            final val = double.tryParse(value);
            if (val != null) {
              ref.read(onboardingViewModelProvider.notifier).updateFatGoal(val);
            }
          },
        ),
      ],
    );
  }
}
