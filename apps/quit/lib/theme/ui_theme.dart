import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';

/// 하루더 전용 시맨틱 색. 라이트/다크로 전환된다.
/// (공용 design_system은 흰 배경 전용이라 자체 테마를 둔다. 추후 공용 패키지로 추출 예정.)
class UiColors {
  final Color bg;
  final Color surface;
  final Color surfaceAlt;
  final Color textPrimary;
  final Color textSecondary;
  final Color textTertiary;
  final Color border;
  final Color accent;

  const UiColors({
    required this.bg,
    required this.surface,
    required this.surfaceAlt,
    required this.textPrimary,
    required this.textSecondary,
    required this.textTertiary,
    required this.border,
    required this.accent,
  });

  static const light = UiColors(
    bg: Color(0xFFF4F6F5),
    surface: Color(0xFFFFFFFF),
    surfaceAlt: Color(0xFFEDF1EF),
    textPrimary: Color(0xFF16201B),
    textSecondary: Color(0xFF667069),
    textTertiary: Color(0xFF9AA5A0),
    border: Color(0xFFE7ECE9),
    accent: Color(0xFF12B76A),
  );

  static const dark = UiColors(
    bg: Color(0xFF0C110E),
    surface: Color(0xFF18211C),
    surfaceAlt: Color(0xFF212B25),
    textPrimary: Color(0xFFF2F5F3),
    textSecondary: Color(0xFF9AA5A0),
    textTertiary: Color(0xFF667069),
    border: Color(0xFF2A352E),
    accent: Color(0xFF3CCB8A),
  );

  static UiColors of(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark ? dark : light;
}

/// 밝기별 ThemeData. 위젯은 대부분 [UiColors.of]로 색을 읽는다.
ThemeData buildUiTheme(Brightness brightness) {
  final c = brightness == Brightness.dark ? UiColors.dark : UiColors.light;
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
