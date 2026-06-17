import 'package:core/core.dart';
import 'package:dday/providers/dday_providers.dart';
import 'package:dday/screens/dday_list_screen.dart';
import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  testWidgets('빈 목록이면 안내 문구와 추가 버튼이 보인다', (tester) async {
    SharedPreferences.setMockInitialValues({});
    final store = await LocalStore.create();

    await tester.pumpWidget(
      ProviderScope(
        overrides: [localStoreProvider.overrideWithValue(store)],
        child: const AppFactory(
          brand: BrandConfig(seed: Color(0xFFFF7AA2)),
          home: DDayListScreen(),
        ),
      ),
    );

    expect(find.text('추가'), findsOneWidget);
    expect(find.text('등록된 D-Day가 없어요'), findsOneWidget);
  });
}
