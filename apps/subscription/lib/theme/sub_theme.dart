import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';

/// 구독 앱 전용 시맨틱 색. 라이트/다크로 전환된다.
/// (공용 design_system은 '흰 배경 고정'이라 이 앱은 자체 테마를 둔다.)
class SubColors {
  final Color bg; // 스캐폴드 배경
  final Color surface; // 카드/타일 배경
  final Color surfaceAlt; // 보조 배경
  final Color textPrimary;
  final Color textSecondary;
  final Color textTertiary;
  final Color border;
  final Color accent;

  const SubColors({
    required this.bg,
    required this.surface,
    required this.surfaceAlt,
    required this.textPrimary,
    required this.textSecondary,
    required this.textTertiary,
    required this.border,
    required this.accent,
  });

  static const light = SubColors(
    bg: Color(0xFFF4F5F7),
    surface: Color(0xFFFFFFFF),
    surfaceAlt: Color(0xFFEFF1F4),
    textPrimary: Color(0xFF17171B),
    textSecondary: Color(0xFF6B7280),
    textTertiary: Color(0xFF9CA3AF),
    border: Color(0xFFEBEDF0),
    accent: Color(0xFF3182F6),
  );

  static const dark = SubColors(
    bg: Color(0xFF0D0E12),
    surface: Color(0xFF1A1C22),
    surfaceAlt: Color(0xFF23262E),
    textPrimary: Color(0xFFF4F5F7),
    textSecondary: Color(0xFF9BA1AC),
    textTertiary: Color(0xFF6B7280),
    border: Color(0xFF2A2D35),
    accent: Color(0xFF4C8DFF),
  );

  static SubColors of(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark ? dark : light;
}

/// 밝기별 ThemeData. 위젯들은 대부분 [SubColors.of]로 색을 읽는다.
ThemeData buildSubTheme(Brightness brightness) {
  final c = brightness == Brightness.dark ? SubColors.dark : SubColors.light;
  final scheme = ColorScheme.fromSeed(
    seedColor: c.accent,
    brightness: brightness,
  ).copyWith(surface: c.surface, primary: c.accent, onSurface: c.textPrimary);

  return ThemeData(
    useMaterial3: true,
    brightness: brightness,
    colorScheme: scheme,
    scaffoldBackgroundColor: c.bg,
    fontFamily: AppFont.family,
    splashColor: Colors.transparent,
    highlightColor: Colors.transparent,
    appBarTheme: AppBarTheme(
      backgroundColor: c.bg,
      foregroundColor: c.textPrimary,
      elevation: 0,
      scrolledUnderElevation: 0,
      centerTitle: false,
      titleTextStyle: AppTypography.title2.copyWith(color: c.textPrimary),
    ),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: c.accent,
      foregroundColor: Colors.white,
    ),
    dividerTheme: const DividerThemeData(color: Colors.transparent),
    popupMenuTheme: PopupMenuThemeData(
      color: c.surface,
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.lg),
      ),
      textStyle: AppTypography.body2.copyWith(color: c.textPrimary),
    ),
  );
}
