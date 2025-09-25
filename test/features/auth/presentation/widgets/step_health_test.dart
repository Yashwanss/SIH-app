import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:safetravel_app/features/auth/presentation/widgets/step_health.dart';

void main() {
  group('StepHealth Privacy Validation Tests', () {
    testWidgets('should display health information section', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        const MaterialApp(home: Scaffold(body: StepHealth())),
      );

      // Verify the main sections are present
      expect(find.text('Health & Safety Information'), findsOneWidget);
      expect(find.text('Location Tracking & Privacy'), findsOneWidget);
      expect(find.text('Privacy Notice'), findsOneWidget);
    });

    testWidgets('should display privacy consent checkbox', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        const MaterialApp(home: Scaffold(body: StepHealth())),
      );

      // Verify privacy consent checkbox is present
      expect(
        find.text(
          'I consent to real-time location tracking for safety purposes *',
        ),
        findsOneWidget,
      );
      expect(find.byType(CheckboxListTile), findsOneWidget);

      // Verify initial state is unchecked
      final checkbox = tester.widget<CheckboxListTile>(
        find.byType(CheckboxListTile),
      );
      expect(checkbox.value, false);
    });

    testWidgets('should call callback when privacy consent is changed', (
      WidgetTester tester,
    ) async {
      bool consentReceived = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: StepHealth(
              onConsentChanged: (consent) {
                consentReceived = consent;
              },
            ),
          ),
        ),
      );

      // Initially consent should be false
      expect(consentReceived, false);

      // Tap the checkbox to give consent
      await tester.tap(find.byType(CheckboxListTile));
      await tester.pumpAndSettle();

      // Verify consent callback was called with true
      expect(consentReceived, true);

      // Tap again to remove consent
      await tester.tap(find.byType(CheckboxListTile));
      await tester.pumpAndSettle();

      // Verify consent callback was called with false
      expect(consentReceived, false);
    });

    testWidgets('should display health information text fields', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        const MaterialApp(home: Scaffold(body: StepHealth())),
      );

      // Verify health information fields are present
      expect(
        find.text('Health Information or Medical Conditions'),
        findsOneWidget,
      );
      expect(find.text('Special Assistance Requirements'), findsOneWidget);

      // Verify placeholder texts
      expect(
        find.text(
          'List any medical conditions, allergies, medications, or health concerns...',
        ),
        findsOneWidget,
      );
      expect(
        find.text('Describe any special assistance you may need...'),
        findsOneWidget,
      );
    });

    testWidgets('should display privacy notice with proper content', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        const MaterialApp(home: Scaffold(body: StepHealth())),
      );

      // Verify privacy notice content
      expect(find.text('Privacy Notice'), findsOneWidget);
      expect(
        find.textContaining('Your health information is encrypted'),
        findsOneWidget,
      );
      expect(
        find.textContaining('Location data is used solely for safety purposes'),
        findsOneWidget,
      );
    });

    testWidgets('checkbox should toggle correctly', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        const MaterialApp(home: Scaffold(body: StepHealth())),
      );

      // Find the checkbox
      final checkboxFinder = find.byType(CheckboxListTile);

      // Initially should be unchecked
      CheckboxListTile checkbox = tester.widget<CheckboxListTile>(
        checkboxFinder,
      );
      expect(checkbox.value, false);

      // Tap to check
      await tester.tap(checkboxFinder);
      await tester.pumpAndSettle();

      // Should now be checked
      checkbox = tester.widget<CheckboxListTile>(checkboxFinder);
      expect(checkbox.value, true);

      // Tap again to uncheck
      await tester.tap(checkboxFinder);
      await tester.pumpAndSettle();

      // Should now be unchecked again
      checkbox = tester.widget<CheckboxListTile>(checkboxFinder);
      expect(checkbox.value, false);
    });
  });
}
