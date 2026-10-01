import 'package:flutter_test/flutter_test.dart';
import 'package:movie_ticket_mobile/core/validation/validators.dart';

void main() {
  test('email', () {
    expect(Validators.email(''), 'validation.required');
    expect(Validators.email('dara@'), 'validation.email');
    expect(Validators.email(' dara@example.com '), isNull);
  });

  test('password needs at least 6 characters', () {
    expect(Validators.password(''), 'validation.required');
    expect(Validators.password('12345'), 'validation.passwordLength');
    expect(Validators.password('123456'), isNull);
  });

  test('confirm password must match', () {
    expect(Validators.confirmPassword('abcdef', 'abcdeg'), 'validation.passwordMismatch');
    expect(Validators.confirmPassword('abcdef', 'abcdef'), isNull);
  });

  test('required trims whitespace', () {
    expect(Validators.required('   '), 'validation.required');
    expect(Validators.required('Dara'), isNull);
  });
}
