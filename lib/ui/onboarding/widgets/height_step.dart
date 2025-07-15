import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:calorie_tracker_app/core/ui/text_field.dart';
import 'package:calorie_tracker_app/ui/onboarding/view_model/onboarding_view_model.dart';

class HeightStep extends ConsumerWidget {
  final VoidCallback onNext;
  final TextEditingController heightController;

  const HeightStep({super.key, required this.onNext, required this.heightController});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text("What's your height?"),
        const SizedBox(height: 24),
        CustomTextField(
          controller: heightController,
          keyboardType: TextInputType.number,
          suffixText: "cm",
          onChanged: (value) {
            final doubleHeight = double.tryParse(value);
            if (doubleHeight != null) {
              ref.read(onboardingViewModelProvider.notifier).updateHeight(doubleHeight);
            }
          },
        ),
      ],
    );
  }
}
