import 'package:flutter/material.dart';

import '../tokens/colors.dart';
import '../tokens/typography.dart';
import 'brand_config.dart';

/// [BrandConfig] → [ThemeData].
///
/// 디자인 시스템의 단일 관문. TDS 무드:
/// - 배경은 흰색(또는 브랜드 무드색), 위계는 회색([AppGrey])으로.
/// - Primary는 브랜드 seed **원색 그대로** (M3 fromSeed의 톤 다운 회피).
/// - 텍스트는 [AppTypography] 스케일.
ThemeData buildTheme(BrandConfig brand, Brightness brightness) {
  final isLight = brightness == Brightness.light;
  final base = ColorScheme.fromSeed(
    seedColor: brand.seed,
    brightness: brightness,
  );

  // 브랜드 원색을 primary로 고정 (선명함 유지).
  final brandScheme = base.copyWith(
    primary: brand.seed,
    onPrimary: AppCommon.white,
  );

  // 라이트 모드는 회색 위계로 중립 역할을 고정.
  final scheme = isLight
      ? brandScheme.copyWith(
          surface: AppCommon.white,
          onSurface: AppSemantic.textPrimary,
          onSurfaceVariant: AppSemantic.textTertiary,
          outline: AppGrey.s300,
          outlineVariant: AppSemantic.border,
          error: AppRed.s500,
          surfaceContainerLowest: AppCommon.white,
          surfaceContainerLow: AppGrey.s50,
          surfaceContainer: AppSemantic.bgSecondary,
        )
      : brandScheme;

  // 디자인 규칙: 화면 배경은 흰색 고정. 색은 위젯이 짊어진다.
  final background = isLight ? AppSemantic.bgScreen : scheme.surface;
  final cardRadius = BorderRadius.circular(brand.radius);
  final fontFamily = brand.fontFamily ?? AppFont.family;

  // TDS 스케일을 Material textTheme 슬롯에 매핑.
  const textTheme = TextTheme(
    displaySmall: AppTypography.display,
    headlineLarge: AppTypography.title1,
    headlineMedium: AppTypography.title2,
    headlineSmall: AppTypography.title3,
    titleLarge: AppTypography.heading1,
    titleMedium: AppTypography.heading2,
    titleSmall: AppTypography.label3,
    bodyLarge: AppTypography.body1,
    bodyMedium: AppTypography.body2,
    bodySmall: AppTypography.body3,
    labelLarge: AppTypography.label2,
    labelMedium: AppTypography.label4,
    labelSmall: AppTypography.caption1,
  );

  return ThemeData(
    useMaterial3: true,
    colorScheme: scheme,
    fontFamily: fontFamily,
    textTheme: textTheme,
    scaffoldBackgroundColor: background,
    appBarTheme: AppBarTheme(
      backgroundColor: background,
      foregroundColor: isLight ? AppSemantic.textPrimary : scheme.onSurface,
      elevation: 0,
      scrolledUnderElevation: 0.5,
      centerTitle: false,
      titleTextStyle: isLight
          ? AppTypography.heading1.copyWith(
              color: AppSemantic.textPrimary,
              fontFamily: fontFamily,
            )
          : null,
    ),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: scheme.primary,
      foregroundColor: scheme.onPrimary,
    ),
    cardTheme: CardThemeData(
      color: isLight ? AppCommon.white : null,
      elevation: 0,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: cardRadius,
        // 흰 배경 위 흰 카드 — 아웃라인으로 구분(배경이 아니라 위젯이 형태를 가짐).
        side: isLight
            ? const BorderSide(color: AppSemantic.border)
            : BorderSide.none,
      ),
    ),
    dividerTheme: isLight
        ? const DividerThemeData(color: AppSemantic.divider, thickness: 1)
        : null,
    // 리스트·토글 항목 라벨은 강조(itemTitle), 보조 설명은 본문(descriptionSub).
    listTileTheme: ListTileThemeData(
      titleTextStyle: AppTypography.itemTitle.copyWith(
        color: isLight ? AppSemantic.textPrimary : scheme.onSurface,
      ),
      subtitleTextStyle: AppTypography.descriptionSub.copyWith(
        color: isLight ? AppSemantic.textTertiary : scheme.onSurfaceVariant,
      ),
    ),
    // 꺼짐: 흰 트랙 + 회색 테두리·손잡이 / 켜짐: KeyColor 트랙 + 흰 손잡이.
    switchTheme: SwitchThemeData(
      trackColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) return scheme.primary;
        return isLight ? AppCommon.white : AppGrey.s700;
      }),
      trackOutlineColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) return Colors.transparent;
        return AppSemantic.border;
      }),
      trackOutlineWidth: const WidgetStatePropertyAll(1.5),
      thumbColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) return AppCommon.white;
        return AppGrey.s400;
      }),
      overlayColor: WidgetStatePropertyAll(scheme.primary.withValues(alpha: 0.08)),
    ),
    inputDecorationTheme: isLight
        ? InputDecorationTheme(
            filled: true,
            fillColor: AppCommon.white,
            border: OutlineInputBorder(
              borderRadius: cardRadius,
              borderSide: const BorderSide(color: AppSemantic.border),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: cardRadius,
              borderSide: const BorderSide(color: AppSemantic.border),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: cardRadius,
              borderSide: BorderSide(color: scheme.primary, width: 1.5),
            ),
          )
        : null,
  );
}
