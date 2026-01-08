import 'package:care/models/constants/calendar_config.dart';
import 'package:care/utils/extensions.dart';
import 'package:flutter/material.dart';

class WalkViewModel extends ChangeNotifier {
  DateTime _focusedDay = DateTime.now();
  DateTime _selectedDay = DateTime.now();

  DateTime get focusedDay => _focusedDay;
  DateTime get selectedDay => _selectedDay;

  void setSelectedDay(DateTime day) {
    _selectedDay = day;
    notifyListeners();
  }

  void _setFocusedDay(DateTime day) {
    _focusedDay = day;
    notifyListeners();
  }

  void previousMonth() {
    if (_focusedDay.isSameMonth(CalendarConfig.firstDay)) {
      return;
    }
    _setFocusedDay(DateTime(_focusedDay.year, _focusedDay.month - 1));
  }

  void nextMonth() {
    if (_focusedDay.isSameMonth(CalendarConfig.today)) {
      return;
    }
    _setFocusedDay(DateTime(_focusedDay.year, _focusedDay.month + 1));
  }
}
