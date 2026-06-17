import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app.dart';
import 'di/dday_providers.dart';

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
