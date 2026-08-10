import 'package:ads/ads.dart';
import 'package:flutter/foundation.dart';

/// D-Day 앱의 AdMob 광고 단위.
///
/// - **디버그/프로파일:** Google 공식 테스트 단위([AdIds.testBanner]).
///   실광고를 개발 중에 띄우거나 클릭하면 AdMob 정책 위반(계정 정지)이라 항상 테스트.
/// - **릴리스:** 아래 실계정 단위.
///
/// ⚠️ 출시 전 [_androidBanner]/[_iosBanner]를 AdMob 콘솔에서 발급한
/// 실제 배너 광고 단위 ID로 교체해야 한다. (그리고 `AndroidManifest.xml`의
/// `com.google.android.gms.ads.APPLICATION_ID`도 실제 앱 ID로 교체.)
abstract final class DDayAds {
  static const _androidBanner = 'ca-app-pub-7882733072028788/9313736435';
  // TODO(iOS 출시): iOS 배너 광고 단위 ID로 교체 (현재 Android용 플레이스홀더).
  static const _iosBanner = 'ca-app-pub-0000000000000000/0000000000';

  /// 배너 광고 단위 — 릴리스는 실단위, 그 외는 테스트단위.
  static String get banner {
    if (!kReleaseMode) return AdIds.testBanner;
    return defaultTargetPlatform == TargetPlatform.iOS
        ? _iosBanner
        : _androidBanner;
  }
}
