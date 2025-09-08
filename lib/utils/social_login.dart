import 'dart:async';
import 'package:care/models/dtos/social_login_dto.dart';
import 'package:care/models/enums/storage_key.dart';
import 'package:care/services/auth_service.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_naver_login/interface/types/naver_login_status.dart';
import 'package:flutter_naver_login/interface/types/naver_token.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_naver_login/flutter_naver_login.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

class NaverSocialLogin extends SocialLogin {
  @override
  Future<SocialLoginDto?> login() async {
    try {
      final res = await FlutterNaverLogin.logIn();
      if (res.status == NaverLoginStatus.loggedIn) {
        final NaverToken token =
            await FlutterNaverLogin.getCurrentAccessToken();
        if (token.isValid()) {
          return await authService.naverLogin(
              token.accessToken, token.refreshToken);
        } else {
          throw Exception('Naver token is invalid');
        }
      } else {
        throw Exception('Naver login failed');
      }
    } catch (error) {
      return null;
    }
  }

  @override
  Future<void> logout() {
    throw UnimplementedError();
  }

  @override
  Future<void> withdraw() {
    throw UnimplementedError();
  }
}

class KakaoSocialLogin extends SocialLogin {
  @override
  Future<SocialLoginDto?> login() async {
    try {
      OAuthToken tokens;

      if (await isKakaoTalkInstalled()) {
        tokens = await UserApi.instance.loginWithKakaoTalk();
        print('[PRINT] 카카오톡으로 로그인 성공');
      } else {
        tokens = await UserApi.instance.loginWithKakaoAccount();
        print('[PRINT] 카카오계정으로 로그인 성공');
      }

      return await authService.kakaoLogin(tokens.accessToken);
    } catch (error) {
      return null;
    }
  }

  @override
  Future<void> logout() {
    throw UnimplementedError();
  }

  @override
  Future<void> withdraw() {
    throw UnimplementedError();
  }
}

class AppleSocialLogin extends SocialLogin {
  final storage = const FlutterSecureStorage();

  @override
  Future<SocialLoginDto?> login() async {
    try {
      final AuthorizationCredentialAppleID credential =
          await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
        webAuthenticationOptions: WebAuthenticationOptions(
          clientId: dotenv.env['APPLE_CLIENT_ID']!,
          redirectUri: Uri.parse(dotenv.env['APPLE_CALLBACK_URL']!),
        ),
      );

      String? email = credential.email;
      String? name =
          (credential.familyName == null || credential.givenName == null)
              ? null
              : credential.familyName! + credential.givenName!;

      if (email == null || name == null) {
        email = await storage.read(key: StorageKey.tempAppleEmail.name);
        name = await storage.read(key: StorageKey.tempAppleName.name);
      } else {
        await Future.wait([
          storage.write(key: StorageKey.tempAppleEmail.name, value: email),
          storage.write(key: StorageKey.tempAppleName.name, value: name),
        ]);
      }

      return await authService.appleLogin(
          credential.authorizationCode, email, name);
    } catch (e) {
      print('[PRINT] 애플 로그인 실패: $e');
      return null;
    }
  }

  @override
  Future<String?> logout() async {
    return null;
  }

  @override
  Future<String?> withdraw() async {
    return null;
  }
}

abstract class SocialLogin {
  final authService = AuthService();

  Future<SocialLoginDto?> login();
  Future<void> logout();
  Future<void> withdraw();
}
