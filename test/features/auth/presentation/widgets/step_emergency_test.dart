import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:safetravel_app/features/auth/presentation/widgets/step_emergency.dart';

void main() {
  group('StepEmergency Widget Tests', () {
    testWidgets('should display emergency contacts section', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        const MaterialApp(home: Scaffold(body: StepEmergency())),
      );

      // Verify the main title and description
      expect(find.text('Emergency Contacts'), findsOneWidget);
      expect(
        find.text(
          'Provide at least two emergency contacts who can be reached in case of an emergency.',
        ),
        findsOneWidget,
      );
    });

    testWidgets('should display initial emergency contact form', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        const MaterialApp(home: Scaffold(body: StepEmergency())),
      );

      // Verify first emergency contact form is present
      expect(find.text('Emergency Contact 1'), findsOneWidget);
      expect(find.text('Full Name *'), findsOneWidget);
      expect(find.text('Select Relationship *'), findsOneWidget);
      expect(find.text('+91'), findsOneWidget);
      expect(find.text('Phone Number *'), findsOneWidget);
      expect(find.text('Email Address'), findsOneWidget);
    });

    testWidgets('should display relationship dropdown with proper options', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        const MaterialApp(home: Scaffold(body: StepEmergency())),
      );

      // Find and tap the dropdown
      final dropdownFinder = find.byType(DropdownButtonFormField<String>);
      expect(dropdownFinder, findsOneWidget);

      await tester.tap(dropdownFinder);
      await tester.pumpAndSettle();

      // Verify dropdown options are present
      expect(find.text('Parent'), findsOneWidget);
      expect(find.text('Spouse'), findsOneWidget);
      expect(find.text('Sibling'), findsOneWidget);
      expect(find.text('Friend'), findsOneWidget);
    });

    testWidgets('should add emergency contact when add button is pressed', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        const MaterialApp(home: Scaffold(body: StepEmergency())),
      );

      // Initially should have one contact
      expect(find.text('Emergency Contact 1'), findsOneWidget);
      expect(find.text('Emergency Contact 2'), findsNothing);

      // Tap add emergency contact button
      final addButton = find.text('Add Emergency Contact');
      expect(addButton, findsOneWidget);
      await tester.tap(addButton);
      await tester.pumpAndSettle();

      // Should now have two contacts
      expect(find.text('Emergency Contact 1'), findsOneWidget);
      expect(find.text('Emergency Contact 2'), findsOneWidget);
    });

    testWidgets('should display +91 prefix for phone numbers', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        const MaterialApp(home: Scaffold(body: StepEmergency())),
      );

      // Verify +91 prefix is displayed
      expect(find.text('+91'), findsOneWidget);

      // Verify phone number hint
      expect(find.text('9876543210'), findsOneWidget);
    });

    testWidgets('should show remove button for additional contacts', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        const MaterialApp(home: Scaffold(body: StepEmergency())),
      );

      // Add a second contact
      await tester.tap(find.text('Add Emergency Contact'));
      await tester.pumpAndSettle();

      // Verify remove buttons are present (only for the second contact, first contact doesn't have remove button)
      expect(find.byIcon(Icons.remove_circle_outline), findsExactly(1));
    });

    testWidgets('should limit maximum contacts to 5', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Container(
              height: 2000, // Give enough height for scrolling
              child: const StepEmergency(),
            ),
          ),
        ),
      );

      // Add contacts up to the limit (start with 1, add 4 more to reach 5)
      for (int i = 1; i < 5; i++) {
        final addButton = find.text('Add Emergency Contact');
        if (addButton.evaluate().isNotEmpty) {
          await tester.scrollUntilVisible(addButton, 100);
          await tester.tap(addButton);
          await tester.pumpAndSettle();
        }
      }

      // Scroll to see the bottom message
      await tester.drag(
        find.byType(SingleChildScrollView),
        const Offset(0, -500),
      );
      await tester.pumpAndSettle();

      // Should show maximum limit message and no add button
      expect(find.text('Maximum 5 emergency contacts allowed'), findsOneWidget);
      expect(find.text('Add Emergency Contact'), findsNothing);
    });
  });
}
