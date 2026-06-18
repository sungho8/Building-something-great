import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';

import 'presentation/views/dday/dday_list_view.dart';

/// 앱 루트. 브랜드 주입 + 첫 화면 지정.
class DDayApp extends StatelessWidget {
  const DDayApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const AppFactory(
      brand: BrandConfig(
        seed: Color(0xFFFF5B7F), // 비비드 코랄핑크 — 포인트
        background: Color(0xFFFFF1F4), // 블러시 핑크 — 따뜻한 배경 무드
        radius: 16,
        vibe: Vibe.soft,
      ),
      title: 'D-Day',
      home: DDayListView(),
    );
  }
}
