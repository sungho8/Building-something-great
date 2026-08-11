import 'package:ads/ads.dart';
import 'package:flutter/foundation.dart';

/// 하루더 AdMob 광고 단위. 릴리스=실단위, 그 외=테스트단위.
abstract final class QuitAds {
  // TODO(출시): AdMob 콘솔의 실제 배너 광고 단위 ID로 교체.
  static const _androidBanner = 'ca-app-pub-0000000000000000/0000000000';
  static const _iosBanner = 'ca-app-pub-0000000000000000/0000000000';

  static String get banner {
    if (!kReleaseMode) return AdIds.testBanner;
    return defaultTargetPlatform == TargetPlatform.iOS
        ? _iosBanner
        : _androidBanner;
  }
}
