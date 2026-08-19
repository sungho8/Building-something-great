import 'dart:ui' show Color;

import 'package:freezed_annotation/freezed_annotation.dart';

part 'subscription.freezed.dart';
part 'subscription.g.dart';

/// 결제 주기.
enum BillingCycle { monthly, yearly, weekly }

/// 구독 카테고리 (색·그룹핑용). 색 매핑은 표현 계층이 담당한다.
enum SubscriptionCategory {
  entertainment,
  music,
  shopping,
  productivity,
  game,
  etc,
}

/// 결제 알림 시점.
enum SubReminder { onDay, dayBefore, threeDaysBefore }

/// 시분초를 버린 날짜. (도메인을 Flutter UI에 의존시키지 않기 위한 순수 함수)
DateTime _dateOnly(DateTime d) => DateTime(d.year, d.month, d.day);

/// 해당 연·월의 일수.
int _daysInMonth(int year, int month) => DateTime(year, month + 1, 0).day;

/// day를 해당 월의 마지막 날로 clamp한 날짜 (매월 31일 결제 → 2월은 28/29일).
DateTime _clampDay(int year, int month, int day) =>
    DateTime(year, month, day > _daysInMonth(year, month)
        ? _daysInMonth(year, month)
        : day);

/// 구독 항목 엔티티.
@freezed
abstract class Subscription with _$Subscription {
  const Subscription._();

  const factory Subscription({
    required String id,
    required String name,

    /// 1회 결제 금액(원).
    required int amount,

    /// 결제 주기.
    @Default(BillingCycle.monthly) BillingCycle cycle,

    /// 기준(최초) 결제일. 다음 결제일은 여기서 주기만큼 굴려 계산한다.
    required DateTime firstPaymentDate,

    /// 카테고리 (색·그룹핑).
    @Default(SubscriptionCategory.etc) SubscriptionCategory category,

    /// 카드 이모지. 빈 문자열이면 없음.
    @Default('') String emoji,

    /// KeyColor(ARGB). null이면 카테고리 기본색을 따른다.
    int? colorValue,

    /// 결제 알림 시점. 비어 있으면 알림 없음.
    @Default([SubReminder.dayBefore]) List<SubReminder> reminders,

    /// 일시정지 여부. true면 총액 합산·알림에서 제외.
    @Default(true) bool active,

    DateTime? createdAt,
  }) = _Subscription;

  factory Subscription.fromJson(Map<String, dynamic> json) =>
      _$SubscriptionFromJson(json);

  /// 오늘 이후의 다음 결제일. 기준일이 미래면 그대로, 과거면 주기만큼 굴린다.
  DateTime get nextPaymentDate {
    final today = _dateOnly(DateTime.now());
    final first = _dateOnly(firstPaymentDate);
    if (!first.isBefore(today)) return first;

    switch (cycle) {
      case BillingCycle.weekly:
        final elapsed = today.difference(first).inDays;
        // ceil: 오늘이 정확히 결제일(7의 배수)이면 오늘을 그대로 쓴다(D-DAY).
        final periods = (elapsed / 7).ceil();
        var next = first.add(Duration(days: 7 * periods));
        while (next.isBefore(today)) {
          next = next.add(const Duration(days: 7));
        }
        return next;

      case BillingCycle.monthly:
        var y = today.year, m = today.month;
        var cand = _clampDay(y, m, first.day);
        if (cand.isBefore(today)) {
          m++;
          if (m > 12) {
            m = 1;
            y++;
          }
          cand = _clampDay(y, m, first.day);
        }
        return cand;

      case BillingCycle.yearly:
        var cand = _clampDay(today.year, first.month, first.day);
        if (cand.isBefore(today)) {
          cand = _clampDay(today.year + 1, first.month, first.day);
        }
        return cand;
    }
  }

  /// 다음 결제일까지 남은 일수 (오늘=0).
  int get daysUntilPayment =>
      nextPaymentDate.difference(_dateOnly(DateTime.now())).inDays;

  /// 표시용 라벨. 오늘이면 D-DAY, 그 외 D-N.
  String get paymentLabel {
    final d = daysUntilPayment;
    return d == 0 ? 'D-DAY' : 'D-$d';
  }

  /// 월 환산 금액. 연=÷12, 주=×52÷12.
  double get monthlyEquivalent {
    switch (cycle) {
      case BillingCycle.monthly:
        return amount.toDouble();
      case BillingCycle.yearly:
        return amount / 12.0;
      case BillingCycle.weekly:
        return amount * 52 / 12.0;
    }
  }

  /// 연 환산 금액.
  double get yearlyEquivalent => monthlyEquivalent * 12;

  /// KeyColor. null이면 카테고리 기본색 사용(표현 계층에서 결정).
  Color? get color => colorValue == null ? null : Color(colorValue!);

  /// 알림 슬롯별 32비트 정수 id.
  int notificationIdFor(SubReminder reminder) =>
      (id.hashCode & 0x1FFFFFFF) * 4 + reminder.index;
}
