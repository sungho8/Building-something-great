/// 타이포 토큰 — TDS 스타일 스케일 (Pretendard 기준).
///
/// 크기는 15/17을 본문 축으로 하는 TDS 계열 스케일.
/// 색은 넣지 않는다 — Theme(textTheme)이 브랜드·위계에 맞게 입힌다.
library;

import 'package:flutter/widgets.dart';

/// 기본 폰트 패밀리.
///
/// Pretendard Regular(400)·SemiBold(600)·Bold(700) 3종을 design_system 패키지
/// 에셋으로 번들한다. `buildTheme`이 [BrandConfig.fontFamily]가 null이면 이 값을
/// 기본으로 사용하므로, 모든 앱이 별도 설정 없이 Pretendard로 렌더된다.
///
/// ⚠️ `packages/design_system/` 접두사 필수. design_system은 각 앱(dday 등)
/// 입장에서 의존 패키지라, Flutter가 폰트 매니페스트에 family를
/// `packages/design_system/Pretendard`로 네임스페이싱해서 등록한다. 접두사 없이
/// 'Pretendard'만 쓰면 매칭 실패 → 에러 없이 조용히 시스템 폰트로 폴백된다.
abstract final class AppFont {
  static const String family = 'packages/design_system/Pretendard';
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

  // ── 역할 별칭 (강조 vs 본문) ─────────────────────────────
  // "무슨 텍스트냐"로 고른다. 강조(semibold)와 본문(regular)을 명확히 나눈다.

  /// 강조 · 위젯/리스트 항목 라벨 (토글·리스트 좌측 텍스트, 카드 제목)
  static const itemTitle = heading1; // 17 semibold

  /// 강조 · 섹션 헤더 (그룹 위 라벨). 보통 textSecondary 색과 함께.
  static const sectionTitle = heading2; // 15 semibold

  /// 본문 · 기본 설명 텍스트
  static const description = body2; // 15 regular

  /// 본문 · 보조 설명·캡션
  static const descriptionSub = body3; // 13 regular
}
