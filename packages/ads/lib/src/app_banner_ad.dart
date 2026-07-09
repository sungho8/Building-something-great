import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import 'ad_ids.dart';

/// 적응형 배너 광고 위젯.
///
/// 로드 전에는 자리를 차지하지 않고, 로드되면 배너 높이만큼 표시한다.
/// 로드 실패 시에도 조용히 숨긴다. [adUnitId] 미지정 시 테스트 배너를 쓴다.
class AppBannerAd extends StatefulWidget {
  final String? adUnitId;

  const AppBannerAd({super.key, this.adUnitId});

  @override
  State<AppBannerAd> createState() => _AppBannerAdState();
}

class _AppBannerAdState extends State<AppBannerAd> {
  BannerAd? _ad;
  bool _loaded = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  void _load() {
    final ad = BannerAd(
      adUnitId: widget.adUnitId ?? AdIds.testBanner,
      size: AdSize.banner,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (_) {
          if (mounted) setState(() => _loaded = true);
        },
        onAdFailedToLoad: (ad, error) => ad.dispose(),
      ),
    );
    _ad = ad;
    ad.load();
  }

  @override
  void dispose() {
    _ad?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ad = _ad;
    if (!_loaded || ad == null) return const SizedBox.shrink();

    return SizedBox(
      width: double.infinity,
      height: ad.size.height.toDouble(),
      child: AdWidget(ad: ad),
    );
  }
}
