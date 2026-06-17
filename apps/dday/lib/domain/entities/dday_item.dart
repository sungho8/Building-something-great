import 'package:flutter/material.dart' show DateUtils;
import 'package:freezed_annotation/freezed_annotation.dart';

part 'dday_item.freezed.dart';
part 'dday_item.g.dart';

/// D-Day 항목 엔티티. 제목 + 목표 날짜.
@freezed
abstract class DDayItem with _$DDayItem {
  const DDayItem._();

  const factory DDayItem({
    required String id,
    required String title,
    required DateTime date,
  }) = _DDayItem;

  /// JSON → 엔티티
  factory DDayItem.fromJson(Map<String, dynamic> json) =>
      _$DDayItemFromJson(json);

  /// 오늘 기준 남은(+)/지난(-) 일수
  int get daysFromToday {
    final today = DateUtils.dateOnly(DateTime.now());
    final target = DateUtils.dateOnly(date);
    return target.difference(today).inDays;
  }

  /// 표시용 라벨 (미래 D-N, 당일 D-DAY, 과거 D+N)
  String get label {
    final d = daysFromToday;
    if (d == 0) return 'D-DAY';
    if (d > 0) return 'D-$d';
    return 'D+${-d}';
  }

  /// 알림용 32비트 정수 id
  int get notificationId => id.hashCode & 0x7fffffff;
}
