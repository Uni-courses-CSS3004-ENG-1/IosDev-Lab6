import 'package:flutter_test/flutter_test.dart';
import 'package:user_registration/utils/validators.dart';

void main() {
  group('Validators.fullName', () {
    test('rejects empty and blank names', () {
      expect(Validators.fullName(null), isNotNull);
      expect(Validators.fullName(''), isNotNull);
      expect(Validators.fullName('   '), isNotNull);
    });

    test('accepts a name', () {
      expect(Validators.fullName('Abror'), isNull);
    });
  });

  group('Validators.email', () {
    test('rejects empty email', () {
      expect(Validators.email(''), 'Email is required');
    });

    test("rejects emails without '@' or '.'", () {
      expect(Validators.email('name.narxoz.kz'), isNotNull);
      expect(Validators.email('name@narxoz'), isNotNull);
    });

    test('accepts a valid email', () {
      expect(Validators.email('name@narxoz.kz'), isNull);
    });
  });

  group('Validators.password', () {
    test('rejects empty and short passwords', () {
      expect(Validators.password(''), 'Password is required');
      expect(Validators.password('12345'), isNotNull);
    });

    test('accepts 6+ characters', () {
      expect(Validators.password('123456'), isNull);
    });
  });

  group('Validators.confirmPassword', () {
    test('rejects empty and mismatching values', () {
      expect(Validators.confirmPassword('', 'secret1'), isNotNull);
      expect(
        Validators.confirmPassword('secret2', 'secret1'),
        'Passwords do not match',
      );
    });

    test('accepts an exact match', () {
      expect(Validators.confirmPassword('secret1', 'secret1'), isNull);
    });
  });
}
