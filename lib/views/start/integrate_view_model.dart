import 'package:care/models/dtos/social_login_dto.dart';
import 'package:care/services/auth_service.dart';
import 'package:flutter/material.dart';

class IntegrateViewModel extends ChangeNotifier {
  final AuthService authService = AuthService();
  final NewProfile? newProfile;

  IntegrateViewModel({required this.newProfile});

  Future<void> integrate() async {
    await authService.integrate(newProfile!);
  }
}
