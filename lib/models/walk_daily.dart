import 'package:freezed_annotation/freezed_annotation.dart';

part 'walk_daily.freezed.dart';
part 'walk_daily.g.dart';

@freezed
abstract class WalkDaily with _$WalkDaily {
  const factory WalkDaily({
    required String date,
    required int goal,
    required int actual,
  }) = _WalkDaily;

  factory WalkDaily.fromJson(Map<String, dynamic> json) =>
      _$WalkDailyFromJson(json);
}
