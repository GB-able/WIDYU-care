import 'package:care/models/parent.dart';
import 'package:care/models/user.dart';
import 'package:flutter/material.dart';

class UserProvider extends ChangeNotifier {
  int _joinStep = 0;
  User? _user;
  List<Parent>? _parents;

  int get joinStep => _joinStep;
  User? get user => _user;
  List<Parent>? get parents => _parents;

  void nextStep() {
    _joinStep++;
    notifyListeners();
  }

  void previousStep() {
    _joinStep--;
    notifyListeners();
  }

  void setUser(User user) {
    _user = user;
    notifyListeners();
  }

  void setParents(List<Parent> parents) {
    _parents = parents;
    notifyListeners();
  }
}
