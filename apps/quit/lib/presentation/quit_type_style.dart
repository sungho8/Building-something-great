import 'package:flutter/material.dart';

import '../domain/entities/quit_item.dart';

/// 끊기 종류 → 라벨·아이콘·기본색·단위 (표현 계층).
abstract final class QuitTypeStyle {
  static const _data =
      <QuitType, (String, IconData, int, String, int)>{
    // (라벨, 아이콘, 기본색, 단위라벨, 기본 하루 소비량)
    QuitType.smoking: ('담배', Icons.smoking_rooms_rounded, 0xFFEB5757, '개비', 20),
    QuitType.drinking: ('술', Icons.local_bar_rounded, 0xFFF2994A, '잔', 0),
    QuitType.custom: ('직접 입력', Icons.flag_rounded, 0xFF12B76A, '회', 0),
  };

  static String label(QuitType t) => _data[t]!.$1;
  static IconData icon(QuitType t) => _data[t]!.$2;
  static Color color(QuitType t) => Color(_data[t]!.$3);
  static String unitLabel(QuitType t) => _data[t]!.$4;

  /// 목표의 실제 표시색: 사용자 지정색 우선, 없으면 종류 기본색.
  static Color colorOf(QuitItem item) => item.color ?? color(item.type);
}
