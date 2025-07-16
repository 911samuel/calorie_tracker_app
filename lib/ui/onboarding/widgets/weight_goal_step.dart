import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:calorie_tracker_app/core/ui/button.dart';
import 'package:calorie_tracker_app/ui/onboarding/view_model/onboarding_view_model.dart';
import 'package:calorie_tracker_app/domain/user.dart';

class WeightGoalStep extends ConsumerWidget {
  final VoidCallback onNext;

  const WeightGoalStep({super.key, required this.onNext});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(onboardingViewModelProvider).user;

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text("Do you want to lose, keep or gain weight?"),
        const SizedBox(height: 24),
        ToggleButtonGroup(
          options: const ['Lose', 'Keep', 'Gain'],
          selectedIndex: user?.goal == Goal.lose
              ? 0
              : user?.goal == Goal.keep
                  ? 1
                  : user?.goal == Goal.gain
                      ? 2
                      : null,
          onSelectionChanged: (index) {
            ref.read(onboardingViewModelProvider.notifier).updateGoal(
              Goal.values[index],
            );
          },
          variant: ButtonVariant.primary,
        ),
      ],
    );
  }
}
