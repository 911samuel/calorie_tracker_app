import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DefaultyStylesViewModel extends ChangeNotifier {
  final TextEditingController controller;
  bool isFocused = false;
  String? errorText;

  DefaultyStylesViewModel({String? initialValue})
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

final defaultyStylesViewModelProvider = ChangeNotifierProvider.autoDispose<DefaultyStylesViewModel>((ref) {
  final viewModel = DefaultyStylesViewModel();
  ref.onDispose(() => viewModel.dispose());
  return viewModel;
});
