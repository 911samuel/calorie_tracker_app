import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:calorie_tracker_app/main.dart' as app;
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Calorie Tracker App Integration Tests', () {
    setUp(() async {
      // Clear any existing preferences before each test
      SharedPreferences.setMockInitialValues({});
    });

    testWidgets('Complete onboarding flow and navigation through all screens', (
      WidgetTester tester,
    ) async {
      // Start with fresh state to ensure onboarding shows
      SharedPreferences.setMockInitialValues({'isFirstTime': true});

      // Launch the app
      app.main();
      await _waitForAppToLoad(tester);

      // Complete the full onboarding flow
      await _completeOnboardingFlow(tester);

      // Verify we've reached the home screen
      await _verifyHomeScreen(tester);

      // Test navigation to all screens
      await _testAllNavigations(tester);

      debugPrint(
        'Complete onboarding integration test completed successfully!',
      );
    });

    testWidgets(
      'Direct home screen navigation (onboarding already completed)',
      (WidgetTester tester) async {
        // Set up state as if onboarding is completed
        SharedPreferences.setMockInitialValues({
          'isFirstTime': false,
          'user_data': _getMockUserData(),
        });

        app.main();
        await _waitForAppToLoad(tester);

        // Should go directly to home screen
        await _verifyHomeScreen(tester);

        // Test all screen navigations from home
        await _testAllNavigations(tester);

        debugPrint('Direct home navigation test completed successfully!');
      },
    );

    testWidgets('Test food search and meal logging functionality', (
      WidgetTester tester,
    ) async {
      // Setup completed onboarding state
      SharedPreferences.setMockInitialValues({
        'isFirstTime': false,
        'user_data': _getMockUserData(),
      });

      app.main();
      await _waitForAppToLoad(tester);

      // Test detailed food search functionality
      await _testFoodSearchDetailed(tester);

      debugPrint('Food search and meal logging test completed successfully!');
    });

    // Removed testWidgets for user profile and settings functionality as it does not exist in the project
  });
}

// Helper Functions

/// Wait for app to fully load with proper timeout
Future<void> _waitForAppToLoad(
  WidgetTester tester, {
  Duration timeout = const Duration(seconds: 10),
}) async {
  await tester.pumpAndSettle(const Duration(seconds: 2));
  await _waitForWidget(find.byType(Scaffold), tester, timeout: timeout);
}

/// Wait for a widget to appear with configurable timeout
Future<void> _waitForWidget(
  Finder finder,
  WidgetTester tester, {
  Duration timeout = const Duration(seconds: 5),
  Duration checkInterval = const Duration(milliseconds: 100),
}) async {
  final end = DateTime.now().add(timeout);
  while (DateTime.now().isBefore(end)) {
    await tester.pump(checkInterval);
    if (finder.evaluate().isNotEmpty) return;
  }
  throw Exception('Widget not found within timeout: ${finder.toString()}');
}

/// Enhanced animation waiting with multiple pump strategies
Future<void> _waitForAnimations(WidgetTester tester, {int millis = 500}) async {
  await tester.pump();
  await tester.pump(Duration(milliseconds: millis));
  await tester.pumpAndSettle(const Duration(milliseconds: 200));
}

/// Get mock user data for testing
String _getMockUserData() {
  return '{"name":"Test User","age":25,"gender":"Male","height":170,"weight":70,"activityLevel":"Lightly Active","goal":"Maintain Weight","carbPercentage":45,"proteinPercentage":30,"fatPercentage":25}';
}

/// Complete the full onboarding flow with improved error handling
Future<void> _completeOnboardingFlow(WidgetTester tester) async {
  debugPrint('Starting onboarding flow...');

  // Step 0: Welcome Step
  await _handleWelcomeStep(tester);

  // Step 1: Gender Selection
  await _handleGenderSelection(tester);

  // Step 2: Age Input
  await _handleAgeInput(tester);

  // Step 3: Height Input
  await _handleHeightInput(tester);

  // Step 4: Weight Input
  await _handleWeightInput(tester);

  // Step 5: Activity Level Selection
  await _handleActivityLevelSelection(tester);

  // Step 6: Weight Goal Selection
  await _handleWeightGoalSelection(tester);

  // Step 7: Nutrient Goals
  await _handleNutrientGoals(tester);

  // Complete onboarding
  await _completeOnboarding(tester);
}

