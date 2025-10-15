// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:pantrychef/main.dart';

void main() {
  testWidgets('PantryChef app smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const PantryChefApp());

    // Verify that the app title is present.
    expect(find.text('PantryChef'), findsOneWidget);
    
    // Verify that the main heading is present.
    expect(find.text('What\'s in your pantry?'), findsOneWidget);
  });
}
