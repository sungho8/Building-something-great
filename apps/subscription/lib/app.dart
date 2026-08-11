import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'di/subscription_providers.dart';
import 'presentation/views/subscription_list_view.dart';
import 'package:app_theme/app_theme.dart';

/// 앱 루트. 라이트/다크 테마를 사용자 설정(없으면 시스템)에 따라 전환한다.
class SubscriptionApp extends ConsumerWidget {
  const SubscriptionApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);
    return MaterialApp(
      title: '구독노트',
      debugShowCheckedModeBanner: false,
      theme: buildUiTheme(Brightness.light, accent: const Color(0xFF3182F6)),
      darkTheme: buildUiTheme(Brightness.dark, accent: const Color(0xFF4C8DFF)),
      themeMode: themeMode,
      home: const SubscriptionListView(),
    );
  }
}
