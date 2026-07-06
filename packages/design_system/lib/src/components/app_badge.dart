import 'package:flutter/material.dart';

import '../tokens/colors.dart';
import '../tokens/radius.dart';
import '../tokens/spacing.dart';
import '../tokens/typography.dart';

/// 배지 변형. tint=연한 배경 / fill=채움 / outline=테두리.
enum AppBadgeVariant { tint, fill, outline }

/// 작은 상태 배지 (N주년, NEW, 진행중 등).
class AppBadge extends StatelessWidget {
  final String text;

  /// 배지 색. null이면 테마 primary.
  final Color? color;

  final AppBadgeVariant variant;

  const AppBadge({
    super.key,
    required this.text,
    this.color,
    this.variant = AppBadgeVariant.tint,
  });

  @override
  Widget build(BuildContext context) {
    final accent = color ?? Theme.of(context).colorScheme.primary;

    final (bg, fg, border) = switch (variant) {
      AppBadgeVariant.tint => (
          accent.withValues(alpha: 0.14),
          accent,
          null,
        ),
      AppBadgeVariant.fill => (accent, AppCommon.white, null),
      AppBadgeVariant.outline => (
          Colors.transparent,
          accent,
          Border.all(color: accent),
        ),
    };

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.s8,
        vertical: 2,
      ),
      decoration: BoxDecoration(
        color: bg,
        border: border,
        borderRadius: BorderRadius.circular(AppRadius.sm),
      ),
      child: Text(
        text,
        style: AppTypography.caption1.copyWith(
          color: fg,
          fontWeight: AppFontWeight.semiBold,
        ),
      ),
    );
  }
}
