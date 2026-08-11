import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:quit/di/quit_providers.dart';
import 'package:quit/presentation/views/quit_home_view.dart';
import 'package:quit/theme/ui_theme.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  testWidgets('빈 상태면 시작 안내와 버튼이 보인다', (tester) async {
    SharedPreferences.setMockInitialValues({});
    final store = await LocalStore.create();

    await tester.pumpWidget(
      ProviderScope(
        overrides: [localStoreProvider.overrideWithValue(store)],
        child: MaterialApp(
          theme: buildUiTheme(Brightness.light),
          home: const QuitHomeView(),
        ),
      ),
    );

    expect(find.text('첫 끊기를 시작해볼까요?'), findsOneWidget);
    expect(find.text('끊기 시작하기'), findsOneWidget);
  });
}
