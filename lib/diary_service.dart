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
    Diary(createdAt: DateTime(2023, 01, 03), text: "dummy2"),
    // Dummy Data
  ];

  /// 특정 날짜의 diary 조회
  List<Diary> getByDate(DateTime date) {
    // diaryList 메소드 에서 date의 값과 같은 날만 return
    return diaryList
        .where((diary) => isSameDay(date, diary.createdAt))
        .toList();
  }

  /// 글 수정을 위해 선택시 해당 날짜 diary 글 조회
  List getByDateDetail(DateTime date) {
    // return diaryList.where((diary) => diaryList. == diary.createdAt);

    final dateDetail =
        diaryList.where((diary) => diary.createdAt == date).toList();

    // print("${dateDetail[0].createdAt}, ${dateDetail[0].text}");

    return [dateDetail[0].createdAt, dateDetail[0].text];
  }

  void create(String text, DateTime selectedDate) {
    DateTime now = DateTime.now();

    // 선택된 날짜(selectedDate)에 현재 시간으로 추가
    DateTime createAt = DateTime(
      selectedDate.year,
      selectedDate.month,
      selectedDate.day,
      now.hour,
      now.minute,
      now.second,
    );

    Diary diary = Diary(
      createdAt: createAt,
      text: text,
    );
    diaryList.add(diary);
    notifyListeners();
  }

  void update(String text, DateTime selectedDate) {
    // List date = getByDateDetail(selectedDate);

    diaryList[diaryList.indexWhere((item) => item.createdAt == selectedDate)]
        .text = text;
    notifyListeners();
  }
}

// 현재 날짜
final kToday = DateTime.now();
// first available day for the calendar. Users will not be able to access days before it.
final kFirstDay = DateTime(kToday.year, kToday.month - 3, kToday.day);
// last available day for the calendar. Users will not be able to access days after it.
final kLastDay = DateTime(kToday.year, kToday.month + 3, kToday.day);
