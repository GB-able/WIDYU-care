import 'package:care/models/member.dart';

class FamilyMembersDto {
  final List<Member> members;

  FamilyMembersDto({
    required this.members,
  });

  factory FamilyMembersDto.fromJson(Map<String, dynamic> json) {
    return FamilyMembersDto(
      members: (json['families'] as List<dynamic>)
          .map((member) => Member.fromJson(member as Map<String, dynamic>))
          .toList(),
    );
  }
}
