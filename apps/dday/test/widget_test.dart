import 'package:dday/main.dart';
import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('홈 화면에 시작하기 버튼이 보인다', (tester) async {
    await tester.pumpWidget(
      const AppFactory(
        brand: BrandConfig(seed: Color(0xFFFF7AA2)),
        home: DDayHome(),
      ),
    );

    expect(find.text('시작하기'), findsOneWidget);
    expect(find.text('🏭 App Factory'), findsOneWidget);
  });
}
