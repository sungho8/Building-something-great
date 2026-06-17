import 'package:flutter/material.dart';

import 'theme/app_theme.dart';
import 'theme/brand_config.dart';

/// 모든 앱의 진입점 래퍼.
///
/// 앱은 자기 [BrandConfig]와 [home]만 넘기면 된다. 테마 구성·라이트/다크 처리는
/// 디자인 시스템이 책임진다. 이게 "브랜드는 주입, 컴포넌트는 무지" 원칙의 입구다.
class AppFactory extends StatelessWidget {
  final BrandConfig brand;
  final Widget home;
  final String title;

  const AppFactory({
    super.key,
    required this.brand,
    required this.home,
    this.title = '',
  });

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: title,
      debugShowCheckedModeBanner: false,
      theme: buildTheme(brand, Brightness.light),
      darkTheme: buildTheme(brand, Brightness.dark),
      home: home,
    );
  }
}
