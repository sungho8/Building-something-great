import 'package:flutter/material.dart';

import '../tokens/colors.dart';
import '../tokens/spacing.dart';
import '../tokens/typography.dart';

/// 빈 화면 안내 (아이콘 + 제목 + 설명 + 선택 액션).
class AppEmptyState extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? description;

  /// 하단 액션 (예: AppButton).
  final Widget? action;

  const AppEmptyState({
    super.key,
    required this.icon,
    required this.title,
    this.description,
    this.action,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 56, color: AppGrey.s300),

          const SizedBox(height: AppSpacing.s16),

          Text(title, style: AppTypography.itemTitle),

          if (description != null) ...[
            const SizedBox(height: AppSpacing.s6),
            Text(
              description!,
              textAlign: TextAlign.center,
              style: AppTypography.descriptionSub
                  .copyWith(color: AppSemantic.textTertiary),
            ),
          ],

          if (action != null) ...[
            const SizedBox(height: AppSpacing.s20),
            action!,
          ],
        ],
      ),
    );
  }
}
