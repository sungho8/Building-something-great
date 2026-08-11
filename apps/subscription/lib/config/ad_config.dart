import 'package:ads/ads.dart';
import 'package:flutter/foundation.dart';

/// 구독 앱의 AdMob 광고 단위.
///
/// - 디버그/프로파일: Google 공식 테스트 단위.
/// - 릴리스: 아래 실계정 단위(출시 전 교체).
abstract final class SubAds {
  static const _androidBanner = 'ca-app-pub-7882733072028788/4956744942';
  // TODO(iOS 출시): iOS 배너 광고 단위 ID로 교체 (현재 Android용 플레이스홀더).
  static const _iosBanner = 'ca-app-pub-0000000000000000/0000000000';

  static String get banner {
    if (!kReleaseMode) return AdIds.testBanner;
    return defaultTargetPlatform == TargetPlatform.iOS
        ? _iosBanner
        : _androidBanner;
  }
}
