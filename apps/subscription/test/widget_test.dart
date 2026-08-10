import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:subscription/di/subscription_providers.dart';
import 'package:subscription/presentation/views/subscription_list_view.dart';
import 'package:subscription/theme/sub_theme.dart';

void main() {
  testWidgets('빈 목록이면 안내 문구와 추가 버튼이 보인다', (tester) async {
    SharedPreferences.setMockInitialValues({});
    final store = await LocalStore.create();

    await tester.pumpWidget(
      ProviderScope(
        overrides: [localStoreProvider.overrideWithValue(store)],
        child: MaterialApp(
          theme: buildSubTheme(Brightness.light),
          home: const SubscriptionListView(),
        ),
      ),
    );

    expect(find.text('구독 추가'), findsOneWidget);
    expect(find.text('등록된 구독이 없어요'), findsOneWidget);
  });
}
