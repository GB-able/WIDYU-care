class Profile {
  final String name;
  final String? phoneNumber;
  final String email;
  final List<String> providers;
  final bool hasParents;

  Profile({
    required this.email,
    required this.name,
    required this.phoneNumber,
    this.providers = const [],
    this.hasParents = false,
  });

  factory Profile.fromJson(Map<String, dynamic> json) {
    final String? phone = json['phoneNumber'] ?? json['phone'];
    return Profile(
      email: json['email'],
      name: json['name'],
      phoneNumber: phone,
      providers: json['providers'].cast<String>() ?? [],
      hasParents: json['hasParents'] ?? false,
    );
  }
}
