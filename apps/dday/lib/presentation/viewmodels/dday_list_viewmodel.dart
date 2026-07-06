import 'package:core/core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../di/dday_providers.dart';
import '../../domain/entities/dday_item.dart';
import '../../domain/repositories/dday_repository.dart';
import '../../services/widget_sync.dart';

/// 알림 시점 → 며칠 전 오프셋
const _reminderOffsetDays = {
  DdayReminder.onDay: 0,
  DdayReminder.dayBefore: 1,
  DdayReminder.weekBefore: 7,
};

/// D-Day 목록 뷰모델. 저장 시 영속화 + 알림 예약 + 위젯 동기화를 함께 처리.
class DDayListViewModel extends Notifier<List<DDayItem>> {
  // 리포지토리 (일회성 읽기)
  DDayRepository get _repo => ref.read(ddayRepositoryProvider);

  // 알림 서비스 (일회성 읽기)
  NotificationService get _noti => ref.read(notificationServiceProvider);

  @override
  List<DDayItem> build() => _sorted(_repo.load());

  /// 신규 추가 또는 기존 수정 (id로 판별).
  Future<void> save(DDayItem item) async {
    final exists = state.any((e) => e.id == item.id);
    final next = exists
        ? [
            for (final e in state)
              if (e.id == item.id) item else e,
          ]
        : [...state, item];
    await _persist(_sorted(next));
    await _reschedule(item);
  }

  /// 항목 삭제.
  Future<void> remove(String id) async {
    final target = _find(id);
    await _persist(state.where((e) => e.id != id).toList());
    if (target != null) await _cancelAll(target);
  }

  /// 삭제 취소(복원). 알림·정렬까지 원복.
  Future<void> restore(DDayItem item) => save(item);

  /// 고정 토글.
  Future<void> togglePin(String id) async {
    final target = _find(id);
    if (target == null) return;
    await save(target.copyWith(pinned: !target.pinned));
  }

  DDayItem? _find(String id) {
    for (final e in state) {
      if (e.id == id) return e;
    }
    return null;
  }

  // 상태 갱신 + 저장 + 위젯 동기화
  Future<void> _persist(List<DDayItem> items) async {
    state = items;
    await _repo.save(items);
    await syncHomeWidget(items);
  }

  // 항목의 모든 알림 슬롯을 취소하고 현재 설정대로 다시 예약
  Future<void> _reschedule(DDayItem item) async {
    await _cancelAll(item);
    final base = item.effectiveDate;
    for (final reminder in item.reminders) {
      final offset = _reminderOffsetDays[reminder]!;
      await _noti.scheduleOnDate(
        id: item.notificationIdFor(reminder),
        title: item.emoji.isEmpty ? 'D-Day' : '${item.emoji} D-Day',
        body: _bodyFor(item, reminder),
        date: base.subtract(Duration(days: offset)),
      );
    }
  }

  Future<void> _cancelAll(DDayItem item) async {
    for (final reminder in DdayReminder.values) {
      await _noti.cancel(item.notificationIdFor(reminder));
    }
  }

  String _bodyFor(DDayItem item, DdayReminder reminder) => switch (reminder) {
        DdayReminder.onDay => '오늘은 «${item.title}» 입니다!',
        DdayReminder.dayBefore => '내일은 «${item.title}» 입니다.',
        DdayReminder.weekBefore => '«${item.title}»까지 7일 남았어요.',
      };
}

// 고정 우선 → 임박(미래·오늘) 가까운 순 → 지난 항목 최근 순
List<DDayItem> _sorted(List<DDayItem> items) {
  final copy = [...items];
  copy.sort((a, b) {
    if (a.pinned != b.pinned) return a.pinned ? -1 : 1;
    final ra = a.daysFromToday >= 0 ? 0 : 1;
    final rb = b.daysFromToday >= 0 ? 0 : 1;
    if (ra != rb) return ra - rb;
    if (a.daysFromToday >= 0) return a.daysFromToday.compareTo(b.daysFromToday);
    return b.daysFromToday.compareTo(a.daysFromToday);
  });
  return copy;
}
