/// Form validators. Each returns a translation key, or null when valid, so the
/// view decides the language.
abstract final class Validators {
  static final _email = RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]{2,}$');

  static const minPasswordLength = 6;

  static String? required(String? value) =>
      (value == null || value.trim().isEmpty) ? 'validation.required' : null;

  static String? email(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'validation.required';
    }
    return _email.hasMatch(value.trim()) ? null : 'validation.email';
  }

  static String? password(String? value) {
    if (value == null || value.isEmpty) {
      return 'validation.required';
    }
    return value.length < minPasswordLength ? 'validation.passwordLength' : null;
  }

  static String? confirmPassword(String? value, String password) {
    if (value == null || value.isEmpty) {
      return 'validation.required';
    }
    return value == password ? null : 'validation.passwordMismatch';
  }
}
