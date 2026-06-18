import 'package:flutter/material.dart';

/// 앱의 분위기. 컴포넌트가 미세하게 다르게 반응할 수 있는 힌트.
enum Vibe { soft, crisp }

/// 각 앱이 주입하는 "외모 설정".
///
/// 컴포넌트는 이 객체를 직접 모른다. [buildTheme]이 이걸 [ThemeData]로 바꿔
/// `Theme.of(context)`로 흘려보내고, 컴포넌트는 그 Theme만 본다.
@immutable
class BrandConfig {
  /// 대표 색(포인트). primary로 원색 그대로 쓰인다.
  final Color seed;

  /// 화면 배경색(앱 무드). null이면 중립 회색 기본값.
  final Color? background;

  /// 폰트 패밀리. null이면 플랫폼 기본 폰트.
  final String? fontFamily;

  /// 모서리 둥글기.
  final double radius;

  /// 앱 분위기.
  final Vibe vibe;

  const BrandConfig({
    required this.seed,
    this.background,
    this.fontFamily,
    this.radius = 12,
    this.vibe = Vibe.soft,
  });
}
