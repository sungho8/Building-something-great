import 'package:core/core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:quit/di/quit_providers.dart';
import 'package:quit/domain/entities/quit_item.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// 예약/취소된 알림 id 기록 (과거 시각은 예약 스킵 — 실제와 동일).
class _FakeNoti extends NotificationService {
  final scheduled = <int>[];
  final canceled = <int>[];

  @override
  Future<void> scheduleAt({
    required int id,
    required String title,
    required String body,
    required DateTime dateTime,
  }) async {
    if (dateTime.isBefore(DateTime.now())) return;
    scheduled.add(id);
  }

  @override
  Future<void> cancel(int id) async => canceled.add(id);
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  setUp(() => SharedPreferences.setMockInitialValues({}));

  Future<({ProviderContainer c, _FakeNoti noti})> harness() async {
    final noti = _FakeNoti();
    final store = await LocalStore.create();
    final c = ProviderContainer(overrides: [
      localStoreProvider.overrideWithValue(store),
      notificationServiceProvider.overrideWithValue(noti),
    ]);
    addTearDown(c.dispose);
    return (c: c, noti: noti);
  }

  test('목표 저장 시 미래 이정표만 알림 예약, 모든 슬롯은 취소', () async {
    final (:c, :noti) = await harness();
    final smokingCount = milestonesFor(QuitType.smoking).length;

    // 30분 전에 끊음 → 20분 이정표는 이미 지남
    final item = QuitItem(
      id: '1',
      name: '담배',
      type: QuitType.smoking,
      quitDate: DateTime.now().subtract(const Duration(minutes: 30)),
    );
    await c.read(quitListProvider.notifier).save(item);

    expect(noti.canceled.length, smokingCount); // 전 슬롯 취소
    expect(noti.scheduled.length, smokingCount - 1); // 20분 슬롯 제외
    expect(noti.scheduled, isNot(contains(item.notificationIdFor(0))));
  });

  test('다시 시작하면 모든 이정표가 미래가 되어 전부 재예약', () async {
    final (:c, :noti) = await harness();
    final vm = c.read(quitListProvider.notifier);
    final smokingCount = milestonesFor(QuitType.smoking).length;

    await vm.save(QuitItem(
      id: '1',
      name: '담배',
      type: QuitType.smoking,
      quitDate: DateTime.now().subtract(const Duration(days: 400)),
    ));
    noti.scheduled.clear();

    await vm.reset('1');
    expect(noti.scheduled.length, smokingCount); // 전 이정표 미래
  });

  test('삭제하면 해당 목표 알림을 취소', () async {
    final (:c, :noti) = await harness();
    final vm = c.read(quitListProvider.notifier);
    await vm.save(QuitItem(
        id: '1', name: '술', type: QuitType.drinking, quitDate: DateTime.now()));
    noti.canceled.clear();

    await vm.remove('1');
    expect(noti.canceled.length, milestonesFor(QuitType.drinking).length);
  });
}
