import 'package:core/core.dart';
import 'package:flutter/material.dart' show ThemeMode;
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/repositories/subscription_repository_impl.dart';
import '../domain/entities/subscription.dart';
import '../domain/repositories/subscription_repository.dart';
import '../presentation/viewmodels/subscription_list_viewmodel.dart';

/// main에서 초기화 인스턴스로 override.
final localStoreProvider = Provider<LocalStore>(
  (ref) => throw UnimplementedError('main에서 override 필요'),
);

/// main에서 초기화 인스턴스로 override.
final notificationServiceProvider = Provider<NotificationService>(
  (ref) => throw UnimplementedError('main에서 override 필요'),
);

/// 구독 리포지토리.
final subscriptionRepositoryProvider = Provider<SubscriptionRepository>(
  (ref) => SubscriptionRepositoryImpl(ref.watch(localStoreProvider)),
);

/// 구독 목록 상태.
final subscriptionListProvider =
    NotifierProvider<SubscriptionListViewModel, List<Subscription>>(
  SubscriptionListViewModel.new,
);

/// 이번 달 총 구독료(활성만, 월 환산 합). 목록 파생값.
final monthlyTotalProvider = Provider<double>((ref) {
  final items = ref.watch(subscriptionListProvider);
  return items
      .where((s) => s.active)
      .fold<double>(0, (sum, s) => sum + s.monthlyEquivalent);
});

/// 활성 구독 수.
final activeCountProvider = Provider<int>((ref) =>
    ref.watch(subscriptionListProvider).where((s) => s.active).length);

/// 테마 모드(시스템/라이트/다크). 로컬에 영속화. 기본은 시스템.
final themeModeProvider =
    NotifierProvider<ThemeModeController, ThemeMode>(ThemeModeController.new);

class ThemeModeController extends Notifier<ThemeMode> {
  static const _key = 'theme_mode';

  @override
  ThemeMode build() {
    return switch (ref.read(localStoreProvider).getString(_key)) {
      'light' => ThemeMode.light,
      'dark' => ThemeMode.dark,
      _ => ThemeMode.system,
    };
  }

  Future<void> set(ThemeMode mode) async {
    state = mode;
    await ref.read(localStoreProvider).setString(_key, mode.name);
  }
}
