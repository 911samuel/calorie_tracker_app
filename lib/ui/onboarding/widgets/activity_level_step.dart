import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:calorie_tracker_app/core/ui/button.dart';
import 'package:calorie_tracker_app/ui/onboarding/view_model/onboarding_view_model.dart';
import 'package:calorie_tracker_app/domain/user.dart';

class ActivityLevelStep extends ConsumerWidget {
  final VoidCallback onNext;

  const ActivityLevelStep({super.key, required this.onNext});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(onboardingViewModelProvider).user;

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text("What's your activity level?"),
        const SizedBox(height: 24),
        ToggleButtonGroup(
          options: const ['Low', 'Medium', 'High'],
          selectedIndex: user?.activityLevel == ActivityLevel.low
              ? 0
              : user?.activityLevel == ActivityLevel.medium
                  ? 1
                  : user?.activityLevel == ActivityLevel.high
                      ? 2
                      : null,
          onSelectionChanged: (index) {
            ref.read(onboardingViewModelProvider.notifier).updateActivityLevel(
              ActivityLevel.values[index],
            );
          },
          variant: ButtonVariant.primary,
        ),
      ],
    );
  }
}
