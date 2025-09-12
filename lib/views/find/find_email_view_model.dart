import 'dart:async';
import 'package:care/models/profile.dart';
import 'package:care/services/auth_service.dart';
import 'package:care/services/sms_service.dart';
import 'package:flutter/material.dart';

enum FindEmailStatus {
  identity,
  success,
  fail,
}

class FindEmailViewModel with ChangeNotifier {
  final authService = AuthService();
  final smsService = SmsService();
  FindEmailStatus _findStatus = FindEmailStatus.identity;

  final _nameCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  final _codeCtrl = TextEditingController();
  final _codeFocus = FocusNode();
  bool _isCodeSent = false;
  bool _isCodeVerified = false;
  bool _isCodeFailed = false;
  int _remainingSeconds = 0;
  Timer? _timer;
  Profile? _profile;
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
  String get phoneNumber => _phoneCtrl.text.replaceAll(RegExp(r'[^0-9]'), '');
  TextEditingController get codeCtrl => _codeCtrl;
  FocusNode get codeFocus => _codeFocus;
  bool get isCodeSent => _isCodeSent;
  bool get isCodeVerified => _isCodeVerified;
  bool get isCodeFailed => _isCodeFailed;
  bool get canSend => _phoneCtrl.text.length == 13 && !isCodeVerified;
  String get timer {
    if (_remainingSeconds <= 0) return '';
    final minutes = _remainingSeconds ~/ 60;
    final seconds = _remainingSeconds % 60;

    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  Profile? get profile => _profile;

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

  void find() async {
    _profile = await authService.getJoinedProfile();
    if (_profile == null) {
      setFindStatus(FindEmailStatus.fail);
    } else {
      setFindStatus(FindEmailStatus.success);
    }
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
