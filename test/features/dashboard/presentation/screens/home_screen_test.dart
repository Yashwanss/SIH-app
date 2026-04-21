import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:safetravel_app/features/dashboard/presentation/screens/home_screen.dart';

void main() {
  group('HomeScreen location behavior', () {
    testWidgets('shows map section with recenter button', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(body: HomeScreen()),
        ),
      );
      await tester.pump();

      expect(find.text('Points of Interest'), findsOneWidget);
      expect(find.byKey(const Key('recenter-location-button')), findsOneWidget);
    });

    testWidgets('shows temporary loading indicator when recenter is tapped', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(body: HomeScreen()),
        ),
      );
      await tester.pump();

      await tester.tap(find.byKey(const Key('recenter-location-button')));
      await tester.pump();

      expect(find.byKey(const Key('recenter-location-progress')), findsOneWidget);
    });
  });
}
