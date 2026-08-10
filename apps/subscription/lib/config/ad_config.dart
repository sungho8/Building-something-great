import 'package:ads/ads.dart';
import 'package:flutter/foundation.dart';

/// 구독 앱의 AdMob 광고 단위.
///
/// - 디버그/프로파일: Google 공식 테스트 단위.
/// - 릴리스: 아래 실계정 단위(출시 전 교체).
abstract final class SubAds {
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
