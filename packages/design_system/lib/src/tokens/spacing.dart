import 'package:flutter/widgets.dart';

/// 간격 토큰 — EggSchool spacing Primitive 스케일 (정확값).
abstract final class AppSpacing {
  static const double s2 = 2;
  static const double s4 = 4;
  static const double s6 = 6;
  static const double s8 = 8;
  static const double s10 = 10;
  static const double s12 = 12;
  static const double s14 = 14;
  static const double s16 = 16;
  static const double s18 = 18;
  static const double s20 = 20;
  static const double s24 = 24;
  static const double s28 = 28;
  static const double s32 = 32;
  static const double s36 = 36;
  static const double s40 = 40;
  static const double s44 = 44;
  static const double s48 = 48;
  static const double s56 = 56;
  static const double s64 = 64;
  static const double s72 = 72;
  static const double s80 = 80;
  static const double s96 = 96;
  static const double s102 = 102;
  static const double s120 = 120;

  /// 완전 둥근/최대값 sentinel (반경 등에 사용).
  static const double full = 999;

  // 의미 별칭 (기존 컴포넌트 호환)
  static const double xs = s4;
  static const double sm = s8;
  static const double md = s16;
  static const double lg = s24;
  static const double xl = s32;

  static const Widget gapSm = SizedBox(height: s8, width: s8);
  static const Widget gapMd = SizedBox(height: s16, width: s16);
  static const Widget gapLg = SizedBox(height: s24, width: s24);
}
