import 'package:flutter/material.dart';

class UserProvider extends ChangeNotifier {
  int _joinStep = 0;

  int get joinStep => _joinStep;

  void nextStep() {
    _joinStep++;
    notifyListeners();
  }
}
