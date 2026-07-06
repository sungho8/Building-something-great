import 'package:flutter/material.dart';

import '../tokens/typography.dart';

/// 앱의 분위기. 컴포넌트가 미세하게 다르게 반응할 수 있는 힌트.
enum Vibe { soft, crisp }

/// 각 앱이 주입하는 "외모 설정".
///
/// 컴포넌트는 이 객체를 직접 모른다. [buildTheme]이 이걸 [ThemeData]로 바꿔
/// `Theme.of(context)`로 흘려보내고, 컴포넌트는 그 Theme만 본다.
///
/// 디자인 규칙: **화면 배경은 흰색으로 고정**한다. 색은 배경이 아니라 위젯이
/// 짊어진다(채움 또는 아웃라인). 그래서 브랜드는 배경색을 갖지 않고, 특정 화면이
/// 예외적으로 배경색이 필요하면 `AppScaffold(backgroundColor:)`로 개별 지정한다.
@immutable
class BrandConfig {
  /// 대표 색(포인트/KeyColor). primary로 원색 그대로 쓰인다.
  final Color seed;

  /// 폰트 패밀리. null이면 기본값(Pretendard, [AppFont.family]) 사용.
  final String? fontFamily;

  /// 모서리 둥글기.
  final double radius;

  /// 앱 분위기.
  final Vibe vibe;

  const BrandConfig({
    required this.seed,
    this.fontFamily,
    this.radius = 12,
    this.vibe = Vibe.soft,
  });
}
