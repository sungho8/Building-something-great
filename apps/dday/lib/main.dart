import 'package:core/core.dart';
import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'providers/dday_providers.dart';
import 'screens/dday_list_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final store = await LocalStore.create();
  final notifications = await NotificationService.create();
  await notifications.requestPermissions();

  runApp(
    ProviderScope(
      overrides: [
        localStoreProvider.overrideWithValue(store),
        notificationServiceProvider.overrideWithValue(notifications),
      ],
      child: const DDayApp(),
    ),
  );
}

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
      home: DDayListScreen(),
    );
  }
}
