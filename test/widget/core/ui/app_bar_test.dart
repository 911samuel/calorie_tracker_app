import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:calorie_tracker_app/core/ui/app_bar.dart';

void main() {
  testWidgets('CustomAppBar renders title and back button', (tester) async {
    bool backPressed = false;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          appBar: CustomAppBar(
            title: 'Test Title',
            onBackPressed: () {
              backPressed = true;
            },
          ),
        ),
      ),
    );

    expect(find.text('Test Title'), findsOneWidget);
    expect(find.byIcon(Icons.arrow_back_ios_new), findsOneWidget);

    await tester.tap(find.byIcon(Icons.arrow_back_ios_new));
    expect(backPressed, isTrue);
  });

  testWidgets('CustomAppBar hides back button when showBackButton is false', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          appBar: CustomAppBar(
            title: 'No Back Button',
            showBackButton: false,
          ),
        ),
      ),
    );

    expect(find.byIcon(Icons.arrow_back_ios_new), findsNothing);
  });

  testWidgets('CustomAppBar shows actions', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          appBar: CustomAppBar(
            title: 'With Actions',
            actions: [
              IconButton(
                icon: Icon(Icons.add),
                onPressed: () {},
              ),
            ],
          ),
        ),
      ),
    );

    expect(find.byIcon(Icons.add), findsOneWidget);
  });
}
