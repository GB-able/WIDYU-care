import 'package:care/models/api_response.dart';
import 'package:dio/dio.dart';

extension StringExtension on String? {
  String toPhone() {
    if (this == null) return '';

    String digitsOnly = this!.replaceAll(RegExp(r'[^\d]'), '');

    if (digitsOnly.length != 11) return '';

    return '${digitsOnly.substring(0, 3)} ${digitsOnly.substring(3, 7)} ${digitsOnly.substring(7, 11)}';
  }

  String toTime() {
    try {
      final times = this!.split(':');
      final hour = int.tryParse(times[0]);
      final minute = times[1];
      final isAfternoon = hour! >= 12;

      return "${isAfternoon ? '오후' : '오전'} ${hour % 12 == 0 ? 12 : hour % 12}:$minute";
    } catch (e) {
      return e.toString();
    }
  }
}

extension DateTimeExtension on DateTime {
  String toKor() {
    final year = this.year;
    final month = this.month;
    final day = this.day;
    final weekdays = ['월요일', '화요일', '수요일', '목요일', '금요일', '토요일', '일요일'];
    final weekday = weekdays[this.weekday - 1];

    return "$year년 ${month.toString().padLeft(2, '0')}월 ${day.toString().padLeft(2, '0')}일 $weekday";
  }

  String get onlyMonthDay {
    final month = this.month;
    final day = this.day;
    final weekdays = ['일', '월', '화', '수', '목', '금', '토'];
    final weekday = weekdays[this.weekday - 1];

    return "${month.toString().padLeft(2, '0')}. ${day.toString().padLeft(2, '0')} ($weekday)";
  }

  String get onlyTime {
    final hour = this.hour;
    final minute = this.minute;
    return "${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}"
        .toTime();
  }

  int get endOfMonthDay {
    return DateTime(year, month + 1, 0).day;
  }

  bool isSameDay(DateTime other) {
    return year == other.year && month == other.month && day == other.day;
  }

  bool isSameMonth(DateTime other) {
    return year == other.year && month == other.month;
  }
}

extension IntExtension on int {
  String toDuration() {
    final minutes = this ~/ 60;
    final seconds = this % 60;
    return "${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}";
  }

  String toComma() {
    return toString().replaceAllMapped(
        RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},');
  }
}

extension ApiResponseExtension on Response {
  ApiResponse<T> toApiResponse<T>(
    T Function(Map<String, dynamic>) fromJson,
  ) {
    return ApiResponse<T>.fromJson(statusCode, data, fromJson);
  }
}
