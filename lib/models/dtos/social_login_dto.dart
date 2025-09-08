import 'package:care/models/profile.dart';

class SocialLoginDto {
  final bool isFirst;
  final String? accessToken;
  final String? refreshToken;
  final Profile? profile;
  final NewProfile? newProfile;

  SocialLoginDto({
    required this.isFirst,
    required this.accessToken,
    required this.refreshToken,
    required this.profile,
    required this.newProfile,
  });

  factory SocialLoginDto.fromJson(Map<String, dynamic> json) {
    return SocialLoginDto(
      isFirst: json['isFirst'],
      accessToken: json['accessToken'],
      refreshToken: json['refreshToken'],
      profile: Profile.fromJson(json['profile']),
      newProfile: NewProfile.fromJson(json['newSocialAccountInfo']),
    );
  }
}

class NewProfile {
  final String oauthId;
  final String provider;
  final String name;
  final String email;

  NewProfile({
    required this.oauthId,
    required this.provider,
    required this.name,
    required this.email,
  });

  factory NewProfile.fromJson(Map<String, dynamic> json) {
    return NewProfile(
      oauthId: json['oauthId'],
      provider: json['provider'],
      name: json['name'],
      email: json['email'],
    );
  }
}
