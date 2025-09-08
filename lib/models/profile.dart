class Profile {
  final String name;
  final String phoneNumber;
  final String email;
  final List<String> providers;

  Profile(
      {required this.email,
      required this.name,
      required this.phoneNumber,
      required this.providers});

  factory Profile.fromJson(Map<String, dynamic> json) {
    return Profile(
      email: json['email'],
      name: json['name'],
      phoneNumber: json['phoneNumber'],
      providers: json['providers'],
    );
  }
}
