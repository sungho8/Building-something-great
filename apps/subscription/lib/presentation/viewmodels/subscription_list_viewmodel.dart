import 'package:core/core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../di/subscription_providers.dart';
import '../../domain/entities/subscription.dart';
import '../../domain/repositories/subscription_repository.dart';
import '../../services/widget_sync.dart';
import '../../utils/currency_format.dart';

/// 알림 시점 → 며칠 전 오프셋
const _reminderOffsetDays = {
  SubReminder.onDay: 0,
  SubReminder.dayBefore: 1,
  SubReminder.threeDaysBefore: 3,
};

/// 구독 목록 뷰모델. 저장 시 영속화 + 결제 알림 예약 + 위젯 동기화.
class SubscriptionListViewModel extends Notifier<List<Subscription>> {
  SubscriptionRepository get _repo => ref.read(subscriptionRepositoryProvider);
  NotificationService get _noti => ref.read(notificationServiceProvider);

  @override
  List<Subscription> build() => _sorted(_repo.load());

  /// 신규 추가 또는 기존 수정 (id로 판별).
  Future<void> save(Subscription item) async {
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

  /// 삭제.
  Future<void> remove(String id) async {
    final target = _find(id);
    await _persist(state.where((e) => e.id != id).toList());
    if (target != null) await _cancelAll(target);
  }

  /// 삭제 취소(복원).
  Future<void> restore(Subscription item) => save(item);

  /// 일시정지 토글.
  Future<void> togglePause(String id) async {
    final target = _find(id);
    if (target == null) return;
    await save(target.copyWith(active: !target.active));
  }

  Subscription? _find(String id) {
    for (final e in state) {
      if (e.id == id) return e;
    }
    return null;
  }

  // 상태 갱신 + 저장 + 위젯 동기화
  Future<void> _persist(List<Subscription> items) async {
    state = items;
    await _repo.save(items);
    await syncHomeWidget(items);
  }

  // 알림 재예약: 일시정지면 모두 취소만.
  Future<void> _reschedule(Subscription item) async {
    await _cancelAll(item);
    if (!item.active) return;
    final base = item.nextPaymentDate;
    for (final reminder in item.reminders) {
      final offset = _reminderOffsetDays[reminder]!;
      await _noti.scheduleOnDate(
        id: item.notificationIdFor(reminder),
        title: item.emoji.isEmpty ? '결제 예정' : '${item.emoji} 결제 예정',
        body: _bodyFor(item, reminder),
        date: base.subtract(Duration(days: offset)),
      );
    }
  }

  Future<void> _cancelAll(Subscription item) async {
    for (final reminder in SubReminder.values) {
      await _noti.cancel(item.notificationIdFor(reminder));
    }
  }

  String _bodyFor(Subscription item, SubReminder reminder) {
    final amount = formatWon(item.amount);
    switch (reminder) {
      case SubReminder.onDay:
        return '오늘 ${item.name} $amount이 결제돼요.';
      case SubReminder.dayBefore:
        return '내일 ${item.name} $amount이 결제돼요.';
      case SubReminder.threeDaysBefore:
        return '3일 뒤 ${item.name} $amount이 결제돼요.';
    }
  }
}

// 일시정지는 뒤로, 그 외 결제 임박 순.
List<Subscription> _sorted(List<Subscription> items) {
  final copy = [...items];
  copy.sort((a, b) {
    if (a.active != b.active) return a.active ? -1 : 1;
    return a.daysUntilPayment.compareTo(b.daysUntilPayment);
  });
  return copy;
}
