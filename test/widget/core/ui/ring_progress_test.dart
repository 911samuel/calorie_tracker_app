import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:calorie_tracker_app/core/ui/ring_progress.dart';

void main() {
  testWidgets('RingProgressBar renders and animates progress', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: RingProgressBar(
            progress: 0.5,
            size: 100,
            strokeWidth: 8,
            progressColor: Colors.blue,
            backgroundColor: Colors.grey,
          ),
        ),
      ),
    );

    expect(find.byType(RingProgressBar), findsOneWidget);

    // Test animation by pumping frames
    await tester.pump(const Duration(milliseconds: 500));
    await tester.pumpAndSettle();
  });
}
