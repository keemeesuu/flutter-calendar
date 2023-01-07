import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
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
  // DateTime _focusedDay = DateTime.now();

  // 선택 날짜
  DateTime selectedDay = DateTime.now();

  // create text controller
  TextEditingController createTextController = TextEditingController();

  // update text controller
  TextEditingController updateTextController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Consumer<DiaryService>(
      builder: (context, diaryService, child) {
        List<Diary> diaryList = diaryService.getByDate(selectedDay);
        return Scaffold(
          appBar: AppBar(
            title: Text("Diary"),
          ),
          body: Column(
            children: [
              TableCalendar(
                firstDay: kFirstDay,
                lastDay: kLastDay,
                focusedDay: selectedDay,

                // "selectedDayPredicate"and "onDaySelected" are a pair.
                // 현재 선택된 날짜를 결정하는 method.
                selectedDayPredicate: (day) {
                  // return value가 true일 경우 날짜는 selected로 표시됨.

                  // isSameDay 란?
                  // Using `isSameDay` is recommended to disregard.
                  // the time-part of compared DateTime objects.
                  // 캘린더 리스트 에서 선택한 날짜와 비교해 맞으면 true 해주는 기능.
                  // argument a와 b를 비교해 맞으면 true 반환.
                  return isSameDay(selectedDay, day);
                },
                onDaySelected: (_, focusedDay) {
                  setState(() {
                    selectedDay = focusedDay;
                    // _focusedDay = focusedDay; // update `_focusedDay` here as well
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
                  return diaryService.getByDate(day);
                },
              ),
              Divider(height: 1),

              /// 선택한 날짜의 일기 목록
              Expanded(
                child: diaryList.isEmpty
                    ? Center(
                        child: Text(""),
                      )
                    : ListView.separated(
                        itemCount: diaryList.length,
                        itemBuilder: (context, index) {
                          // 역순으로 보여주기
                          int i = diaryList.length - index - 1;
                          Diary diary = diaryList[i];
                          return ListTile(
                            title: Text(
                              diary.text,
                              style: TextStyle(
                                fontSize: 24,
                                color: Colors.black,
                              ),
                            ),
                            trailing: Text(
                              DateFormat('kk:mm').format(diary.createdAt),
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey,
                              ),
                            ),

                            /// Update Button
                            onTap: () {
                              // 텍스트 불러오기
                              List diaryDetail =
                                  diaryService.getByDateDetail(diary.createdAt);
                              updateTextController.text = diaryDetail[1];
                              final ogDate = diaryDetail[0];

                              showUpdateDialog(context, diaryService, ogDate);
                            },

                            /// Delete Button
                            onLongPress: () {
                              showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    title: Text("삭제 하시겠습니까?"),
                                    actions: [
                                      TextButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        child: Text("취소"),
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          diaryService.delete(diary.createdAt);
                                          Navigator.pop(context);
                                        },
                                        child: Text("삭제"),
                                      ),
                                    ],
                                  );
                                },
                              );
                            },
                          );
                        },
                        separatorBuilder: (context, index) {
                          return Divider(height: 1);
                        },
                      ),
              ),
            ],
          ),
          floatingActionButton: FloatingActionButton(
            child: Icon(Icons.create),
            backgroundColor: Colors.indigo,
            onPressed: () {
              showCreateDialog(context, diaryService);
            },
          ),
        );
      },
    );
  }

  /// Diary 수정 다이얼로그 보여주기
  Future<dynamic> showUpdateDialog(
      BuildContext context, DiaryService diaryService, ogDate) {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("일기 수정"),
          content: TextField(
            autofocus: true,
            controller: updateTextController,
            decoration: InputDecoration(),
            onSubmitted: (value) {
              diaryService.update(
                ogDate,
                updateTextController.text,
              );
              Navigator.pop(context);
            },
          ),
          actions: [
            /// 취소 버튼
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                "취소",
                style: TextStyle(color: Colors.indigo),
              ),
            ),

            /// 작성 버튼
            TextButton(
              onPressed: () {
                diaryService.update(
                  ogDate,
                  updateTextController.text,
                );
                Navigator.pop(context);
              },
              child: Text(
                "확인",
                style: TextStyle(color: Colors.indigo),
              ),
            ),
          ],
        );
      },
    );
  }

  /// Diary 작성 다이얼로그 보여주기
  Future<dynamic> showCreateDialog(
      BuildContext context, DiaryService diaryService) {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("일기 작성"),
          content: TextField(
            controller: createTextController,
            autofocus: true,
            cursorColor: Colors.indigo,
            decoration: InputDecoration(
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.indigo),
              ),
            ),
            onSubmitted: (_) {
              createDiary(diaryService);
              Navigator.pop(context);
            },
          ),
          actions: [
            /// 취소 버튼
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                "취소",
                style: TextStyle(color: Colors.indigo),
              ),
            ),

            /// 작성 버튼
            TextButton(
              onPressed: () {
                createDiary(diaryService);
                Navigator.pop(context);
              },
              child: Text(
                "확인",
                style: TextStyle(color: Colors.indigo),
              ),
            ),
          ],
        );
      },
    );
  }

  /// 작성하기
  /// 엔터를 누르거나 작성 버튼을 누르는 경우 호출
  void createDiary(DiaryService diaryService) {
    // 앞뒤 공백 삭제
    String newText = createTextController.text.trim();
    if (newText.isNotEmpty) {
      diaryService.create(selectedDay, newText);
      createTextController.text = "";
    }
  }
}
