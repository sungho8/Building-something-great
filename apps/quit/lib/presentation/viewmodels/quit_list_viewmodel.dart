import 'package:core/core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../di/quit_providers.dart';
import '../../domain/entities/quit_item.dart';
import '../../domain/repositories/quit_repository.dart';
import '../../services/widget_sync.dart';

/// 끊기 목표 목록 뷰모델. 저장 시 영속화 + 위젯 동기화 + 이정표 알림 예약.
class QuitListViewModel extends Notifier<List<QuitItem>> {
  QuitRepository get _repo => ref.read(quitRepositoryProvider);
  NotificationService get _noti => ref.read(notificationServiceProvider);

  @override
  List<QuitItem> build() => _sorted(_repo.load());

  /// 신규/수정 (id로 판별).
  Future<void> save(QuitItem item) async {
    final exists = state.any((e) => e.id == item.id);
    final next = exists
        ? [
            for (final e in state)
              if (e.id == item.id) item else e,
          ]
        : [...state, item];
    await _persist(_sorted(next));
    await _rescheduleMilestones(item);
  }

  Future<void> remove(String id) async {
    final target = _find(id);
    await _persist(state.where((e) => e.id != id).toList());
    if (target != null) await _cancelMilestones(target);
  }

  Future<void> restore(QuitItem item) => save(item);

  /// 다시 시작 — 끊은 시각을 지금으로, 최고 기록은 보존/갱신.
  Future<void> reset(String id) async {
    final t = _find(id);
    if (t == null) return;
    await save(t.copyWith(
      bestStreakDays: t.updatedBestStreak,
      quitDate: DateTime.now(),
    ));
  }

  QuitItem? _find(String id) {
    for (final e in state) {
      if (e.id == id) return e;
    }
    return null;
  }

  Future<void> _persist(List<QuitItem> items) async {
    state = items;
    await _repo.save(items);
    await syncHomeWidget(items);
  }

  // 이정표별 알림 재예약: 각 슬롯 취소 후 미래 도래분만 예약.
  Future<void> _rescheduleMilestones(QuitItem item) async {
    final ms = milestonesFor(item.type);
    for (var i = 0; i < ms.length; i++) {
      final id = item.notificationIdFor(i);
      await _noti.cancel(id);
      await _noti.scheduleAt(
        id: id,
        title: '${item.name} · 이정표 달성 🎉',
        body: ms[i].title,
        dateTime: item.quitDate.add(ms[i].after),
      );
    }
  }

  Future<void> _cancelMilestones(QuitItem item) async {
    for (var i = 0; i < milestonesFor(item.type).length; i++) {
      await _noti.cancel(item.notificationIdFor(i));
    }
  }
}

// 가장 오래 버틴 목표(끊은 시각이 이른 것)를 앞으로.
List<QuitItem> _sorted(List<QuitItem> items) {
  final copy = [...items];
  copy.sort((a, b) => a.quitDate.compareTo(b.quitDate));
  return copy;
}
