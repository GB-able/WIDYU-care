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
      profile:
          json['profile'] != null ? Profile.fromJson(json['profile']) : null,
      newProfile: json['newSocialAccountInfo'] != null
          ? NewProfile(
              oauthId: json['newSocialAccountInfo']['oauthId'],
              provider: json['newSocialAccountInfo']['provider'],
              name: json['newSocialAccountInfo']['name'],
              email: json['newSocialAccountInfo']['email'],
              phoneNumber: json['newSocialAccountInfo']['phoneNumber'] ??
                      json['profile'] != null
                  ? json['profile']['phoneNumber']
                  : null,
            )
          : null,
    );
  }
}

class NewProfile {
  final String oauthId;
  final String provider;
  final String name;
  final String email;
  final String phoneNumber;

  NewProfile({
    required this.oauthId,
    required this.provider,
    required this.name,
    required this.email,
    required this.phoneNumber,
  });

  factory NewProfile.fromJson(Map<String, dynamic> json) {
    return NewProfile(
      oauthId: json['oauthId'],
      provider: json['provider'],
      name: json['name'],
      email: json['email'],
      phoneNumber: json['phoneNumber'],
    );
  }
}
