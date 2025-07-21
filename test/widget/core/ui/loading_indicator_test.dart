import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:calorie_tracker_app/core/ui/loading_indicator.dart';

void main() {
  testWidgets('LoadingIndicator renders circular variant', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: LoadingIndicator(
            variant: LoadingVariant.circular,
            value: 0.5,
            color: Colors.red,
            size: 30,
            strokeWidth: 4,
          ),
        ),
      ),
    );

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('LoadingIndicator renders linear variant', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: LoadingIndicator(
            variant: LoadingVariant.linear,
            value: 0.7,
            color: Colors.blue,
          ),
        ),
      ),
    );

    expect(find.byType(LinearProgressIndicator), findsOneWidget);
  });
}
