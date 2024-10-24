class User {
  String name;
  String lastName;
  String email;
  DateTime? birthDate;
  Gender? gender;
  String? phoneNumber;
  String? profilePictureURL;


  User({
    required this.name,
    required this.lastName,
    required this.email,
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