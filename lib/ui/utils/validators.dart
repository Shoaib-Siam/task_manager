class Validators {
  static final RegExp emailRegex = RegExp(r"^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$");
  static final RegExp passwordRegex = RegExp(
    r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$',
  );

  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Enter your email';
    } else if (!emailRegex.hasMatch(value)) {
      return 'Enter a valid email address';
    }
    return null;
  }

  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Enter your password';
    } else if (!passwordRegex.hasMatch(value)) {
      return 'Password must be 8+ chars, include uppercase, lowercase, number, and special char';
    }
    return null;
  }
}
