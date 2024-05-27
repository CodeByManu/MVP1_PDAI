// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:my_app/User/user_model.dart';
import 'package:my_app/login_screen.dart';
import 'package:provider/provider.dart';
import 'package:my_app/main.dart';
import 'package:my_app/Routines/add_routine.dart';

void main() {
  testWidgets('RoutineModel updates when a routine is added',
      (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(
      ChangeNotifierProvider(
        create: (context) => UserSession(),
        child: MaterialApp(
          home: LoginScreen(),
        ),
      ),
    );

    // Verify that our routine list starts empty.
    expect(find.byType(ListTile), findsNothing);

    // Tap the 'Add' button and trigger a frame.
    await tester.tap(find.byType(FloatingActionButton));
    await tester.pump();

    // Verify that our routine list has one item.
    expect(find.byType(ListTile), findsOneWidget);
  });
}
