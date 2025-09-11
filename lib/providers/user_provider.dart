import 'package:care/models/parent.dart';
import 'package:care/models/profile.dart';
import 'package:care/services/auth_service.dart';
import 'package:flutter/material.dart';

class UserProvider extends ChangeNotifier {
  final authService = AuthService();

  int _joinStep = 0;
  Profile? _profile;
  List<Parent>? _parents;

  bool get isLogin => _profile != null;
  int get joinStep => _joinStep;
  Profile? get profile => _profile;
  List<Parent>? get parents => _parents;

  Future<void> init() async {
    _profile = await authService.getProfile();
  }

  void setStep(int step) {
    _joinStep = step;
    notifyListeners();
  }

  void nextStep() {
    _joinStep++;
    notifyListeners();
  }

  void previousStep() {
    _joinStep--;
    notifyListeners();
  }

  void setProfile(Profile profile) {
    _profile = profile;
    notifyListeners();
  }

  void setParents(List<Parent> parents) {
    _parents = parents;
    notifyListeners();
  }
}
