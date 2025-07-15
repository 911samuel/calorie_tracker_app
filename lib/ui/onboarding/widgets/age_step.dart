import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:calorie_tracker_app/core/ui/button.dart';
import 'package:calorie_tracker_app/core/ui/text_field.dart';
import 'package:calorie_tracker_app/ui/onboarding/view_model/onboarding_view_model.dart';

class AgeStep extends ConsumerWidget {
  final VoidCallback onNext;
  final TextEditingController ageController;

  const AgeStep({super.key, required this.onNext, required this.ageController});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(onboardingViewModelProvider).user;

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text("What's your age?"),
        const SizedBox(height: 24),
        CustomTextField(
          controller: ageController,
          keyboardType: TextInputType.number,
          onChanged: (value) {
            final intAge = int.tryParse(value);
            if (intAge != null) {
              ref.read(onboardingViewModelProvider.notifier).updateAge(intAge);
            }
          },
        ),
        const SizedBox(height: 24),
        CustomButton(
          text: "Next",
          onPressed: (user?.age != null && user!.age! > 0) ? onNext : null,
        ),
      ],
    );
  }
}
