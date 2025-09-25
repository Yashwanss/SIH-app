import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:safetravel_app/features/auth/presentation/screens/registration_screen.dart';

void main() {
  group('Registration Screen Privacy Validation Tests', () {
    testWidgets('should display registration screen with initial step', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(const MaterialApp(home: RegistrationScreen()));

      // Verify the main title and initial step
      expect(find.text('SafeTravel Registration'), findsOneWidget);
      expect(
        find.text('Personal Information'),
        findsOneWidget,
      ); // StepPersonal title
    });

    testWidgets('should navigate through steps using next button', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(const MaterialApp(home: RegistrationScreen()));

      // Navigate to health step (last step)
      for (int i = 0; i < 3; i++) {
        await tester.tap(find.text('Next'));
        await tester.pumpAndSettle();
      }

      // Should now be on health step
      expect(find.text('Health & Safety Information'), findsOneWidget);
      expect(
        find.text('Register'),
        findsOneWidget,
      ); // Final step shows Register button
    });

    testWidgets(
      'should show privacy dialog when trying to register without consent',
      (WidgetTester tester) async {
        await tester.pumpWidget(const MaterialApp(home: RegistrationScreen()));

        // Navigate to health step (last step)
        for (int i = 0; i < 3; i++) {
          await tester.tap(find.text('Next'));
          await tester.pumpAndSettle();
        }

        // Try to register without checking privacy consent
        await tester.tap(find.text('Register'));
        await tester.pumpAndSettle();

        // Should show privacy required dialog
        expect(find.text('Privacy Consent Required'), findsOneWidget);
        expect(
          find.text(
            'You must consent to location tracking for safety purposes',
          ),
          findsOneWidget,
        );
        expect(find.text('OK'), findsOneWidget);
      },
    );

    testWidgets('should allow registration after giving privacy consent', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(const MaterialApp(home: RegistrationScreen()));

      // Navigate to health step (last step)
      for (int i = 0; i < 3; i++) {
        await tester.tap(find.text('Next'));
        await tester.pumpAndSettle();
      }

      // Give privacy consent by checking the checkbox
      await tester.tap(find.byType(CheckboxListTile));
      await tester.pumpAndSettle();

      // Now try to register - should succeed (no dialog should appear)
      await tester.tap(find.text('Register'));
      await tester.pumpAndSettle();

      // Should not show the privacy dialog
      expect(find.text('Privacy Consent Required'), findsNothing);

      // Should navigate to completion screen (we can't test this directly due to navigation,
      // but the absence of the dialog indicates success)
    });

    testWidgets('should close privacy dialog when OK is tapped', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(const MaterialApp(home: RegistrationScreen()));

      // Navigate to health step
      for (int i = 0; i < 3; i++) {
        await tester.tap(find.text('Next'));
        await tester.pumpAndSettle();
      }

      // Try to register without consent
      await tester.tap(find.text('Register'));
      await tester.pumpAndSettle();

      // Dialog should be shown
      expect(find.text('Privacy Consent Required'), findsOneWidget);

      // Tap OK to close dialog
      await tester.tap(find.text('OK'));
      await tester.pumpAndSettle();

      // Dialog should be closed
      expect(find.text('Privacy Consent Required'), findsNothing);

      // Should still be on health step
      expect(find.text('Health & Safety Information'), findsOneWidget);
    });

    testWidgets('should show previous button on non-first steps', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(const MaterialApp(home: RegistrationScreen()));

      // Initially should not show previous button
      expect(find.text('Previous'), findsNothing);

      // Navigate to next step
      await tester.tap(find.text('Next'));
      await tester.pumpAndSettle();

      // Should now show previous button
      expect(find.text('Previous'), findsOneWidget);
    });

    testWidgets('should navigate back when previous button is tapped', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(const MaterialApp(home: RegistrationScreen()));

      // Navigate to second step
      await tester.tap(find.text('Next'));
      await tester.pumpAndSettle();

      // Should be on travel step
      expect(find.text('Identity Documents'), findsOneWidget);

      // Navigate back
      await tester.tap(find.text('Previous'));
      await tester.pumpAndSettle();

      // Should be back on personal step
      expect(find.text('Personal Information'), findsOneWidget);
    });
  });
}
