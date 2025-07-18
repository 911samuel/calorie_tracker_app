import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TextFieldViewModel extends ChangeNotifier {
  final TextEditingController controller;
  String? errorText;
  bool isFocused = false;

  TextFieldViewModel({String? initialValue})
      : controller = TextEditingController(text: initialValue);

  void setError(String? error) {
    errorText = error;
    notifyListeners();
  }

  void setFocus(bool focus) {
    isFocused = focus;
    notifyListeners();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}

final textFieldViewModelProvider = ChangeNotifierProvider.autoDispose<TextFieldViewModel>((ref) {
  final viewModel = TextFieldViewModel();
  ref.onDispose(() => viewModel.dispose());
  return viewModel;
});
