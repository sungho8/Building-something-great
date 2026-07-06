import 'package:flutter/material.dart' show Color, DateUtils;
import 'package:freezed_annotation/freezed_annotation.dart';

part 'dday_item.freezed.dart';
part 'dday_item.g.dart';

/// 알림 시점 옵션.
enum DdayReminder {
  /// 당일 오전 9시
  onDay,

  /// 1일 전 오전 9시
  dayBefore,

  /// 7일 전 오전 9시
  weekBefore,
}

/// D-Day 항목 엔티티.
@freezed
abstract class DDayItem with _$DDayItem {
  const DDayItem._();

  const factory DDayItem({
    required String id,
    required String title,
    required DateTime date,

    /// 매년 반복(생일·기념일). 지난 날짜는 자동으로 다음 도래일로 계산된다.
    @Default(false) bool repeatYearly,

    /// 카드·위젯에 붙는 이모지. 빈 문자열이면 없음.
    @Default('') String emoji,

    /// 목록 맨 위·홈 위젯 고정.
    @Default(false) bool pinned,

    /// 지난 날짜를 셀 때 당일을 1일로 포함 (만난 날 = 1일).
    @Default(false) bool includeStartDay,

    /// 알림 시점 목록. 비어 있으면 알림 없음.
    @Default([DdayReminder.onDay]) List<DdayReminder> reminders,

    /// KeyColor(ARGB). null이면 앱 브랜드색을 따른다. 히어로 카드 채움·라벨 강조에 쓰임.
    int? colorValue,

    /// 생성 시각. 진행 게이지 계산용 (구버전 데이터는 null).
    DateTime? createdAt,
  }) = _DDayItem;

  /// JSON → 엔티티
  factory DDayItem.fromJson(Map<String, dynamic> json) =>
      _$DDayItemFromJson(json);

  /// 계산 기준 날짜. 매년 반복이면 다음 도래일(올해 지났으면 내년).
  DateTime get effectiveDate {
    if (!repeatYearly) return date;
    final today = DateUtils.dateOnly(DateTime.now());
    var next = DateTime(today.year, date.month, date.day);
    if (next.isBefore(today)) {
      next = DateTime(today.year + 1, date.month, date.day);
    }
    return next;
  }

  /// 오늘 기준 남은(+)/지난(-) 일수
  int get daysFromToday {
    final today = DateUtils.dateOnly(DateTime.now());
    return DateUtils.dateOnly(effectiveDate).difference(today).inDays;
  }

  /// 이번 도래일이 몇 주년인지. 매년 반복이 아니거나 첫 해면 null.
  int? get anniversaryYears {
    if (!repeatYearly) return null;
    final years = effectiveDate.year - date.year;
    return years >= 1 ? years : null;
  }

  /// 표시용 라벨 (미래 D-N, 당일 D-DAY, 과거 D+N)
  String get label {
    final d = daysFromToday;
    if (d == 0) return 'D-DAY';
    if (d > 0) return 'D-$d';
    return 'D+${-d + (includeStartDay ? 1 : 0)}';
  }

  /// 목표일까지의 진행률(0~1). 계산 불가(지난 날짜·구버전 데이터)면 null.
  double? get progress {
    final d = daysFromToday;
    if (d <= 0) return null;

    // 매년 반복: 직전 도래일 → 다음 도래일 사이에서 얼마나 왔는지
    if (repeatYearly) {
      final prev =
          DateTime(effectiveDate.year - 1, date.month, date.day);
      final total = effectiveDate.difference(prev).inDays;
      if (total <= 0) return null;
      return ((total - d) / total).clamp(0.0, 1.0);
    }

    // 일반: 등록일 → 목표일 사이에서 얼마나 왔는지
    final created = createdAt;
    if (created == null) return null;
    final total = DateUtils.dateOnly(effectiveDate)
        .difference(DateUtils.dateOnly(created))
        .inDays;
    if (total <= 0) return null;
    return ((total - d) / total).clamp(0.0, 1.0);
  }

  /// KeyColor. null이면 앱 브랜드색 사용.
  Color? get color => colorValue == null ? null : Color(colorValue!);

  /// 알림 슬롯별 32비트 정수 id (슬롯 = [DdayReminder.index])
  int notificationIdFor(DdayReminder reminder) =>
      (id.hashCode & 0x1FFFFFFF) * 4 + reminder.index;
}
