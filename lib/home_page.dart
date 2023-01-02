import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

import 'diary_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

/// Example event class.
class Event {
  final String title;

  const Event(this.title);

  @override
  String toString() => title;
}

class _HomePageState extends State<HomePage> {
  // 달력 보여주는 형식(?)
  // In order to dynamically update visible calendar format, add those lines to the widget:
  CalendarFormat _calendarFormat = CalendarFormat.month;

  // 지정 날짜
  DateTime _focusedDay = DateTime.now();

  // 선택 날짜
  DateTime? _selectedDay;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Diary"),
      ),
      body: TableCalendar(
        focusedDay: _focusedDay,
        firstDay: kFirstDay,
        lastDay: kLastDay,

        // "selectedDayPredicate"and "onDaySelected" are a pair.
        // 현재 선택된 날짜를 결정하는 method.
        selectedDayPredicate: (day) {
          // return value가 true일 경우 날짜는 selected로 표시됨.

          // Using `isSameDay` is recommended to disregard.
          // the time-part of compared DateTime objects.
          // 대략 캘린더 리스트 에서 선택한 날짜와 비교해 맞으면 true 해주는 기능.
          // argument a와 b를 비교해 맞으면 true 반환.
          print(_selectedDay);
          return isSameDay(_selectedDay, day);
        },
        onDaySelected: (selectedDay, focusedDay) {
          setState(() {
            _selectedDay = selectedDay;
            _focusedDay = focusedDay; // update `_focusedDay` here as well
          });
        },

        // 달력형식 변경 (Month, 2weeks, Week).
        // "calendarFormat" and "onFormatChanged" are a apir.
        calendarFormat: _calendarFormat,
        onFormatChanged: (format) {
          setState(() {
            _calendarFormat = format;
          });
        },

        eventLoader: (day) {
          // 각 날짜에 해당하는 diaryList 보여주기
          return [];
        },
      ),
    );
  }
}
