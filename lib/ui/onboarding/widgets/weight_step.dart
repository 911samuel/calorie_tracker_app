import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:calorie_tracker_app/core/ui/text_field.dart';
import 'package:calorie_tracker_app/ui/onboarding/view_model/onboarding_view_model.dart';

class WeightStep extends ConsumerWidget {
  final VoidCallback onNext;
  final TextEditingController weightController;

  const WeightStep({super.key, required this.onNext, required this.weightController});

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text("What's your weight?"),
        const SizedBox(height: 24),
        CustomTextField(
          controller: weightController,
          keyboardType: TextInputType.number,
          suffixText: "kg",
          onChanged: (value) {
            final doubleWeight = double.tryParse(value);
            if (doubleWeight != null) {
              ref.read(onboardingViewModelProvider.notifier).updateWeight(doubleWeight);
            }
          },
        ),
      ],
    );
  }
}
