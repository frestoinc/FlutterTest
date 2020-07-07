class FormController {
  final String emailError;
  final String passwordError;
  final bool isDataValid;

  FormController({this.emailError, this.passwordError, this.isDataValid});

  factory FormController.init() => FormController(isDataValid: false);

  factory FormController.error(String a, String b) =>
      FormController(emailError: a, passwordError: b, isDataValid: false);

  factory FormController.isValidated(bool b) => FormController(isDataValid: b);
}
