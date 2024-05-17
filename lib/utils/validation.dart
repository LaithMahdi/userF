String? validEmail(String? value) {
  return value!.isEmpty
      ? "Please enter your email"
      : value.length < 6 || !value.contains('@') || !value.contains('.')
          ? "Please enter a valid email"
          : null;
}

String? validPassword(String? value) {
  return value!.isEmpty
      ? "Please enter your password"
      : value.length < 4
          ? "Password must be at least 4 characters"
          : null;
}

String? validPhoneNum(String? value) {
  return value!.isEmpty
      ? "Please enter your phone number"
      : value.length != 8
          ? "Phone number must be 8 characters"
          : null;
}

String? validConfirmPassword(String? value, String password) {
  return value!.isEmpty
      ? "Please enter your password"
      : value != password
          ? "Password does not match"
          : null;
}

String? validAdresse(String? value) {
  return value!.isEmpty
      ? "Please enter your address"
      : value.length < 3
          ? "Address must be at least 3 characters"
          : null;
}

String? validString(String? value) {
  return value!.isEmpty
      ? "This field is required"
      : value.length < 3
          ? "Address must be at least 3 characters"
          : null;
}
