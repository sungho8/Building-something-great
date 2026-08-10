import 'package:flutter/material.dart';

import '../domain/entities/subscription.dart';

/// 카테고리 → 라벨·기본색·아이콘 매핑 (표현 계층 책임 — 엔티티는 색/아이콘을 모른다).
///
/// 아이콘은 임시로 Material 아이콘을 쓴다. 추후 브랜드별 asset 아이콘으로 교체 예정.
abstract final class CategoryStyle {
  static const _data = <SubscriptionCategory, (String, int, IconData)>{
    SubscriptionCategory.entertainment: ('엔터테인먼트', 0xFFF04452, Icons.movie_rounded),
    SubscriptionCategory.music: ('음악', 0xFF7E5BEF, Icons.music_note_rounded),
    SubscriptionCategory.shopping: ('쇼핑', 0xFFF98C0E, Icons.shopping_bag_rounded),
    SubscriptionCategory.productivity: ('생산성', 0xFF3182F6, Icons.bolt_rounded),
    SubscriptionCategory.game: ('게임', 0xFF06B4C9, Icons.sports_esports_rounded),
    SubscriptionCategory.etc: ('기타', 0xFF5B6472, Icons.credit_card_rounded),
  };

  static String label(SubscriptionCategory c) => _data[c]!.$1;
  static Color color(SubscriptionCategory c) => Color(_data[c]!.$2);
  static IconData icon(SubscriptionCategory c) => _data[c]!.$3;

  /// 구독의 실제 표시색: 사용자 지정색 우선, 없으면 카테고리 기본색.
  static Color colorOf(Subscription s) => s.color ?? color(s.category);
}
