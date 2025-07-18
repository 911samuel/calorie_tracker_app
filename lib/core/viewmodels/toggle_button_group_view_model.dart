import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ToggleButtonGroupViewModel extends ChangeNotifier {
  int? selectedIndex;

  ToggleButtonGroupViewModel({this.selectedIndex});

  void selectIndex(int index) {
    selectedIndex = index;
    notifyListeners();
  }
}

final toggleButtonGroupViewModelProvider = ChangeNotifierProvider.autoDispose<ToggleButtonGroupViewModel>((ref) {
  return ToggleButtonGroupViewModel();
});
