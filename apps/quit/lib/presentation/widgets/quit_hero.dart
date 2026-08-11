import 'package:design_system/design_system.dart'
    show AppSpacing, AppRadius, AppTypography, AppCommon;
import 'package:flutter/material.dart';

import '../../domain/entities/quit_item.dart';
import '../../theme/ui_theme.dart';
import '../../utils/format.dart';
import '../quit_type_style.dart';

/// 대표 목표 히어로 — accent로 꽉 채우고 큰 D+ 카운터 + 절약액 + 다음 이정표.
class QuitHero extends StatelessWidget {
  const QuitHero({super.key, required this.item, this.onTap});

  final QuitItem item;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final c = UiColors.of(context);
    const onColor = AppCommon.white;
    final sub = onColor.withValues(alpha: 0.85);
    final next = item.nextMilestone;

    return Material(
      color: c.accent,
      borderRadius: BorderRadius.circular(AppRadius.xl),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.s20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(QuitTypeStyle.icon(item.type), color: onColor, size: 20),
                  const SizedBox(width: AppSpacing.s8),
                  Expanded(
                    child: Text(item.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTypography.itemTitle.copyWith(color: onColor)),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.s12),
              Text('D+${item.daysSince}',
                  style: AppTypography.display
                      .copyWith(color: onColor, fontSize: 52, height: 1.0)),
              const SizedBox(height: AppSpacing.s4),
              Text(
                item.dailyCost > 0
                    ? '${formatWon(item.moneySaved)} 절약'
                    : formatElapsed(item.elapsed),
                style: AppTypography.body2.copyWith(color: sub),
              ),
              const SizedBox(height: AppSpacing.s16),
              // 다음 이정표
              if (next != null) ...[
                ClipRRect(
                  borderRadius: BorderRadius.circular(AppRadius.max),
                  child: LinearProgressIndicator(
                    value: item.milestoneProgress,
                    minHeight: 6,
                    backgroundColor: onColor.withValues(alpha: 0.25),
                    valueColor: const AlwaysStoppedAnimation(onColor),
                  ),
                ),
                const SizedBox(height: AppSpacing.s8),
                Text('다음: ${next.title}',
                    style: AppTypography.caption1.copyWith(color: sub)),
              ] else
                Text('모든 이정표를 달성했어요 🎉',
                    style: AppTypography.body3
                        .copyWith(color: onColor, fontWeight: FontWeight.w500)),
            ],
          ),
        ),
      ),
    );
  }
}
