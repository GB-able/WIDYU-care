import 'package:care/models/walk_daily.dart';

class WalkMonthlyDto {
  final int previous;
  final int current;
  final List<WalkDaily> daily;

  WalkMonthlyDto(
      {required this.previous, required this.current, required this.daily});

  factory WalkMonthlyDto.fromJson(Map<String, dynamic> json) {
    return WalkMonthlyDto(
      previous: json['summary']['previous']['achieved'],
      current: json['summary']['current']['achieved'],
      daily: (json['dailyData'] as List<dynamic>)
          .map((walk) => WalkDaily.fromJson(walk))
          .toList(),
    );
  }
}
