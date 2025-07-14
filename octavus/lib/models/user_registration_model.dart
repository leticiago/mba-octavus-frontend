class UserRegistration {
  String name;
  String surname;
  String email;
  String password;
  String username;
  String contact;
  String instrumentId;
  String profileId;
  List<String>? roles;

  UserRegistration({
    required this.name,
    required this.surname,
    required this.email,
    required this.password,
    required this.username,
    required this.contact,
    required this.instrumentId,
    required this.profileId,
    required this.roles,
  });

  Map<String, dynamic> toJson() => {
        'email': email,
        'password': password,
        'name': name,
        'username': username,
        'contact': contact,
        'instrumentId': instrumentId,
        'profileId': profileId,
        'roles': roles,
        'surname': surname
      };
}
