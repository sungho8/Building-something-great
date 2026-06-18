import 'package:flutter/material.dart';

/// 색 토큰 — EggSchool 디자인 시스템 Primitive에서 자동 생성 (정확값).
///
/// 구조 원칙:
/// - Neutral·Text·Icon·Border·시맨틱(red/blue/...) 스케일은 **모든 앱 공유**.
/// - [AppPrimary]는 기본 브랜드(Egg Purple). 앱별 브랜드는 BrandConfig→Theme로 교체하고,
///   이 스케일은 기본/참조용으로 둔다.
library;

/// 공통 색
abstract final class AppCommon {
  static const white = Color(0xFFFFFFFF);
  static const black = Color(0xFF000000);
}

/// 태그/카테고리 색
abstract final class AppTag {
  static const pink = Color(0xFFFF669A);
  static const mint = Color(0xFF0BD5AD);
  static const orange = Color(0xFFFFAB33);
  static const red = Color(0xFFF75A4C);
  static const blue = Color(0xFF379EFF);
  static const purple = Color(0xFF7E5BEF);
  static const black = Color(0xFF0F1012);
  static const gray = Color(0xFF9C9EA4);
}

/// 기본 브랜드(Egg Purple). 앱별 교체 대상.
abstract final class AppPrimary {
  static const s50 = Color(0xFFF8F6FF);
  static const s100 = Color(0xFFF0ECFF);
  static const s200 = Color(0xFFE3DBFF);
  static const s300 = Color(0xFFCBBFFF);
  static const s400 = Color(0xFFB09AFF);
  static const s500 = Color(0xFF7E5BEF);
  static const s600 = Color(0xFF6A45DC);
  static const s700 = Color(0xFF5936BB);
  static const s800 = Color(0xFF472C96);
  static const s900 = Color(0xFF2F1D6B);
}

/// 중립 — 배경·버튼 등 범용 (공유)
abstract final class AppNeutral {
  static const s50 = Color(0xFFFAFAFD);
  static const s100 = Color(0xFFF7F7FB);
  static const s200 = Color(0xFFE8E8EE);
  static const s300 = Color(0xFFE5E7EC);
  static const s400 = Color(0xFFD8DAE1);
  static const s500 = Color(0xFFC8CAD2);
  static const s600 = Color(0xFFB0B3BC);
  static const s700 = Color(0xFF9295A0);
  static const s800 = Color(0xFF6E7178);
}

/// 텍스트 색 (공유)
abstract final class AppText {
  static const s50 = Color(0xFFEDEDF3);
  static const s100 = Color(0xFFE6E7EE);
  static const s200 = Color(0xFFDCDDE5);
  static const s300 = Color(0xFFCACAD2);
  static const s400 = Color(0xFF9C9EA4);
  static const s500 = Color(0xFF74767C);
  static const s600 = Color(0xFF5C5E65);
  static const s700 = Color(0xFF47494E);
  static const s800 = Color(0xFF2C2E31);
  static const s900 = Color(0xFF0F1012);
}

/// 아이콘 색 (공유)
abstract final class AppIcon {
  static const s50 = Color(0xFFF2F2F4);
  static const s100 = Color(0xFFE0E0E4);
  static const s200 = Color(0xFFC8C8CE);
  static const s300 = Color(0xFFA5A5AF);
  static const s400 = Color(0xFF95959F);
  static const s500 = Color(0xFF81818D);
  static const s600 = Color(0xFF6B6B78);
  static const s700 = Color(0xFF545461);
  static const s800 = Color(0xFF3D3D4A);
  static const s900 = Color(0xFF2A2A37);
}

/// 테두리 색 (공유)
abstract final class AppBorder {
  static const s50 = Color(0xFFF1F1F5);
  static const s100 = Color(0xFFE5E5EC);
  static const s200 = Color(0xFFD4D4DC);
  static const s300 = Color(0xFFBBBBC6);
  static const s400 = Color(0xFF9F9FAC);
  static const s500 = Color(0xFF80808F);
  static const s600 = Color(0xFF606070);
  static const s700 = Color(0xFF404050);
  static const s800 = Color(0xFF282835);
  static const s900 = Color(0xFF111111);
}

