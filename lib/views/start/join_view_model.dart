import 'dart:async';
import 'package:care/models/profile.dart';
import 'package:care/services/auth_service.dart';
import 'package:care/services/sms_service.dart';
import 'package:care/utils/validators.dart';
import 'package:flutter/material.dart';

enum JoinStatus {
  emailPassword,
  identityVerification,
  welcomeInvite,
  applePhone
}

class JoinViewModel with ChangeNotifier {
  final SmsService smsService = SmsService();
  final AuthService authService = AuthService();

  final _nameCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  final _codeCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _pwCtrl = TextEditingController();
  final _codeFocus = FocusNode();
  bool _isCodeSent = false;
  bool _isCodeVerified = false;
  bool _isCodeFailed = false;
  Timer? _timer;
  int _remainingSeconds = 0;
  bool _isAgreed = false;
  bool _isDuplicated = false;
  bool _isChecked = false;
  late JoinStatus _joinStatus;

  JoinViewModel({JoinStatus initJoinStatus = JoinStatus.identityVerification}) {
    _joinStatus = initJoinStatus;
    _nameCtrl.addListener(() => notifyListeners());
    _phoneCtrl.addListener(() => notifyListeners());
    _codeCtrl.addListener(() {
      _isCodeFailed = false;
      notifyListeners();
    });
    _emailCtrl.addListener(() {
      _isChecked = false;
      _isDuplicated = false;
      notifyListeners();
    });
    _pwCtrl.addListener(() => notifyListeners());
  }

  /* [NOTICE] JoinStatus.identityVerification */
  TextEditingController get nameCtrl => _nameCtrl;
  TextEditingController get phoneCtrl => _phoneCtrl;
  String get phoneNumber => _phoneCtrl.text.replaceAll(RegExp(r'[^0-9]'), '');
  TextEditingController get codeCtrl => _codeCtrl;
  FocusNode get codeFocus => _codeFocus;
  bool get isCodeSent => _isCodeSent;
  bool get isCodeVerified => _isCodeVerified;
  bool get isCodeFailed => _isCodeFailed;
  bool get canSend =>
      _phoneCtrl.text.length == 13 &&
      !isCodeVerified &&
      nameCtrl.text.isNotEmpty;
  String get timer {
    if (_remainingSeconds <= 0) return '';
    final minutes = _remainingSeconds ~/ 60;
    final seconds = _remainingSeconds % 60;

    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  bool get isAgreed => _isAgreed;
  /* [NOTICE] JoinStatus.emailPassword */
  TextEditingController get emailCtrl => _emailCtrl;
  TextEditingController get pwCtrl => _pwCtrl;
  bool get isDuplicated => _isDuplicated;
  bool get isChecked => _isChecked;
  JoinStatus get joinStatus => _joinStatus;

  String? codeValidator(String? value) {
    if (_isCodeFailed) {
      return "인증번호가 일치하지 않아요.";
    }
    return null;
  }

  String? emailValidator(String? value) {
    return Validators.chainValidators(value, [
      Validators.emailValidator,
      (value) => isDuplicated ? "중복된 이메일이에요." : null,
    ]);
  }

  void setIsCodeSent(bool value) {
    _isCodeSent = value;
    notifyListeners();
  }

  void sendVerificationCode() async {
    if (!canSend || isCodeVerified) return;

    if (_timer != null) {
      _timer!.cancel();
    }

    await smsService.sendSms(nameCtrl.text, phoneNumber);
    _isCodeSent = true;
    _remainingSeconds = 300;

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _remainingSeconds--;
      if (_remainingSeconds <= 0) {
        timer.cancel();
        _isCodeSent = false;
      }
      notifyListeners();
    });

    notifyListeners();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _codeFocus.requestFocus();
    });
  }

  void verifyCode() async {
    _codeFocus.unfocus();
    if (await smsService.isVerified(phoneNumber, codeCtrl.text)) {
      _isCodeFailed = false;
      _isCodeVerified = true;
    } else {
      _isCodeFailed = true;
      _isCodeVerified = false;
    }
    notifyListeners();
  }

  Future<Profile?> getJoinedProfile() async {
    return await authService.getJoinedProfile();
  }

  void checkDuplicated() async {
    final available = await authService.checkDuplicated(emailCtrl.text);
    if (available) {
      _isDuplicated = false;
      _isChecked = true;
    }
    notifyListeners();
  }

  Future<void> updateApplePhone() async {
    await authService.updateApplePhone(emailCtrl.text);
  }

  void join(VoidCallback onSuccess, Function(String) onFailure) async {
    if (emailCtrl.text.isEmpty || pwCtrl.text.isEmpty || isDuplicated) {
      return;
    }
    try {
      await authService.join(nameCtrl.text, emailCtrl.text,
          phoneCtrl.text.replaceAll(RegExp(r'[^0-9]'), ''), pwCtrl.text);
      onSuccess();
    } catch (e) {
      onFailure("회원가입에 실패했어요. 다시 시도해주세요.");
    }
  }

  void toggleAgree() {
    _isAgreed = !_isAgreed;
    notifyListeners();
  }

  void setJoinStatus(JoinStatus status) {
    _joinStatus = status;
    notifyListeners();
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _phoneCtrl.dispose();
    _codeCtrl.dispose();
    _emailCtrl.dispose();
    _pwCtrl.dispose();
    _codeFocus.dispose();
    _timer?.cancel();
    super.dispose();
  }
}
