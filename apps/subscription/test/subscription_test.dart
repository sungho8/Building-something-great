import 'package:flutter_test/flutter_test.dart';
import 'package:subscription/domain/entities/subscription.dart';

DateTime _dOnly(DateTime d) => DateTime(d.year, d.month, d.day);

Subscription _sub({
  int amount = 10000,
  BillingCycle cycle = BillingCycle.monthly,
  DateTime? firstPaymentDate,
}) =>
    Subscription(
      id: 's',
      name: '넷플릭스',
      amount: amount,
      cycle: cycle,
      firstPaymentDate: firstPaymentDate ?? DateTime(2020, 1, 15),
    );

void main() {
  group('월 환산액', () {
    test('월 구독은 금액 그대로', () {
      expect(_sub(amount: 12000).monthlyEquivalent, 12000);
    });
    test('연 구독은 ÷12', () {
      expect(_sub(amount: 120000, cycle: BillingCycle.yearly).monthlyEquivalent,
          closeTo(10000, 0.001));
    });
    test('주 구독은 ×52÷12', () {
      expect(_sub(amount: 3000, cycle: BillingCycle.weekly).monthlyEquivalent,
          closeTo(3000 * 52 / 12, 0.001));
    });
    test('연 환산액 = 월환산 ×12', () {
      final s = _sub(amount: 120000, cycle: BillingCycle.yearly);
      expect(s.yearlyEquivalent, closeTo(120000, 0.001));
    });
  });

  group('다음 결제일', () {
    test('기준일이 미래면 그대로', () {
      final future = DateTime.now().add(const Duration(days: 10));
      final n = _sub(firstPaymentDate: future).nextPaymentDate;
      expect(_dOnly(n), _dOnly(future));
    });

    test('월 구독 — 과거 기준일은 미래로 이월(같은 일자 유지)', () {
      final n = _sub(
        firstPaymentDate: DateTime(2020, 1, 15),
        cycle: BillingCycle.monthly,
      ).nextPaymentDate;
      expect(n.day, 15);
      expect(n.isBefore(_dOnly(DateTime.now())), isFalse);
    });

    test('월 구독 — 31일 결제는 짧은 달에 말일로 clamp', () {
      final n = _sub(
        firstPaymentDate: DateTime(2020, 1, 31),
        cycle: BillingCycle.monthly,
      ).nextPaymentDate;
      final lastDay = DateTime(n.year, n.month + 1, 0).day;
      expect(n.day, lastDay); // 31이 없으면 말일
      expect(n.isBefore(_dOnly(DateTime.now())), isFalse);
    });

    test('연 구독 — 과거는 다음 도래일(월·일 유지)', () {
      final n = _sub(
        firstPaymentDate: DateTime(2015, 6, 20),
        cycle: BillingCycle.yearly,
      ).nextPaymentDate;
      expect(n.month, 6);
      expect(n.day, 20);
      expect(n.isBefore(_dOnly(DateTime.now())), isFalse);
    });

    test('주 구독 — 기준일에서 7일 배수', () {
      final n = _sub(
        firstPaymentDate: DateTime(2020, 1, 1),
        cycle: BillingCycle.weekly,
      ).nextPaymentDate;
      expect(n.difference(DateTime(2020, 1, 1)).inDays % 7, 0);
      expect(n.isBefore(_dOnly(DateTime.now())), isFalse);
    });

    test('daysUntilPayment는 항상 0 이상', () {
      expect(_sub().daysUntilPayment, greaterThanOrEqualTo(0));
    });
  });

  test('notificationIdFor — 리마인더별로 다르고 안정적', () {
    final s = _sub();
    final ids = {for (final r in SubReminder.values) s.notificationIdFor(r)};
    expect(ids.length, SubReminder.values.length);
    expect(s.notificationIdFor(SubReminder.onDay),
        s.notificationIdFor(SubReminder.onDay));
  });

  test('colorValue null이면 color도 null', () {
    expect(_sub().color, isNull);
  });

  test('JSON 직렬화 왕복 (확장 필드 포함)', () {
    final s = Subscription(
      id: 'abc',
      name: '유튜브 프리미엄',
      amount: 14900,
      cycle: BillingCycle.yearly,
      firstPaymentDate: DateTime(2026, 3, 9),
      category: SubscriptionCategory.entertainment,
      emoji: '📺',
      colorValue: 0xFF3182F6,
      reminders: const [SubReminder.onDay, SubReminder.threeDaysBefore],
      active: false,
    );
    final restored = Subscription.fromJson(s.toJson());
    expect(restored, s);
  });
}
