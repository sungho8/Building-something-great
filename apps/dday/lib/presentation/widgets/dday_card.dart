import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';

import '../../domain/entities/dday_item.dart';
import '../../utils/date_format.dart';

/// D-Day 한 건을 컴팩트 카드로 표시. 이모지·제목·날짜 + 라벨(D-N).
class DDayCard extends StatelessWidget {
  const DDayCard({super.key, required this.item, this.onTap});

  final DDayItem item;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    // 항목별 KeyColor가 있으면 라벨·핀 강조에 사용 (없으면 브랜드색).
    final accent = item.color ?? theme.colorScheme.primary;

    return AppCard(
      padding: EdgeInsets.zero,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Row(
            children: [
              if (item.emoji.isNotEmpty) ...[
                Text(item.emoji, style: const TextStyle(fontSize: 20)),
                const SizedBox(width: AppSpacing.s12),
              ],

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        if (item.pinned) ...[
                          Icon(Icons.push_pin, size: 13, color: accent),
                          const SizedBox(width: 4),
                        ],
                        Flexible(
                          child: Text(
                            item.title,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: AppTypography.heading2,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: AppSpacing.s4),

                    Text(
                      formatDdayDate(item.effectiveDate),
                      style: AppTypography.body3
                          .copyWith(color: AppSemantic.textTertiary),
                    ),
                  ],
                ),
              ),

              const SizedBox(width: AppSpacing.s12),

              Text(
                item.label,
                style: AppTypography.title3.copyWith(color: accent),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