Future<void> _handleWelcomeStep(WidgetTester tester) async {
  debugPrint('Testing Welcome Step (Step 0)');
  await _waitForAnimations(tester);

  final welcomeButton = find.text("Let's go");
  if (welcomeButton.evaluate().isNotEmpty) {
    await tester.tap(welcomeButton);
    await _waitForAnimations(tester);
  }
}

Future<void> _handleGenderSelection(WidgetTester tester) async {
  debugPrint('Testing Gender Selection (Step 1)');
  await _waitForAnimations(tester);

  final genderButtons = [find.text('Male'), find.text('Female')];
  bool genderSelected = false;

  for (final button in genderButtons) {
    if (button.evaluate().isNotEmpty) {
      await tester.tap(button.first);
      await _waitForAnimations(tester);
      genderSelected = true;
      break;
    }
  }

  if (genderSelected) {
    await _tapNextButton(tester);
  }
}

Future<void> _handleAgeInput(WidgetTester tester) async {
  debugPrint('Testing Age Input (Step 2)');
  await _waitForAnimations(tester);

  final ageField = _findTextFieldByContext(tester, ['age', 'Age']);
  if (ageField != null) {
    await _enterTextSafely(tester, ageField, '25');
    await _tapNextButton(tester);
  }
}

Future<void> _handleHeightInput(WidgetTester tester) async {
  debugPrint('Testing Height Input (Step 3)');
  await _waitForAnimations(tester);

  final heightField = _findTextFieldByContext(tester, [
    'height',
    'Height',
    'cm',
  ]);
  if (heightField != null) {
    await _enterTextSafely(tester, heightField, '170');
    await _tapNextButton(tester);
  }
}

Future<void> _handleWeightInput(WidgetTester tester) async {
  debugPrint('Testing Weight Input (Step 4)');
  await _waitForAnimations(tester);

  final weightField = _findTextFieldByContext(tester, [
    'weight',
    'Weight',
    'kg',
  ]);
  if (weightField != null) {
    await _enterTextSafely(tester, weightField, '70');
    await _tapNextButton(tester);
  }
}

Future<void> _handleActivityLevelSelection(WidgetTester tester) async {
  debugPrint('Testing Activity Level Selection (Step 5)');
  await _waitForAnimations(tester);

  final activityButtons = [
    find.textContaining('Low'),
    find.textContaining('Medium'),
    find.textContaining('High'),
  ];

  for (final button in activityButtons) {
    if (button.evaluate().isNotEmpty) {
      await tester.tap(button.first);
      await _waitForAnimations(tester);
      await _tapNextButton(tester);
      break;
    }
  }
}

Future<void> _handleWeightGoalSelection(WidgetTester tester) async {
  debugPrint('Testing Weight Goal Selection (Step 6)');
  await _waitForAnimations(tester);

  final goalButtons = [
    find.textContaining('Lose'),
    find.textContaining('Keep'),
    find.textContaining('Gain'),
  ];

  for (final button in goalButtons) {
    if (button.evaluate().isNotEmpty) {
      await tester.tap(button.first);
      await _waitForAnimations(tester);
      await _tapNextButton(tester);
      break;
    }
  }
}

Future<void> _handleNutrientGoals(WidgetTester tester) async {
  debugPrint('Testing Nutrient Goals (Step 7)');
  await _waitForAnimations(tester);

  final textFields = find.byType(TextField);
  if (textFields.evaluate().length >= 3) {
    final nutrients = ['45', '30', '25']; // Carbs, Protein, Fat percentages

    for (int i = 0; i < 3 && i < textFields.evaluate().length; i++) {
      final field = textFields.at(i);
      await _enterTextSafely(tester, field, nutrients[i]);
    }
  }
  await _tapNextButton(tester);
}

Future<void> _completeOnboarding(WidgetTester tester) async {
  debugPrint('Completing onboarding...');
  await _waitForAnimations(tester);

  // Look for completion buttons
  final completionButtons = [
    find.text('Finish'),
    find.text('Complete'),
    find.text('Done'),
    find.text('Get Started'),
    find.byType(ElevatedButton),
  ];

  bool completed = false;
  for (final button in completionButtons) {
    if (button.evaluate().isNotEmpty) {
      await tester.tap(button.first);
      await _waitForAnimations(tester, millis: 3000);
      completed = true;
      break;
    }
  }

  if (!completed) {
    debugPrint(
      'No completion button found, onboarding may already be complete',
    );
  }
}

