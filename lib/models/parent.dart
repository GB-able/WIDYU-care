class Parent {
  final String name;
  final String inviteCode;
  final String phoneNumber;
  final String address;
  final String detailAddress;
  final String birthDate;

  Parent({
    required this.name,
    required this.inviteCode,
    required this.phoneNumber,
    required this.address,
    required this.detailAddress,
    required this.birthDate,
  });

  Map<String, dynamic> toJson() {
    return {
      "name": name,
      "birthDate": birthDate.replaceAll(". ", ""),
      "phoneNumber": phoneNumber.replaceAll(" ", ""),
      "address": address,
      "detailAddress": detailAddress,
      "inviteCode": inviteCode,
    };
  }
}
