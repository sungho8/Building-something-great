import 'dart:ui' show Color;

import 'package:freezed_annotation/freezed_annotation.dart';

part 'quit_item.freezed.dart';
part 'quit_item.g.dart';

/// 끊기 종류. 이정표 세트·아이콘·기본 단위를 결정한다.
enum QuitType { smoking, drinking, custom }

/// 건강/성취 이정표. 경과 [after]가 지나면 달성.
/// (의학 정보라 '일반적으로 알려진' 톤 — 단정·과장 금지, 진단·치료 주장 아님)
class Milestone {
  final Duration after;
  final String title;
  const Milestone(this.after, this.title);
}

const _smoking = <Milestone>[
  Milestone(Duration(minutes: 20), '심박수·혈압이 안정되기 시작해요'),
  Milestone(Duration(hours: 12), '혈중 산소가 정상 수준으로'),
  Milestone(Duration(days: 1), '심장 부담이 줄기 시작해요'),
  Milestone(Duration(days: 2), '후각·미각이 살아나기 시작해요'),
  Milestone(Duration(days: 14), '혈액순환·폐기능이 나아져요'),
  Milestone(Duration(days: 30), '기침·숨참이 줄어들어요'),
  Milestone(Duration(days: 90), '폐 기능이 뚜렷이 좋아져요'),
  Milestone(Duration(days: 365), '심장병 위험이 크게 낮아져요'),
];

const _drinking = <Milestone>[
  Milestone(Duration(days: 1), '혈중 알코올이 빠져나가요'),
  Milestone(Duration(days: 3), '수면의 질이 좋아지기 시작해요'),
  Milestone(Duration(days: 7), '간이 회복되기 시작해요'),
  Milestone(Duration(days: 14), '집중력·컨디션이 올라와요'),
  Milestone(Duration(days: 30), '간 지방이 줄어들어요'),
  Milestone(Duration(days: 90), '전반적인 건강이 좋아져요'),
  Milestone(Duration(days: 365), '간 기능이 크게 회복돼요'),
];

const _custom = <Milestone>[
  Milestone(Duration(days: 1), '첫 하루를 버텼어요'),
  Milestone(Duration(days: 3), '3일째, 고비를 넘겼어요'),
  Milestone(Duration(days: 7), '일주일 달성!'),
  Milestone(Duration(days: 14), '2주째, 습관이 되어가요'),
  Milestone(Duration(days: 30), '한 달 달성!'),
  Milestone(Duration(days: 100), '100일, 대단해요'),
  Milestone(Duration(days: 365), '1년, 완전히 바뀌었어요'),
];

/// 종류별 이정표(경과 오름차순).
List<Milestone> milestonesFor(QuitType type) => switch (type) {
      QuitType.smoking => _smoking,
      QuitType.drinking => _drinking,
      QuitType.custom => _custom,
    };

/// 끊기 목표 엔티티.
@freezed
abstract class QuitItem with _$QuitItem {
  const QuitItem._();

  const factory QuitItem({
    required String id,
    required String name,
    @Default(QuitType.custom) QuitType type,

    /// 끊은 일시(시 단위까지). 경과 카운트의 기준.
    required DateTime quitDate,

    /// 이전 하루 지출(원). 절약액 계산.
    @Default(0) int dailyCost,

    /// 이전 하루 소비량(개비/잔/회). 회피량 계산.
    @Default(0) double dailyUnits,

    /// 소비 단위 라벨(개비/잔/회).
    @Default('회') String unitLabel,

    /// 최고 연속 기록(일). 리셋해도 보존.
    @Default(0) int bestStreakDays,

    /// KeyColor(ARGB). null이면 브랜드색.
    int? colorValue,

    DateTime? createdAt,
  }) = _QuitItem;

  factory QuitItem.fromJson(Map<String, dynamic> json) =>
      _$QuitItemFromJson(json);

  /// 끊은 뒤 경과 시간(음수 방지).
  Duration get elapsed {
    final d = DateTime.now().difference(quitDate);
    return d.isNegative ? Duration.zero : d;
  }

  /// 경과 일수(내림).
  int get daysSince => elapsed.inDays;

  // 소수 일수(분 단위 정밀 — 금액이 매끄럽게 오른다)
  double get _elapsedDays => elapsed.inMinutes / (60 * 24);

  /// 절약한 금액(원).
  double get moneySaved => dailyCost * _elapsedDays;

  /// 회피한 소비량(개비/잔/회).
  double get unitsAvoided => dailyUnits * _elapsedDays;

  /// 아직 안 지난 다음 이정표. 모두 달성했으면 null.
  Milestone? get nextMilestone {
    for (final m in milestonesFor(type)) {
      if (m.after > elapsed) return m;
    }
    return null;
  }

  /// 직전에 달성한 이정표(없으면 null).
  Milestone? get lastAchieved {
    Milestone? last;
    for (final m in milestonesFor(type)) {
      if (m.after <= elapsed) last = m;
    }
    return last;
  }

  /// 달성한 이정표 수.
  int get achievedCount {
    var n = 0;
    for (final m in milestonesFor(type)) {
      if (m.after <= elapsed) n++;
    }
    return n;
  }

  /// 직전 이정표 → 다음 이정표 사이 진행률(0~1). 모두 달성이면 1.
  double get milestoneProgress {
    final next = nextMilestone;
    if (next == null) return 1;
    final prev = lastAchieved?.after ?? Duration.zero;
    final total = (next.after - prev).inSeconds;
    if (total <= 0) return 0;
    return ((elapsed - prev).inSeconds / total).clamp(0.0, 1.0);
  }

  /// 리셋 시 갱신될 최고 기록(현재 연속과 기존 최고 중 큰 값).
  int get updatedBestStreak =>
      daysSince > bestStreakDays ? daysSince : bestStreakDays;

  /// KeyColor. null이면 브랜드색 사용.
  Color? get color => colorValue == null ? null : Color(colorValue!);
}
