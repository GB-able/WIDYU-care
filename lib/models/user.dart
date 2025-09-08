class User {
  final String name;
  final String email;
  final String phone;
  final List<String>? socials;

  User({
    required this.name,
    required this.email,
    required this.phone,
    this.socials,
  });
}
