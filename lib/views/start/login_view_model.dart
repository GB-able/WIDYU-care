import 'package:care/services/auth_service.dart';
import 'package:care/utils/validators.dart';
import 'package:flutter/cupertino.dart';

class LoginViewModel with ChangeNotifier {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final AuthService authService = AuthService();

  final _emailCtrl = TextEditingController();
  final _pwCtrl = TextEditingController();
  bool _isPwObscure = true;
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
  bool get isPwObscure => _isPwObscure;

  String? emailValidator(String? value) {
    return Validators.chainValidators(value, [
      (value) => _isFailed ? "" : null,
      Validators.emailValidator,
    ]);
  }

  String? pwValidator(String? value) {
    if (_isFailed) {
      return "이메일 또는 비밀번호가 일치하지 않아요.";
    } else if (value == null || value.isEmpty) {
      return '비밀번호를 입력해주세요.';
    }
    return null;
  }

  void login(VoidCallback onSuccess, VoidCallback onFailure) async {
    if (formKey.currentState?.validate() ?? false) {
      if (await authService.login(_emailCtrl.text, _pwCtrl.text)) {
        onSuccess();
      } else {
        _isFailed = true;
        onFailure();
        notifyListeners();
      }
    } else {
      onFailure();
    }
  }

  void togglePwObscure() {
    _isPwObscure = !_isPwObscure;
    notifyListeners();
  }
}
