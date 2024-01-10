class RegisterScreenModel {
  String firstName;
  String lastName;
  String otherName;
  String email;
  String password;
  bool termsAndConditions;

  RegisterScreenModel(
      {required this.firstName,
      required this.lastName,
      required this.email,
      required this.password,
      required this.otherName,
      required this.termsAndConditions});

  Map<String, dynamic> toJson() {
    return {
      'firstName': firstName,
      'lastName': lastName,
      'otherName': otherName,
      'email': email,
      'password': password,
      'termsAndConditionsAgreement': termsAndConditions,
    };
  }
}
