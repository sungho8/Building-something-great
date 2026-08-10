import 'dart:convert';

import 'package:backend/backend.dart';
import 'package:core/core.dart';
import 'package:dday/di/dday_providers.dart';
import 'package:dday/domain/entities/dday_item.dart';
import 'package:dday/presentation/viewmodels/dday_list_viewmodel.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

// ── 페이크들 (지연 참조 리팩터 덕에 Firebase/플랫폼 없이 상속 가능) ──

/// 예약/취소된 알림 id만 기록한다.
class _FakeNoti extends NotificationService {
  final scheduled = <int>[];
  final canceled = <int>[];

  @override
  Future<void> scheduleOnDate({
    required int id,
    required String title,
    required String body,
    required DateTime date,
    int hour = 9,
  }) async {
    scheduled.add(id);
  }

  @override
  Future<void> cancel(int id) async => canceled.add(id);
}

/// currentUser만 흉내낸다.
class _FakeAuth extends AuthService {
  _FakeAuth([this._user]);
  final AppUser? _user;

  @override
  AppUser? get currentUser => _user;
}

/// push된 데이터를 붙잡고, pull은 미리 넣어둔 스냅샷을 돌려준다.
class _FakeCloud extends CloudSyncService {
  String? pushed;
  CloudSnapshot? snapshot;

  @override
  Future<void> push(String uid, String data) async => pushed = data;

  @override
  Future<CloudSnapshot?> pull(String uid) async => snapshot;
}

/// 테스트 하네스: 페이크 주입된 단일 컨테이너 + 페이크 핸들.
class _Harness {
  _Harness._(this.container, this.noti, this.cloud);

  final ProviderContainer container;
  final _FakeNoti noti;
  final _FakeCloud cloud;

  static Future<_Harness> create({AppUser? user}) async {
    final noti = _FakeNoti();
    final cloud = _FakeCloud();
    final store = await LocalStore.create();
    final container = ProviderContainer(
      overrides: [
        localStoreProvider.overrideWithValue(store),
        notificationServiceProvider.overrideWithValue(noti),
        authServiceProvider.overrideWithValue(_FakeAuth(user)),
        cloudSyncProvider.overrideWithValue(cloud),
      ],
    );
    return _Harness._(container, noti, cloud);
  }

  DDayListViewModel get vm => container.read(ddayListProvider.notifier);
  List<DDayItem> get state => container.read(ddayListProvider);
}

const _user = AppUser(uid: 'u1', isAnonymous: false);

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() => SharedPreferences.setMockInitialValues({}));

  Future<_Harness> harness({AppUser? user}) async {
    final h = await _Harness.create(user: user);
    addTearDown(h.container.dispose);
    return h;
  }

  test('초기 상태는 빈 목록', () async {
    final h = await harness();
    expect(h.state, isEmpty);
  });

  test('save로 신규 항목을 추가하면 상태에 반영된다', () async {
    final h = await harness();
    await h.vm.save(
      DDayItem(id: '1', title: '시험', date: DateTime.now().add(const Duration(days: 10))),
    );
    expect(h.state.map((e) => e.id), ['1']);
  });

  test('정렬: 고정 > 임박(미래) > 지난 항목', () async {
    final h = await harness();
    final now = DateTime.now();
    await h.vm.save(DDayItem(id: 'past', title: '과거', date: now.subtract(const Duration(days: 3))));
    await h.vm.save(DDayItem(id: 'soon', title: '임박', date: now.add(const Duration(days: 2))));
    await h.vm.save(DDayItem(id: 'far', title: '먼미래', date: now.add(const Duration(days: 30))));
    await h.vm.save(DDayItem(id: 'pin', title: '고정', date: now.add(const Duration(days: 100)), pinned: true));

    expect(h.state.map((e) => e.id), ['pin', 'soon', 'far', 'past']);
  });

  test('save는 기존 알림을 모두 취소하고 reminders대로 다시 예약한다', () async {
    final h = await harness();
    final item = DDayItem(
      id: 'x',
      title: '일정',
      date: DateTime.now().add(const Duration(days: 10)),
      reminders: const [DdayReminder.onDay, DdayReminder.dayBefore],
    );
    await h.vm.save(item);

    expect(h.noti.canceled.length, DdayReminder.values.length); // 3슬롯 전부 취소
    expect(h.noti.scheduled, [
      item.notificationIdFor(DdayReminder.onDay),
      item.notificationIdFor(DdayReminder.dayBefore),
    ]);
  });

  test('remove는 상태에서 제거하고 알림을 취소한다', () async {
    final h = await harness();
    final item = DDayItem(id: 'r', title: '삭제대상', date: DateTime.now().add(const Duration(days: 5)));
    await h.vm.save(item);
    h.noti.canceled.clear();

    await h.vm.remove('r');
    expect(h.state, isEmpty);
    expect(h.noti.canceled, contains(item.notificationIdFor(DdayReminder.onDay)));
  });

  test('togglePin은 고정 상태를 뒤집는다', () async {
    final h = await harness();
    await h.vm.save(DDayItem(id: 'p', title: '핀', date: DateTime.now().add(const Duration(days: 5))));
    expect(h.state.single.pinned, isFalse);

    await h.vm.togglePin('p');
    expect(h.state.single.pinned, isTrue);
  });

  test('restore는 삭제했던 항목을 다시 넣는다', () async {
    final h = await harness();
    final item = DDayItem(id: 'u', title: '되돌리기', date: DateTime.now().add(const Duration(days: 5)));
    await h.vm.save(item);
    await h.vm.remove('u');
    expect(h.state, isEmpty);

    await h.vm.restore(item);
    expect(h.state.single.id, 'u');
  });

  test('로그인 상태에서 backupNow는 클라우드에 현재 데이터를 올린다', () async {
    final h = await harness(user: _user);
    await h.vm.save(DDayItem(id: '1', title: 'A', date: DateTime(2030, 1, 1)));
    await h.vm.backupNow();

    expect(h.cloud.pushed, isNotNull);
    expect(h.cloud.pushed, contains('"title":"A"'));
  });

  test('게스트(비로그인)면 backupNow는 아무것도 안 한다', () async {
    final h = await harness(); // user 없음
    await h.vm.save(DDayItem(id: '1', title: 'A', date: DateTime(2030, 1, 1)));
    await h.vm.backupNow();
    expect(h.cloud.pushed, isNull);
  });

  test('restoreFromCloud는 스냅샷으로 로컬을 덮어쓴다', () async {
    final h = await harness(user: _user);
    final cloudItem = DDayItem(id: 'cloud', title: '복원됨', date: DateTime(2030, 5, 5));
    h.cloud.snapshot = CloudSnapshot(data: jsonEncode([cloudItem.toJson()]));

    expect(await h.vm.restoreFromCloud(), isTrue);
    expect(h.state.single.title, '복원됨');
  });

  test('백업이 없으면 restoreFromCloud는 false', () async {
    final h = await harness(user: _user);
    expect(await h.vm.restoreFromCloud(), isFalse);
  });
}
