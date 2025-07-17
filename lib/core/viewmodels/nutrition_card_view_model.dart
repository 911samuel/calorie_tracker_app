import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class NutritionCardViewModel extends ChangeNotifier {
  final TextEditingController controller;
  bool isExpanded;
  bool showInputField;

  NutritionCardViewModel({String? initialValue, this.isExpanded = false, this.showInputField = false})
      : controller = TextEditingController(text: initialValue);

  void setExpanded(bool expanded) {
    isExpanded = expanded;
    notifyListeners();
  }

  void setShowInputField(bool show) {
    showInputField = show;
    notifyListeners();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}

final nutritionCardViewModelProvider = ChangeNotifierProvider.autoDispose<NutritionCardViewModel>((ref) {
  final viewModel = NutritionCardViewModel();
  ref.onDispose(() => viewModel.dispose());
  return viewModel;
});
