import 'package:flutter/cupertino.dart';

class LoginViewModel with ChangeNotifier {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  final _emailCtrl = TextEditingController();
  final _pwCtrl = TextEditingController();
  bool _isPwObsecure = true;
  bool _isFailed = false;

  LoginViewModel() {
    _emailCtrl.addListener(() {
      _isFailed = false;
      notifyListeners();
    });
    _pwCtrl.addListener(() {
      _isFailed = false;
      notifyListeners();
    });
  }

  @override
  void dispose() {
    _emailCtrl.dispose();
    _pwCtrl.dispose();
    super.dispose();
  }

  TextEditingController get emailCtrl => _emailCtrl;
  TextEditingController get pwCtrl => _pwCtrl;
  bool get isPwObsecure => _isPwObsecure;

  String? emailValidator(String? value) {
    if (_isFailed) {
      return "이메일 또는 비밀번호가 일치하지 않습니다.";
    } else if (value == null || value.isEmpty) {
      return '이메일을 입력해주세요.';
    } else if (!RegExp(r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$")
        .hasMatch(value)) {
      return '올바른 이메일 형식이 아닙니다.';
    }
    return null;
  }

  String? pwValidator(String? value) {
    if (_isFailed) {
      return "이메일 또는 비밀번호가 일치하지 않습니다.";
    } else if (value == null || value.isEmpty) {
      return '비밀번호를 입력해주세요.';
    }
    return null;
  }

  Future<bool> login() async {
    if (formKey.currentState?.validate() ?? false) {
      if (false) {
        // [TODO] 실제 로그인 로직 넣기
        await Future.delayed(const Duration(seconds: 1));
        return true;
      } else {
        _isFailed = true;
        notifyListeners();
        return false;
      }
    } else {
      return false;
    }
  }

  void togglePwObscure() {
    _isPwObsecure = !_isPwObsecure;
    notifyListeners();
  }
}
