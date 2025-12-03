import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:roll_dice_app/gradient_container.dart';

void main() {
  testWidgets('GradientContainer renders correctly', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: GradientContainer(
            Color.fromARGB(255, 33, 5, 109),
            Color.fromARGB(255, 68, 21, 149),
          ),
        ),
      ),
    );

    // Verify that GradientContainer is rendered
    expect(find.byType(GradientContainer), findsOneWidget);

    // Verify Roll Dice button exists
    expect(find.text('Roll Dice'), findsOneWidget);
  });
}
