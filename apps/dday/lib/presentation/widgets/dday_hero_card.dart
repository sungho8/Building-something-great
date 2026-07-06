import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';

import '../../domain/entities/dday_item.dart';
import '../../utils/date_format.dart';

/// 최상단 강조 카드. 큰 D-라벨 + 날짜 + 진행 게이지.
///
/// D-DAY 당일이면 브랜드색으로 꽉 채워 축하 무드를 낸다.
class DDayHeroCard extends StatelessWidget {
  const DDayHeroCard({
    super.key,
    required this.item,
    this.onTap,
    this.onPinToggle,
  });

  final DDayItem item;
  final VoidCallback? onTap;
  final VoidCallback? onPinToggle;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final isToday = item.daysFromToday == 0;

    final fg = isToday ? scheme.onPrimary : scheme.onSurface;
    final subFg = isToday
        ? scheme.onPrimary.withValues(alpha: 0.85)
        : AppSemantic.textTertiary;
    final labelColor = isToday ? scheme.onPrimary : scheme.primary;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: isToday ? scheme.primary : scheme.surface,
        borderRadius: BorderRadius.circular(AppRadius.xl),
        border: isToday ? null : Border.all(color: AppSemantic.border),
        boxShadow: [
          BoxShadow(
            color: scheme.primary.withValues(alpha: isToday ? 0.28 : 0.08),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
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
                    if (item.emoji.isNotEmpty) ...[
                      Text(item.emoji, style: const TextStyle(fontSize: 22)),
                      const SizedBox(width: AppSpacing.s8),
                    ],
                    Expanded(
                      child: Text(
                        item.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTypography.title3.copyWith(color: fg),
                      ),
                    ),
                    if (onPinToggle != null)
                      IconButton(
                        visualDensity: VisualDensity.compact,
                        onPressed: onPinToggle,
                        icon: Icon(
                          item.pinned
                              ? Icons.push_pin
                              : Icons.push_pin_outlined,
                          size: 20,
                          color: item.pinned ? labelColor : subFg,
                        ),
                      ),
                  ],
                ),

                const SizedBox(height: AppSpacing.s4),

                Text(
                  item.label,
                  style: AppTypography.display.copyWith(
                    color: labelColor,
                    fontSize: 44,
                    height: 1.0,
                  ),
                ),

                const SizedBox(height: AppSpacing.s10),

                Row(
                  children: [
                    Text(
                      formatDdayDate(item.effectiveDate),
                      style: AppTypography.body3.copyWith(color: subFg),
                    ),
                    if (item.anniversaryYears != null) ...[
                      const SizedBox(width: AppSpacing.s8),
                      _Badge(
                        text: '${item.anniversaryYears}주년',
                        color: labelColor,
                      ),
                    ],
                  ],
                ),

                if (item.progress != null) ...[
                  const SizedBox(height: AppSpacing.s16),
                  _ProgressBar(
                    value: item.progress!,
                    color: labelColor,
                    track: isToday
                        ? scheme.onPrimary.withValues(alpha: 0.25)
                        : AppSemantic.divider,
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// N주년 등 작은 배지.
class _Badge extends StatelessWidget {
  const _Badge({required this.text, required this.color});

  final String text;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.s8,
        vertical: 2,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.14),
        borderRadius: BorderRadius.circular(AppRadius.sm),
      ),
      child: Text(
        text,
        style: AppTypography.caption1.copyWith(
          color: color,
          fontWeight: AppFontWeight.semiBold,
        ),
      ),
    );
  }
}

/// 둥근 진행 게이지.
class _ProgressBar extends StatelessWidget {
  const _ProgressBar({
    required this.value,
    required this.color,
    required this.track,
  });

  final double value;
  final Color color;
  final Color track;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(AppRadius.max),
      child: LinearProgressIndicator(
        value: value,
        minHeight: 6,
        backgroundColor: track,
        valueColor: AlwaysStoppedAnimation(color),
      ),
    );
  }
}
