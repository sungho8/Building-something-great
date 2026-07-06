import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
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

  test('buildTheme의 기본 폰트가 패키지 네임스페이스 접두사를 포함한다', () {
    // packages/design_system/ 접두사가 없으면 FontManifest의 등록 키와 어긋나
    // 조용히 시스템 폰트로 폴백된다 (에러 없음) — 회귀 방지용 테스트.
    final theme = buildTheme(
      const BrandConfig(seed: Color(0xFF2E6BFF)),
      Brightness.light,
    );

    expect(AppFont.family, startsWith('packages/design_system/'));
    expect(theme.textTheme.bodyMedium!.fontFamily, AppFont.family);
  });

  test('Pretendard 3개 굵기 에셋이 실제로 로드된다', () async {
    for (final weight in ['Regular', 'SemiBold', 'Bold']) {
      final data =
          await rootBundle.load('assets/fonts/Pretendard-$weight.otf');
      expect(data.lengthInBytes, greaterThan(0));
    }
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
