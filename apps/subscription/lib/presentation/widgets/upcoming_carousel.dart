import 'package:design_system/design_system.dart'
    show AppSpacing, AppRadius, AppTypography;
import 'package:flutter/material.dart';

import '../../domain/entities/subscription.dart';
import 'package:app_theme/app_theme.dart';
import '../../utils/currency_format.dart';
import '../category_style.dart';

/// 곧 결제 예정 구독 가로 카러셀.
class UpcomingCarousel extends StatelessWidget {
  const UpcomingCarousel({super.key, required this.items, this.onTap});

  final List<Subscription> items;
  final ValueChanged<Subscription>? onTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 104,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s16),
        itemCount: items.length,
        separatorBuilder: (context, index) =>
            const SizedBox(width: AppSpacing.s10),
        itemBuilder: (context, i) {
          final item = items[i];
          return _UpcomingCard(
            item: item,
            onTap: onTap == null ? null : () => onTap!(item),
          );
        },
      ),
    );
  }
}

class _UpcomingCard extends StatelessWidget {
  const _UpcomingCard({required this.item, this.onTap});

  final Subscription item;
  final VoidCallback? onTap;

  String get _dLabel {
    final d = item.daysUntilPayment;
    if (d == 0) return '오늘 결제';
    if (d == 1) return '내일 결제';
    return 'D-$d';
  }

  @override
  Widget build(BuildContext context) {
    final c = UiColors.of(context);
    final cat = CategoryStyle.colorOf(item);
    final imminent = item.daysUntilPayment <= 3;

    return Material(
      color: c.surface,
      borderRadius: BorderRadius.circular(AppRadius.lg),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        child: Container(
          width: 176,
          padding: const EdgeInsets.all(AppSpacing.s14),
          decoration: BoxDecoration(
            border: Border.all(color: c.border),
            borderRadius: BorderRadius.circular(AppRadius.lg),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    width: 34,
                    height: 34,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: cat,
                      borderRadius: BorderRadius.circular(AppRadius.md),
                    ),
                    child: Icon(CategoryStyle.icon(item.category),
                        size: 18, color: Colors.white),
                  ),
                  const SizedBox(width: AppSpacing.s10),
                  Expanded(
                    child: Text(
                      item.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTypography.itemTitle
                          .copyWith(color: c.textPrimary),
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    _dLabel,
                    style: AppTypography.label3.copyWith(
                        color: imminent ? c.accent : c.textSecondary),
                  ),
                  Text(
                    formatWon(item.amount),
                    style: AppTypography.caption1
                        .copyWith(color: c.textSecondary),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
