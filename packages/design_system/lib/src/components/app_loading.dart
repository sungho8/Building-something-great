import 'package:flutter/material.dart';

import '../tokens/colors.dart';
import '../tokens/spacing.dart';
import '../tokens/typography.dart';

/// 로딩 인디케이터 (+ 선택 메시지). 중앙 정렬.
class AppLoading extends StatelessWidget {
  final String? message;

  /// 스피너 색. null이면 테마 primary.
  final Color? color;

  const AppLoading({super.key, this.message, this.color});

  @override
  Widget build(BuildContext context) {
    final accent = color ?? Theme.of(context).colorScheme.primary;

    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: 28,
            height: 28,
            child: CircularProgressIndicator(strokeWidth: 3, color: accent),
          ),
          if (message != null) ...[
            const SizedBox(height: AppSpacing.s12),
            Text(
              message!,
              style: AppTypography.descriptionSub
                  .copyWith(color: AppSemantic.textTertiary),
            ),
          ],
        ],
      ),
    );
  }
}
