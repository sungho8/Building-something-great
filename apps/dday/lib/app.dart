import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'di/dday_providers.dart';
import 'presentation/views/auth/login_view.dart';
import 'presentation/views/dday/dday_list_view.dart';

/// 앱 루트. 브랜드 주입 + 첫 화면 지정.
class DDayApp extends StatelessWidget {
  const DDayApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const AppFactory(
      brand: BrandConfig(
        seed: Color(0xFFFF5B7F), // 비비드 코랄핑크 — KeyColor(위젯이 짊어짐)
        radius: 16,
        vibe: Vibe.soft,
      ),
      title: 'D-Day',
      home: RootGate(),
    );
  }
}

/// 온보딩 완료 여부에 따라 로그인 화면 또는 목록을 보여준다.
class RootGate extends ConsumerWidget {
  const RootGate({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final onboarded = ref.watch(onboardingProvider);
    return onboarded ? const DDayListView() : const LoginView();
  }
}
