import 'package:ads/ads.dart';
import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app.dart';
import 'di/subscription_providers.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final store = await LocalStore.create();
  final notifications = await NotificationService.create(
    channelId: 'subscription_reminders',
    channelName: '구독 결제 알림',
  );
  await notifications.requestPermissions();
  await AdsService.initialize();

  runApp(
    ProviderScope(
      overrides: [
        localStoreProvider.overrideWithValue(store),
        notificationServiceProvider.overrideWithValue(notifications),
      ],
      child: const SubscriptionApp(),
    ),
  );
}
