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

abstract class SocialLogin {
  final authService = AuthService();

  Future<SocialLoginDto?> login();
  Future<void> logout();
  Future<void> withdraw();
}
