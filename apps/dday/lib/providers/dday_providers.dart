import 'package:core/core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/dday_repository.dart';
import '../models/dday_item.dart';
import '../services/widget_sync.dart';

/// main에서 초기화된 인스턴스로 override 한다.
final localStoreProvider = Provider<LocalStore>((ref) {
  throw UnimplementedError('main에서 override 필요');
});

final notificationServiceProvider = Provider<NotificationService>((ref) {
  throw UnimplementedError('main에서 override 필요');
});

final ddayRepositoryProvider = Provider<DDayRepository>((ref) {
  return DDayRepository(ref.watch(localStoreProvider));
});

final ddayListProvider =
    NotifierProvider<DDayListNotifier, List<DDayItem>>(DDayListNotifier.new);

/// D-Day 목록 상태. 추가/수정/삭제 시 영속화 + 알림 예약 + 위젯 동기화를 함께 처리.
class DDayListNotifier extends Notifier<List<DDayItem>> {
  DDayRepository get _repo => ref.read(ddayRepositoryProvider);
  NotificationService get _noti => ref.read(notificationServiceProvider);

  @override
  List<DDayItem> build() => _sorted(_repo.load());

  Future<void> add(DDayItem item) async {
    await _persist(_sorted([...state, item]));
    await _scheduleNotification(item);
  }

  Future<void> update(DDayItem item) async {
    await _persist(_sorted([
      for (final e in state)
        if (e.id == item.id) item else e,
    ]));
    await _noti.cancel(item.notificationId);
    await _scheduleNotification(item);
  }

  Future<void> remove(String id) async {
    DDayItem? target;
    for (final e in state) {
      if (e.id == id) {
        target = e;
        break;
      }
    }
    await _persist(state.where((e) => e.id != id).toList());
    if (target != null) await _noti.cancel(target.notificationId);
  }

  Future<void> _persist(List<DDayItem> items) async {
    state = items;
    await _repo.save(items);
    await syncHomeWidget(items);
  }

  Future<void> _scheduleNotification(DDayItem item) async {
    await _noti.scheduleOnDate(
      id: item.notificationId,
      title: 'D-Day',
      body: '오늘은 «${item.title}» 입니다!',
      date: item.date,
    );
  }
}

/// 임박한(미래·오늘) 항목을 가까운 순으로, 그 뒤에 지난 항목을 최근 순으로 정렬.
List<DDayItem> _sorted(List<DDayItem> items) {
  final copy = [...items];
  copy.sort((a, b) {
    final ra = a.daysFromToday >= 0 ? 0 : 1;
    final rb = b.daysFromToday >= 0 ? 0 : 1;
    if (ra != rb) return ra - rb;
    if (a.daysFromToday >= 0) return a.daysFromToday.compareTo(b.daysFromToday);
    return b.daysFromToday.compareTo(a.daysFromToday);
  });
  return copy;
}