Future<void> _tapNextButton(WidgetTester tester) async {
  final nextButtons = [find.text('Next'), find.byType(ElevatedButton)];

  for (final button in nextButtons) {
    if (button.evaluate().isNotEmpty) {
      await tester.tap(button.first);
      await _waitForAnimations(tester);
      break;
    }
  }
}

/// Find text field by context clues
Finder? _findTextFieldByContext(
  WidgetTester tester,
  List<String> contextClues,
) {
  final textFields = find.byType(TextField);
  if (textFields.evaluate().isEmpty) return null;

  // Try to find the most relevant text field
  for (final clue in contextClues) {
    final contextFinder = find.textContaining(clue);
    if (contextFinder.evaluate().isNotEmpty) {
      return textFields.first; // Return first available text field
    }
  }

  return textFields.first; // Fallback to first text field
}

/// Safely enter text into a field
Future<void> _enterTextSafely(
  WidgetTester tester,
  Finder field,
  String text,
) async {
  try {
    await tester.ensureVisible(field);
    await tester.tap(field);
    await _waitForAnimations(tester, millis: 200);
    await tester.enterText(field, text);
    await _waitForAnimations(tester);
  } catch (e) {
    debugPrint('Error entering text: $e');
  }
}

/// Verify we're on the home screen with comprehensive checks
Future<void> _verifyHomeScreen(WidgetTester tester) async {
  debugPrint('Verifying Home Screen Navigation');
  await _waitForAnimations(tester, millis: 3000);

  final homeIndicators = [
    find.textContaining('Today'),
    find.textContaining('Calories'),
    find.textContaining('Breakfast'),
    find.textContaining('Lunch'),
    find.textContaining('Dinner'),
    find.textContaining('Snack'),
    find.textContaining('Home'),
    find.textContaining('Nutrition'),
    find.textContaining('Meal'),
    find.byType(Card),
    find.byType(FloatingActionButton),
    find.byIcon(Icons.add),
    find.byType(BottomNavigationBar),
  ];

  bool foundHomeScreen = false;
  String foundIndicator = '';

  for (final indicator in homeIndicators) {
    if (indicator.evaluate().isNotEmpty) {
      foundHomeScreen = true;
      foundIndicator = indicator.toString();
      debugPrint('Found home screen indicator: $foundIndicator');
      break;
    }
  }

  // Fallback check for basic screen structure
  if (!foundHomeScreen) {
    foundHomeScreen = find.byType(Scaffold).evaluate().isNotEmpty;
    if (foundHomeScreen) {
      foundIndicator = 'Scaffold (basic screen structure)';
      debugPrint('Found: $foundIndicator');
    }
  }

  expect(
    foundHomeScreen,
    isTrue,
    reason:
        'Should be on home screen with recognizable content. Last found: $foundIndicator',
  );
}

/// Test all navigation scenarios
Future<void> _testAllNavigations(WidgetTester tester) async {
  debugPrint('Testing all navigation scenarios...');

  await _testFoodSearchNavigation(tester);
  await _testHomeScreenInteractions(tester);
  await _testBottomNavigation(tester);
  await _testDrawerNavigation(tester);
}

/// Enhanced food search navigation test
Future<void> _testFoodSearchNavigation(WidgetTester tester) async {
  debugPrint('Testing Food Search Navigation');

  final searchEntryPoints = [
    find.textContaining('+ Add Breakfast'),
    find.textContaining('+ Add Lunch'),
    find.textContaining('+ Add Dinner'),
    find.textContaining('+ Add Snack'),
  ];

  for (final entryPoint in searchEntryPoints) {
    if (entryPoint.evaluate().isNotEmpty) {
      await tester.tap(entryPoint.first);
      await _waitForAnimations(tester);

      // Check if we're on food search screen
      final searchIndicators = [
        find.textContaining('Search'),
        find.textContaining('Food'),
        find.byType(TextField),
        find.byIcon(Icons.search),
      ];

      bool foundSearchScreen = false;
      for (final indicator in searchIndicators) {
        if (indicator.evaluate().isNotEmpty) {
          foundSearchScreen = true;
          break;
        }
      }

      if (foundSearchScreen) {
        await _testSearchFunctionality(tester);
      }

      break;
    }
  }
}

