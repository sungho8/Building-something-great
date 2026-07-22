import 'package:ads/ads.dart';
import 'package:backend/backend.dart';
import 'package:core/core.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app.dart';
import 'data/repositories/dday_repository_impl.dart';
import 'di/dday_providers.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final store = await LocalStore.create();
  final notifications = await NotificationService.create();
  await notifications.requestPermissions();
  await AdsService.initialize();
  initKakao(dDayKakaoNativeAppKey);

  // Firebase: 게스트 로그인 + (로컬이 비어 있으면) 클라우드 복원.
  // 콘솔 미설정·오프라인 등 어떤 실패에도 앱은 로컬로 계속 동작한다.
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    final user = await AuthService().ensureGuest();
    final repo = DDayRepositoryImpl(store);
    if (repo.load().isEmpty) {
      final snap = await CloudSyncService().pull(user.uid);
      if (snap != null && snap.data.isNotEmpty) {
        await repo.importRaw(snap.data);
      }
    }
  } catch (_) {
    // 클라우드 없이 로컬 전용으로 계속.
  }

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
