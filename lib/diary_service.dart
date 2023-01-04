import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class Diary {
  DateTime createdAt;
  String text;

  Diary({
    required this.createdAt,
    required this.text,
  });
}

class DiaryService extends ChangeNotifier {
  /// Diary 목록
  List<Diary> diaryList = [
    Diary(createdAt: DateTime.now(), text: "dummy1"),
    Diary(createdAt: DateTime.now(), text: "dummy2"),
    Diary(createdAt: DateTime(2023, 01, 05), text: "dummy2"),
    // Dummy Data
  ];

  /// 특정 날짜의 diary 조회
  List<Diary> getByDate(DateTime date) {
    // diaryList 메소드 에서 date의 값과 같은 날만 return
    return diaryList
        .where((diary) => isSameDay(date, diary.createdAt))
        .toList();
  }
}

// 현재 날짜
final kToday = DateTime.now();
// first available day for the calendar. Users will not be able to access days before it.
final kFirstDay = DateTime(kToday.year, kToday.month - 3, kToday.day);
// last available day for the calendar. Users will not be able to access days after it.
final kLastDay = DateTime(kToday.year, kToday.month + 3, kToday.day);
