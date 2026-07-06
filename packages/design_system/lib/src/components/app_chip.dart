import 'package:flutter/material.dart';

import '../tokens/colors.dart';
import '../tokens/spacing.dart';
import '../tokens/typography.dart';

/// 칩 크기 (높이 36/30).
enum AppChipSize { md, sm }

/// 선택형 필(pill) 칩.
///
/// 선택 시 브랜드색(또는 [color]) 틴트 배경 + 테두리 + semibold 글자로 강조된다.
/// 필터·선택지·태그 어디에나 쓴다.
class AppChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback? onTap;
  final IconData? leadingIcon;
  final AppChipSize size;

  /// 강조 색. null이면 테마 primary.
  final Color? color;

  const AppChip({
    super.key,
    required this.label,
    this.selected = false,
    this.onTap,
    this.leadingIcon,
    this.size = AppChipSize.md,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final accent = color ?? Theme.of(context).colorScheme.primary;
    final isSm = size == AppChipSize.sm;

    final fg = selected ? accent : AppSemantic.textSecondary;
    final bg = selected ? accent.withValues(alpha: 0.10) : AppCommon.white;
    final border = selected ? accent : AppSemantic.border;
    final baseStyle = isSm ? AppTypography.label4 : AppTypography.label3;

    return Material(
      color: bg,
      shape: StadiumBorder(
        side: BorderSide(color: border, width: selected ? 1.2 : 1),
      ),
      child: InkWell(
        onTap: onTap,
        customBorder: const StadiumBorder(),
        child: Container(
          height: isSm ? 30 : 36,
          padding: EdgeInsets.symmetric(
            horizontal: isSm ? AppSpacing.s10 : AppSpacing.s14,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (leadingIcon != null) ...[
                Icon(leadingIcon, size: isSm ? 14 : 16, color: fg),
                const SizedBox(width: AppSpacing.s4),
              ],
              Text(
                label,
                style: baseStyle.copyWith(
                  color: fg,
                  fontWeight: selected
                      ? AppFontWeight.semiBold
                      : AppFontWeight.regular,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
