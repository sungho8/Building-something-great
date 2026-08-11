import 'package:design_system/design_system.dart'
    show AppFont, AppTypography, AppRadius;
import 'package:flutter/material.dart';

/// 앱 공용 시맨틱 색. 중립 팔레트는 공유하고 [accent]만 앱별로 주입한다.
/// ThemeData에 확장으로 실려 [UiColors.of]로 읽힌다.
class UiColors extends ThemeExtension<UiColors> {
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

  static const _light = UiColors(
    bg: Color(0xFFF4F5F7),
    surface: Color(0xFFFFFFFF),
    surfaceAlt: Color(0xFFEFF1F4),
    textPrimary: Color(0xFF17181B),
    textSecondary: Color(0xFF6B7280),
    textTertiary: Color(0xFF9CA3AF),
    border: Color(0xFFEBEDF0),
    accent: Color(0xFF3182F6),
  );

  static const _dark = UiColors(
    bg: Color(0xFF0D0E12),
    surface: Color(0xFF1A1C22),
    surfaceAlt: Color(0xFF23262E),
    textPrimary: Color(0xFFF4F5F7),
    textSecondary: Color(0xFF9BA1AC),
    textTertiary: Color(0xFF6B7280),
    border: Color(0xFF2A2D35),
    accent: Color(0xFF4C8DFF),
  );

  /// 밝기 + 앱 accent로 팔레트 생성.
  factory UiColors.build(Brightness brightness, Color accent) =>
      (brightness == Brightness.dark ? _dark : _light).copyWith(accent: accent);

  static UiColors of(BuildContext context) =>
      Theme.of(context).extension<UiColors>()!;

  @override
  UiColors copyWith({
    Color? bg,
    Color? surface,
    Color? surfaceAlt,
    Color? textPrimary,
    Color? textSecondary,
    Color? textTertiary,
    Color? border,
    Color? accent,
  }) =>
      UiColors(
        bg: bg ?? this.bg,
        surface: surface ?? this.surface,
        surfaceAlt: surfaceAlt ?? this.surfaceAlt,
        textPrimary: textPrimary ?? this.textPrimary,
        textSecondary: textSecondary ?? this.textSecondary,
        textTertiary: textTertiary ?? this.textTertiary,
        border: border ?? this.border,
        accent: accent ?? this.accent,
      );

  @override
  UiColors lerp(ThemeExtension<UiColors>? other, double t) {
    if (other is! UiColors) return this;
    return UiColors(
      bg: Color.lerp(bg, other.bg, t)!,
      surface: Color.lerp(surface, other.surface, t)!,
      surfaceAlt: Color.lerp(surfaceAlt, other.surfaceAlt, t)!,
      textPrimary: Color.lerp(textPrimary, other.textPrimary, t)!,
      textSecondary: Color.lerp(textSecondary, other.textSecondary, t)!,
      textTertiary: Color.lerp(textTertiary, other.textTertiary, t)!,
      border: Color.lerp(border, other.border, t)!,
      accent: Color.lerp(accent, other.accent, t)!,
    );
  }
}

/// 밝기별 ThemeData. [accent]로 브랜드색을 주입한다.
ThemeData buildUiTheme(Brightness brightness, {required Color accent}) {
  final c = UiColors.build(brightness, accent);
  final scheme = ColorScheme.fromSeed(
    seedColor: accent,
    brightness: brightness,
  ).copyWith(surface: c.surface, primary: accent, onSurface: c.textPrimary);

  return ThemeData(
    useMaterial3: true,
    brightness: brightness,
    colorScheme: scheme,
    scaffoldBackgroundColor: c.bg,
    fontFamily: AppFont.family,
    splashColor: Colors.transparent,
    highlightColor: Colors.transparent,
    extensions: [c],
    appBarTheme: AppBarTheme(
      backgroundColor: c.bg,
      foregroundColor: c.textPrimary,
      elevation: 0,
      scrolledUnderElevation: 0,
      centerTitle: false,
      titleTextStyle: AppTypography.title2.copyWith(color: c.textPrimary),
    ),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: accent,
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
