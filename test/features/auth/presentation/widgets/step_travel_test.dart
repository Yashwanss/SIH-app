import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:safetravel_app/features/auth/presentation/widgets/step_travel.dart';

void main() {
  testWidgets(
    'StepTravel widget should contain accommodation details section',
    (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(home: Scaffold(body: StepTravel())),
      );

      // Verify the accommodation section is present
      expect(find.text('Accommodation Details'), findsOneWidget);
      expect(find.text('Where are you staying at? *'), findsOneWidget);
      expect(
        find.text('Let us know where you\'ll be staying during your travel.'),
        findsOneWidget,
      );
    },
  );

  testWidgets(
    'StepTravel widget should have location textfield with proper decoration',
    (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(home: Scaffold(body: StepTravel())),
      );

      // Find the textfield by looking for the hint text
      final hintTextFinder = find.text(
        'Search for hotels, addresses, landmarks...',
      );
      expect(hintTextFinder, findsOneWidget);

      // Check for location icon
      expect(find.byIcon(Icons.location_on), findsWidgets);
    },
  );
}
