import 'dart:async';

import 'package:care/utils/validators.dart';
import 'package:flutter/material.dart';

enum JoinStatus {
  emailPassword,
  identityVerification,
  welcomeInvite,
}

class JoinViewModel with ChangeNotifier {
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
  bool _isAgreed = false;
  bool _isDuplicated = false;
  bool _isChecked = false;
  JoinStatus _joinStatus = JoinStatus.identityVerification;

  JoinViewModel() {
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
  TextEditingController get codeCtrl => _codeCtrl;
  FocusNode get codeFocus => _codeFocus;
  bool get isCodeSent => _isCodeSent;
  bool get isCodeVerified => _isCodeVerified;
  bool get isCodeFailed => _isCodeFailed;
  bool get canSend => _phoneCtrl.text.length == 13 && !isCodeVerified;
  Timer? get timer => _timer;
  bool get isAgreed => _isAgreed;
  /* [NOTICE] JoinStatus.emailPassword */
  TextEditingController get emailCtrl => _emailCtrl;
  TextEditingController get pwCtrl => _pwCtrl;
  bool get isDuplicated => _isDuplicated;
  bool get isChecked => _isChecked;
  JoinStatus get joinStatus => _joinStatus;

  String? codeValidator(String? value) {
    if (_isCodeFailed) {
      return "인증번호가 일치하지 않습니다.";
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

  void sendVerificationCode() {
    // [TODO] 실제 인증번호 전송 로직 넣기
    if (!canSend || isCodeVerified) return;

    if (_timer != null) {
      _timer!.cancel();
    }
    _isCodeSent = true;
    _timer = Timer.periodic(const Duration(minutes: 5), (timer) {});
    notifyListeners();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _codeFocus.requestFocus();
    });
  }

  void verifyCode() {
    _codeFocus.unfocus();
    // [TODO] 실제 인증번호 검증 로직 넣기
    if (true) {
      _isCodeFailed = false;
      _isCodeVerified = true;
    } else {
      _isCodeFailed = true;
      _isCodeVerified = false;
    }
    notifyListeners();
  }

  void checkDuplicated() {
    // [TODO] 중복 이메일 확인 로직 넣기
    _isDuplicated = false;
    _isChecked = true;
    notifyListeners();
  }

  void join(VoidCallback callback) {
    // [TODO] 회원가입 로직 넣기
    if (emailCtrl.text.isEmpty || pwCtrl.text.isEmpty || isDuplicated) {
      return;
    }
    callback();
    setJoinStatus(JoinStatus.welcomeInvite);
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
