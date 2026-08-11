import 'package:core/core.dart';
import 'package:flutter/material.dart' show ThemeMode;
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/repositories/quit_repository_impl.dart';
import '../domain/entities/quit_item.dart';
import '../domain/repositories/quit_repository.dart';
import '../presentation/viewmodels/quit_list_viewmodel.dart';

/// main에서 override.
final localStoreProvider = Provider<LocalStore>(
  (ref) => throw UnimplementedError('main에서 override 필요'),
);

/// main에서 override.
final notificationServiceProvider = Provider<NotificationService>(
  (ref) => throw UnimplementedError('main에서 override 필요'),
);

final quitRepositoryProvider = Provider<QuitRepository>(
  (ref) => QuitRepositoryImpl(ref.watch(localStoreProvider)),
);

/// 끊기 목표 목록 상태.
final quitListProvider =
    NotifierProvider<QuitListViewModel, List<QuitItem>>(QuitListViewModel.new);

/// 대표 목표(가장 오래 버틴 것 = 목록 첫 항목). 없으면 null.
final primaryQuitProvider = Provider<QuitItem?>((ref) {
  final list = ref.watch(quitListProvider);
  return list.isEmpty ? null : list.first;
});

/// 테마 모드(시스템/라이트/다크). 로컬 영속화.
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
