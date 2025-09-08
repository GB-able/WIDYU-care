import 'dart:async';
import 'package:flutter/material.dart';

enum FindPasswordStatus {
  identity,
  success,
  fail,
}

class PwInput with ChangeNotifier {
  final TextEditingController ctrl;
  bool _isObscure = true;

  bool get isObscure => _isObscure;

  VoidCallback get toggleObscure => () {
        _isObscure = !_isObscure;
        notifyListeners();
      };

  PwInput({required this.ctrl});

  @override
  void dispose() {
    ctrl.dispose();
    super.dispose();
  }
}

class FindPasswordViewModel with ChangeNotifier {
  FindPasswordStatus _findStatus = FindPasswordStatus.identity;

  final _nameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  final _codeCtrl = TextEditingController();
  final _pwInput = PwInput(ctrl: TextEditingController());
  final _pwConfirmInput = PwInput(ctrl: TextEditingController());
  final _codeFocus = FocusNode();
  bool _isCodeSent = false;
  bool _isCodeVerified = false;
  bool _isCodeFailed = false;
  Timer? _timer;
  bool _canReset = false;

  FindPasswordViewModel() {
    _nameCtrl.addListener(() => notifyListeners());
    _emailCtrl.addListener(() => notifyListeners());
    _phoneCtrl.addListener(() => notifyListeners());
    _pwInput.ctrl.addListener(() => notifyListeners());
    _pwConfirmInput.ctrl.addListener(() => notifyListeners());
    _codeCtrl.addListener(() {
      _isCodeFailed = false;
      notifyListeners();
    });
  }

  FindPasswordStatus get findStatus => _findStatus;
  TextEditingController get nameCtrl => _nameCtrl;
  TextEditingController get emailCtrl => _emailCtrl;
  TextEditingController get phoneCtrl => _phoneCtrl;
  TextEditingController get codeCtrl => _codeCtrl;
  PwInput get pwInput => _pwInput;
  PwInput get pwConfirmInput => _pwConfirmInput;
  FocusNode get codeFocus => _codeFocus;
  bool get isCodeSent => _isCodeSent;
  bool get isCodeVerified => _isCodeVerified;
  bool get isCodeFailed => _isCodeFailed;
  bool get canSend => _phoneCtrl.text.length == 13 && !isCodeVerified;
  Timer? get timer => _timer;
  bool get canReset => _canReset;

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

  void checkCanReset() {
    // [TODO] 실제 비밀번호 찾기 로직 넣기
    _canReset = false;
  }

  void reset() {
    // [TODO] 실제 비밀번호 재설정 로직 넣기
  }

  void setFindStatus(FindPasswordStatus status) {
    if (status == FindPasswordStatus.fail) {
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
    _emailCtrl.dispose();
    _phoneCtrl.dispose();
    _pwInput.dispose();
    _pwConfirmInput.dispose();
    _codeCtrl.dispose();
    _codeFocus.dispose();
    _timer?.cancel();
    super.dispose();
  }
}
