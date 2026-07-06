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

  final background =
      brand.background ?? (isLight ? AppSemantic.bgScreen : scheme.surface);
  final cardRadius = BorderRadius.circular(brand.radius);

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
    fontFamily: brand.fontFamily,
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
              fontFamily: brand.fontFamily,
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
        side: isLight
            ? const BorderSide(color: AppSemantic.divider)
            : BorderSide.none,
      ),
    ),
    dividerTheme: isLight
        ? const DividerThemeData(color: AppSemantic.divider, thickness: 1)
        : null,
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
