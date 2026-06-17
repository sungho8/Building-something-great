import 'package:flutter/material.dart' show DateUtils;

/// D-Day 항목. 제목 + 목표 날짜.
class DDayItem {
  final String id;
  final String title;
  final DateTime date;

  const DDayItem({required this.id, required this.title, required this.date});

  /// 새 항목 생성 (id는 생성 시각 기반).
  factory DDayItem.create({required String title, required DateTime date}) {
    return DDayItem(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      title: title,
      date: date,
    );
  }

  /// 오늘 기준 남은(+) / 지난(-) 일수.
  int get daysFromToday {
    final today = DateUtils.dateOnly(DateTime.now());
    final target = DateUtils.dateOnly(date);
    return target.difference(today).inDays;
  }

  /// 표시용 라벨. 미래=D-N, 당일=D-DAY, 과거=D+N.
  String get label {
    final d = daysFromToday;
    if (d == 0) return 'D-DAY';
    if (d > 0) return 'D-$d';
    return 'D+${-d}';
  }

  /// 알림용 32비트 정수 id.
  int get notificationId => id.hashCode & 0x7fffffff;

  DDayItem copyWith({String? title, DateTime? date}) => DDayItem(
        id: id,
        title: title ?? this.title,
        date: date ?? this.date,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'date': date.toIso8601String(),
      };

  factory DDayItem.fromJson(Map<String, dynamic> json) => DDayItem(
        id: json['id'] as String,
        title: json['title'] as String,
        date: DateTime.parse(json['date'] as String),
      );
}
