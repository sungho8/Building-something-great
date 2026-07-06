/// 타이포 토큰 — TDS 스타일 스케일 (Pretendard 기준).
///
/// 크기는 15/17을 본문 축으로 하는 TDS 계열 스케일.
/// 색은 넣지 않는다 — Theme(textTheme)이 브랜드·위계에 맞게 입힌다.
library;

import 'package:flutter/widgets.dart';

/// 기본 폰트 패밀리.
///
/// ⚠️ Pretendard 에셋은 아직 번들되지 않았다. 번들 전에는 시스템 폰트로 렌더된다.
abstract final class AppFont {
  static const String family = 'Pretendard';
}

/// 폰트 굵기
abstract final class AppFontWeight {
  static const FontWeight thin = FontWeight.w100;
  static const FontWeight extraLight = FontWeight.w200;
  static const FontWeight light = FontWeight.w300;
  static const FontWeight regular = FontWeight.w400;
  static const FontWeight medium = FontWeight.w500;
  static const FontWeight semiBold = FontWeight.w600;
  static const FontWeight bold = FontWeight.w700;
  static const FontWeight extraBold = FontWeight.w800;
  static const FontWeight black = FontWeight.w900;
}

/// 텍스트 스타일 스케일.
///
/// display > title > heading > body > caption 위계 + 버튼용 label.
abstract final class AppTypography {
  /// 30/40 bold — 큰 숫자·스플래시 등 화면의 주인공
  static const display = TextStyle(
    fontSize: 30,
    height: 40 / 30,
    fontWeight: AppFontWeight.bold,
  );

  /// 26/36 bold — 화면 대제목
  static const title1 = TextStyle(
    fontSize: 26,
    height: 36 / 26,
    fontWeight: AppFontWeight.bold,
  );

  /// 22/30 bold — 섹션 제목
  static const title2 = TextStyle(
    fontSize: 22,
    height: 30 / 22,
    fontWeight: AppFontWeight.bold,
  );

  /// 20/28 bold — 카드 제목·강조 숫자
  static const title3 = TextStyle(
    fontSize: 20,
    height: 28 / 20,
    fontWeight: AppFontWeight.bold,
  );

  /// 17/24 semibold — 리스트 타이틀
  static const heading1 = TextStyle(
    fontSize: 17,
    height: 24 / 17,
    fontWeight: AppFontWeight.semiBold,
  );

  /// 15/22 semibold — 작은 타이틀
  static const heading2 = TextStyle(
    fontSize: 15,
    height: 22 / 15,
    fontWeight: AppFontWeight.semiBold,
  );

  /// 17/26 regular — 큰 본문
  static const body1 = TextStyle(
    fontSize: 17,
    height: 26 / 17,
    fontWeight: AppFontWeight.regular,
  );

  /// 15/24 regular — 기본 본문
  static const body2 = TextStyle(
    fontSize: 15,
    height: 24 / 15,
    fontWeight: AppFontWeight.regular,
  );

  /// 13/20 regular — 보조 본문
  static const body3 = TextStyle(
    fontSize: 13,
    height: 20 / 13,
    fontWeight: AppFontWeight.regular,
  );

  /// 12/16 regular — 캡션
  static const caption1 = TextStyle(
    fontSize: 12,
    height: 16 / 12,
    fontWeight: AppFontWeight.regular,
  );

  /// 11/14 regular — 최소 캡션
  static const caption2 = TextStyle(
    fontSize: 11,
    height: 14 / 11,
    fontWeight: AppFontWeight.regular,
  );

  /// 17/24 semibold — 버튼 lg(48)
  static const label1 = TextStyle(
    fontSize: 17,
    height: 24 / 17,
    fontWeight: AppFontWeight.semiBold,
  );

  /// 15/22 semibold — 버튼 md(42)
  static const label2 = TextStyle(
    fontSize: 15,
    height: 22 / 15,
    fontWeight: AppFontWeight.semiBold,
  );

  /// 14/20 semibold — 버튼 sm(36)
  static const label3 = TextStyle(
    fontSize: 14,
    height: 20 / 14,
    fontWeight: AppFontWeight.semiBold,
  );

  /// 13/18 semibold — 버튼 xs(32)
  static const label4 = TextStyle(
    fontSize: 13,
    height: 18 / 13,
    fontWeight: AppFontWeight.semiBold,
  );
}
