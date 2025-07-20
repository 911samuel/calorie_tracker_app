import 'package:flutter_test/flutter_test.dart';
import 'package:calorie_tracker_app/core/viewmodels/toggle_button_group_view_model.dart';

void main() {
  late ToggleButtonGroupViewModel viewModel;
  late int notificationCount;

  setUp(() {
    viewModel = ToggleButtonGroupViewModel();
    notificationCount = 0;
    viewModel.addListener(() => notificationCount++);
  });

  tearDown(() {
    // No resources to dispose
  });

  test('Should initialize with null selectedIndex', () {
    expect(viewModel.selectedIndex, isNull);
  });

  test('Should initialize with given selectedIndex', () {
    final vm = ToggleButtonGroupViewModel(selectedIndex: 2);
    expect(vm.selectedIndex, 2);
  });

  test('Should update selectedIndex and notify listeners', () {
    viewModel.selectIndex(1);
    expect(viewModel.selectedIndex, 1);
    expect(notificationCount, 1);
  });

  test('Should handle negative index', () {
    viewModel.selectIndex(-1);
    expect(viewModel.selectedIndex, -1);
    expect(notificationCount, 1);
  });
}
