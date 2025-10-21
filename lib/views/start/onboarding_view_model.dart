import 'package:care/models/dtos/social_login_dto.dart';
import 'package:care/models/enums/social_type.dart';
import 'package:care/models/enums/storage_key.dart';
import 'package:care/services/auth_service.dart';
import 'package:care/utils/show_toast.dart';
import 'package:carousel_slider/carousel_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_naver_login/flutter_naver_login.dart';
import 'package:flutter_naver_login/interface/types/naver_login_status.dart';
import 'package:flutter_naver_login/interface/types/naver_token.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart'
    hide Profile;
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:care/models/profile.dart';

class OnboardingViewModel extends ChangeNotifier {
  final storage = const FlutterSecureStorage();
  final authService = AuthService();

  List<String> descriptions =
      List.generate(5, (_) => "부모님의 하루를 챙기고,\n마음까지 전하세요.");

  final _ctrl = CarouselSliderController();
  int _currIdx = 0;

  CarouselSliderController get ctrl => _ctrl;
  int get currIdx => _currIdx;

  void setCurrIdx(int idx) {
    _currIdx = idx;
    notifyListeners();
  }

  Future<void> socialLogin(SocialType type, Function(Profile profile) onJoined,
      VoidCallback onNotJoined) async {
    SocialLoginDto? result;
    switch (type) {
      case SocialType.apple:
        result = await _appleLogin();
        break;
      case SocialType.kakao:
        result = await _kakaoLogin();
        break;
      case SocialType.naver:
        result = await _naverLogin();
        break;
    }

    if (result == null) {
      showToast("${type.label} 로그인 실패");
      return;
    }

    if (result.socialToken == null) {
      onNotJoined();
    } else {
      await storage.write(
          key: StorageKey.tempToken.name, value: result.socialToken!);
      onJoined(result.profile!);
    }
  }

  Future<SocialLoginDto?> _appleLogin() async {
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

  Future<SocialLoginDto?> _kakaoLogin() async {
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
    } catch (e) {
      print('[PRINT] 카카오 로그인 실패: $e');
      return null;
    }
  }

  Future<SocialLoginDto?> _naverLogin() async {
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
      print('[PRINT] 네이버 로그인 실패: $error');
      return null;
    }
  }
}
