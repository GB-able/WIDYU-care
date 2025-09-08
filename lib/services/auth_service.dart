import 'package:care/models/dtos/social_login_dto.dart';
import 'package:care/models/enums/social_type.dart';
import 'package:care/services/api.dart';

class AuthService {
  final API api = API();
  final String url = "/auth/guardians";

  Future<SocialLoginDto?> _socialLogin(
      SocialType provider, Map<String, dynamic> body) async {
    final res = await api.req(
      "$url/sign-in/social",
      method: HttpMethod.post,
      query: {
        "provider": provider.name,
      },
      body: body,
    );

    if (res.statusCode == 200 || res.statusCode == 201) {
      final data = res.data['data'];
      final String? accessToken = data['accessToken'];
      final String? refreshToken = data['refreshToken'];
      if (accessToken != null && refreshToken != null) {
        await api.setToken(accessToken, refreshToken);
      }
      return SocialLoginDto.fromJson(data);
    }

    return null;
  }

  Future<SocialLoginDto?> appleLogin(
      String authorizationCode, String? email, String? name) async {
    return _socialLogin(SocialType.apple, {
      "authorizationCode": authorizationCode,
      "profile": {
        "email": email,
        "name": name,
      }
    });
  }

  Future<SocialLoginDto?> kakaoLogin(String accessToken) async {
    return _socialLogin(SocialType.kakao, {
      "accessToken": accessToken,
    });
  }

  Future<SocialLoginDto?> naverLogin(
      String accessToken, String refreshToken) async {
    return _socialLogin(SocialType.naver, {
      "accessToken": accessToken,
      "refreshToken": refreshToken,
    });
  }
}