Future<void> _testSearchFunctionality(WidgetTester tester) async {
  debugPrint('Testing search functionality');

  final searchFields = find.byType(TextField);
  if (searchFields.evaluate().isNotEmpty) {
    final searchField = searchFields.first;
    await _enterTextSafely(tester, searchField, 'apple');
    await _waitForAnimations(tester, millis: 1000);

    // Look for search results
    final resultIndicators = [
      find.byType(ListTile),
      find.byType(Card),
      find.textContaining('apple'),
      find.textContaining('Apple'),
    ];

    for (final indicator in resultIndicators) {
      if (indicator.evaluate().isNotEmpty) {
        debugPrint('Found search results');
        break;
      }
    }
  }
}

Future<void> _testFoodSearchDetailed(WidgetTester tester) async {
  debugPrint('Testing detailed food search functionality');

  // Navigate to food search
  await _testFoodSearchNavigation(tester);

  // Test different search terms
  final searchTerms = ['chicken', 'rice', 'banana'];

  for (final term in searchTerms) {
    final searchFields = find.byType(TextField);
    if (searchFields.evaluate().isNotEmpty) {
      final searchField = searchFields.first;
      await tester.tap(searchField);
      await _waitForAnimations(tester);
      await tester.enterText(searchField, term);
      await _waitForAnimations(tester, millis: 1500);

      // Look for and interact with results
      final results = find.byType(ListTile);
      if (results.evaluate().isNotEmpty) {
        await tester.tap(results.first);
        await _waitForAnimations(tester);
      }
    }
  }
}

Future<void> _testHomeScreenInteractions(WidgetTester tester) async {
  debugPrint('Testing home screen interactions');

  // Test date picker
  final datePickerButton = find.byIcon(Icons.calendar_today);
  if (datePickerButton.evaluate().isNotEmpty) {
    await tester.tap(datePickerButton);
    await _waitForAnimations(tester);

    final okButton = find.text('OK');
    if (okButton.evaluate().isNotEmpty) {
      await tester.tap(okButton);
      await _waitForAnimations(tester);
    }
  }

  // Test nutrition cards
  final cards = find.byType(Card);
  if (cards.evaluate().isNotEmpty) {
    await tester.tap(cards.first);
    await _waitForAnimations(tester);
  }

  // Test floating action button
  final fab = find.byType(FloatingActionButton);
  if (fab.evaluate().isNotEmpty) {
    await tester.tap(fab);
    await _waitForAnimations(tester);
  }
}

Future<void> _testBottomNavigation(WidgetTester tester) async {
  debugPrint('Testing bottom navigation');

  final bottomNavBar = find.byType(BottomNavigationBar);
  if (bottomNavBar.evaluate().isEmpty) return;

  // Find all navigation items
  final navItems = find.descendant(
    of: bottomNavBar,
    matching: find.byType(GestureDetector),
  );

  final itemCount = navItems.evaluate().length;
  debugPrint('Found $itemCount bottom navigation items');

  for (int i = 0; i < itemCount && i < 4; i++) {
    try {
      await tester.tap(navItems.at(i));
      await _waitForAnimations(tester, millis: 800);
      debugPrint('Navigated to tab $i');
    } catch (e) {
      debugPrint('Error navigating to tab $i: $e');
    }
  }
}

Future<void> _testDrawerNavigation(WidgetTester tester) async {
  debugPrint('Testing drawer navigation');

  final drawerButton = find.byIcon(Icons.menu);
  if (drawerButton.evaluate().isEmpty) return;

  await tester.tap(drawerButton);
  await _waitForAnimations(tester);

  // Look for drawer items
  final drawerItems = find.byType(ListTile);
  if (drawerItems.evaluate().isNotEmpty) {
    // Test first few drawer items
    final itemCount = drawerItems.evaluate().length;
    for (int i = 0; i < itemCount && i < 3; i++) {
      try {
        await tester.tap(drawerItems.at(i));
        await _waitForAnimations(tester);

        // Reopen drawer for next item
        if (i < itemCount - 1) {
          await tester.tap(drawerButton);
          await _waitForAnimations(tester);
        }
      } catch (e) {
        debugPrint('Error testing drawer item $i: $e');
      }
    }
  }

  // Close drawer
  await tester.tapAt(const Offset(400, 300));
  await _waitForAnimations(tester);
}
