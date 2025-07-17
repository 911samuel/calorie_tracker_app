import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class OnboardingTextFieldViewModel extends ChangeNotifier {
  final TextEditingController controller;
  bool isFocused = false;
  String? errorText;

  OnboardingTextFieldViewModel({String? initialValue})
      : controller = TextEditingController(text: initialValue);

  void setFocus(bool focus) {
    isFocused = focus;
    notifyListeners();
  }

  void setError(String? error) {
    errorText = error;
    notifyListeners();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}

final onboardingTextFieldViewModelProvider = ChangeNotifierProvider.autoDispose<OnboardingTextFieldViewModel>((ref) {
  final viewModel = OnboardingTextFieldViewModel();
  ref.onDispose(() => viewModel.dispose());
  return viewModel;
});
