class Validators {
  static bool isValidEmail(String value) {
    final emailRegex = RegExp(r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
    return emailRegex.hasMatch(value);
  }

  static bool isUideEmail(String email) {
    return email.endsWith('@uide.edu.ec');
  }
}