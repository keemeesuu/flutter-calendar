import 'package:flutter/material.dart';

class Diary {
  DateTime createdAt;
  String text;

  Diary({
    required this.createdAt,
    required this.text,
  });
}

class DiaryService {
  /// Diary 목록
  List<Diary> diaryList = [];
}

// 현재 날짜
final kToday = DateTime.now();
// first available day for the calendar. Users will not be able to access days before it.
final kFirstDay = DateTime(kToday.year, kToday.month - 3, kToday.day);
// last available day for the calendar. Users will not be able to access days after it.
final kLastDay = DateTime(kToday.year, kToday.month + 3, kToday.day);
