import 'package:flutter/material.dart';

import '../tokens/colors.dart';
import 'brand_config.dart';

/// [BrandConfig] → [ThemeData].
///
/// 디자인 시스템의 단일 관문.
/// - Primary는 브랜드 seed **원색 그대로** (M3 fromSeed의 톤 다운을 피해 선명하게).
/// - 배경은 브랜드 무드색(없으면 중립 회색).
/// - 중립·텍스트·테두리·에러는 EggSchool 공유 토큰.
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

  // 라이트 모드는 공유 토큰으로 중립색 역할을 고정.
  final scheme = isLight
      ? brandScheme.copyWith(
          surface: AppCommon.white,
          onSurface: AppText.s900,
          onSurfaceVariant: AppText.s500,
          outline: AppBorder.s300,
          outlineVariant: AppBorder.s200,
          error: AppRed.s500,
          surfaceContainerLowest: AppCommon.white,
          surfaceContainerLow: AppNeutral.s50,
          surfaceContainer: AppNeutral.s100,
        )
      : brandScheme;

  final background =
      brand.background ?? (isLight ? AppNeutral.s50 : scheme.surface);
  final cardRadius = BorderRadius.circular(brand.radius);

  return ThemeData(
    useMaterial3: true,
    colorScheme: scheme,
    fontFamily: brand.fontFamily,
    scaffoldBackgroundColor: background,
    appBarTheme: AppBarTheme(
      backgroundColor: background,
      foregroundColor: isLight ? AppText.s900 : scheme.onSurface,
      elevation: 0,
      scrolledUnderElevation: 0.5,
      centerTitle: false,
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
            ? const BorderSide(color: AppBorder.s100)
            : BorderSide.none,
      ),
    ),
    inputDecorationTheme: isLight
        ? InputDecorationTheme(
            filled: true,
            fillColor: AppCommon.white,
            border: OutlineInputBorder(
              borderRadius: cardRadius,
              borderSide: const BorderSide(color: AppBorder.s200),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: cardRadius,
              borderSide: const BorderSide(color: AppBorder.s200),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: cardRadius,
              borderSide: BorderSide(color: scheme.primary, width: 1.5),
            ),
          )
        : null,
  );
}
