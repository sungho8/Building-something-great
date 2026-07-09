import 'package:flutter/foundation.dart';

/// 광고 단위 ID.
///
/// 기본값은 Google 공식 **테스트 광고 단위**라 AdMob 실계정 없이도 광고가 뜬다.
/// 출시 시 각 앱이 자기 실계정 ID를 [AppBannerAd.adUnitId] 등으로 주입한다.
abstract final class AdIds {
  // Google 공식 테스트 배너 단위
  static const _androidTestBanner = 'ca-app-pub-3940256099942544/6300978111';
  static const _iosTestBanner = 'ca-app-pub-3940256099942544/2934735716';

  /// 플랫폼별 테스트 배너 단위.
  static String get testBanner =>
      defaultTargetPlatform == TargetPlatform.iOS
          ? _iosTestBanner
          : _androidTestBanner;
}
