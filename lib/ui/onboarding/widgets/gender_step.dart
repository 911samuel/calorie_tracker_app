import 'package:calorie_tracker_app/core/ui/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:calorie_tracker_app/core/ui/button.dart';
import 'package:calorie_tracker_app/domain/models/user.dart';
import 'package:calorie_tracker_app/ui/onboarding/view_model/onboarding_view_model.dart';

class GenderStep extends ConsumerWidget {
  final VoidCallback onNext;

  const GenderStep({super.key, required this.onNext});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(onboardingViewModelProvider).user;

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        CustomText(
          label: "What's your gender?",
        ),
        const SizedBox(height: 24),
        ToggleButtonGroup(
          options: const ['Male', 'Female'],
          selectedIndex: user?.gender == Gender.male ? 0 : user?.gender == Gender.female ? 1 : null,
          onSelectionChanged: (index) {
            ref.read(onboardingViewModelProvider.notifier).updateGender(
              index == 0 ? Gender.male : Gender.female,
            );
          },
          variant: ButtonVariant.primary,
        ),
      ],
    );
  }
}
