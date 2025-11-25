import 'dart:math';

import 'package:care/models/constants/calendar_config.dart';
import 'package:care/styles/colors.dart';
import 'package:care/styles/typos.dart';
import 'package:care/utils/extensions.dart';
import 'package:care/widgets/icon_widget.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:table_calendar/table_calendar.dart';

class CalendarWidget extends StatelessWidget {
  const CalendarWidget({
    super.key,
    required this.type,
    required this.focusedDay,
    required this.selectedDay,
    required this.onSelectedDay,
  });

  final CalendarFormat type;
  final DateTime focusedDay;
  final DateTime selectedDay;
  final Function(DateTime) onSelectedDay;

  @override
  Widget build(BuildContext context) {
    final today = DateTime.now();
    final double percent = Random().nextDouble();

    if (type == CalendarFormat.week) {
      return TableCalendar(
        locale: 'ko_KR',
        headerVisible: false,
        focusedDay: focusedDay,
        firstDay: focusedDay,
        lastDay: focusedDay,
        calendarFormat: type,
        rowHeight: 91,
        daysOfWeekVisible: false,
        startingDayOfWeek: StartingDayOfWeek.sunday,
        calendarBuilders: CalendarBuilders(
          prioritizedBuilder: (context, date, events) => Container(
            width: 44,
            decoration: BoxDecoration(
              color: date.isSameDay(selectedDay)
                  ? MyColor.grey700
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(999),
            ),
            padding: const EdgeInsets.only(top: 5, bottom: 10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(DateFormat('E', 'ko_KR').format(date),
                    style: date.isSameDay(selectedDay)
                        ? MyTypo.subTitle2.copyWith(color: MyColor.white)
                        : MyTypo.body2.copyWith(color: MyColor.grey700)),
                Container(
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(
                    color: date.isSameDay(today) && !date.isSameDay(selectedDay)
                        ? MyColor.orange200
                        : Colors.transparent,
                    shape: BoxShape.circle,
                  ),
                  alignment: Alignment.center,
                  child: Text(date.day.toString(),
                      style: date.isSameDay(selectedDay)
                          ? MyTypo.subTitle2.copyWith(color: MyColor.white)
                          : MyTypo.body2.copyWith(color: MyColor.grey700)),
                ),
                percent == 1
                    ? Container(
                        width: 22,
                        height: 22,
                        decoration: const BoxDecoration(
                          color: MyColor.primary,
                          shape: BoxShape.circle,
                        ),
                        alignment: Alignment.center,
                        child: const IconWidget(
                          icon: "check",
                          width: 16,
                          height: 16,
                          color: MyColor.orange50,
                        ),
                      )
                    : CircularPercentIndicator(
                        radius: 11,
                        animation: true,
                        percent: date.isAfter(today) ? 0 : percent,
                        progressColor: MyColor.primary,
                        backgroundColor: date.isAfter(today)
                            ? MyColor.grey100
                            : MyColor.primaryLight,
                        lineWidth: 4,
                        circularStrokeCap: CircularStrokeCap.round,
                      ),
              ],
            ),
          ),
        ),
      );
    } else {
      return NotificationListener<ScrollNotification>(
        onNotification: (notification) {
          return false;
        },
        child: TableCalendar(
          locale: 'ko_KR',
          focusedDay: focusedDay,
          firstDay: CalendarConfig.firstDay,
          lastDay: CalendarConfig.lastDay,
          calendarFormat: type,
          rowHeight: 72,
          daysOfWeekVisible: true,
          daysOfWeekHeight: 44,
          daysOfWeekStyle: DaysOfWeekStyle(
            weekdayStyle: MyTypo.body2.copyWith(color: MyColor.grey500),
            weekendStyle: MyTypo.body2.copyWith(color: MyColor.grey500),
          ),
          calendarStyle: const CalendarStyle(
            outsideDaysVisible: false,
          ),
          headerVisible: false,
          availableGestures: AvailableGestures.none,
          startingDayOfWeek: StartingDayOfWeek.sunday,
          calendarBuilders: CalendarBuilders(
            prioritizedBuilder: (context, date, events) => GestureDetector(
              onTap: () {
                onSelectedDay(date);
              },
              child: Container(
                width: 44,
                decoration: BoxDecoration(
                  color: date.isSameDay(selectedDay)
                      ? MyColor.grey700
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(999),
                ),
                padding: const EdgeInsets.only(top: 2, bottom: 10),
                margin: const EdgeInsets.only(top: 8),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      width: 28,
                      height: 28,
                      decoration: BoxDecoration(
                        color: date.isSameDay(today) &&
                                !date.isSameDay(selectedDay)
                            ? MyColor.orange200
                            : Colors.transparent,
                        shape: BoxShape.circle,
                      ),
                      alignment: Alignment.center,
                      child: Text(date.day.toString(),
                          style: date.isSameDay(selectedDay)
                              ? MyTypo.subTitle2.copyWith(color: MyColor.white)
                              : MyTypo.body2.copyWith(color: MyColor.grey700)),
                    ),
                    percent == 1
                        ? Container(
                            width: 22,
                            height: 22,
                            decoration: const BoxDecoration(
                              color: MyColor.primary,
                              shape: BoxShape.circle,
                            ),
                            alignment: Alignment.center,
                            child: const IconWidget(
                              icon: "check",
                              width: 16,
                              height: 16,
                              color: MyColor.orange50,
                            ),
                          )
                        : CircularPercentIndicator(
                            radius: 11,
                            animation: true,
                            percent: date.isAfter(today) ? 0 : percent,
                            progressColor: MyColor.primary,
                            backgroundColor: date.isAfter(today)
                                ? MyColor.grey100
                                : MyColor.primaryLight,
                            lineWidth: 4,
                            circularStrokeCap: CircularStrokeCap.round,
                          ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    }
  }
}
