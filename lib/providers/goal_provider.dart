import 'package:care/models/constants/calendar_config.dart';
import 'package:care/models/dtos/walk_monthly_dto.dart';
import 'package:care/models/member.dart';
import 'package:care/models/walk_daily.dart';
import 'package:care/services/goal_service.dart';
import 'package:care/utils/extensions.dart';
import 'package:flutter/material.dart';
import 'package:care/services/walk_service.dart';

class GoalProvider extends ChangeNotifier {
  final goalService = GoalService();
  final walkService = WalkService();

  List<Member> _families = [];
  int? _selectFamilyId;
  final Map<int, Map<String, WalkMonthlyDto>> _walks = {};
  final Map<int, Map<String, Map<DateTime, double>>> _walkPercents = {};
  final Map<int, Set<String>> _loadingWalkMonths = {};

  List<Member> get families => _families;
  int? get selectFamilyId => _selectFamilyId;

  GoalProvider() {
    init();
  }

  void init() async {
    await getFamilies();
    // _families = await goalService.getFamilies();
    if (_families.isEmpty) {
      notifyListeners();
      return;
    }
    for (var family in _families) {
      _walks[family.id] = {};
      _walkPercents[family.id] = {};
      _loadingWalkMonths[family.id] = <String>{};
    }
    _selectFamilyId = _families.first.id;
    await _requestWalkMonthly(CalendarConfig.today);
    notifyListeners();
  }

  Future<void> getFamilies() async {
    final res = await goalService.getFamilies();
    if (res.isSuccess) {
      _families = res.data!.members;
    } else {
      throw Exception("가족 목록 조회 실패");
    }
    notifyListeners();
  }

  Map<DateTime, double> getWalkPercentData(DateTime date) {
    if (_selectFamilyId == null) {
      return {};
    }
    final key = _monthKey(date);
    final familyId = _selectFamilyId!;
    final cached = _walkPercents[familyId]?[key];
    if (cached != null) {
      return cached;
    }
    _requestWalkMonthly(date);
    return {};
  }

  Future<void> _requestWalkMonthly(DateTime date) async {
    if (_selectFamilyId == null) {
      return;
    }
    final key = _monthKey(date);
    final familyId = _selectFamilyId!;
    final familyWalks = _walks[familyId]!;
    final familyPercents = _walkPercents[familyId]!;
    final loadingSet = _loadingWalkMonths[familyId]!;

    if (familyWalks.containsKey(key) || loadingSet.contains(key)) {
      return;
    }

    loadingSet.add(key);
    try {
      final res = await walkService.getWalkMonthly(
        date.year,
        date.month,
        familyId,
      );
      if (res.isSuccess && res.data != null) {
        familyWalks[key] = res.data!;
        familyPercents[key] = _buildPercentMap(res.data!);
      } else {
        throw Exception("월 별 걷기 목록 조회 셀패");
      }
      notifyListeners();
    } finally {
      loadingSet.remove(key);
    }
  }

  Map<DateTime, double> _buildPercentMap(WalkMonthlyDto dto) {
    final map = <DateTime, double>{};
    for (final walk in dto.daily) {
      final parsed = DateTime.parse(walk.date);
      final normalized = DateTime(parsed.year, parsed.month, parsed.day);
      final ratio = walk.goal == 0 ? 0.0 : walk.actual / walk.goal;
      final clamped = ratio.clamp(0.0, 1.0).toDouble();
      map[normalized] = clamped;
    }
    return map;
  }

  String _monthKey(DateTime date) =>
      '${date.year}-${date.month.toString().padLeft(2, '0')}';

  int getSuccessWalkCnt(DateTime date) {
    if (_selectFamilyId == null) {
      return 0;
    }
    final key = _monthKey(date);
    final familyId = _selectFamilyId!;
    final walkData = _walks[familyId]?[key];
    if (walkData == null) {
      return 0;
    }
    return walkData.daily
        .where((walk) => walk.goal > 0 && walk.actual >= walk.goal)
        .length;
  }

  WalkDaily? getWalkDaily(DateTime date) {
    if (_selectFamilyId == null) {
      return null;
    }
    return _walks[_selectFamilyId!]?[_monthKey(date)]
        ?.daily
        .firstWhere((walk) => DateTime.parse(walk.date).isSameDay(date));
  }
}
