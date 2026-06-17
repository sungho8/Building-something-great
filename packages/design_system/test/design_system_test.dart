import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('buildTheme이 seed 색으로 Material3 ColorScheme을 만든다', () {
    final theme = buildTheme(
      const BrandConfig(seed: Color(0xFFFF7AA2)),
      Brightness.light,
    );

    expect(theme.useMaterial3, isTrue);
    expect(theme.colorScheme.brightness, Brightness.light);
  });

  testWidgets('AppButton은 라벨을 렌더한다', (tester) async {
    await tester.pumpWidget(
      const AppFactory(
        brand: BrandConfig(seed: Color(0xFF2E6BFF)),
        home: Scaffold(body: AppButton(label: '확인')),
      ),
    );

    expect(find.text('확인'), findsOneWidget);
  });
}
