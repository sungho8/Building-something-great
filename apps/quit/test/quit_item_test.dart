import 'package:flutter_test/flutter_test.dart';
import 'package:quit/domain/entities/quit_item.dart';

QuitItem _item({
  QuitType type = QuitType.smoking,
  required Duration ago,
  int dailyCost = 0,
  double dailyUnits = 0,
  int bestStreakDays = 0,
}) =>
    QuitItem(
      id: 'q',
      name: '담배',
      type: type,
      quitDate: DateTime.now().subtract(ago),
      dailyCost: dailyCost,
      dailyUnits: dailyUnits,
      bestStreakDays: bestStreakDays,
    );

void main() {
  group('경과·절약·회피', () {
    test('경과 일수', () {
      expect(_item(ago: const Duration(days: 10)).daysSince, 10);
    });

    test('미래 quitDate는 경과 0 (음수 방지)', () {
      final future = QuitItem(
          id: 'q', name: 'x', quitDate: DateTime.now().add(const Duration(days: 3)));
      expect(future.elapsed, Duration.zero);
      expect(future.daysSince, 0);
    });

    test('절약 금액 = 하루비용 × 경과일 (근사)', () {
      final s = _item(ago: const Duration(days: 10), dailyCost: 5000);
      expect(s.moneySaved, closeTo(50000, 100));
    });

    test('회피량 = 하루소비 × 경과일 (근사)', () {
      final s = _item(ago: const Duration(days: 10), dailyUnits: 20);
      expect(s.unitsAvoided, closeTo(200, 1));
    });
  });

  group('이정표', () {
    test('20분 지나면 첫 금연 이정표 달성', () {
      final s = _item(type: QuitType.smoking, ago: const Duration(minutes: 30));
      expect(s.achievedCount, greaterThanOrEqualTo(1));
      expect(s.lastAchieved, isNotNull);
    });

    test('갓 시작하면 다음 이정표는 20분짜리', () {
      final s = _item(type: QuitType.smoking, ago: const Duration(minutes: 1));
      expect(s.achievedCount, 0);
      expect(s.nextMilestone?.after, const Duration(minutes: 20));
      expect(s.milestoneProgress, greaterThan(0));
      expect(s.milestoneProgress, lessThan(1));
    });

    test('1년 넘으면 모든 이정표 달성 + 진행률 1', () {
      final s = _item(type: QuitType.smoking, ago: const Duration(days: 400));
      expect(s.nextMilestone, isNull);
      expect(s.milestoneProgress, 1);
      expect(s.achievedCount, milestonesFor(QuitType.smoking).length);
    });

    test('종류별 이정표 세트가 다르다', () {
      expect(milestonesFor(QuitType.smoking),
          isNot(equals(milestonesFor(QuitType.drinking))));
    });
  });

  group('최고 기록', () {
    test('현재 연속이 기존 최고보다 크면 갱신값이 현재', () {
      final s = _item(ago: const Duration(days: 15), bestStreakDays: 10);
      expect(s.updatedBestStreak, 15);
    });
    test('기존 최고가 더 크면 유지', () {
      final s = _item(ago: const Duration(days: 3), bestStreakDays: 30);
      expect(s.updatedBestStreak, 30);
    });
  });

  test('JSON 왕복', () {
    final s = QuitItem(
      id: 'a',
      name: '술',
      type: QuitType.drinking,
      quitDate: DateTime(2026, 1, 1, 9),
      dailyCost: 20000,
      dailyUnits: 3,
      unitLabel: '잔',
      bestStreakDays: 42,
      colorValue: 0xFF12B76A,
    );
    expect(QuitItem.fromJson(s.toJson()), s);
  });
}
