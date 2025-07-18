import 'package:flutter_test/flutter_test.dart';
import 'package:calorie_tracker_app/core/viewmodels/nutrition_card_view_model.dart';

void main() {
  late NutritionCardViewModel viewModel;
  late int notificationCount;

  setUp(() {
    viewModel = NutritionCardViewModel();
    notificationCount = 0;
    viewModel.addListener(() => notificationCount++);
  });

  tearDown(() {
    viewModel.dispose();
  });

  test('Should initialize with default values', () {
    expect(viewModel.isExpanded, false);
    expect(viewModel.showInputField, false);
    expect(viewModel.controller.text, '');
  });

  test('Should initialize with given initial value', () {
    final vm = NutritionCardViewModel(initialValue: 'test');
    expect(vm.controller.text, 'test');
    vm.dispose();
  });

  test('Should update isExpanded and notify listeners', () {
    viewModel.setExpanded(true);
    expect(viewModel.isExpanded, true);
    expect(notificationCount, 1);
  });

  test('Should update showInputField and notify listeners', () {
    viewModel.setShowInputField(true);
    expect(viewModel.showInputField, true);
    expect(notificationCount, 1);
  });

  test('Should dispose controller without error', () {
    final vm = NutritionCardViewModel();
    expect(() => vm.dispose(), returnsNormally);
  });

  test('Should handle null and empty initial values', () {
    final vm1 = NutritionCardViewModel(initialValue: null);
    final vm2 = NutritionCardViewModel(initialValue: '');
    expect(vm1.controller.text, '');
    expect(vm2.controller.text, '');
    vm1.dispose();
    vm2.dispose();
  });
}
