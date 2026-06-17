import 'package:flutter/material.dart';

import 'brand_config.dart';

/// [BrandConfig] → [ThemeData].
///
/// 디자인 시스템의 단일 관문. 모든 컴포넌트는 여기서 나온 Theme만 본다.
/// 앱마다 brand만 바꾸면 같은 컴포넌트가 다른 외모로 렌더된다.
ThemeData buildTheme(BrandConfig brand, Brightness brightness) {
  final scheme = ColorScheme.fromSeed(
    seedColor: brand.seed,
    brightness: brightness,
  );
  final radius = BorderRadius.circular(brand.radius);

  return ThemeData(
    useMaterial3: true,
    colorScheme: scheme,
    fontFamily: brand.fontFamily,
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        shape: RoundedRectangleBorder(borderRadius: radius),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      ),
    ),
    cardTheme: CardThemeData(
      shape: RoundedRectangleBorder(borderRadius: radius),
      clipBehavior: Clip.antiAlias,
    ),
  );
}
