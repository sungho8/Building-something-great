import 'package:flutter/material.dart';

import '../tokens/colors.dart';
import '../tokens/radius.dart';
import '../tokens/spacing.dart';
import '../tokens/typography.dart';

/// 체크박스 (+ 선택 라벨).
///
/// [label]을 주면 행 전체가 탭 영역이 된다. 색은 [color] 또는 테마 primary.
class AppCheckbox extends StatelessWidget {
  final bool value;
  final ValueChanged<bool>? onChanged;
  final String? label;
  final Color? color;

  const AppCheckbox({
    super.key,
    required this.value,
    this.onChanged,
    this.label,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final accent = color ?? Theme.of(context).colorScheme.primary;

    final box = SizedBox(
      width: 24,
      height: 24,
      child: Checkbox(
        value: value,
        onChanged:
            onChanged == null ? null : (v) => onChanged!(v ?? false),
        activeColor: accent,
        side: const BorderSide(color: AppSemantic.border, width: 1.5),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.xs),
        ),
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        visualDensity: VisualDensity.compact,
      ),
    );

    if (label == null) return box;

    return InkWell(
      onTap: onChanged == null ? null : () => onChanged!(!value),
      borderRadius: BorderRadius.circular(AppRadius.sm),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.s6),
        child: Row(
          children: [
            box,
            const SizedBox(width: AppSpacing.s12),
            Expanded(
              child: Text(label!, style: AppTypography.description),
            ),
          ],
        ),
      ),
    );
  }
}
