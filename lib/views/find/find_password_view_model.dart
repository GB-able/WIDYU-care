import 'dart:async';
import 'package:care/services/auth_service.dart';
import 'package:care/services/sms_service.dart';
import 'package:care/utils/validators.dart';
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
  final authService = AuthService();
  final smsService = SmsService();

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
  int _remainingSeconds = 0;
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
  String get phoneNumber => _phoneCtrl.text.replaceAll(RegExp(r'[^0-9]'), '');
  TextEditingController get codeCtrl => _codeCtrl;
  PwInput get pwInput => _pwInput;
  PwInput get pwConfirmInput => _pwConfirmInput;
  FocusNode get codeFocus => _codeFocus;
  bool get isCodeSent => _isCodeSent;
  bool get isCodeVerified => _isCodeVerified;
  bool get isCodeFailed => _isCodeFailed;
  bool get canSend =>
      _phoneCtrl.text.length == 13 &&
      !isCodeVerified &&
      _nameCtrl.text.isNotEmpty &&
      Validators.emailValidator(emailCtrl.text) == null;
  String get timer {
    if (_remainingSeconds <= 0) return '';
    final minutes = _remainingSeconds ~/ 60;
    final seconds = _remainingSeconds % 60;

    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

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

  void sendVerificationCode() async {
    if (!canSend || isCodeVerified) return;

    if (_timer != null) {
      _timer!.cancel();
    }

    if (await smsService.sendSmsForPw(
        nameCtrl.text, emailCtrl.text, phoneNumber)) {
      _canReset = true;
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
    } else {
      setFindStatus(FindPasswordStatus.fail);
    }
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

  void reset(VoidCallback onSuccess) async {
    try {
      await authService.resetPassword(
          pwInput.ctrl.text, pwConfirmInput.ctrl.text);
      onSuccess();
    } catch (e) {
      throw Exception('Reset password failed');
    }
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
