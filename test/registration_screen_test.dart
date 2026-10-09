import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:user_registration/main.dart';

Future<void> fillValidForm(WidgetTester tester) async {
  await tester.enterText(find.byKey(const Key('nameField')), 'Abror');
  await tester.enterText(find.byKey(const Key('emailField')), 'name@narxoz.kz');
  await tester.enterText(find.byKey(const Key('passwordField')), 'secret1');
  await tester.enterText(
    find.widgetWithText(TextFormField, 'Confirm Password'),
    'secret1',
  );
}

Future<void> tapRegister(WidgetTester tester) async {
  await tester.ensureVisible(find.byKey(const Key('registerButton')));
  await tester.tap(find.byKey(const Key('registerButton')));
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('shows an error under every field on empty submit', (
    tester,
  ) async {
    await tester.pumpWidget(const RegistrationApp());

    await tapRegister(tester);

    expect(find.text('Full name is required'), findsOneWidget);
    expect(find.text('Email is required'), findsOneWidget);
    expect(find.text('Password is required'), findsOneWidget);
    expect(find.text('Please confirm your password'), findsOneWidget);
    expect(
      find.text('You must accept the Terms and Conditions'),
      findsOneWidget,
    );
    expect(find.text('Registration Successful'), findsNothing);
  });

  testWidgets('blocks registration until terms are accepted', (tester) async {
    await tester.pumpWidget(const RegistrationApp());

    await fillValidForm(tester);
    await tapRegister(tester);

    expect(
      find.text('You must accept the Terms and Conditions'),
      findsOneWidget,
    );
    expect(find.text('Registration Successful'), findsNothing);
  });

  testWidgets('shows mismatch error when passwords differ', (tester) async {
    await tester.pumpWidget(const RegistrationApp());

    await fillValidForm(tester);
    await tester.enterText(
      find.widgetWithText(TextFormField, 'Confirm Password'),
      'secret2',
    );
    await tester.pump();

    expect(find.text('Passwords do not match'), findsOneWidget);
  });

  testWidgets('registers with valid data and selected role', (tester) async {
    await tester.pumpWidget(const RegistrationApp());

    await fillValidForm(tester);

    await tester.ensureVisible(find.byKey(const Key('roleField')));
    await tester.tap(find.byKey(const Key('roleField')));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Developer').last);
    await tester.pumpAndSettle();

    await tester.ensureVisible(find.byType(Checkbox));
    await tester.tap(find.byType(Checkbox));
    await tester.pump();

    await tapRegister(tester);

    expect(find.text('Registration Successful'), findsOneWidget);
    expect(find.text('Role: Developer'), findsOneWidget);
    expect(
      find.text('Welcome, Abror! Registration successful.'),
      findsOneWidget,
    );
  });
}
