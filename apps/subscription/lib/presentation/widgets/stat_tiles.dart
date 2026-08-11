import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';

import 'package:app_theme/app_theme.dart';
import '../../utils/currency_format.dart';

/// 상단 요약 스탯 3종 — 이번 달 / 활성 / 연간.
class StatTiles extends StatelessWidget {
  const StatTiles({
    super.key,
    required this.monthlyTotal,
    required this.activeCount,
  });

  final double monthlyTotal;
  final int activeCount;

  @override
  Widget build(BuildContext context) {
    final c = UiColors.of(context);
    return Row(
      children: [
        _Tile(
          label: '이번 달',
          value: formatWon(monthlyTotal),
          valueColor: c.accent,
        ),
        const SizedBox(width: AppSpacing.s10),
        _Tile(label: '활성', value: '$activeCount개'),
        const SizedBox(width: AppSpacing.s10),
        _Tile(label: '연간', value: formatWon(monthlyTotal * 12)),
      ],
    );
  }
}

class _Tile extends StatelessWidget {
  const _Tile({required this.label, required this.value, this.valueColor});

  final String label;
  final String value;
  final Color? valueColor;

  @override
  Widget build(BuildContext context) {
    final c = UiColors.of(context);
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.s14, vertical: AppSpacing.s16),
        decoration: BoxDecoration(
          color: c.surface,
          borderRadius: BorderRadius.circular(AppRadius.lg),
          border: Border.all(color: c.border),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label,
                style:
                    AppTypography.caption1.copyWith(color: c.textTertiary)),
            const SizedBox(height: AppSpacing.s6),
            FittedBox(
              fit: BoxFit.scaleDown,
              alignment: Alignment.centerLeft,
              child: Text(
                value,
                style: AppTypography.heading1
                    .copyWith(color: valueColor ?? c.textPrimary),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
