import 'dart:ui' show Color;

import 'package:dday/domain/entities/dday_item.dart';
import 'package:flutter_test/flutter_test.dart';

DDayItem _item(DateTime date) =>
    DDayItem(id: 't', title: '테스트', date: date);

void main() {
  test('오늘 날짜는 D-DAY', () {
    expect(_item(DateTime.now()).label, 'D-DAY');
  });

  test('미래 날짜는 D-N', () {
    expect(_item(DateTime.now().add(const Duration(days: 10))).label, 'D-10');
  });

  test('과거 날짜는 D+N', () {
    expect(
      _item(DateTime.now().subtract(const Duration(days: 5))).label,
      'D+5',
    );
  });

  test('시작일 포함이면 지난 날 +1', () {
    final item = _item(DateTime.now().subtract(const Duration(days: 5)))
        .copyWith(includeStartDay: true);
    expect(item.label, 'D+6');
  });

  test('매년 반복 — 지난 생일은 내년 도래일로 계산', () {
    final now = DateTime.now();
    final pastBirthday = DateTime(2000, now.month, now.day)
        .subtract(const Duration(days: 3));
    final item = DDayItem(
      id: 'b',
      title: '생일',
      date: pastBirthday,
      repeatYearly: true,
    );
    // 올해 생일이 이미 지났으므로 내년으로 → 미래 라벨(D-N) 또는 D-DAY
    expect(item.daysFromToday >= 0, isTrue);
    expect(item.anniversaryYears, isNotNull);
  });

  test('매년 반복 — 2월 29일 기념일은 평년에 2월 말로 clamp(회귀)', () {
    final item = DDayItem(
      id: 'leap',
      title: '윤년 기념일',
      date: DateTime(2024, 2, 29),
      repeatYearly: true,
    );
    // 3월 1일로 밀리지 않아야 한다.
    expect(item.effectiveDate.month, 2);
    expect(item.daysFromToday, greaterThanOrEqualTo(0));
  });

  test('진행률 — 등록일 대비 절반 지점은 약 0.5', () {
    final now = DateTime.now();
    final item = DDayItem(
      id: 'p',
      title: '목표',
      date: now.add(const Duration(days: 5)),
      createdAt: now.subtract(const Duration(days: 5)),
    );
    expect(item.progress, closeTo(0.5, 0.15));
  });

  test('진행률 — 과거 항목은 null', () {
    final item = _item(DateTime.now().subtract(const Duration(days: 1)));
    expect(item.progress, isNull);
  });

  test('colorValue가 null이면 color도 null (브랜드 위임)', () {
    expect(_item(DateTime.now()).color, isNull);
  });

  test('notificationIdFor — 리마인더별로 다르고, 같은 입력엔 안정적', () {
    final item = _item(DateTime.now());
    final ids = {
      for (final r in DdayReminder.values) item.notificationIdFor(r),
    };
    // 3개 슬롯이 서로 겹치지 않는다
    expect(ids.length, DdayReminder.values.length);
    // 같은 항목·같은 슬롯이면 항상 같은 id
    expect(
      item.notificationIdFor(DdayReminder.onDay),
      item.notificationIdFor(DdayReminder.onDay),
    );
    // 32비트 양수 범위
    for (final id in ids) {
      expect(id, greaterThanOrEqualTo(0));
    }
  });

  test('JSON 직렬화 왕복 (확장 필드 포함)', () {
    final item = DDayItem(
      id: 'abc',
      title: '시험',
      date: DateTime(2026, 11, 19),
      emoji: '📚',
      colorValue: 0xFF3182F6,
      repeatYearly: true,
      pinned: true,
      reminders: const [DdayReminder.dayBefore, DdayReminder.weekBefore],
    );
    final restored = DDayItem.fromJson(item.toJson());
    expect(restored, item);
    expect(restored.color, const Color(0xFF3182F6));
  });
}
