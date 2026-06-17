import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';

import '../models/dday_item.dart';
import '../utils/date_format.dart';

/// D-Day 한 건을 카드로 표시. 제목·날짜 + 큰 라벨(D-N).
class DDayCard extends StatelessWidget {
  const DDayCard({super.key, required this.item, this.onTap});

  final DDayItem item;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AppCard(
      padding: EdgeInsets.zero,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(item.title, style: theme.textTheme.titleMedium),
                    AppSpacing.gapSm,
                    Text(
                      formatDdayDate(item.date),
                      style: theme.textTheme.bodySmall
                          ?.copyWith(color: theme.colorScheme.outline),
                    ),
                  ],
                ),
              ),
              Text(
                item.label,
                style: theme.textTheme.headlineSmall?.copyWith(
                  color: theme.colorScheme.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
