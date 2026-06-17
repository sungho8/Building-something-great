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
        seed: Color(0xFFFF7AA2), // 말랑한 핑크 — D-Day의 정체성
        radius: 16,
        vibe: Vibe.soft,
      ),
      title: 'D-Day',
      home: DDayListView(),
    );
  }
}
