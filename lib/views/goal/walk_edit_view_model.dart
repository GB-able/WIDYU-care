import 'package:care/services/walk_service.dart';
import 'package:flutter/material.dart';

class WalkEditViewModel extends ChangeNotifier {
  final walkService = WalkService();

  int? _initGoal = 10000;
  int? _goal = 10000;
  int? get goal => _goal;

  WalkEditViewModel() {
    init();
  }

  void init() async {
    _initGoal = 10000;
    _goal = _initGoal;
    notifyListeners();
  }

  void setGoal(int goal) {
    _goal = goal;
    notifyListeners();
  }

  Future<void> save(int memberId, void Function() onSuccess,
      void Function(String) onFailure) async {
    try {
      await walkService.updateWalkGoal(memberId, goal!);
      onSuccess();
    } catch (e) {
      onFailure("잠시 후 다시 시도해주세요.");
    }
  }
}
