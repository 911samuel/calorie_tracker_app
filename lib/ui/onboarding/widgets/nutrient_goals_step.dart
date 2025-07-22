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
            } else if (value.isNotEmpty) {
              // Trigger validation for invalid input
              ref.read(onboardingViewModelProvider.notifier).updateCarbsGoal(-1);
            }
          },
        ),
        const SizedBox(height: 8),
        Builder(builder: (context) {
          final viewModel = ref.watch(onboardingViewModelProvider.notifier);
          final carbsError = viewModel.getFieldError('carbs');
          if (carbsError != null) {
            return Padding(
              padding: const EdgeInsets.only(top: 4.0),
              child: Text(
                carbsError,
                style: const TextStyle(color: Colors.red, fontSize: 12),
                textAlign: TextAlign.center,
              ),
            );
          }
          return const SizedBox.shrink();
        }),
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
            } else if (value.isNotEmpty) {
              // Trigger validation for invalid input
              ref.read(onboardingViewModelProvider.notifier).updateProteinGoal(-1);
            }
          },
        ),
        const SizedBox(height: 8),
        Builder(builder: (context) {
          final viewModel = ref.watch(onboardingViewModelProvider.notifier);
          final proteinError = viewModel.getFieldError('protein');
          if (proteinError != null) {
            return Padding(
              padding: const EdgeInsets.only(top: 4.0),
              child: Text(
                proteinError,
                style: const TextStyle(color: Colors.red, fontSize: 12),
                textAlign: TextAlign.center,
              ),
            );
          }
          return const SizedBox.shrink();
        }),
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
            } else if (value.isNotEmpty) {
              // Trigger validation for invalid input
              ref.read(onboardingViewModelProvider.notifier).updateFatGoal(-1);
            }
          },
        ),
        const SizedBox(height: 8),
        Builder(builder: (context) {
          final viewModel = ref.watch(onboardingViewModelProvider.notifier);
          final fatError = viewModel.getFieldError('fat');
          if (fatError != null) {
            return Padding(
              padding: const EdgeInsets.only(top: 4.0),
              child: Text(
                fatError,
                style: const TextStyle(color: Colors.red, fontSize: 12),
                textAlign: TextAlign.center,
              ),
            );
          }
          return const SizedBox.shrink();
        }),
      ],
    );
  }
}
