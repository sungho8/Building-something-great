import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(
    const AppFactory(
      brand: BrandConfig(
        seed: Color(0xFFFF7AA2), // 말랑한 핑크 — D-Day의 정체성
        radius: 16,
        vibe: Vibe.soft,
      ),
      title: 'D-Day',
      home: DDayHome(),
    ),
  );
}

class DDayHome extends StatelessWidget {
  const DDayHome({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(title: const Text('D-Day')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: AppCard(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('🏭 App Factory', style: textTheme.titleLarge),
                AppSpacing.gapSm,
                Text('첫 제품: D-Day 카운터', style: textTheme.bodyMedium),
                AppSpacing.gapLg,
                AppButton(
                  label: '시작하기',
                  icon: Icons.add,
                  onPressed: () {},
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
