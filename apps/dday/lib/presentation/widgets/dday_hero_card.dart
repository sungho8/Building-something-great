import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';

import '../../domain/entities/dday_item.dart';
import '../../utils/date_format.dart';

/// 최상단 강조 카드.
///
/// 디자인 규칙(흰 배경 + 위젯이 KeyColor를 짊어짐)에 따라, 화면에서 색을 짊어지는
/// 주역이다. 브랜드색으로 꽉 채우고, D-DAY 당일엔 축하 문구를 더한다.
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
    final scheme = Theme.of(context).colorScheme;
    final onColor = scheme.onPrimary;
    final subColor = onColor.withValues(alpha: 0.85);
    final isToday = item.daysFromToday == 0;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: scheme.primary,
        borderRadius: BorderRadius.circular(AppRadius.xl),
        boxShadow: [
          BoxShadow(
            color: scheme.primary.withValues(alpha: 0.30),
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
                        style: AppTypography.title3.copyWith(color: onColor),
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
                          color: item.pinned ? onColor : subColor,
                        ),
                      ),
                  ],
                ),

                const SizedBox(height: AppSpacing.s4),

                Text(
                  item.label,
                  style: AppTypography.display.copyWith(
                    color: onColor,
                    fontSize: 44,
                    height: 1.0,
                  ),
                ),

                const SizedBox(height: AppSpacing.s10),

                Row(
                  children: [
                    Text(
                      formatDdayDate(item.effectiveDate),
                      style: AppTypography.body3.copyWith(color: subColor),
                    ),
                    if (item.anniversaryYears != null) ...[
                      const SizedBox(width: AppSpacing.s8),
                      _Badge(text: '${item.anniversaryYears}주년', on: onColor),
                    ],
                  ],
                ),

                if (isToday) ...[
                  const SizedBox(height: AppSpacing.s8),
                  Text(
                    '오늘이에요 🎉',
                    style: AppTypography.body2.copyWith(
                      color: onColor,
                      fontWeight: AppFontWeight.bold,
                    ),
                  ),
                ] else if (item.progress != null) ...[
                  const SizedBox(height: AppSpacing.s16),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(AppRadius.max),
                    child: LinearProgressIndicator(
                      value: item.progress,
                      minHeight: 6,
                      backgroundColor: onColor.withValues(alpha: 0.25),
                      valueColor: AlwaysStoppedAnimation(onColor),
                    ),
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

/// N주년 등 작은 배지 (채운 카드 위에 얹는 반투명 흰 필).
class _Badge extends StatelessWidget {
  const _Badge({required this.text, required this.on});

  final String text;
  final Color on;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.s8,
        vertical: 2,
      ),
      decoration: BoxDecoration(
        color: on.withValues(alpha: 0.18),
        borderRadius: BorderRadius.circular(AppRadius.sm),
      ),
      child: Text(
        text,
        style: AppTypography.caption1.copyWith(
          color: on,
          fontWeight: AppFontWeight.semiBold,
        ),
      ),
    );
  }
}
