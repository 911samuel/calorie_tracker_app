import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:calorie_tracker_app/core/ui/text_field.dart';
import 'package:calorie_tracker_app/ui/onboarding/view_model/onboarding_view_model.dart';

class HeightStep extends ConsumerWidget {
  final VoidCallback onNext;
  final TextEditingController heightController;

  const HeightStep({
    super.key,
    required this.onNext,
    required this.heightController,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          "What's your height?",
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 40),
        CustomTextField(
          controller: heightController,
          keyboardType: TextInputType.number,
          hintText: "180",
          suffixText: "cm",
          suffixTextColor: Colors.grey,
          isOnboarding: true, // Enable onboarding style
          onChanged: (value) {
            final intHeight = int.tryParse(value);
            if (intHeight != null) {
              ref
                  .read(onboardingViewModelProvider.notifier)
                  .updateHeight(intHeight.toDouble());
            } else if (value.isNotEmpty) {
              // Trigger validation for invalid input
              ref.read(onboardingViewModelProvider.notifier).updateHeight(0);
            }
          },
        ),
        const SizedBox(height: 8),
        Builder(builder: (context) {
          final viewModel = ref.watch(onboardingViewModelProvider.notifier);
          final heightError = viewModel.getFieldError('height');
          if (heightError != null) {
            return Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Text(
                heightError,
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
