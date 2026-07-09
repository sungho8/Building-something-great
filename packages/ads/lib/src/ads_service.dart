import 'dart:async';

import 'package:google_mobile_ads/google_mobile_ads.dart';

/// AdMob 초기화 + 동의(UMP) 관리.
///
/// 앱 시작 시 [initialize]를 한 번 호출한다. GDPR/ATT 동의를 먼저 수집한 뒤
/// SDK를 초기화한다. 동의 흐름이 실패해도 광고 초기화는 막지 않는다(비차단).
abstract final class AdsService {
  static bool _initialized = false;

  /// 초기화됨 여부.
  static bool get isInitialized => _initialized;

  /// SDK 초기화. [testDeviceIds]를 주면 해당 기기에 테스트 광고를 강제한다.
  static Future<void> initialize({List<String> testDeviceIds = const []}) async {
    if (_initialized) return;

    await _gatherConsent();

    if (testDeviceIds.isNotEmpty) {
      await MobileAds.instance.updateRequestConfiguration(
        RequestConfiguration(testDeviceIds: testDeviceIds),
      );
    }

    await MobileAds.instance.initialize();
    _initialized = true;
  }

  // UMP 동의 정보 갱신 + 필요 시 동의 폼 표시. 실패·미필요면 조용히 통과.
  static Future<void> _gatherConsent() async {
    final completer = Completer<void>();
    try {
      ConsentInformation.instance.requestConsentInfoUpdate(
        ConsentRequestParameters(),
        () async {
          try {
            await ConsentForm.loadAndShowConsentFormIfRequired((_) {});
          } catch (_) {
            // 폼 로드/표시 실패는 무시.
          }
          if (!completer.isCompleted) completer.complete();
        },
        (_) {
          if (!completer.isCompleted) completer.complete();
        },
      );
    } catch (_) {
      if (!completer.isCompleted) completer.complete();
    }
    // 동의 흐름이 오래 걸려도 앱 시작을 막지 않도록 타임아웃.
    await completer.future.timeout(
      const Duration(seconds: 5),
      onTimeout: () {},
    );
  }
}
