import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:calorie_tracker_app/core/ui/custom_text.dart';

void main() {
  testWidgets('CustomText renders with given label and styles', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: CustomText(
            label: 'Test Label',
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.red,
            textAlign: TextAlign.center,
            letterSpacing: 1.5,
            height: 1.2,
            overflow: TextOverflow.ellipsis,
            maxLines: 2,
          ),
        ),
      ),
    );

    final textWidget = tester.widget<Text>(find.text('Test Label'));
    expect(textWidget.style?.fontSize, 18);
    expect(textWidget.style?.fontWeight, FontWeight.bold);
    expect(textWidget.style?.color, Colors.red);
    expect(textWidget.textAlign, TextAlign.center);
    expect(textWidget.style?.letterSpacing, 1.5);
    expect(textWidget.style?.height, 1.2);
    expect(textWidget.overflow, TextOverflow.ellipsis);
    expect(textWidget.maxLines, 2);
  });
}
