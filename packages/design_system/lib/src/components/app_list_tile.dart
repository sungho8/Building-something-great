import 'package:flutter/material.dart';

import '../tokens/colors.dart';
import '../tokens/radius.dart';
import '../tokens/spacing.dart';
import '../tokens/typography.dart';

/// 설정·이동 행. 둥근 아이콘 박스 + 라벨 + (부가값) + 트레일링.
///
/// [AppCard] 안에 쌓아 설정 그룹을 만들거나 단독으로 쓴다.
/// onTap이 있으면 기본으로 오른쪽에 chevron이 붙는다.
class AppListTile extends StatelessWidget {
  final IconData? leadingIcon;

  /// 아이콘 강조 색. null이면 회색 톤.
  final Color? leadingColor;

  final String title;
  final String? subtitle;

  /// 오른쪽 위젯. null이고 onTap이 있으면 chevron.
  final Widget? trailing;

  final VoidCallback? onTap;

  const AppListTile({
    super.key,
    this.leadingIcon,
    this.leadingColor,
    required this.title,
    this.subtitle,
    this.trailing,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final iconFg = leadingColor ?? AppSemantic.textSecondary;
    final iconBg = (leadingColor ?? AppGrey.s500).withValues(alpha: 0.10);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppRadius.md),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: AppSpacing.s10),
          child: Row(
            children: [
              if (leadingIcon != null) ...[
                Container(
                  width: 38,
                  height: 38,
                  decoration: BoxDecoration(
                    color: iconBg,
                    borderRadius: BorderRadius.circular(AppRadius.md),
                  ),
                  child: Icon(leadingIcon, size: 20, color: iconFg),
                ),
                const SizedBox(width: AppSpacing.s12),
              ],

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: AppTypography.itemTitle),

                    if (subtitle != null) ...[
                      const SizedBox(height: 2),
                      Text(
                        subtitle!,
                        style: AppTypography.descriptionSub
                            .copyWith(color: AppSemantic.textTertiary),
                      ),
                    ],
                  ],
                ),
              ),

              const SizedBox(width: AppSpacing.s8),

              trailing ??
                  (onTap != null
                      ? const Icon(Icons.chevron_right,
                          size: 20, color: AppGrey.s400)
                      : const SizedBox.shrink()),
            ],
          ),
        ),
      ),
    );
  }
}
