class Validators {

  static bool isValidEmail(String email) {
    return !email.contains(' ') && email.length>6;
  }

  static bool isValidPassword(String password) {
    return password.length>=6;
  }
}