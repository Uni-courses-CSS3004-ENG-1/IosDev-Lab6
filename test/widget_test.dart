import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:user_registration/main.dart';

void main() {
  testWidgets('shows errors when the form is empty', (tester) async {
    await tester.pumpWidget(const MyApp());

    await tester.ensureVisible(find.text('Register'));
    await tester.tap(find.text('Register'));
    await tester.pump();

    expect(find.text('Please enter your full name'), findsOneWidget);
    expect(find.text('Please enter your email'), findsOneWidget);
    expect(find.text('Please enter a password'), findsOneWidget);
  });

  testWidgets('registers when the form is valid', (tester) async {
    await tester.pumpWidget(const MyApp());

    final fields = find.byType(TextFormField);
    await tester.enterText(fields.at(0), 'Abror');
    await tester.enterText(fields.at(1), 'name@narxoz.kz');
    await tester.enterText(fields.at(2), 'secret1');
    await tester.enterText(fields.at(3), 'secret1');

    await tester.ensureVisible(find.byType(Checkbox));
    await tester.tap(find.byType(Checkbox));
    await tester.ensureVisible(find.text('Register'));
    await tester.tap(find.text('Register'));
    await tester.pump();

    expect(find.text('Registration successful!'), findsOneWidget);
  });
}
