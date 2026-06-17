import 'package:core/core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../di/dday_providers.dart';
import '../../domain/entities/dday_item.dart';
import '../../domain/repositories/dday_repository.dart';
import '../../services/widget_sync.dart';

/// D-Day 목록 뷰모델. 추가/수정/삭제 시 영속화 + 알림 예약 + 위젯 동기화를 함께 처리.
class DDayListViewModel extends Notifier<List<DDayItem>> {
  // 리포지토리 (일회성 읽기)
  DDayRepository get _repo => ref.read(ddayRepositoryProvider);

  // 알림 서비스 (일회성 읽기)
  NotificationService get _noti => ref.read(notificationServiceProvider);

  @override
  List<DDayItem> build() => _sorted(_repo.load());

  /// 새 항목 추가 (id는 생성 시각 기반)
  Future<void> add({required String title, required DateTime date}) async {
    final item = DDayItem(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      title: title,
      date: date,
    );
    await _persist(_sorted([...state, item]));
    await _scheduleNotification(item);
  }

  /// 기존 항목 수정
  Future<void> update(DDayItem item) async {
    await _persist(_sorted([
      for (final e in state)
        if (e.id == item.id) item else e,
    ]));
    await _noti.cancel(item.notificationId);
    await _scheduleNotification(item);
  }

  /// 항목 삭제
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

  // 상태 갱신 + 저장 + 위젯 동기화
  Future<void> _persist(List<DDayItem> items) async {
    state = items;
    await _repo.save(items);
    await syncHomeWidget(items);
  }

  // 해당 항목 당일 알림 예약
  Future<void> _scheduleNotification(DDayItem item) async {
    await _noti.scheduleOnDate(
      id: item.notificationId,
      title: 'D-Day',
      body: '오늘은 «${item.title}» 입니다!',
      date: item.date,
    );
  }
}

// 임박한(미래·오늘) 가까운 순 → 그 뒤에 지난 항목 최근 순으로 정렬
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
