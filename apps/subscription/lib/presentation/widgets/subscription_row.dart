import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';

import '../../domain/entities/subscription.dart';
import 'package:app_theme/app_theme.dart';
import '../../utils/currency_format.dart';
import '../category_style.dart';

const _cycleWord = {
  BillingCycle.monthly: '월',
  BillingCycle.yearly: '연',
  BillingCycle.weekly: '주',
};

/// 구독 목록의 한 줄 — 아이콘(색 사각) + 이름/결제일 + 가격/D-day.
///
/// 아이콘은 임시로 카테고리 Material 아이콘. 추후 브랜드 asset 아이콘으로 교체.
class SubscriptionRow extends StatelessWidget {
  const SubscriptionRow({super.key, required this.item, this.onTap});

  final Subscription item;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final c = UiColors.of(context);
    final cat = CategoryStyle.colorOf(item);
    final paused = !item.active;
    final imminent = item.active && item.daysUntilPayment <= 3;

    return Opacity(
      opacity: paused ? 0.55 : 1,
      child: Material(
        color: c.surface,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(AppRadius.lg),
          child: Container(
            padding: const EdgeInsets.all(AppSpacing.s14),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(AppRadius.lg),
              border: Border.all(color: c.border),
            ),
            child: Row(
              children: [
                // 브랜드 아이콘 (색 사각)
                Container(
                  width: 48,
                  height: 48,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: cat,
                    borderRadius: BorderRadius.circular(AppRadius.md),
                  ),
                  child: Icon(CategoryStyle.icon(item.category),
                      size: 24, color: Colors.white),
                ),
                const SizedBox(width: AppSpacing.s12),

                // 이름 + 결제일·주기
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTypography.itemTitle
                            .copyWith(color: c.textPrimary),
                      ),
                      const SizedBox(height: AppSpacing.s2),
                      Text(
                        '${cycleDateLabel(item.nextPaymentDate, item.cycle.index)} · ${_cycleWord[item.cycle]}',
                        style: AppTypography.descriptionSub
                            .copyWith(color: c.textSecondary),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: AppSpacing.s8),

                // 가격 + D-day
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      formatWon(item.amount),
                      style: AppTypography.itemTitle
                          .copyWith(color: c.textPrimary),
                    ),
                    const SizedBox(height: AppSpacing.s2),
                    Text(
                      paused ? '일시정지' : item.paymentLabel,
                      style: AppTypography.caption1.copyWith(
                        color: imminent ? c.accent : c.textTertiary,
                        fontWeight:
                            imminent ? AppFontWeight.bold : AppFontWeight.medium,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
