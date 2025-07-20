import 'package:flutter_test/flutter_test.dart';
import 'package:calorie_tracker_app/core/viewmodels/onboarding_text_field_view_model.dart';

void main() {
  late OnboardingTextFieldViewModel viewModel;
  late int notificationCount;

  setUp(() {
    viewModel = OnboardingTextFieldViewModel();
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
    final vm = OnboardingTextFieldViewModel(initialValue: 'abc');
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
    final vm = OnboardingTextFieldViewModel();
    expect(() => vm.dispose(), returnsNormally);
  });
}
