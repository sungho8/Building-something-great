import 'package:flutter/widgets.dart';

/// 폰트 토큰 — EggSchool typo Primitive 기준.
///
/// ⚠️ Pretendard 폰트 에셋은 아직 번들되지 않았다. 실제 렌더에는 폰트 추가 필요.
/// ⚠️ 타입 사이즈 스케일(Label1~4 등)은 Semantic 컬렉션에 있어 별도 수령 예정.
abstract final class AppFont {
  /// 기본 폰트 패밀리.
  static const String family = 'Pretendard';
}

/// 폰트 굵기 (weight-100 ~ weight-900).
abstract final class AppFontWeight {
  static const FontWeight thin = FontWeight.w100; // Thin
  static const FontWeight extraLight = FontWeight.w200; // ExtraLight
  static const FontWeight light = FontWeight.w300; // Light
  static const FontWeight regular = FontWeight.w400; // Regular
  static const FontWeight medium = FontWeight.w500; // Medium
  static const FontWeight semiBold = FontWeight.w600; // SemiBold
  static const FontWeight bold = FontWeight.w700; // Bold
  static const FontWeight extraBold = FontWeight.w800; // ExtraBold
  static const FontWeight black = FontWeight.w900; // Black
}
