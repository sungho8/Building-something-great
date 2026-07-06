/// 색 토큰 — TDS(토스 디자인 시스템) 스타일 팔레트.
///
/// 팩토리 기본 무드: **흰 배경 + 회색 위계 + 선명한 포인트**.
/// - [AppGrey]가 시스템의 뼈대. 텍스트·테두리·배경 위계를 전부 이걸로 만든다.
/// - [AppBlue]는 팩토리 기본 브랜드 색. 앱별 브랜드는 BrandConfig(seed)로 교체.
/// - [AppRed]·[AppGreen]·[AppOrange]는 시맨틱(오류·성공·경고), 모든 앱 공유.
///
/// 값은 TDS 공개 팔레트 기반의 근사값이다.
library;

import 'package:flutter/material.dart';

/// 공통 색
abstract final class AppCommon {
  static const white = Color(0xFFFFFFFF);
  static const black = Color(0xFF000000);
}

/// 회색 위계 — 시스템의 뼈대
abstract final class AppGrey {
  static const s50 = Color(0xFFF9FAFB);
  static const s100 = Color(0xFFF2F4F6);
  static const s200 = Color(0xFFE5E8EB);
  static const s300 = Color(0xFFD1D6DB);
  static const s400 = Color(0xFFB0B8C1);
  static const s500 = Color(0xFF8B95A1);
  static const s600 = Color(0xFF6B7684);
  static const s700 = Color(0xFF4E5968);
  static const s800 = Color(0xFF333D4B);
  static const s900 = Color(0xFF191F28);
}

/// 자주 쓰는 회색 역할 별칭 — 위계 고민 없이 바로 쓰는 용도
abstract final class AppSemantic {
  /// 제목·본문 기본
  static const textPrimary = AppGrey.s900;

  /// 보조 텍스트
  static const textSecondary = AppGrey.s700;

  /// 힌트·비활성 톤 텍스트
  static const textTertiary = AppGrey.s500;

  /// 비활성 텍스트
  static const textDisabled = AppGrey.s300;

  /// 컴포넌트 테두리
  static const border = AppGrey.s200;

  /// 구분선
  static const divider = AppGrey.s100;

  /// 화면 기본 배경
  static const bgScreen = AppCommon.white;

  /// 섹션·인풋 등 2차 배경
  static const bgSecondary = AppGrey.s100;
}

/// 팩토리 기본 브랜드(블루). 앱별 브랜드는 BrandConfig로 교체.
abstract final class AppBlue {
  static const s50 = Color(0xFFE8F3FF);
  static const s100 = Color(0xFFC9E2FF);
  static const s200 = Color(0xFF90C2FF);
  static const s300 = Color(0xFF64A8FF);
  static const s400 = Color(0xFF4593FC);
  static const s500 = Color(0xFF3182F6);
  static const s600 = Color(0xFF2272EB);
  static const s700 = Color(0xFF1B64DA);
  static const s800 = Color(0xFF1957C2);
  static const s900 = Color(0xFF194AA6);
}

/// 시맨틱 — 오류·삭제
abstract final class AppRed {
  static const s50 = Color(0xFFFFEEF0);
  static const s100 = Color(0xFFFFD6DB);
  static const s200 = Color(0xFFFFAAB3);
  static const s300 = Color(0xFFFF7A87);
  static const s400 = Color(0xFFF95866);
  static const s500 = Color(0xFFF04452);
  static const s600 = Color(0xFFD6323F);
  static const s700 = Color(0xFFB22732);
}

/// 시맨틱 — 성공·완료
abstract final class AppGreen {
  static const s50 = Color(0xFFEAFAF2);
  static const s100 = Color(0xFFC8F2DE);
  static const s200 = Color(0xFF93E6C1);
  static const s300 = Color(0xFF55D69E);
  static const s400 = Color(0xFF26C983);
  static const s500 = Color(0xFF02BC70);
  static const s600 = Color(0xFF02A863);
  static const s700 = Color(0xFF028A52);
}

/// 시맨틱 — 경고·주의
abstract final class AppOrange {
  static const s50 = Color(0xFFFFF4E5);
  static const s100 = Color(0xFFFFE3BF);
  static const s200 = Color(0xFFFFCB85);
  static const s300 = Color(0xFFFFB14D);
  static const s400 = Color(0xFFFD9E28);
  static const s500 = Color(0xFFF98C0E);
  static const s600 = Color(0xFFE07C09);
  static const s700 = Color(0xFFBA6705);
}
