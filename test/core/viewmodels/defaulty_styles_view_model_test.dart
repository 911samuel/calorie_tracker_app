import 'package:flutter_test/flutter_test.dart';
import 'package:calorie_tracker_app/core/viewmodels/defaulty_styles_view_model.dart';

void main() {
  late DefaultyStylesViewModel viewModel;
  late int notificationCount;

  setUp(() {
    viewModel = DefaultyStylesViewModel();
    notificationCount = 0;
    viewModel.addListener(() => notificationCount++);
  });

  tearDown(() {
    viewModel.dispose();
  });

  test('Should initialize with default values', () {
    expect(viewModel.isFocused, false);
    expect(viewModel.errorText, isNull);
    expect(viewModel.controller.text, '');
  });

  test('Should initialize with given initial value', () {
    final vm = DefaultyStylesViewModel(initialValue: 'abc');
    expect(vm.controller.text, 'abc');
    vm.dispose();
  });

  test('Should update isFocused and notify listeners', () {
    viewModel.setFocus(true);
    expect(viewModel.isFocused, true);
    expect(notificationCount, 1);
  });

  test('Should update errorText and notify listeners', () {
    viewModel.setError('error');
    expect(viewModel.errorText, 'error');
    expect(notificationCount, 1);
  });

  test('Should handle null and empty errorText', () {
    viewModel.setError(null);
    expect(viewModel.errorText, isNull);
    viewModel.setError('');
    expect(viewModel.errorText, '');
  });

  test('Should dispose controller without error', () {
    final vm = DefaultyStylesViewModel();
    expect(() => vm.dispose(), returnsNormally);
  });
}
