import 'package:care/services/auth_service.dart';
import 'package:flutter/material.dart';

class IntegrateViewModel extends ChangeNotifier {
  final AuthService authService = AuthService();

  Future<void> integrate() async {
    await authService.integrate();
  }
}
