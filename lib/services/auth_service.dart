import 'package:care/models/dtos/social_login_dto.dart';
import 'package:care/models/enums/social_type.dart';
import 'package:care/models/parent.dart';
import 'package:care/models/profile.dart';
import 'package:care/services/api.dart';

class AuthService {
  final API api = API();
  final String url = "/auth";

  Future<SocialLoginDto?> _socialLogin(
      SocialType provider, Map<String, dynamic> body) async {
    final res = await api.req(
      "$url/guardians/sign-in/social",
      method: HttpMethod.post,
      query: {
        "provider": provider.name,
      },
      body: body,
      tokenType: TokenType.none,
    );

    if (res.statusCode == 200 || res.statusCode == 201) {
      final data = res.data['data'];
      final String? accessToken = data['accessToken'];
      final String? refreshToken = data['refreshToken'];
      if (accessToken != null && refreshToken != null) {
        await api.setToken(accessToken, refreshToken);
      }
      return SocialLoginDto.fromJson(data);
    } else {
      throw Exception('Social login failed');
    }
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

  Future<void> logout() async {
    final res = await api.req(
      "$url/logout",
      method: HttpMethod.post,
    );
    if (res.statusCode == 200) {
      await api.removeToken();
    }
  }

  Future<void> withdraw() async {
    final res = await api.req(
      "$url/guardians/withdraw",
      method: HttpMethod.delete,
      body: {
        "reason": "테스트",
      },
    );
    if (res.statusCode == 200) {
      await api.removeToken();
    } else {
      throw Exception('Withdraw failed');
    }
  }

  Future<Profile?> getProfile() async {
    if (!await api.hasToken()) {
      return null;
    }

    final res = await api.req(
      "$url/guardians/me",
      method: HttpMethod.get,
    );
    if (res.statusCode == 200) {
      return Profile.fromJson(res.data['data']);
    }
    return null;
  }

  Future<void> registerParent(List<Parent> parents) async {
    final res = await api.req(
      "$url/parents/sign-up",
      method: HttpMethod.post,
      body: parents.map((e) => e.toJson()).toList(),
    );
    if (res.statusCode == 200) {
      return;
    } else {
      throw Exception('Register parent failed');
    }
  }

  Future<Profile?> getJoinedProfile() async {
    final res = await api.req(
      "$url/guardians/profile/temporary",
      method: HttpMethod.get,
      tokenType: TokenType.temporary,
    );
    if (res.statusCode == 200) {
      return Profile.fromJson(res.data['data']);
    } else {
      return null;
    }
  }

  Future<void> integrate(NewProfile profile) async {
    final res = await api.req(
      "$url/guardians/social/integration",
      method: HttpMethod.post,
      body: {
        "name": profile.name,
        "email": profile.email,
        "phoneNumber": profile.phoneNumber,
        "provider": profile.provider,
        "oauthId": profile.oauthId,
      },
    );
    if (res.statusCode == 200) {
      return;
    } else {
      throw Exception('Integrate failed');
    }
  }

  Future<void> join(
      String name, String email, String phoneNumber, String password) async {
    try {
      final res = await api.req(
        "$url/guardians/sign-up/local",
        method: HttpMethod.post,
        body: {
          "name": name,
          "email": email,
          "phoneNumber": phoneNumber,
          "password": password,
        },
        tokenType: TokenType.temporary,
      );
      if (res.statusCode == 200) {
        final data = res.data['data'];
        await api.setToken(data['accessToken'], data['refreshToken']);
      } else {
        throw Exception('Join failed');
      }
    } catch (e) {
      throw Exception('Join failed');
    }
  }

  Future<bool> checkDuplicated(String email) async {
    final res = await api.req(
      "$url/guardians/email/check",
      method: HttpMethod.post,
      body: {"email": email},
    );
    if (res.statusCode == 200) {
      return res.data['data'];
    } else {
      throw Exception('Check duplicated failed');
    }
  }

  Future<void> resetPassword(String password, String confirmPassword) async {
    final res = await api.req(
      "$url/guardians/password",
      method: HttpMethod.patch,
      body: {"password": password, "confirmPassword": confirmPassword},
      tokenType: TokenType.temporary,
    );
    if (res.statusCode != 200) {
      throw Exception('Reset password failed');
    }
  }

  Future<bool> login(String email, String password) async {
    try {
      final res = await api.req(
        "$url/guardians/sign-in/local",
        method: HttpMethod.post,
        body: {"email": email, "password": password},
      );
      if (res.statusCode == 200) {
        final data = res.data['data'];
        await api.setToken(data['accessToken'], data['refreshToken']);
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }
}
