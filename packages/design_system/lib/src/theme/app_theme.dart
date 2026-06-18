import 'package:flutter/material.dart';

import '../tokens/colors.dart';
import 'brand_config.dart';

/// [BrandConfig] → [ThemeData].
///
/// 디자인 시스템의 단일 관문. 브랜드(Primary)는 앱별 seed에서, 중립·텍스트·테두리·
/// 에러색은 EggSchool 공유 토큰에서 가져온다. 컴포넌트는 여기서 나온 Theme만 본다.
ThemeData buildTheme(BrandConfig brand, Brightness brightness) {
  final isLight = brightness == Brightness.light;
  final base = ColorScheme.fromSeed(
    seedColor: brand.seed,
    brightness: brightness,
  );

  // 라이트 모드는 공유 토큰으로 중립색 역할을 고정해 완성도를 맞춘다.
  final scheme = isLight
      ? base.copyWith(
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
      : base;

  final cardRadius = BorderRadius.circular(brand.radius);

  return ThemeData(
    useMaterial3: true,
    colorScheme: scheme,
    fontFamily: brand.fontFamily,
    scaffoldBackgroundColor: isLight ? AppNeutral.s50 : scheme.surface,
    appBarTheme: AppBarTheme(
      backgroundColor: isLight ? AppNeutral.s50 : scheme.surface,
      foregroundColor: isLight ? AppText.s900 : scheme.onSurface,
      elevation: 0,
      scrolledUnderElevation: 0.5,
      centerTitle: false,
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
