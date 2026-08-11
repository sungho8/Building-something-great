import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'di/quit_providers.dart';
import 'presentation/views/quit_home_view.dart';
import 'theme/ui_theme.dart';

/// 앱 루트. 라이트/다크를 사용자 설정(없으면 시스템)에 따라 전환.
class QuitApp extends ConsumerWidget {
  const QuitApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);
    return MaterialApp(
      title: '하루더',
      debugShowCheckedModeBanner: false,
      theme: buildUiTheme(Brightness.light),
      darkTheme: buildUiTheme(Brightness.dark),
      themeMode: themeMode,
      home: const QuitHomeView(),
    );
  }
}
