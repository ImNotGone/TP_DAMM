class User {
  String name;
  String lastName;
  String email;
  String password;
  DateTime? birthDate;
  Gender? gender;
  String? phoneNumber;
  // String? profilePicture;


  User({
    required this.name,
    required this.lastName,
    required this.email,
    required this.password,
  });

  bool isComplete (){
    return
      birthDate != null && email.isNotEmpty && gender != null && phoneNumber != null;
  }
}

enum Gender{
  male,
  female,
  nonBinary
}