/// Sub/Red (공유)
abstract final class AppRed {
  static const s50 = Color(0xFFFFF0F0);
  static const s100 = Color(0xFFFFD9D9);
  static const s200 = Color(0xFFFFB3B3);
  static const s300 = Color(0xFFFF8080);
  static const s400 = Color(0xFFE84444);
  static const s500 = Color(0xFFD32F2F);
  static const s600 = Color(0xFFCC2B2B);
  static const s700 = Color(0xFFB52020);
}

/// Sub/Deep-Red (공유)
abstract final class AppDeepRed {
  static const s50 = Color(0xFFFFF0F0);
  static const s100 = Color(0xFFFFD9D9);
  static const s200 = Color(0xFFFFB3B3);
  static const s300 = Color(0xFFFF8080);
  static const s400 = Color(0xFFF05050);
  static const s500 = Color(0xFFCE0017);
  static const s600 = Color(0xFFA80013);
  static const s700 = Color(0xFF85000F);
}

/// Sub/Green (공유)
abstract final class AppGreen {
  static const s50 = Color(0xFFE6FAF0);
  static const s100 = Color(0xFFC8F2D9);
  static const s200 = Color(0xFF96E6B3);
  static const s300 = Color(0xFF54D68A);
  static const s400 = Color(0xFF22CC69);
  static const s500 = Color(0xFF00C853);
  static const s600 = Color(0xFF00A844);
  static const s700 = Color(0xFF008535);
}

/// Sub/Blue (공유)
abstract final class AppBlue {
  static const s50 = Color(0xFFEDF1FA);
  static const s100 = Color(0xFFCFDAF5);
  static const s200 = Color(0xFFA0B6EC);
  static const s300 = Color(0xFF6B8FDF);
  static const s400 = Color(0xFF3A63C4);
  static const s500 = Color(0xFF123C91);
  static const s600 = Color(0xFF0D2E72);
  static const s700 = Color(0xFF081F52);
}

/// Sub/Yellow (공유)
abstract final class AppYellow {
  static const s50 = Color(0xFFFFFAE5);
  static const s100 = Color(0xFFFFF4C2);
  static const s200 = Color(0xFFFFED99);
  static const s300 = Color(0xFFFFE570);
  static const s400 = Color(0xFFFFE05C);
  static const s500 = Color(0xFFFFDC50);
  static const s600 = Color(0xFFF5CC28);
  static const s700 = Color(0xFFFBC600);
}

/// Sub/Lime (공유)
abstract final class AppLime {
  static const s50 = Color(0xFFF4FBEA);
  static const s100 = Color(0xFFE4F6CC);
  static const s200 = Color(0xFFCEEEAA);
  static const s300 = Color(0xFFA2D45E);
  static const s400 = Color(0xFF9FD85C);
  static const s500 = Color(0xFF8AC339);
  static const s600 = Color(0xFF6FA029);
  static const s700 = Color(0xFF537A1C);
}

/// Sub/Light-Green (공유)
abstract final class AppLightGreen {
  static const s50 = Color(0xFFF9FCE5);
  static const s100 = Color(0xFFF2F8CC);
  static const s200 = Color(0xFFE7F2A4);
  static const s300 = Color(0xFFD8EA78);
  static const s400 = Color(0xFFC8E050);
  static const s500 = Color(0xFFB4D230);
  static const s600 = Color(0xFF98B418);
  static const s700 = Color(0xFF7A9200);
}

/// Sub/Cyan (공유)
abstract final class AppCyan {
  static const s50 = Color(0xFFE5F9FC);
  static const s100 = Color(0xFFCCF2F8);
  static const s200 = Color(0xFFA4E8F2);
  static const s300 = Color(0xFF60D8E8);
  static const s400 = Color(0xFF22C8DC);
  static const s500 = Color(0xFF06B4C9);
  static const s600 = Color(0xFF059AAD);
  static const s700 = Color(0xFF047A88);
}

/// Sub/Sky (공유)
abstract final class AppSky {
  static const s50 = Color(0xFFEBF5FF);
  static const s100 = Color(0xFFEBF5FF);
  static const s200 = Color(0xFFAACFFF);
  static const s300 = Color(0xFF88BCFF);
  static const s400 = Color(0xFF6DB0FF);
  static const s500 = Color(0xFF55AAFF);
  static const s600 = Color(0xFF3388DD);
  static const s700 = Color(0xFF1A6ABB);
}
