import 'package:design_system/design_system.dart'
    show AppSpacing, AppRadius, AppTypography;
import 'package:flutter/material.dart';

import '../../domain/entities/quit_item.dart';
import 'package:app_theme/app_theme.dart';
import '../../utils/format.dart';
import '../quit_type_style.dart';

/// 대표 외 목표의 컴팩트 카드 행.
class QuitCard extends StatelessWidget {
  const QuitCard({super.key, required this.item, this.onTap});

  final QuitItem item;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final c = UiColors.of(context);
    final color = QuitTypeStyle.colorOf(item);

    return Material(
      color: c.surface,
      borderRadius: BorderRadius.circular(AppRadius.lg),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        child: Container(
          padding: const EdgeInsets.all(AppSpacing.s14),
          decoration: BoxDecoration(
            border: Border.all(color: c.border),
            borderRadius: BorderRadius.circular(AppRadius.lg),
          ),
          child: Row(
            children: [
              Container(
                width: 44,
                height: 44,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(AppRadius.md),
                ),
                child: Icon(QuitTypeStyle.icon(item.type),
                    size: 22, color: Colors.white),
              ),
              const SizedBox(width: AppSpacing.s12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(item.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTypography.itemTitle
                            .copyWith(color: c.textPrimary)),
                    const SizedBox(height: AppSpacing.s2),
                    Text(
                      item.dailyCost > 0
                          ? '${formatWon(item.moneySaved)} 절약'
                          : formatElapsed(item.elapsed),
                      style: AppTypography.descriptionSub
                          .copyWith(color: c.textSecondary),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: AppSpacing.s8),
              Text('D+${item.daysSince}',
                  style: AppTypography.itemTitle.copyWith(color: color)),
            ],
          ),
        ),
      ),
    );
  }
}
