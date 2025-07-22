import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:calorie_tracker_app/core/ui/text_field.dart';
import 'package:calorie_tracker_app/ui/onboarding/view_model/onboarding_view_model.dart';

class WeightStep extends ConsumerWidget {
  final VoidCallback onNext;
  final TextEditingController weightController;

  const WeightStep({
    super.key,
    required this.onNext,
    required this.weightController,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          "What's your weight?",
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 40),
        CustomTextField(
          controller: weightController,
          keyboardType: TextInputType.number,
          hintText: "70",
          suffixText: "kg",
          suffixTextColor: Colors.grey,
          isOnboarding: true, // Enable onboarding style
          onChanged: (value) {
            final doubleWeight = double.tryParse(value);
            if (doubleWeight != null) {
              ref
                  .read(onboardingViewModelProvider.notifier)
                  .updateWeight(doubleWeight);
            } else if (value.isNotEmpty) {
              // Trigger validation for invalid input
              ref.read(onboardingViewModelProvider.notifier).updateWeight(0);
            }
          },
        ),
        const SizedBox(height: 8),
        Builder(builder: (context) {
          final viewModel = ref.watch(onboardingViewModelProvider.notifier);
          final weightError = viewModel.getFieldError('weight');
          if (weightError != null) {
            return Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Text(
                weightError,
                style: const TextStyle(color: Colors.red, fontSize: 14),
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
