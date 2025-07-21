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
            }
          },
        ),
        const SizedBox(height: 8),
        Builder(builder: (context) {
          final error = ref.watch(onboardingViewModelProvider).error;
          if (error != null && error.contains("height")) {
            return Text(
              error,
              style: const TextStyle(color: Colors.red, fontSize: 12),
            );
          }
          return const SizedBox.shrink();
        }),
      ],
    );
  }
}
