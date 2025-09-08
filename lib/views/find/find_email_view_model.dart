import 'dart:async';
import 'package:flutter/material.dart';

enum FindEmailStatus {
  identity,
  success,
  fail,
}

class FindEmailViewModel with ChangeNotifier {
  FindEmailStatus _findStatus = FindEmailStatus.identity;

  final _nameCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  final _codeCtrl = TextEditingController();
  final _codeFocus = FocusNode();
  bool _isCodeSent = false;
  bool _isCodeVerified = false;
  bool _isCodeFailed = false;
  Timer? _timer;
  String? _email;

  FindEmailViewModel() {
    _nameCtrl.addListener(() => notifyListeners());
    _phoneCtrl.addListener(() => notifyListeners());
    _codeCtrl.addListener(() {
      _isCodeFailed = false;
      notifyListeners();
    });
  }

  FindEmailStatus get findStatus => _findStatus;
  TextEditingController get nameCtrl => _nameCtrl;
  TextEditingController get phoneCtrl => _phoneCtrl;
  TextEditingController get codeCtrl => _codeCtrl;
  FocusNode get codeFocus => _codeFocus;
  bool get isCodeSent => _isCodeSent;
  bool get isCodeVerified => _isCodeVerified;
  bool get isCodeFailed => _isCodeFailed;
  bool get canSend => _phoneCtrl.text.length == 13 && !isCodeVerified;
  Timer? get timer => _timer;
  String? get email => _email;

  String? codeValidator(String? value) {
    if (_isCodeFailed) {
      return "인증번호가 일치하지 않아요.";
    }
    return null;
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
    _codeCtrl.clear();
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

  void find() {
    // [TODO] 실제 이메일 찾기 로직 넣기
    // _email = "example@widyu.com";
  }

  void setFindStatus(FindEmailStatus status) {
    if (status == FindEmailStatus.fail) {
      _isCodeSent = false;
      _isCodeVerified = false;
      _codeCtrl.clear();
    }
    _findStatus = status;
    notifyListeners();
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _phoneCtrl.dispose();
    _codeCtrl.dispose();
    _codeFocus.dispose();
    _timer?.cancel();
    super.dispose();
  }
}
